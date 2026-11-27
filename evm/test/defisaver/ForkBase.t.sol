// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

/// @title DeFi Saver fork base (Immunefi scaffold)
/// @notice Read-only mainnet-fork checks against core in-scope contracts.
/// @dev Addresses match `addresses/mainnet.json` on defisaver-v3-contracts @ 9f9324cb (2026-11-25).
///      Pin block for stable registry/action bytecode — update before filing a report if your PoC
///      depends on oracle state or a specific recipe revision.
contract DefiSaverForkBaseTest is Test {
    /// @dev Recent Ethereum mainnet height (~2026-11-27) — reproducible fork baseline for local PoCs.
    uint256 internal constant FORK_BLOCK = 26_504_176;

    address internal constant DFS_REGISTRY =
        0x287778F121F134C66212FB16c9b53eC991D32f5b;
    address internal constant RECIPE_EXECUTOR =
        0x6e7dEde13E011Eee74E0c731A06c158377fc1Cae;
    address internal constant ADMIN_VAULT =
        0xCCf3d848e08b94478Ed8f46fFead3008faF581fD;
    address internal constant DFS_PROXY_REGISTRY =
        0x29474FdaC7142f9aB7773B8e38264FA15E3805ed;
    address internal constant STRATEGY_EXECUTOR =
        0x3727C31D4D4c5270290FFb20C4C358C84c0792C9;

  bytes4 internal constant RECIPE_EXECUTOR_ID = 0x4c69ee1e;

    function _rpcUrl() internal view returns (string memory url) {
        try vm.envString("ETH_RPC_URL") returns (string memory v) {
            return v;
        } catch {
            return "";
        }
    }

    function _forkOrSkip() internal returns (bool skipped) {
        string memory rpc = _rpcUrl();
        if (bytes(rpc).length == 0) {
            emit log_string("ETH_RPC_URL unset - skipping fork test (expected in CI)");
            vm.skip(true);
            return true;
        }
        vm.createSelectFork(rpc, FORK_BLOCK);
        return false;
    }

    function _assertHasCode(address who, string memory label) internal view {
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(who)
        }
        assertGt(codeSize, 0, label);
    }

    function test_forkCoreContractsDeployed() public {
        if (_forkOrSkip()) return;

        _assertHasCode(DFS_REGISTRY, "DFSRegistry");
        _assertHasCode(RECIPE_EXECUTOR, "RecipeExecutor");
        _assertHasCode(ADMIN_VAULT, "AdminVault");
        _assertHasCode(DFS_PROXY_REGISTRY, "DFSProxyRegistry");
        _assertHasCode(STRATEGY_EXECUTOR, "StrategyExecutor");
    }

    function test_forkRecipeExecutorWiredToRegistry() public {
        if (_forkOrSkip()) return;

        assertTrue(IDFSRegistry(DFS_REGISTRY).isRegistered(RECIPE_EXECUTOR_ID), "recipe registered");
        address recipeFromReg = IDFSRegistry(DFS_REGISTRY).getAddr(RECIPE_EXECUTOR_ID);
        assertEq(recipeFromReg, RECIPE_EXECUTOR, "registry recipe addr");

        // v1.0.7 RecipeExecutor embeds REGISTRY_ADDR; there is no public registry() getter.
        address admin = IRecipeExecutor(RECIPE_EXECUTOR).adminVault();
        assertEq(admin, ADMIN_VAULT, "adminVault");
    }

    /// @dev Placeholder — replace with a minimal recipe/strategy exploit path; do not submit without real impact.
    function testExploit() public {
        if (_forkOrSkip()) return;

        // 1. Identify in-scope action(s) under `contracts/actions/**` and the recipe/subscription path.
        // 2. Fork impersonation: vm.prank(userProxy) — use DFSProxyRegistry / user's DSProxy as needed.
        // 3. Build calldata for RecipeExecutor.executeRecipe or executeRecipeFromStrategy.
        // 4. Assert concrete loss of funds, auth bypass, or other Immunefi impact — not eth_call smoke tests.

        emit log_string("testExploit: hypothesis slot - implement before Immunefi submission");
        assertTrue(true, "scaffold placeholder");
    }
}

interface IDFSRegistry {
    function getAddr(bytes4 _id) external view returns (address);
    function isRegistered(bytes4 _id) external view returns (bool);
}

interface IRecipeExecutor {
    function adminVault() external view returns (address);
}