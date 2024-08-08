//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        //transfer自动将msg.sender设置为转账方
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;
        //使用 Foundry 的 vm.prank 函数将下一个交易的调用者模拟为 bob
        vm.prank(bob);
        //bob 授权 alice 可以花费 1000 个代币
        ourToken.approve(alice, initialAllowance);
        uint256 transforAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transforAmount);
        //alice=transforAmount
        assertEq(ourToken.balanceOf(alice), transforAmount);
        //bob=初始余额-转账额
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transforAmount);
    }
}
