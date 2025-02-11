// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

/**
 * @dev Errors for the Dynamis contract.
 */
interface DynamisErrors {
    /**
     * @dev Indicates a failure with the caller if the caller is not the owner
     * of a tokenId.
     */
    error CallerNotOwner();

    /**
     * @dev Indicates a failure with the total supply if the total supply
     * exceeds the cap.
     */
    error ExceededCap();

    /**
     * @dev Indicates a failure with the quantity if the quantity of tokens
     * being minted for node minting in the start phase is not divisible by node
     * mint multiplier.
     */
    error IncorrectNodeMintQuantity();

    /**
     * @dev Indicates a failure with the token if the token is not registered as
     * a payment token with a cooresponding price feed.
     */
    error IncorrectPaymentToken();

    /**
     * @dev Indicates a failure with the signature if the signature recovers a
     * different address than the signer.
     */
    error IncorrectSignatureRecovery();

    /**
     * @dev Indicates a failure with the cost if the cost calculated is less
     * than the base cost for a single token.
     */
    error InsufficientCost();

    /**
     * @dev Indicates a failure with the quantity if the quantity is `0`.
     */
    error InsufficientQuantity();

    /**
     * @dev Indicates a failure with the reward if the reward is `0`.
     */
    error InsufficientReward();

    /**
     * @dev Indicates an error with the given argument address. For example,
     * `address(0)`.
     */
    error InvalidAddress();

    /**
     * @dev Indicates an error with the given argument amount. For example, `0`.
     */
    error InvalidAmount();

    /**
     * @dev Indicates an error with the given argument array's arity. For
     * example, `firstArray.length() != secondArray.length()`.
     */
    error InvalidArrayArity();

    /**
     * @dev Indicates an error with the given argument array's length. For
     * example, `array.length() == 0`.
     */
    error InvalidArrayLength();

    /**
     * @dev Indicates an error with the given argument's assignment. For
     * example, `argument == stateVariable`.
     */
    error InvalidAssignment();

    /**
     * @dev Indicates an error with the given argument payable value. For
     * example, `0`.
     */
    error InvalidPayableValue();

    /**
     * @dev Indicates an error with the given argument string. For example,
     * `""`.
     */
    error InvalidString();

    /**
     * @dev Indicates a failure with the phase if the phase being requested is
     * not currently accessible.
     */
    error PhaseInaccessible();

    /**
     * @dev Indicates a failure with the phase if the phase being requested is
     * not currently active.
     */
    error PhaseInactive();

    /**
     * @dev Indicates a failure with the phase if the phase is in between phases
     * and hence is on hold.
     */
    error PhaseOnHold();

    /**
     * @dev Indicates a failure with the sale if the sale being requested is not
     * currently active.
     */
    error SaleInactive();

    /**
     * @dev Indicates a failure with the signature if the signature has already
     * been used at least once.
     */
    error SignatureAlreadyUsed();

    /**
     * @dev Indicates a failure with the deadline if the deadline has been
     * crossed when a signature is verified.
     */
    error SignatureDeadlineCrossed();

    /**
     * @dev Indicates a failure with the expiry if the expiry has not been
     * crossed when a transfer or approval is performed.
     */
    error Vested();
}
