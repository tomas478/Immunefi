# DeFi Saver PoCs

| Field | Value |
|-------|--------|
| **Immunefi** | https://immunefi.com/bug-bounty/defisaver/ |
| **Scope** | https://immunefi.com/bug-bounty/defisaver/scope/ |
| **Chain** | Ethereum mainnet (fork locally — no public mainnet testing) |
| **Primacy** | **Primacy of Rules** |
| **KYC** | Not required |
| **Max bounty** | $350,000 (smart contracts) |

## In-scope assets (Immunefi, verified 2026-11-27 JST)

| Asset | Notes |
|-------|--------|
| **DeFi Saver V3 smart contracts** | Entire [defisaver-v3-contracts](https://github.com/defisaver/defisaver-v3-contracts) tree **except** `contracts/mocks/` and `contracts/views/`. |
| **Web & app** | https://defisaver.com/ and related UI (separate impact scale). |

Immunefi does **not** list per-contract mainnet addresses on the scope page; use the project's deployment manifest:

- **Repo:** https://github.com/defisaver/defisaver-v3-contracts  
- **Addresses:** [`addresses/mainnet.json`](https://github.com/defisaver/defisaver-v3-contracts/blob/main/addresses/mainnet.json)  
- **Pinned ref for this scaffold:** `9f9324cb36d465e2e2105ad559be8bb57e4d9c9f` (2026-11-25) — same commit as the git submodule below (update both if Immunefi scope lists a newer ref).

## Vendored sources (git submodule)

| Location | Commit |
|----------|--------|
| `evm/lib/defisaver-v3-contracts` | `9f9324cb36d465e2e2105ad559be8bb57e4d9c9f` |

```bash
# from repo root
git submodule update --init --recursive
cd evm && forge build
```

Import in PoC tests via Foundry remapping `defisaver/` (e.g. `defisaver/interfaces/core/IDFSRegistry.sol`). Read-only fork helpers may use local interfaces; recipe PoCs should prefer submodule types.

Findings called out in [audits](https://github.com/defisaver/defisaver-v3-contracts/tree/main/audits) are **out of scope**. PoC required for all severities.

### Core mainnet deployments (from `mainnet.json` @ pin above)

| Contract | Address |
|----------|---------|
| DFSRegistry | `0x287778F121F134C66212FB16c9b53eC991D32f5b` |
| RecipeExecutor (registry id `0x4c69ee1e`, v1.0.7) | `0x6e7dEde13E011Eee74E0c731A06c158377fc1Cae` |
| RecipeExecutor (legacy deployment; Etherscan tag) | `0x1D6DEdb49AF91A11B5C5F34954FD3E8cC4f03A86` — superseded on-chain by registry lookup above |
| AdminVault | `0xCCf3d848e08b94478ED8f46fFead3008faF581fD` |
| DFSProxyRegistry | `0x29474FdaC7142f9aB7773B8e38264FA15E3805ed` |
| StrategyExecutor | `0x3727C31D4D4c5270290FFb20C4C358C84c0792C9` |

Recipe/action contracts are registered in `DFSRegistry` by `bytes4` id (see `id` fields in `mainnet.json`). Trace outward calls to Aave/Maker/Compound only when your impact maps to an **in-scope** smart-contract or web/app impact.

## Fork tests in this monorepo

```bash
cp evm/.env.example evm/.env   # set ETH_RPC_URL
cd evm
forge test --match-contract DefiSaverForkBase -vvv
forge test --match-contract DefiSaverRecipePoC -vvv
```

- **Pinned block:** `26_504_176` (~2026-11-27) — stable bytecode/registry state for local PoCs; bump if your narrative needs a specific upgrade block.  
- **Test files:** `evm/test/defisaver/ForkBase.t.sol`, `evm/test/defisaver/RecipePoC.t.sol` (skips when `ETH_RPC_URL` is unset, same pattern as `test/ForkTemplate.t.sol`).

## Hunting notes

- Focus: recipe composability, leverage flows, subscription/automation triggers, proxy permissions.  
- Map hypotheses to Immunefi **impacts in scope** (theft, freezing, auth/signing abuse, etc.).  
- Do **not** run exploit attempts on live mainnet/testnet; fork only (program prohibited activities).