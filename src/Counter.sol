// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {console} from "forge-std/console.sol";

contract Counter is UUPSUpgradeable, Ownable {
    uint256 public number;

    constructor() Ownable(msg.sender) {}

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function _authorizeUpgrade(address) internal override onlyProxy {}
}
