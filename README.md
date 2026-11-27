# immunefi

Monorepo starter for **Immunefi** proof-of-concept work on **EVM (Foundry)** and **Solana (Anchor)**.

Planning notes (shortlist, weekly rhythm, tooling) live in the Cursor Project store under `docs/immunefi-fulltime-shortlist.md` and `docs/immunefi-hunting-guide.md` — not vendored here. Primary programs this layout targets:

| Program | Chain | Focus |
|---------|-------|--------|
| [Origin Protocol](https://immunefi.com/bug-bounty/originprotocol/) | ETH, Base, Arbitrum | Yield / LST / ARM; fork PoC with pinned block |
| [DeFi Saver](https://immunefi.com/bug-bounty/defisaver/) | Ethereum | Recipe composability, leverage |
| [Lista DAO](https://immunefi.com/bug-bounty/listadao/) | BSC | CDP `lisUSD`, `moolah` lending |
| [Raydium](https://immunefi.com/bug-bounty/raydium/) | Solana | AMM / cp-swap (Immunefi triage) |
| [Orca](https://immunefi.com/bug-bounty/orca/) | Solana | Whirlpools CLMM |

## Layout

```text
evm/          Foundry — fork templates, programs/origin|defisaver|lista/
solana/       Anchor workspace — programs/poc, research/raydium|orca/
```

## Setup

**EVM**

```bash
cp evm/.env.example evm/.env   # add RPC URLs locally; never commit
cd evm && forge test
```

**Solana**

```bash
cd solana
yarn install
solana-test-validator   # separate terminal
anchor build && anchor test
```

## Weekly workflow (full-time hunting)

Recon and scope diffs Monday; EVM fork PoCs mid-week (`forge test` on pinned blocks); Solana local-validator tests before Friday submit-or-hold; Saturday duplicate and Immunefi dashboard hygiene. Keep at most five primaries deep—swap one bench program when scope stalls.

## CI

GitHub Actions runs `forge test` in `evm/` (fork tests skip without `ETH_RPC_URL`) and `anchor build` in `solana/`. No repository secrets required.

## License

MIT — see [LICENSE](./LICENSE).