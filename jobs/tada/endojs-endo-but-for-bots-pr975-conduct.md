PR #975 is **MERGED** into the live `llm` trunk (merge commit `eb47ab67`, merged at 13:10:52Z). Job complete.

## Completion report

**Job:** Finalize (curate → merge) endojs/endo-but-for-bots PR #975 — `design(ironhorse): recover the debugger row and land native break-on-uncaught`

**What I did:**
1. **Verified guards.** Confirmed bot repo (`endojs/endo-but-for-bots`), PR OPEN, base `llm` (live trunk — not a frozen `-<sha>` snapshot, no unfreeze needed).
2. **Confirmed the approval.** The event watcher's missed approval was real: **kriskowal APPROVED on the exact current head `e50ffce8`** (12:59:26Z), superseding his earlier `CHANGES_REQUESTED` on the older commit `76a4f81`. kriskowal is on `journal2:maintainers/allowlist`. `reviewDecision` was empty (the repo has no required-review branch protection), which correctly falls through to the individual-review gate.
3. **Re-verified merge-readiness.** `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`, all 5 CI checks SUCCESS (build, lint, test, browser-tests, zizmor).
4. **Curated (un-drafted).** The PR was still draft; ran `gh pr ready 975` → ready for review.
5. **Merged via the deterministic spine.** `ci-wait-merge.sh endojs/endo-but-for-bots 975 --merge` re-confirmed CI green + maintainer approval on head and created the merge commit (exit 0).

**What changed:** PR #975 merged into `llm` with merge commit `eb47ab6749b12dcdec261e5a2373200038b5c3e2`. Head branch deleted by the spine (no open downstream PR used it as base, so branch-retention did not fire).

**Follow-ups:** None. No downstream PRs were blocked on this merge. Conductor did not post any follow-up jobs (per role norms). Merge outcome is genuine — no `orchestration-failed` marker.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr975-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 19 tokens (508110 cached reads)
- Output: 5038 tokens
- Cost: $0.8488249999999999
- Wall-clock: 89s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
