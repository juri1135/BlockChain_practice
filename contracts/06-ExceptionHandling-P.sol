// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/* Error Handling: assert, require, revert */
contract ErrorHandling {
    struct Triangle {				                                    // 삼각형을 정의하는 구조체
        uint Edge1;	                    				            
        uint Edge2;						                            
        uint Edge3;		                        		            
    }
    
    Triangle public myTriangle = Triangle(5, 4, 3);
    
    function checkTriangle(uint a, uint b, uint c) public returns (bool result) {
        if ((a < b + c) && (b < c + a) && (c < a + b))                  // 한 변의 길이가 두 변의 합보다 작은지를 검사
            return true;
        else
            return false;
    }

    function testAssert(uint a, uint b, uint c) public {
        myTriangle.Edge1 = a;
        myTriangle.Edge2 = b;
        myTriangle.Edge3 = c;

        assert(checkTriangle(a, b, c)); 	                            // 조건 위배시 revert (상태변수 변경 취소)	
        //assert가 조건 X를 검사해서 강제 예외 처리 								                                    
    }
    
    function testRequire(uint a, uint b, uint c) public{
        require((a>0)&&(b>0)&&(c>0));
        myTriangle.Edge1 = a;
        myTriangle.Edge2 = b;
        myTriangle.Edge3 = c;

        
    }                                                                   // (연습문제 1) 아래의 지시에 따라 require 예외처리를 사용하는 함수를 작성하시오.
                                                                        // 입력 파라미터 a, b, c가 큰 순서대로 주어지고 모든 파라미터가 0보다 큰 지를 검사한다. 
                                                                        // 검사를 통과하면 myTriangle의 변의 길이를 갱신한다.
                                                                        // 함수의 이름과 파라미터는 testRequire(uint a, uint b, uint c) 형태로 한다.

    function testRevert(uint a, uint b, uint c) public {
        myTriangle.Edge1 = a;
        myTriangle.Edge2 = b;
        myTriangle.Edge3 = c;
        
        if ((a < b) || (b < c) || (c <= 0)) {					        // 입력 파라미터들이 길이 순서로 정렬되었는가? 0보다 큰가?
            revert("Parameters must be ordered and greater than 0");	// revert (상태변수 변경 취소)
        }
    }
}