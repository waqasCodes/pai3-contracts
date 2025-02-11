// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { IERC721A } from "erc721a/contracts/IERC721A.sol";

/**
 * @title IDynamis.
 * @author PAI3 Team.
 * @notice Dynamis NFT collection interface.
 */
interface IDynamis is IERC721A {
    /* ========================== TYPES ========================== */

    enum Sale {
        NODE,
        WHITELIST
    }

    enum Phase {
        START,
        SECOND,
        THIRD,
        FOURTH,
        END
    }

    enum Scenario {
        RESERVED,
        FIRST_PHASE
    }

    struct Cap {
        /// @custom:member Cap on the number of NFTs minted.
        uint128 cap;
        /// @custom:member Number of NFTs minted.
        uint128 minted;
    }

    struct Window {
        /// @custom:member Timestamp at which a phase will start.
        uint128 startTimestamp;
        /// @custom:member Timestamp at which a phase will end.
        uint128 endTimestamp;
    }

    struct Record {
        /// @custom:member Timestamp at which a NFT was minted.
        uint64 startTimestamp;
        /// @custom:member Timestamp after which vesting will end.
        uint64 vestingEndTimestamp;
        /// @custom:member Timestamp after which reward generation will stop.
        uint64 rewardingEndTimestamp;
        /// @custom:member Timestamp at which a transfer was performed.
        uint64 lastInteractedTimestamp;
    }

    struct DynamisParams {
        /// @custom:member Address of the contract owner.
        address owner;
        /// @custom:member Token collection name.
        string name;
        /// @custom:member Token collection symbol.
        string symbol;
        /// @custom:member Cap on the number of NFTs minted.
        uint256 cap;
        /// @custom:member Address of the PAI3 token.
        IERC20 pai3;
        /// @custom:member Address of the treasury wallet.
        address treasuryWallet;
        /// @custom:member Address of the reward wallet.
        address rewardWallet;
        /// @custom:member Address of the signature signer.
        address signer;
        /// @custom:member Base URI for computing tokenURI.
        string baseURI;
        /// @custom:member Situational caps on the number of NFTs minted.
        uint128[2] situationalCaps;
        /// @custom:member Base costs for sales.
        uint256[2] saleBaseCosts;
        /// @custom:member Base costs for phases.
        uint256[5] phaseBaseCosts;
        /// @custom:member Duration windows for phases and sales.
        Window[3] windows;
        /// @custom:member Addresses of the payment tokens.
        IERC20[] tokens;
        /// @custom:member Addresses of the price feeds.
        AggregatorV3Interface[] priceFeeds;
    }

    /* ========================== EVENTS ========================== */

    /**
     * @dev Emitted when `quantity` of NFTs is minted by `minter` starting from
     * `startTokenId` using `token` with the amount of `cost`.
     */
    event Mint(
        address indexed minter,
        IERC20 token,
        uint256 startTokenId,
        uint256 quantity,
        uint256 cost
    );

    /**
     * @dev Emitted when `reward` and `due` corresponding to a `tokenId` is
     * claimed by `claimer`.
     */
    event Claim(
        address indexed claimer,
        uint256 tokenId,
        uint256 reward,
        uint256 due
    );

    /**
     * @dev Emitted when signer is changed to `newSigner` from `oldSigner`.
     */
    event UpdateSigner(address indexed newSigner, address indexed oldSigner);

    /**
     * @dev Emitted when baseURI is changed to `newBaseURI` from `oldBaseURI`.
     */
    event UpdateBaseURI(string newBaseURI, string oldBaseURI);

    /**
     * @dev Emitted when configuration of `sale` is changed to `newWindow` and
     * `newBaseCost` from `oldWindow` and `oldBaseCost`.
     */
    event UpdateSale(
        Sale sale,
        Window newWindow,
        uint256 newBaseCost,
        Window oldWindow,
        uint256 oldBaseCost
    );

    /**
     * @dev Emitted when `window` is set for `phase`.
     */
    event SetPhaseWindow(Phase phase, Window window);

    /**
     * @dev Emitted when the price feed of a `token` is changed to
     * `newPriceFeed` from `oldPriceFeed`.
     */
    event UpdatePriceFeed(
        IERC20 token,
        AggregatorV3Interface newPriceFeed,
        AggregatorV3Interface oldPriceFeed
    );

    /* ========================== FUNCTIONS ========================== */

    /**
     * @notice Safely mints `quantity` NFTs and transfers them to `to`.
     * NOTE: Only owner can call this function. Mints reserved NFTs. Situational
     * cap is applied for reserved NFTs.
     * @param to Address to receive the NFTS.
     * @param quantity Amount of NFTs to mint.
     */
    function safeMint(address to, uint256 quantity) external;

    /**
     * @notice Mints `quantity` NFTs and transfers them to the caller.
     * NOTE: Payable value must be given. Only accepts Eth as a payment method.
     * Mints NFTs for a sale.
     * @param quantity Amount of NFTs to mint.
     * @param deadline Expiration deadline for the signed message.
     * @param signature Signed message to determine correctness.
     */
    function mintSaleWithEth(
        uint256 quantity,
        uint256 deadline,
        Sale sale,
        bytes memory signature
    ) external payable;

    /**
     * @notice Mints `quantity` NFTs and transfers them to the caller.
     * NOTE: Only accepts `token` if it is registered as a payment method. Mints
     * NFTs for a sale.
     * @param token Registered payment method.
     * @param quantity Amount of NFTs to mint.
     * @param deadline Expiration deadline for the signed message.
     * @param signature Signed message to determine correctness.
     */
    function mintSale(
        IERC20 token,
        uint256 quantity,
        uint256 deadline,
        Sale sale,
        bytes memory signature
    ) external;

    /**
     * @notice Mints `quantity` NFTs and transfers them to the caller.
     * NOTE: Payable value must be given. Only accepts Eth as a payment method.
     * Mints NFTs for a phase. Situational cap is applied for first phase NFTs.
     * @param quantity Amount of NFTs to mint.
     */
    function mintWithEth(uint256 quantity) external payable;

    /**
     * @notice Mints `quantity` NFTs and transfers them to the caller.
     * NOTE: Only accepts `token` if it is registered as a payment method. Mints
     * NFTs for a phase. Situational cap is applied for first phase NFTs.
     * @param token Registered payment method.
     * @param quantity Amount of NFTs to mint.
     */
    function mint(IERC20 token, uint256 quantity) external;

    /**
     * @notice Transfers rewards collected by the user relevant to a `tokenId`.
     * @param tokenId Unique identifier of the token.
     * @param deadline Expiration deadline for the signed message.
     * @param signature Signed message to determine correctness.
     */
    function claim(
        uint256 tokenId,
        uint256 deadline,
        bytes memory signature
    ) external;

    /**
     * @notice Change the state of the contract from unpaused to paused.
     * NOTE: Only owner can call this function. Can only be called when
     * unpaused.
     */
    function pause() external;

    /**
     * @notice Change the state of the contract from paused to unpaused.
     * NOTE: Only owner can call this function. Can only be called when paused.
     */
    function unpause() external;

    /**
     * @notice Updates the address of the signature signer.
     * NOTE: Only owner can call this function.
     * @param newSigner Address of the new signature signer.
     */
    function updateSigner(address newSigner) external;

    /**
     * @notice Updates the value of base URI.
     * NOTE: Only owner can call this function.
     * @param newBaseURI String of the new base URI.
     */
    function updateBaseURI(string memory newBaseURI) external;

    /**
     * @notice Updates the configuration of a given `sale`.
     * NOTE: Only owner can call this function.
     * @param sale Unique identifier of the sale.
     * @param newWindow Window to update for the given sale.
     * @param newBaseCost Base cost to update for the given phase.
     */
    function updateSale(
        Sale sale,
        Window memory newWindow,
        uint256 newBaseCost
    ) external;

    /**
     * @notice Sets the `window` of a given `phase`.
     * NOTE: Only owner can call this function.
     * @param phase Unique identifier of the phase.
     * @param window Window to set for the given phase.
     */
    function setPhaseWindow(Phase phase, Window memory window) external;

    /**
     * @notice Adds, removes or updates the `priceFeed` of a given `token`.
     * NOTE: Only owner can call this function.
     * @param token Address of the payment method.
     * @param priceFeed Price feed to add, remove or update for the given
     * payment method.
     */
    function updatePriceFeed(
        IERC20 token,
        AggregatorV3Interface priceFeed
    ) external;

    /**
     * @notice Time based records relevant to a `tokenId`.
     * @param tokenId Unique identifier of the NFT.
     * @return record Complete time based record of the NFT.
     */
    function tokenRecords(
        uint256 tokenId
    ) external view returns (Record memory);

    /**
     * @notice Vesting duration in seconds, that is, 1 year time.
     */
    function VESTING_DURATION() external view returns (uint64);

    /**
     * @notice Reward duration in seconds, that is, 3 years time.
     */
    function REWARD_DURATION() external view returns (uint64);

    /**
     * @notice Reward generated per second.
     */
    function REWARD_PER_SECOND() external view returns (uint256);

    /**
     * @notice Cap on the number of NFTs minted for phases and sales.
     */
    function CAP() external view returns (uint256);

    /**
     * @notice Address of the PAI3 token.
     */
    function PAI3() external view returns (IERC20);

    /**
     * @notice Address of the treasury wallet.
     */
    function TREASURY_WALLET() external view returns (address);

    /**
     * @notice Address of the reward wallet.
     */
    function REWARD_WALLET() external view returns (address);

    /**
     * @notice Address of the signature signer.
     */
    function signer() external view returns (address);

    /**
     * @notice Base URI for computing tokenURI. If set, the resulting URI for
     * each NFT will be the concatenation of the base URI and the tokenId.
     */
    function baseURI() external view returns (string memory);

    /**
     * @notice Recorded mint Supply given a specific scenario and a cap that is
     * applied in that situation.
     * @param index Unique identifier of the mint scenario.
     * @return cap Cap on the number of NFTs minted in the given mint scenario.
     * @return minted Number of NFTs minted in the given mint scenario.
     */
    function situationalCaps(
        uint256 index
    ) external view returns (uint128, uint128);

    /**
     * @notice Base cost for a sale.
     * @param index Unique identifier of the sale.
     * @return baseCost Base cost of a NFT in the given sale.
     */
    function saleBaseCosts(uint256 index) external view returns (uint256);

    /**
     * @notice Duration window for a sale.
     * @param index Unique identifier of the sale.
     * @return startTimestamp Start timestamp of the given sale.
     * @return endTimestamp End timestamp of the given sale.
     */
    function saleWindows(
        uint256 index
    ) external view returns (uint128, uint128);

    /**
     * @notice Base cost for a phase.
     * @param index Unique identifier of the phase.
     * @return baseCost Base cost of a NFT in the given phase.
     */
    function phaseBaseCosts(uint256 index) external view returns (uint256);

    /**
     * @notice Duration window for a phase.
     * @param index Unique identifier of the phase.
     * @return startTimestamp Start timestamp of the given phase.
     * @return endTimestamp End timestamp of the given phase.
     */
    function phaseWindows(
        uint256 index
    ) external view returns (uint128, uint128);

    /**
     * @notice Due rewards relevant to a `tokenId`.
     * @param tokenId Unique identifier of the NFT.
     * @return due Due rewards not yet claimed.
     */
    function dues(uint256 tokenId) external view returns (uint256);

    /**
     * @notice Address of the price feed relevant to a registered payment
     * method.
     * @param token Address of the payment method.
     * @return priceFeed Address of the price feed.
     */
    function priceFeeds(
        IERC20 token
    ) external view returns (AggregatorV3Interface);
}
