// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {DefiSaverForkBaseTest} from "./ForkBase.t.sol";
import {StrategyModel} from "defisaver/core/strategy/StrategyModel.sol";
import {IDFSRegistry} from "defisaver/interfaces/core/IDFSRegistry.sol";
import {IRecipeExecutor} from "defisaver/interfaces/core/IRecipeExecutor.sol";

/// @title Recipe decode example (read-only)
/// @notice Shows how `StrategyModel.Recipe` fields map to ABI encoding and registry action ids on a mainnet fork.
contract DefiSaverRecipeDecodeTest is DefiSaverForkBaseTest {
    /// @dev SendToken @ mainnet.json pin 9f9324cb — in-scope utils action, no state change in this test.
    bytes4 internal constant SEND_TOKEN_ACTION_ID = 0x02abc227;
    address internal constant SEND_TOKEN_ACTION =
        0x5c19aF6F5de91209c3bc2Ba447b1f5eb53c50759;

    function _exampleRecipe() internal pure returns (StrategyModel.Recipe memory recipe) {
        recipe.name = "DecodeExample";
        recipe.callData = new bytes[](1);
        recipe.callData[0] = hex"";
        recipe.subData = new bytes32[](0);
        recipe.actionIds = new bytes4[](1);
        recipe.actionIds[0] = SEND_TOKEN_ACTION_ID;
        recipe.paramMapping = new uint8[][](1);
        recipe.paramMapping[0] = new uint8[](0);
    }

    /// @dev Round-trip abi.encode / abi.decode for the Recipe tuple (same layout as `executeRecipe` argument).
    function test_decodeRecipeStructRoundTrip() public {
        if (_forkOrSkip()) return;

        StrategyModel.Recipe memory recipe = _exampleRecipe();

        bytes memory encoded = abi.encode(
            recipe.name, recipe.callData, recipe.subData, recipe.actionIds, recipe.paramMapping
        );

        (
            string memory name,
            bytes[] memory callData,
            bytes32[] memory subData,
            bytes4[] memory actionIds,
            uint8[][] memory paramMapping
        ) = abi.decode(encoded, (string, bytes[], bytes32[], bytes4[], uint8[][]));

        assertEq(keccak256(bytes(name)), keccak256(bytes("DecodeExample")));
        assertEq(actionIds.length, 1);
        assertEq(actionIds[0], SEND_TOKEN_ACTION_ID);
        assertEq(callData.length, 1);
        assertEq(callData[0].length, 0);
        assertEq(subData.length, 0);
        assertEq(paramMapping.length, 1);
        assertEq(paramMapping[0].length, 0);

        emit log_named_string("decoded_recipe_name", name);
        emit log_named_bytes32("decoded_action_id", bytes32(actionIds[0]));
    }

    /// @dev Inspect `executeRecipe` calldata: selector + non-empty payload (read-only; no call to RecipeExecutor).
    function test_inspectExecuteRecipeCalldata() public pure {
        StrategyModel.Recipe memory recipe = _exampleRecipe();

        bytes memory callData = abi.encodeWithSelector(IRecipeExecutor.executeRecipe.selector, recipe);

        bytes4 selector;
        assembly {
            selector := mload(add(callData, 32))
        }

        assertEq(selector, IRecipeExecutor.executeRecipe.selector);
        assertGt(callData.length, 4);
    }

    /// @dev On fork: registry resolves SendToken action id to deployed bytecode (matches pinned `mainnet.json`).
    function test_forkDecodeRegistryActionBinding() public {
        if (_forkOrSkip()) return;

        address action = IDFSRegistry(DFS_REGISTRY).getAddr(SEND_TOKEN_ACTION_ID);
        assertTrue(action != address(0), "SendToken registered");
        assertEq(action, SEND_TOKEN_ACTION, "SendToken addr");

        uint256 codeSize;
        assembly {
            codeSize := extcodesize(action)
        }
        assertGt(codeSize, 0, "SendToken bytecode");

        emit log_named_address("send_token_action", action);
        emit log_named_uint("recipe_executor_code_size", RECIPE_EXECUTOR.code.length);
    }
}