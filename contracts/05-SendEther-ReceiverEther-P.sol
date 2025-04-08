// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 이더(ether) 송금: transfer, send, call */

contract SendEther {
    uint oneWei = 1;				                        // 솔리더티에서의 기본 단위는 wei
    uint twoWei = 2 wei;
    uint oneEther = 10**18;			                        // 1 ether = 10의 18승 
    uint twoEther = 2e18;			                        // 2 * 10의 18승
    uint threeEther = 3 ether;		                        // ether는 10의 18승을 의미
    
    uint public balance;    

    constructor() payable {			                        // 컨트랙트를 배포하면서 이더(ether) 송금	
        balance = msg.value;
    }      
   
    function sendViaTransfer(address payable _to) public {  // 실패시 예외(exception) 발생, 컨트랙트 실행을 "중단하고 revert"
        balance -= 2000000;
        _to.transfer(2000000);
    }
      
    function sendViaSend(address payable _to) public {	    // 실패시 bool 값을 반환, 컨트랙트 실행은 "계속" (revert 발생 없음)
        // balance -= 2000000;				                // 송금 전에 balance를 먼저 갱신하면 balance에 틀린 값이 유지될 수 있음
        bool sent = _to.send(2000000);
        if (sent == true)				                    // 정확한 balance를 유지하려면 조건 검사후 balance 갱신 필요
            balance -= 2000000;
    }
    // call 함수 사용법. (bool success, bytes memory data)=address.call{value:amount}(data) 
    //value는 보낼 Ether 양, data는 호출할 함수의 시그니처 및 인수를 인코딩한 바이트 데이터 
    function sendViaCall(address payable  _to) public {
        (bool success,) = _to.call{value:2000000}("");
        if (success == true)				                    // 정확한 balance를 유지하려면 조건 검사후 balance 갱신 필요
            balance -= 2000000;			        
                                                               
    }                                                         // (연습문제 1) address.call 함수를 사용하여 ether를 전송하는 sendViaCall 함수를 작성하시오.
    
    function getRealBalance() public view returns(uint){
        //address.balance: ETH 잔고 수량 (wei 단위) 

        return address(this).balance;
    }



    
                                                            // (연습문제 2) SendEther 컨트랙트가 보유한 정확한 ether 값을 리턴하는 getRealBalance 함수를 작성하시오.    
}

/* 이더(ether) 수신: payable function, receive, fallback */
contract ReceiveEther {
    uint public balance = 0;
    
    function payableFunction() public payable {			    // 이더를 수신할 수 있는 payable 함수
        balance += msg.value;
    }
    
    receive() external payable {				            // 이더를 수신할 수 있는 receive 함수
        balance += msg.value;					            // 상태변수를 변경할 경우 이더 수신 실패
    }								                        // payable fallback 함수가 없을 경우 송금된 이더를 수신
    
    fallback() external payable {				            // 이더를 수신할 수 있는 fallback 함수
        balance += msg.value;						
    }    
}

/* 컨트랙트 실행을 통한 확인
(1) 컨트랙트 배포
    - SendEther 배포시 5,000,000 wei 송금
    //deploy할 때 value에 해당 값 넣어서 실행
(2) SendEther 컨트랙트 실행
    (2-1) ReceiveEther 주소 복사 //contract에서 receiver 클릭해서 deploy하면 주소 나옴
    (2-2) sendViaCall( ) 실행 및 SendEther의 balance 확인 (3,000,000) (ReceiveEther contract 주소)
    (2-3) sendViaSend( ) 실행 및 SendEther의 balance 확인 (1,000,000) (ACCOUNT 주소) 
    (2-4) sendViaTransfer( ) 실행, 트랜잭션 실패 확인, SendEther의 balance 확인 (1,000,000) (ACCOUNT 주소) 
*/

/* 주의: receive 함수와 fallback 함수가 모두 존재할 경우 */
/* msg.data가 ""이면 receive 함수가 실행 */
/* msg.data가 "something that does not exit"이면 fallback 함수가 실행 */

