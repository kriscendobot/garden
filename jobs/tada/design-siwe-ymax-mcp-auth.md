Job completed (doin→tada landed). Here is my completion report.

---

# Completion report — `design-siwe-ymax-mcp-auth`

**What I did.** Investigated and wrote a maintainer-review design for integrating SIWE with ymax so an MCP server authenticates the caller's Ethereum address per tool call. Grounded entirely in public sources (the internal `ymax-web` repo is inaccessible, per the maintainer clarification that arrived in my inbox mid-job — drained and honored).

**What I grounded it in:**
- **ymax product (public):** agoric.com/ymax + Messari + the private-beta blog — a non-custodial cross-chain stablecoin yield orchestrator, "one signature," Keplr today with **MetaMask/EVM planned**; Dan Finlay's note that ymax encodes readable challenges into a MetaMask **ERC-712** signature.
- **ymax on-chain/planner (public, in `Agoric/agoric-sdk`):** the load-bearing find — `packages/portfolio-api/src/evm-wallet/{eip712-messages,message-handler-helpers}.ts` **already** does SIWE-grade verification (EIP-712 typed-data, `recoverTypedDataAddress`, domain/nonce/deadline validation, source-EVM-account binding, Permit2). Plus `portfolio-contract` (Agoric Exo) and `services/ymax-planner`.
- **MCP authorization spec** (rev 2025-06-18: OAuth 2.1 + RFC 9728 PRM + RFC 8707 audience + PKCE) and the six **2025-11-25/2026-07-28 hardening SEPs** from the library.
- The prior SIWE research report (commit `96011938`).

**Recommendation.** Shape **(b) — a custom SIWE verifier as ymax's own MCP OAuth AS+RS**, reusing the EIP-712 verification ymax already owns (same address-as-principal model end to end, lowest dependency, no stale/unaudited siwe-oidc under a funds-moving system). Shape (a) siwe-oidc reserved strictly for a future third-party-federation requirement. The design also specifies: the per-tool declarative auth descriptor + dispatch middleware (401 token → 403 scope → 403 owner-binding), server-issued single-use SIWE nonce + 5–15 min tokens + refresh rotation + RFC 8707 audience binding, **first-class EIP-1271** contract-wallet verification (ymax accounts can be contract wallets), and the Endo/ocap fit (verified address as an attenuating claim, MCP server holds the user's authority not its own).

**What changed.** One new file: `journal/entries/2026/06/24/230700Z-result-gardener-design-siwe-ymax-mcp-auth.md` on `journal2` (commit `a7e347fc`, confirmed on `origin/journal2`).

**Process note / follow-up.** The shared `/home/kris/journal` working tree could not rebase (another gardener's in-progress library ingest left untracked files that blocked checkout). I pushed via an **isolated temp worktree off `origin/journal2`** and reconciled the shared branch ref with `update-ref` (no working-tree touch), then removed the temp worktree — consistent with the isolated-worktree discipline for the concurrently-mutated main tree. No standing garden infra problem; just the expected shared-tree contention.

**Open questions for the maintainer** (need internal ymax-web/GA detail, flagged not guessed): (1) does ymax-web already mint a sign-in session post-"one signature" that the MCP should consume? (2) which signer do MCP callers use at GA — MetaMask/ERC-4361 vs Keplr/CAIP-122? (3) remote-HTTP vs local-stdio MCP transport? (4) any third-party-federation requirement (the sole trigger to flip to shape a)?
