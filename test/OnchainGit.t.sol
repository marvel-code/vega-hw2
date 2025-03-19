// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OnchainGit} from "../src/OnchainGit.sol";
import {Counter} from "../src/Counter.sol";

contract OnchainGitTest is Test {
    OnchainGit onchainGit;
    Counter counter;
    address nonOwner = address(0x1234);

    function setUp() public {
        counter = new Counter();
        onchainGit = new OnchainGit(address(counter));
    }

    function testInitialVersion() public view {
        assertEq(onchainGit.currentVersion(), address(counter));
        assertEq(onchainGit.versionHistory(0), address(counter));
    }

    function testUpgradeToNewImplementation() public {
        Counter newCounter = new Counter();
        onchainGit.upgradeTo(address(newCounter));
        assertEq(onchainGit.currentVersion(), address(newCounter));
        assertEq(onchainGit.versionHistory(1), address(newCounter));
        assertNotEq(onchainGit.versionHistory(0), address(newCounter));
    }

    function testUpgradeToZeroAddress() public {
        vm.expectRevert("Invalid address");
        onchainGit.upgradeTo(address(0));
    }

    function testUpgradeToSameAddress() public {
        vm.expectRevert("Already active");
        onchainGit.upgradeTo(address(counter));
    }

    function testOnlyOwnerUpgrade() public {
        Counter newCounter = new Counter();
        vm.prank(nonOwner);
        vm.expectRevert();
        onchainGit.upgradeTo(address(newCounter));
    }

    function testDelegateCallsToImplementation() public {
        Counter proxyCounter = Counter(address(onchainGit));
        proxyCounter.setNumber(42);
        assertEq(proxyCounter.number(), 42);
        proxyCounter.increment();
        assertEq(proxyCounter.number(), 43);
    }

    function testRollbackValid() public {
        Counter newCounter = new Counter();
        onchainGit.upgradeTo(address(newCounter));
        onchainGit.rollbackTo(0);
        assertEq(onchainGit.currentVersion(), address(counter));
        assertEq(onchainGit.versionHistory(2), address(counter));
    }

    function testRollbackOutOfRange() public {
        vm.expectRevert("Index out of range");
        onchainGit.rollbackTo(1);
    }

    function testRollbackAlreadyActive() public {
        Counter newCounter = new Counter();
        onchainGit.upgradeTo(address(newCounter));
        vm.expectRevert("Already active");
        onchainGit.rollbackTo(1);
    }

    function testOnlyOwnerRollback() public {
        Counter newCounter = new Counter();
        onchainGit.upgradeTo(address(newCounter));
        vm.prank(nonOwner);
        vm.expectRevert();
        onchainGit.rollbackTo(0);
    }
}
