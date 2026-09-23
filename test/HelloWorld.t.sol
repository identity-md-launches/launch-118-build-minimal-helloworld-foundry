// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {HelloWorld} from "../src/HelloWorld.sol";

// Only the built-in Foundry cheatcode needed to fund the rejection test.
interface Vm {
    function deal(address account, uint256 newBalance) external;
}

contract HelloWorldTest {
    Vm private constant VM = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    HelloWorld private helloWorld;

    function setUp() public {
        helloWorld = new HelloWorld();
    }

    function testGreetReturnsHelloWorld() public view {
        require(keccak256(bytes(helloWorld.greet())) == keccak256(bytes("Hello, world!")), "incorrect greeting");
    }

    function testGreetRejectsEther() public {
        VM.deal(address(this), 1 wei);

        (bool success,) = address(helloWorld).call{value: 1 wei}(abi.encodeCall(HelloWorld.greet, ()));

        require(!success, "greet must reject ETH");
        require(address(helloWorld).balance == 0, "contract retained ETH");
        require(address(this).balance == 1 wei, "sender lost ETH");
    }

    function testRejectsUnknownFunction() public {
        (bool success,) = address(helloWorld).call(abi.encodeWithSignature("unknownFunction()"));

        require(!success, "unknown function must revert");
    }

    function testRejectsPlainEtherTransfer() public {
        VM.deal(address(this), 1 wei);

        (bool success,) = address(helloWorld).call{value: 1 wei}("");

        require(!success, "plain ETH transfer must revert");
        require(address(helloWorld).balance == 0, "contract retained ETH");
        require(address(this).balance == 1 wei, "sender lost ETH");
    }
}
