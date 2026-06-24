---
ts: 2026-06-02T18:35:43Z
kind: dispatch
role: groom
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/groom--cb5fcd
short_id: cb5fcd
refs:
  - designs/README.md
  - designs/endo-gateway.md
  - designs/endo-gateway-mcp.md
  - designs/gateway-package.md
---

# dispatch: groom — rebucket roadmap toward shortest-MCP-bridge route + identify design gaps + propose PR

Full grooming pass on `designs/README.md` (and `DESIGNS-WITHOUT-PR.md`
if relevant) on `endojs/endo-but-for-bots:llm`. Rebucket and
reprioritize pending milestones to emphasize the **shortest
route to a gateway that can serve as an MCP bridge to Endo
agents**.

Maintainer's framing of "the job" (what completion requires):

1. **Hosting** — tentatively on AWS. The existing
   `designs/gateway-packaging-aws-stack.md` (PR #356, stacked
   sibling of #343) is in flight.
2. **Stripe integration to buy tokens** for:
   - **compute (computrons)**
   - **storage**
   - **network transfer**
   - **inference (cogitrons)**
   Phase 8 of the gateway implementation (PR #396) landed a
   `ResourceLedger` exo with `purchaseTokens(tokens, proof)`
   contract; the Stripe-specific `verifyPaymentProof` adapter
   is the work that remains.
3. **User interface designating users by public key**, with:
   - Optional **bond to OAuth** (no existing design — gap).
   - A mechanism for **key recovery or rotation** (the
     gateway design's Open Question 1 names the Pass-
     Invariant-Eq problem under
     `daemon-agent-network-identity`).

## Required outputs

- Rebucketed roadmap on a branch (PR-shaped output, NOT direct
  commit). Open a DRAFT PR against `llm` from a
  `groom/mcp-bridge-rebucket` branch.
- A `## Design gaps` section in the PR body enumerating designs
  that don't yet exist but block the named completion path.
  At minimum:
  - OAuth bonding to public-key identity.
  - Key recovery / rotation (per Open Question 1 of
    `endo-gateway.md`).
  - Stripe `verifyPaymentProof` adapter design (or
    explicit "implementation-only, no design needed" framing).
- An open-questions append per `skills/groom-open-questions/
  SKILL.md` shape, recording any trade-off recommendations
  that need maintainer adjudication.

## Carry-forward context the groom should fold into the pass

- Today's 9-phase gateway implementation (PRs #343, #388, #389,
  #392, #393, #394, #395, #396, #397) is mid-stream. Phase 10
  (Feature 9 HTTPS proxy compat) is paused on a 529; Phase 11
  (Feature 10 OS packaging) follows. The roadmap should reflect
  the gateway as in-progress, not Not Started.
- Today's `designs/endo-gateway-mcp.md` (PR #376, MERGED) is
  the MCP extension; the roadmap may need to surface it as a
  bin within the gateway cluster.
- PR #390 is the open `@endo/git` rename (was `@endo/endo-git`);
  PR #345 (`@endo/cancel`) merged today. PR #387 is the
  benchmark direct-download (master-variant of #386) DRAFT;
  closes endo#3289.

## Sub-mode

**Full grooming pass** with PR-shaped output. The "PR-shaped"
requirement deviates from the standard "commit directly to the
roadmap branch" discipline; the maintainer wants reviewability
on this rebucket because the strategic shift is substantive.

## Discipline

- Per `roles/groom/AGENT.md` § Procedure (full pass).
- Date the pass 2026-06-02.
- Cite sources for every actual (PR numbers, merge dates,
  test counts).
- Decisions requiring taste go in the open-questions note,
  not the README rebucket.
- Standing relaxation on `endojs/endo-but-for-bots` covers
  the draft-PR open.

## Report

Return:
- PR number + URL.
- Branch name.
- Summary of the rebucket: which designs moved milestones,
  why, and which design gaps are identified.
- Open-questions surfaced for maintainer adjudication.
- Final `Self-improvement: ...`.

The liaison writes the matching result entry and tears down
the dispatch root.
