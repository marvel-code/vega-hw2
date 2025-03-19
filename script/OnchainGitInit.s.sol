// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {OnchainGit} from "../src/OnchainGit.sol";
import {Counter} from "../src/Counter.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract OnchainGitScript is Script {
    Counter public counter;
    OnchainGit public onchainGit;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new Counter();
        onchainGit = new OnchainGit(address(counter));

        vm.stopBroadcast();
    }
}
