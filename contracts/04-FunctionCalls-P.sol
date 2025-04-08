// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 외부 컨트랙트 함수의 호출 */

contract Callee {
    uint public stateVal = 100;
    
    fallback() external payable { //함수 호출 조건 안 맞으면 실행 
        stateVal = 1;
    }
    
    function foo(uint x) public returns (uint) {
        stateVal += x;
        return stateVal;
    }
}

contract Caller {
    uint public stateVal = 3000;
    Callee public CalleeA;					                // CalleeA의 참조만 생성, 객체는 생성되지 않음
    Callee public CalleeB = new Callee();				    // CalleeB의 객체 생성 (Caller에 포함되어 함께 생성됨, CalleeB는 별도 생성 필요없음)
    uint public returnVal;
    
    /*function getReceiverBStateVal() public {
        returnVal = ReceiverB.stateVal();
    }*/

    function callFooA() public {
        returnVal = CalleeA.foo(123);						    // CalleeA의 객체가 존재하지 않으므로 호출 실패
        //호출 실패하면서 fallback 함수 호출. stateVal 1로 초기화
       
    }
    
    function callFooB() public {
        returnVal = CalleeB.foo(456);						    // 컨트랙트 이름을 이용한 호출 --> 성공
        //stateVal은 100+456 = 556
    }
    
    function callFooWithAddr(address payable addr) public {		// Callee가 payable fallback을 가지고 있기 때문에 payable addr로 선언
        Callee CalleeC = Callee(addr);			//address를 contract로 변환 	
        returnVal = CalleeC.foo(789);				            // 변환된 컨트랙트를 이용한 호출 
        //어떤 callee 호출하는지에 따라 갈림 
    }
    
    function callFooWithCall(address addr) public {
        (bool success, bytes memory data) = addr.call(			// 주소를 사용하여 call 함수로 호출 
            abi.encodeWithSignature("foo(uint256)", 888));		// 함수의 시그니처와 파라미터를 함께 인코딩하여 하나의 bytes형 파라미터로 변환
        returnVal = abi.decode(data, (uint));			        // 호출된 foo의 리턴값 data를 디코딩
                                                                // (연습문제 1) Callee의 stateVal이 변경되는가?
        //callee 변경                                                      
    }    

    function callFooWithDelegateCall(address addr) public {
        (bool success, bytes memory data) = addr.delegatecall(	// 주소를 사용하여 delegatecall 함수로 호출 
            abi.encodeWithSignature("foo(uint256)", 999));		// 함수의 시그니처와 파라미터를 함께 인코딩하여 하나의 bytes형 파라미터로 변환
        returnVal = abi.decode(data, (uint));			        // 호출된 foo의 리턴값 data를 디코딩
                                                                // (연습문제 2) Callee의 stateVal이 변경되는가?
        //callee는 그대로, caller는 변경                                  //delegate call은 caller의 문맥 유지. 따라서 변경 X
    } 
}
