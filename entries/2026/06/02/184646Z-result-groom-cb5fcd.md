---
ts: 2026-06-02T18:46:46Z
kind: result
role: groom
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: cb5fcd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 400
    role: new
refs:
  - entries/2026/06/02/183543Z-dispatch-groom-cb5fcd.md
  - entries/2026/06/02/184400Z-message-groom-4c3a95.md
  - https://github.com/endojs/endo-but-for-bots/pull/400
---

# result: groom — PR #400 rebucket for shortest-MCP-bridge route

- **PR #400** DRAFT, base `llm`, head `groom/mcp-bridge-rebucket`.
- Substantive commit `0289d375`: `designs/README.md` +169 / -6.
- Open-questions: `entries/2026/06/02/184400Z-message-groom-4c3a95.md`.

## Rebucket highlights

- **New Milestone B: MCP Bridge Hosting** (cross-cutting). P0
  gateway impl completion → P1 MCP termination → P2 AWS hosting
  → P3 Stripe billing → P4 OAuth bonding + key recovery. P1 and
  P2 admit parallelism once P0 phases 2/7/8 land.
- **New Milestone 7: Public Hosting and Billing** — AWS stack
  (PR #356) + three named design gaps.
- M1 `endo-gateway` row updated to name the 9 implementation
  phases landed today + surface phases 10/11 as pending.
- `endo-gateway-mcp` raised to **Strategic Early in M1**.

## Design gaps identified (in PR #400 body)

- `gateway-oauth-bonding.md` (proposed M7) — bond OAuth ID to
  public-key. Distinct from existing `endoclaw-oauth` and
  `endopi-provider-registry-and-oauth`.
- `gateway-key-recovery.md` (proposed M7) — operator-side
  bearer re-issue conditioned on OAuth proof; narrower than
  `endo-gateway.md` OQ1 Pass-Invariant-Eq.
- `gateway-stripe-adapter.md` (proposed M7) — or
  rationale-as-implementation-only; Phase 8 PR #396 lands the
  `verifyPaymentProof` contract.
- `gateway-resource-classes` (fold into stripe-adapter):
  per-class measurement surfaces for
  computron/cogitron/storage/network.
- Gateway HTTP listener wire-up (existing): tracked as
  Milestone B P0 gap.
- MCP bridge from gateway (existing): covered by
  endo-gateway-mcp.md PR #376 merged today; implementable as-is
  gated on phases 2/7/8.

## Five open questions for maintainer adjudication

In `entries/2026/06/02/184400Z-message-groom-4c3a95.md`:
1. M-bin confirmation for the four design gaps.
2. Whether Milestone B reshapes M1 priority among other 8 rows.
3. Whether `endopi-provider-registry-and-oauth` needs to rise.
4. Whether `gateway-package` retires `endo-gateway` in the
   README when PR #343 merges (recommended defer to next pass).
5. Whether Milestone B's exit criterion captures the
   maintainer intent about the tool surface (static Lal set
   today vs. capability-scoped `daemon-agent-tools` once it
   lands).

## Liaison disposition

Dispatch root torn down. The rebucket PR #400 awaits maintainer
review; the five open questions on the `4c3a95` message gate any
follow-on designer dispatches for the named gaps.
