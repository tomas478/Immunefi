# Solana / Anchor

Anchor workspace skeleton for Immunefi PoCs (**Raydium**, **Orca**, and program-specific work).

## Prerequisites

- [Solana CLI](https://docs.anza.xyz/cli/install) (local validator)
- [Anchor](https://www.anchor-lang.com/docs/installation) 0.30.x (matches `Anchor.toml`)
- Node 18+ and `yarn` or `npm`

## Setup

```bash
cd solana
yarn install          # or npm install
solana-test-validator   # separate terminal
anchor build
anchor test           # builds, deploys to localnet, runs tests/poc.ts
```

## Client / test pattern

1. `tests/poc.ts` shows **initialize → increment** against the local validator via `AnchorProvider.env()`.
2. For real bounty PoCs, add programs under `programs/<name>/` or keep exploit clients in `tests/` and pin the program commit from the Immunefi scope page.
3. **CPI:** When your PoC invokes in-scope Raydium/Orca instructions, build with the `cpi` feature and pass every account the upstream IDL expects—wrong ordering fails on-chain the same way as production. Document signer seeds and `invoke_signed` in the report.

## Research folders (scope pointers)

| Directory | Program | In-scope repo |
|-----------|---------|---------------|
| `research/raydium/` | [Raydium](https://immunefi.com/bug-bounty/raydium/) | https://github.com/raydium-io/raydium-amm |
| `research/orca/` | [Orca](https://immunefi.com/bug-bounty/orca/) | https://github.com/orca-so/whirlpools |

Clone upstream into `research/<slug>/vendor/` when you start a sprint; do not commit private keys.

## minimal `programs/poc`

Template counter only—replace with your exploit program or delete once real PoCs land.