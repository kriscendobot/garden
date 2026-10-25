**Gauntlet viability for kriscendobot/minion.town PR #220 ("feat(settings): add resumable guest account deletion"): proceed.**

I only read GitHub (PR facts, the related PRs, main's history and tree). I made no changes, opened no PR and used no gauntlet budget.

**PR state:** open, draft, mergeable, with no reviews yet. The base is the frozen snapshot `main-df5bd2d`, and the head is `b0cf0289` from the weave this morning (2026-10-25T07:28Z).

**Deciding question:** Is resumable account deletion for browser guests still missing from `main`, with #220 as the only open implementation of it?

**Evidence:**
- **No other implementation exists.**
  - Deletion first landed in #200, which was reverted (`87cebebf`).
  - It was re-landed in #213, which was also reverted (`0e644c0c`, via #214).
  - The re-land #216 was closed and split into three PRs: #218 (guest bond ledger, merged 2026-10-24 as `c104813b`), #219 (settings menu and sign-out, still open) and #220 (the deletion itself).
  - #220 is the only open PR with "deletion" in its title.
- **Main still lacks the feature.** `src/auth/stores/dynamodb.ts` on `main` has no `closeGuestBonds` or `GuestBondsClosedError`. Main's history includes `3ef7d62e`, "move the guest deletion facet to #220", so #218 handed that code to this PR on purpose.
- **The premise still holds.** The prerequisite storage migration (#218) has landed and deployed, as the split plan intended. This PR is the planned last step, and nothing newer has replaced it.
- **One thing to know going in:** the branch still includes #219's commit (`2e563013`) underneath its own four, because #219 hasn't merged. The weave report says the next weave drops it once #219 lands. The panel will review that commit too until then, but it doesn't make #220 stale.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr220-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (241994 cached reads)
- Output: 2038 tokens
- Cost: $0.4823428
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
