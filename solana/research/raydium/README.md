# Raydium research

- **Immunefi:** https://immunefi.com/bug-bounty/raydium/ (managed triage)
- **Primary repo:** https://github.com/raydium-io/raydium-amm
- **Also in scope:** cp-swap, CLMM, etc. — read latest **Assets in Scope** on the program page.

## Workflow

1. Note pinned commit / deployment from Immunefi scope.
2. `git clone` into `research/raydium/vendor/` (gitignored if large — use submodule optionally).
3. Reproduce bugs with `solana-test-validator` + upgraded BPF or against devnet only where scope allows (never mainnet exploitation).
4. Immunefi triage responds on-page — keep questions in the dashboard.

Audit carve-outs on CLMM/Hybrid are often OOS; grep program exclusions before PoC investment.