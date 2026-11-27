# EVM / Foundry

Foundry workspace for Immunefi smart-contract PoCs (primary stack: **Origin Protocol**, **DeFi Saver**, **Lista DAO**).

## Setup

```bash
# From repo root
git submodule update --init --recursive   # forge-std + defisaver-v3-contracts

cp evm/.env.example evm/.env   # add RPC URLs locally — never commit

cd evm
forge build
forge test
```

### Vendored protocol sources (`lib/`)

| Path | Pin | Notes |
|------|-----|--------|
| `lib/forge-std` | submodule | Foundry test utils |
| `lib/defisaver-v3-contracts` | `9f9324cb` | [defisaver-v3-contracts](https://github.com/defisaver/defisaver-v3-contracts) — Immunefi scope tree (excl. `mocks/`, `views/`) |

Remapping: `defisaver/` → `lib/defisaver-v3-contracts/contracts/` (see `foundry.toml`).

With `ETH_RPC_URL` in `evm/.env`, fork tests run against a **pinned mainnet block**. Without RPC, fork tests skip and CI still passes (`test/Smoke.t.sol` always runs).

## Program-specific PoCs

Add one subdirectory per bounty program under `evm/programs/`. Keep vendored protocol code and your PoC tests together; point `foundry.toml` `src`/`test` only if you split profiles (optional).

| Directory | Immunefi program | In-scope repo (start here) |
|-----------|------------------|----------------------------|
| `programs/origin/` | [Origin Protocol](https://immunefi.com/bug-bounty/originprotocol/) | [OriginProtocol/arm-oeth](https://github.com/OriginProtocol/arm-oeth) |
| `programs/defisaver/` | [DeFi Saver](https://immunefi.com/bug-bounty/defisaver/) | [defisaver/defisaver-v3-contracts](https://github.com/defisaver/defisaver-v3-contracts) |
| `programs/lista/` | [Lista DAO](https://immunefi.com/bug-bounty/listadao/) | [lista-dao/moolah](https://github.com/lista-dao/moolah) |

Suggested layout per program:

```text
evm/programs/<slug>/
  README.md           # pinned commit, scope notes, contract addresses
  lib/                # optional: forge install target or git submodule
  test/               # PoC tests — copy ForkTemplate.t.sol patterns
```

## Fork workflow (Immunefi)

1. Read the program page for **assets in scope** and pinned deployments.
2. Set `FORK_BLOCK` in your test to the block where balances/oracles match your narrative.
3. Single `testExploit()` (or named clearly) with asserts on fund loss / privilege gain.
4. Document `forge test --match-contract YourPoC -vvv` in the Immunefi report.

See `test/ForkTemplate.t.sol` for block pinning and skip-without-RPC behavior.

**DeFi Saver:** `forge test --match-contract DefiSaverForkBase -vvv` — see `programs/defisaver/README.md` and `test/defisaver/ForkBase.t.sol`.

**DeFi Saver recipe starter:** `forge test --match-contract DefiSaverRecipePoC -vvv` — `test/defisaver/RecipePoC.t.sol` imports interfaces from the submodule.