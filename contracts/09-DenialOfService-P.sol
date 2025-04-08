// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 시나리오: 최대 ether를 지불하는 계정을 king으로 선출, 이전 king에게는 ether 반환 */

// contract KingOfEther {
//     address public king;	                            // king의 주소 (현재까지 최대 금액을 지불한 계정의 주소)
//     uint public highestPay;	// 현재 king이 지불한 금액

//     function claimThrone() external payable {
//         require(msg.value > highestPay,                 // 송금받은 금액이 highestPay보다 커야 함
//             "Need to pay more to become the king");     // 송금받은 금액이 highestPay보다 작으면 revert 발생
									
//         (bool sent, bytes memory data) = 
//             king.call {value: highestPay} ("");		    // 송금받은 금액이 highestPay보다 크면 현재 king에게 지불했던 금액을 반환
//         require(sent, "Failed to send Ether");			// 반환이 실패할 경우 revert 발생 (이후 코드는 실행이 안됨)

//         king = msg.sender;							    // king을 교체
//         highestPay = msg.value;						    // 최대 지불 금액을 갱신
//     }
// }
contract KingOfEther {
    address public king;	                            // king의 주소 (현재까지 최대 금액을 지불한 계정의 주소)
    uint public highestPay;	// 현재 king이 지불한 금액

    function claimThrone() external payable {
        require(msg.value > highestPay,                 // 송금받은 금액이 highestPay보다 커야 함
            "Need to pay more to become the king");     // 송금받은 금액이 highestPay보다 작으면 revert 발생

        king = msg.sender;							    // king을 교체
        highestPay = msg.value;						    // 최대 지불 금액을 갱신
									
        (bool sent, ) = 
            king.call {value: highestPay} ("");		    // 실패해도 무시하고 진행

        
    }
}
contract Attacker {								        // receive함수와 fallback 함수가 없어 이더 수신 불가능
// 다른 계정이 attacker보다 높은 금액으로 송신해서 king 교체하고 ether 돌려줘야 하는데 attacker가 receive, fallback 없어서 ether 수신 불가
// 따라서 revert되어버림. 근데 king 교체는 ether 보낸 게 성공한 후에 이루어지기 때문에 최대 지불 금액, king 모두 교체 안 된 상태... 
    KingOfEther kingOfEther; 

    function setKingOfEtherAddr(address payable addr) public {
        kingOfEther = KingOfEther(addr);
    } 

    function attack() public payable {
        kingOfEther.claimThrone {value: msg.value} ();	// msg.value 금액으로 calimThrone 함수 호출
    }
}

/* 컨트랙트 실행을 통한 확인
(1) KingOfEther 배포 
(2) KingOfEther 주소값 복사 및 Attacker 배포 (KingOfEther 주소값을 파라미터로 입력)
(3) Attack 계정으로 attack() 실행 (500 wei 송금)
    (3-1) king 및 highestPay 확인
(4) 다른 계정으로 claimThrone( ) 실행 (700 wei 송금) --> 예외 발생 및 king 교체 실패
    (4-1) balance 및 king 확인
*/

// (연습문제 1) KingOfEther 컨트랙트는 어떻게 동작하는지, 문제가 무엇인지 생각해보시오.
//attacker가 500을 보내면 초기엔 king이 없기 때문에 attacker가 king이 되고 이전 king이 없어서 ether 보낼 필요도 없음. 그래서 최대 지불 금액 500, king은 attacker 상태
//다른 계정이 500보다 높은 금액을 보내서 claimThrone에서 require 통과하고 call을 통해 Ether 반환하려고 하는데 attacker에 receive, fallback이 없어서 Ether 못 보냄
//결국 Failed to send Ether 에러 발생하면서 revert되고 king 교체, 최대 지불 금액 갱신을 하지 못 함.
//따라서 attacker보다 높은 금액을 지불했음에도 king이 되지 못 하고 최대 지불 금액도 갱신하지 못 함 

// (연습문제 2) Attacker의 공격을 막을 수 있도록 KingOfEther 컨트랙트를 수정하시오.
//king 교체, 최대 지불 금액 갱신 이후 Ether 반환
