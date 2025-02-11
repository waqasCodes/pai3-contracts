// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title PAI3.
 * @author PAI3 Team.
 * @notice PAI3 token.
 */
contract PAI3 is Ownable, ERC20 {
    /* ========================== CONSTRUCTOR ========================== */

    /**
     * @dev Constructor. Assigns ownership and mints total supply.
     * @param owner_ Address of the contract owner.
     * @param rewardWallet_ Address of the reward wallet.
     * @param totalSupply_ Amount of tokens to mint.
     */
    constructor(
        address owner_,
        address rewardWallet_,
        uint256 totalSupply_
    ) Ownable(owner_) ERC20("PAI3", "PAI3") {
        _mint(rewardWallet_, totalSupply_);
    }
}
