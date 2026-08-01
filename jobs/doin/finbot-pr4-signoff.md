---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: orchestrator

# Merge-governance sign-off + merge for kriscendobot/finbot PR #4

PR: https://github.com/kriscendobot/finbot/pull/4 (DRAFT, OPEN)
Head: `b70fb80c912e726e1dab1756f898e643aa3e1de7` (unchanged since sign-off)
Base: `main`. CI GitHub Actions `test`: green. Mergeable.

Both merge-governance gates are already cleared at the **current, unchanged**
head `b70fb80`:

1. **Panel — PASSED.** The scripted panel ran on 2026-07-29 at head `b70fb80`,
   recorded 28 formal seat verdicts, and passed (report:
   `jobs/tada/finbot-pr4-panel-20260729.md`). The one must-fix from the prior
   panel round — omitted `llmProgram` capabilities must deny all host tools — was
   fixed in commit `b70fb80` with a planner/wallet regression test.
2. **Orchestrator sign-off — PASSED.** An orchestrator sign-off passed on
   2026-07-29 at head `b70fb80` (report: `jobs/tada/finbot-pr4-fable-signoff.md`,
   "sign-off: passed for PR #4 at b70fb80"), confirming the omitted-capabilities
   fix fail-closes `llmProgram` tool access and its regression passes. That
   sign-off explicitly took **no merge action**, so the increment never landed —
   this job finishes it.

## What to do

You hold the merge authority for this increment (governance: the merge is the
orchestrator's authority, or a conductor it directs — NOT the press's).

1. **Verify at claim time** (idempotence + freshness):
   - `gh pr view https://github.com/kriscendobot/finbot/pull/4 --json isDraft,state,headRefOid,statusCheckRollup`.
   - If the head is **still `b70fb80`**, CI is **green**, and the PR is still open:
     both gates above hold at the current head → proceed to merge.
   - If the head has **moved off `b70fb80`**, do NOT merge on the stale gates:
     re-post a fresh panel at the new head, and stop. The gates must be met at the
     head you merge.
   - If already merged, this is a NO-OP — report and stop.
2. **Execute the merge** (un-draft, then merge; or direct a conductor to). This is
   the FIRST finbot increment landing under the 2026-07-22 two-gate governance;
   land it cleanly (respect the repo's merge style; leave `main` green).
3. Governance note (2026-08-01 maintainer decision): the sign-off gate is **no
   longer pinned to Fable/mentat**. The gate itself is unchanged and is satisfied
   by the passed panel + passed orchestrator sign-off recorded above. Do not
   re-incur mentat spend re-reviewing what already passed at this unchanged head —
   verify, then merge.

## Ignore the obsolete panel-rerun

`jobs/todo/finbot-pr4-panel-rerun-20260725` is **stale**: it describes PR #4 as of
2026-07-25 (head `63df8109`, "prior panel requested changes"), a state since
resolved — the panel actually ran and PASSED at the current head `b70fb80` on
07-29, followed by the passed sign-off. That parked job was promoted mechanically
on 2026-08-01 without re-checking that the panel already ran. It targets a head
(`63df8109`) that is not the current tip. Do not let it block or race this merge;
it can be dropped as obsolete once PR #4 is merged.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T09:59:18Z
