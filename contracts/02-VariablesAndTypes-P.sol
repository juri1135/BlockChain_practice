// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
/* 밸류형 변수: 부울형(bool), 정수형(uint, int), 열거형(enum), 주소형(address) */

contract ValueTypeVariables {
    /* 부울형(bool) */
    bool booVar1 = true;                        		// 상태변수의 default visibility는 internal, 컨트랙트 내부 및 자식 클래스에서 접근 가능
    bool private boolVar2 = true;               		// private variable, 자식 클래스에서 접근 불가능
    bool public boolVar3;                       		// public variable, 초기값이 없을 경우 'zero state' 또는 'false'로 초기화
    
    /* 부호없는 정수형(uint) */    
    uint256 public uint256Var=2**256-1;		                    // (연습문제 1) uint256Var를 최대값으로 초기화 하시오. (256-bit 부호가 없는 정수)
    uint public uintVar=2**256-1;			                    // (연습문제 2) uintVar를 최대값으로 초기화하시오. 

    /* 부호있는 정수형(int) */    
    int8 public int8Var = 32;				            // 8-bit 부호가 있는 정수
    int256 public int256Var=2**255-1; //부호 있는 버전에서 /2		                    // (연습문제 3) int256Var를 최대값으로 초기화 하시오.
    int public intVar = - 2**255;
    //-128~127 -2^7, 2^7-1
    //0~255 0, 2^8-1			            // (연습문제 4) intVar를 최소값(minimum)으로 초기화 하시오.
    
    /* 열거형(enum) */
    enum MyEnum {				                        // 열거형, 각 심볼은 순서대로 0, 1, 2, 3, 4, ...로 취급
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }
    
    MyEnum public enumVar1 = MyEnum.Accepted;	        // 열거형 항목 참조는 '.' 사용
    MyEnum public enumVar2 = MyEnum(4);		            // 열거형 항목 대신 숫자 사용 가능 (형변환 필요)

    /* 주소형(address) */
    address public owner;				                // 주소형 (20 바이트)
    
    constructor() {        
        owner = msg.sender;	              
    }
}

/* 참조형 변수: 배열(array), 스트링(string), 구조체(struct), 매핑(mapping) */

contract ReferenceTypeVariables {
    /* 정수 배열(array) */
    uint[2] public arrayVar1 = [1, 2];			        // 고정크기(fixed-size) 배열, 초기화는 [ ] 사용
    uint[] public arrayVar2;				            // 동적크기(dynamically-sized) 배열
    
    /* 문자열(string) */
    string public stringVar = "Hello World";	        // 문자열

    /* 구조체(struct) */
    struct MyStruct {				                    // 구조체
        uint val;	                    
        bool ok;		                        
    }
    
    MyStruct public structVar1 = MyStruct(4, true);		            // 구조체 초기화 방법 1
    MyStruct public structVar2 = MyStruct({val:5, ok:true});	    // 구조체 초기화 방법 2
    
    /* 매핑(mapping) */
    mapping (uint => string) public mappingVar1;			        // 매핑형, "mappinVar1[uint] = string" 형식으로 사용
    mapping (uint => mapping (bool => string)) public mappingVar2;	// 매핑형, "mappinVar2[uint][bool] = string" 형식으로 사용
        
    constructor() {
        arrayVar2 = [3, 4, 5];				            // 동적크기(dynamically-sized) 배열의 초기화
        arrayVar2.push(6);                				                // (연습문제 5) push 함수를 사용하여 arrayVar2에 '6'을 추가하시오.
        arrayVar2.pop();				                // (연습문제 6) pop 함수를 사용하여 arrayVar2의 마지막 원소를 제거하시오.
		
        mappingVar1[0] = "The 1st mapping value";	                // 매핑형, mappinVar1[uint] = string 형태로 사용
        mappingVar1[1] = "The 2nd mapping value";	                // 매핑형, mappinVar1[uint] = string 형태로 사용
        mappingVar2[0][false] = "The 1st mapping of mapping";	    // 매핑형, mappinVar2[uint][bool] = string 형태로 사용
        mappingVar2[0][true] = "The 2nd mapping of mapping";	    // 매핑형, mappinVar2[uint][bool] = string 형태로 사용
    }

    function changeStructVar1(uint val1, bool val2) public {	    
        structVar1.val = val1;
        structVar1.ok = val2;        
    }

    function changeString() public {
        stringVar = "Goodbye World";  
        stringVar=string.concat("Hello World",stringVar);
                            // (연습문제 7) concat 함수를 사용하여 stringVar를 "Hello World"와 " Goodbye World"가 합쳐진 문자열로 만드시오.
    }
}