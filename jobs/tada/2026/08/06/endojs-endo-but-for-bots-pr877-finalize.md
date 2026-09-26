The PR is un-drafted, OPEN, MERGEABLE, based on live `llm`. The merge is blocked pending re-approval, which I've escalated. Job outcome is a stall, so it carries the declined-merge marker.

orchestration-failed: true

## Conductor report — endojs/endo-but-for-bots#877 (feat/endor-npm-dual-build-execution → llm)

**Outcome: NOT merged — stalled on `merge blocked: no maintainer approval` (rebase invalidated the approval).**

### What I did
- Verified guards: bot repo `endojs/endo-but-for-bots`, base `llm` (live trunk, **not** a frozen snapshot — no unfreeze needed), PR OPEN + MERGEABLE.
- Confirmed the blocking rebase (`endojs-endo-but-for-bots-pr877-rebase`) already completed (in `jobs/tada/`): it resolved the base conflict and force-pushed head `c48a7d83d`; 25 CI checks dispatched.
- **Un-drafted the PR** (`gh pr ready`) — the curation step the job requested; readies it for re-review. Now `isDraft:false`.
- Ran the deterministic maintainer-approval gate (`pr-maintainer-approval-gh.sh`): **exit 1 — no APPROVED review on the current head**.
- Alerted the maintainer via the liaison inbox (message delivered).

### Why the merge is blocked
kriskowal's latest `APPROVED` review (2026-08-06 06:31Z) is on commit `58bdaa60f`. The rebase force-pushed a new head `c48a7d83d` at 06:49Z — **after** the approval — and changed the tree (conflict resolution preserving the base's dependency-edge / shared-endowment / bundle-doc changes alongside the PR's self-reference + text-codec work). The approval-on-current-head gate correctly treats the prior approval as stale. The job body anticipated the rebase but assumed the approval would survive it; the deterministic gate says otherwise, and I did not merge over a stale approval.

At report time CI was still all-pending (no failures observed) — the blocker is the approval, not CI.

### Follow-ups (I do not post these myself)
- **kriskowal (or a journal maintainer) re-approves endojs/endo-but-for-bots#877 at head `c48a7d83d`.** Once re-approved and CI green, a fresh `merge`/conduct job lands it with `--merge`. Repo has no auto-merge enabled, so `--auto` cannot be pre-armed.
- Base is live `llm`; no frozen-base unfreeze or branch-sweep is pending.

The `orchestration-failed: true` marker above holds any merge-gated downstream (`blocked_on` this job) for the maintainer rather than promoting it onto an unlanded merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr877-finalize.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (659456 cached reads)
- Output: 10702 tokens
- Cost: $1.092589
- Wall-clock: 191s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
