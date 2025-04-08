// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ProxyContract {
    uint256 public x;
    uint256 public y;

    address public owner;
    address public logicAddr;    
    // proxy의 slot은 0: x, 1: y, 2: owner, 3: logicAddr 
    // 로직 컨트랙트의 주소를 설정
    constructor(address _Addr) {        
        logicAddr = _Addr;      
        owner = msg.sender;
    }
    
    // (연습문제 1) 로직 컨트랙트의 주소를 변경하는 upgrade(address _newAddr) 함수를 작성하시오.
    // 단, 프록시 컨트랙트의 owner만이 변경할 수 있도록 하시오.
    function upgrade(address _newAddr) public {
        if(msg.sender==owner) logicAddr=_newAddr;
    }  
    
    // 클라이언트 함수 호출을 로직 컨트랙트에게 delegate
    // client의 호출을 logic contract에 위임 
    // 존재하지 않는 함수 호출 시 logic contract로 delegatecall 통해 전달 
    //delegate는 calling의 상태값 사용 proxy의 x에 값이 저장되는데 이 때 사용되는 상태값이 client의 상태값. 저장은 callee 저장 공간에 저장 
    fallback() external payable {
        (bool success, ) = logicAddr.delegatecall(msg.data);
        require(success , " Error calling logical contract");
    }
}

contract LogicContract_V1 {   
    //logic contract의 x, y가 각각 proxy의 x, y에 mapping  
    uint256 public x;
    uint256 public y;
        
    function updateX(uint256 _num) public {
        x = _num;
    }

    function updateY(uint256 _num) public {
        y = _num;
    }
}
//이 contract는 proxy addr로 주소를 설정하고 proxy contract에 dosomething 함수 요청 

contract ClientContract {        
    address public proxyAddr;

    // 프록시 컨트랙트의 주소를 설정
    constructor(address _Addr) {        
        proxyAddr = _Addr;
    }
        
    // 프록시 컨트랙트에게 updateX 함수 실행을 요청
    function doSomething(uint256 _num) public {        
        proxyAddr.call(abi.encodeWithSignature("updateX(uint256)", _num));
    }
}

// (연습문제 2) updateX(uint256 _num) 함수가 상태변수 x를 _num의 2배가 되도록 실행하는 새로운 LogicContract_V2를 작성하고, 
// LogicContract_V2를 사용하도록 ProxyContract를 업데이트 한 후 올바르게 동작하는 지 확인하시오.
// 단, 프록시 컨트랙트, 클라이언트 컨트랙트, 기존의 로직 컨트랙트 LogicContract_V1의 코드는 어떠한 변경도 없이 그대로 유지되도록 하시오.
//
  contract LogicContract_V2 {    
    uint256 public x;
    uint256 public y;
        
    function updateX(uint256 _num) public {
        x = 2*_num;
    }

    function updateY(uint256 _num) public {
        y = _num;
    }
}

/* 컨트랙트 실행을 통한 확인
(1) LogicContract_V1 배포 
(2) ProxyContract 배포 (LogicContract_V1 주소를 인자로 전달)
(3) ClientContract 배포 (ProxyContract 주소를 인자로 전달)
    (3-1) ClientContract의 doSomething(uint256 _num) 함수를 호출하여 ProxyContract의 x값을 초기화
    (3-1) ProxyContract의 x값을 확인하여 ClientContract의 doSomething(uint256 _num) 함수가 정상적으로 동작하는지 확인
(4) LogicContract_V2 배포 
(5) ProxyContract의 로직 컨트랙트 주소를 LogicContract_V2로 변경
(6) ClientContract의 doSomething(uint256 _num) 함수를 호출하여 ProxyContract의 x값을 변경
    (6-1) ProxyContract의 x값을 확인하여 ClientContract의 doSomething(uint256 _num) 함수가 정상적으로 동작하는지 확인
    (6-2) ProxyContract의 x값이 LogicContract_V2의 x값의 2배로 변경되었는지 확인
    (6-3) ClientContract의 doSomething(uint256 _num) 함수를 호출하여 ProxyContract의 y값을 변경
    (6-4) ProxyContract의 y값을 확인하여 ClientContract의 doSomething(uint256 _num) 함수가 정상적으로 동작하는지 확인
*/
