// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Counter} from "./Counter.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract OnchainGit is ERC1967Proxy, Ownable, ReentrancyGuard {
    address[] public versionHistory;
    address public currentVersion;

    constructor(
        address initialVersion
    ) ERC1967Proxy(initialVersion, "") Ownable(msg.sender) {
        require(initialVersion != address(0), "Invalid address");
        versionHistory.push(initialVersion);
        currentVersion = initialVersion;
    }

    function upgradeTo(
        address newImplementation
    ) public onlyOwner nonReentrant {
        require(newImplementation != address(0), "Invalid address");
        require(newImplementation != currentVersion, "Already active");
        versionHistory.push(newImplementation);
        currentVersion = newImplementation;
        Counter impl = Counter(address(this));
        impl.upgradeToAndCall(newImplementation, "");
    }

    function rollbackTo(uint index) public onlyOwner {
        require(
            index < versionHistory.length && index >= 0,
            "Index out of range"
        );
        upgradeTo(versionHistory[index]);
    }

    function getVersionHistoryLength() public view returns (uint256) {
        return versionHistory.length;
    }
}
