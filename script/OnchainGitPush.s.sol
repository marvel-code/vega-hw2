// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {OnchainGit} from "../src/OnchainGit.sol";
import {Counter} from "../src/Counter.sol";

contract OnchainGitScript is Script {
    Counter public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address onchainGitAddress = vm.envAddress("ONCHAIN_GIT_ADDRESS");
        OnchainGit onchainGit = OnchainGit(payable(onchainGitAddress));
        counter = new Counter();
        onchainGit.upgradeTo(address(counter));

        vm.stopBroadcast();
    }
}
