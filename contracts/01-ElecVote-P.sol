// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 컨트랙트의 구성 */

contract ElectronicVote {

    /* 상태변수 --> 블록체인에 영속적으로 저장 */
    uint public numCandidates;	                    // 후보 인원
    string[] candidateNames; 		                // 후보자 목록
    mapping (string => uint) public votesReceived;  // 후보자별 득표 수


    /* constructor 함수는 컨트랙트가 배포될 때 1회 자동 실행 */     
    constructor() {			                    
        candidateNames.push("Alice");		        // 후보자 Alice 등록, candidateNames 배열에 추가
        candidateNames.push("Bob");		            // 후보자 Bob 등록, candidateNames 배열에 추가
        candidateNames.push("Chloe");		        // 후보자 Chloe 등록, candidateNames 배열에 추가
        numCandidates = 3;			                // 후보 인원 설정
    }


    /* 다른 함수들은 필요시 외부에서 호출 */
    function getCandidateName(uint index) public view returns(string memory) {	// 후보자 이름 확인
        if (index < candidateNames.length) 
            return candidateNames[index];
        return "Invalid candidate";		
    }
    
    // function vote(string memory candidateName) public {     // (연습문제 1) 후보자의 이름 대신 순번을 사용하는 “vote(uint index)” 형태가 되도록
	// 	votesReceived[candidateName] += 1;                  // 좌측의 “vote(string memory candidateName)” 함수를 변경하시오
    // }
    function vote(uint index) public{
        if(index<candidateNames.length)
            votesReceived[candidateNames[index]]+=1;
   }
   //제대로 투표가 된 건지 확인하기 위한 함수 
    function getVotes(uint index) public view returns(uint) {
    return votesReceived[candidateNames[index]];
}
}

