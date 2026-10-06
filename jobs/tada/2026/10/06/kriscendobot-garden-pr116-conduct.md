# Conduct report: kriscendobot/garden#116 (standing token-backoff ramp design)

**Outcome:** PR #116 is merged. The PR shows `state=MERGED` with merge commit `3ee5f45bee1225cc81004f26963e9da3ca88d6ea`, merged at 2026-10-06T19:16:29Z. It merged against its frozen review base `main2-1c21cce`, which is the conductor's exception for open-questions answer surfaces.

**Checks before merging (all state re-fetched):**
- **Answer-surface marker:** the PR body carries `<!-- garden-design-open-questions -->`. The PR was a draft, its head was `6986cf38c24351ceae4eed8859b6cbf70f2993ed`, and GitHub reported it MERGEABLE/CLEAN.
- **Design file:** `designs/standing-token-backoff-ramp.md` on the PR head is byte-identical to `origin/main2` (empty diff).
- **`designs/README.md`:** it differs from `main2` only in rows other PRs changed later (`manual-gauntlet-trigger`, `minion-town-pr-screening`). The ramp's own row is identical.
- **Approval:** kriskowal's APPROVED review 5432482973 (on `98db614`) still stands. It was not dismissed, there is no later CHANGES_REQUESTED, and kriskowal is on `maintainers/allowlist`. GitHub's `reviewDecision` is APPROVED.
- **Checks:** the PR head has 0 check runs and 0 commit statuses, so nothing is pending or failing. The `main2` checks run 37515208019 succeeded.

**Steps taken:**
1. Un-drafted the PR (`gh pr ready 116`).
2. Merged with `gh pr merge 116 --merge --match-head-commit 6986cf38…`, which creates a merge commit and does not retarget to `main2`. The `ci-wait-merge.sh` spine has no support for this exception and would have moved the base to the live trunk, so I merged by hand.
3. Swept the frozen review base: `sweep-frozen-bases.sh kriscendobot/garden 116` deleted `main2-1c21cce`, which pointed at the merge commit `3ee5f45`.
4. Deleted the head branch `design/standing-token-backoff-ramp` after the REST list showed no open PR using it as a base.

Both refs now return 404.

**Downstream:** this merge clears the gate for the implementation child in orchestration `orch-standing-token-backoff-ramp-delivery`. The orchestrate watcher will promote it, and this job posted no follow-ups.

**Follow-up (optional):** `ci-wait-merge.sh` does not handle the open-questions answer-surface exception, so every conductor has to merge these PRs by hand. Teaching the spine to detect the marker would close that gap.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr116-conduct.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (559239 cached reads)
- Output: 3362 tokens
- Cost: $0.6134558
- Wall-clock: 74s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
