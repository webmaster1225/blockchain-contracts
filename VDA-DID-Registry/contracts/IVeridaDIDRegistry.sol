/* SPDX-License-Identifier: MIT */
pragma solidity ^0.8.18;

interface IVeridaDIDRegistry {
    /**
     * @notice Emitted when a user register endpoints
     * @param didAddress DID
     * @param endponits A list of registered endpoint
     */
    event Register(address didAddress, string[] endponits);

    /**
     * @notice Emittted when a DID address is revoked
     * @dev Only controller can revoke
     * @param didAddress DID address to be revoked
     */
    event Revoke(address didAddress);

    /**
     * @notice Emitted when controller is set for a DID address
     * @param didAddress DID address
     * @param controller Updated controller address
     */
    event SetController(address didAddress, address controller);

    /**
     * @notice Check whether didAddress is registered
     * @dev Used in the `VDAXPReward` contract
     * @param didAddress DID address to be checked
     * @return bool `true` if registered
     */
    function isRegistered(address didAddress) external view returns(bool);

    /**
     * @notice Register a list of endpoints for a did
     * @dev Update the list if already registered
     * @param didAddress DID address, ex : 0xb794f5ea0ba39494ce839613fffba74279579268
     * @param endpoints List of endpoints
     * @param signature Signature is generated by : sign(${did}/${nonce}/${endpoints[0]}/${endpoints[1]}/...)
     */
    function register(address didAddress, string[] calldata endpoints, bytes calldata signature ) external;

    /**
     * @notice Revoke a DID address
     * @dev Only controller can do this
     * @param didAddress DID address to be revoked
     * @param signature Signature signed by controller of DID
     */
    function revoke(address didAddress, bytes calldata signature) external;

    /**
     * @notice Get a controller of a DID address
     * @param didAddress DID address
     * @return address Controller address
     */
    function getController(address didAddress) external view returns(address);

    /**
     * @notice Set a controller of a DID address
     * @dev Only previous controller can call this function. After register a DID by register(...) function, the did itself is a controller.
     * @param didAddress DID address to change the controller
     * @param controller New controller address to be set
     * @param signature Signature signed by previous controller
     */
    function setController(address didAddress, address controller, bytes calldata signature) external;
    
    /**
     * @notice Lookup the endpoints for a given DID address
     * @param didAddress : DID address.
     * @return address Address of controller
     * @return string[] Array of endpoints for a given DID address
     */
    function lookup(address didAddress) external view returns(address, string[] memory);

    /**
     * @notice Obtain the nonce for a DID address
     * @param didAddress DID address
     */
    function nonce(address didAddress) external view returns(uint);

    /**
     * @notice Return the number of active DIDs
     * @dev Active DIDs doesn't include revoked ones.
     * @return uint Number of active DIDs
     */
    function activeDIDCount() external view returns(uint);

    /**
     * @notice Get the registered did list by starting index & count
     * @dev Only owner can see it
     * @param startIndex Start index in the registered DID array. Index started from 0
     * @param count Number of DIDs to be retrieved
     * @return address[] Address list of Registered DIDs
     */
    function getDIDs(uint startIndex, uint count) external view returns(address[] memory);
}