// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* 함수의 형식, 리턴 값, 인자값 전달 */

contract FunctionBasics {
    uint[] public arrayA = [1, 2];
    uint[] public arrayB;
    uint[] public arrayC = [3, 4];
    uint[] public arrayD;
    
    uint public returnValue1;
    bool public returnValue2;
    uint public returnValue3;

    mapping (uint => string) public mappingVar;
     
    constructor() {	                                                        // mappingVar 초기화
        mappingVar[0] = "The 1st mapping value";
        mappingVar[1] = "The 2nd mapping value";    
    }

    function returnNamed() public pure returns (uint x, bool b, uint y) {	    // 복수의 리턴 값 가능
        return (3, false, 4);
    }
   
    function returnUnnamed() public pure returns (uint, bool, uint) {	        // 리턴 값들의 이름 생략 가능
        return (1, true, 2);
    }    
       
    function returnAssigned() public pure returns (uint x, bool b, uint y) {	    // 리턴 값들의 이름을 직접 사용, 별도의 return 문장 불필요
        x = 5;
        b = true;
        y = 6;
    }
    
    function receiveReturnValues() public {				                    // 복수의 리턴 값을 받는 방법
        (uint i, bool b, uint j) = returnNamed();
        (returnValue1, returnValue2, returnValue3) = returnNamed();
    }
    
    function returnArray() public view returns (uint[] memory) {		            // 배열을 리턴할 수 있음
        return arrayA;
    }

   function changeArrayViaMemory(uint[] memory _array) internal  {          // call-by-value, 메모리에 파라미터 값들이 복사됨
        arrayB = _array;					                                
        _array[0] = 1000;					                                // 인자값을 변경해도 원래 파라미터의 값이 변경되지 않음
    }

    function testChangeArrayViaMemory() public {				            
        changeArrayViaMemory(arrayA);					                    
        arrayD = returnArray();  
        //1,2                                          // (연습문제 1) arrayD의 값은 얼마인가?
    }

    function changeArrayViaStorage(uint[] storage _array) internal {        // call-by-reference, 메모리에 레퍼런스가 복사됨
        arrayB = _array;					                                
        _array[0] = 1000;					                                // 인자값을 변경하면 원래 파라미터의 값이 변경
    }

    function testChangeArrayViaStorage() public {				            
        changeArrayViaStorage(arrayA);					                    
        arrayD = returnArray();  
        // 1000, 2                                          // (연습문제 2) arrayD의 값은 얼마인가?
    }
}
//deploy 이후에 deployed contracts에서 각 함수(주황색) 클릭해서 실행한 후 returnArray 함수 실행해서 array 값 확인해서 답 확인. 