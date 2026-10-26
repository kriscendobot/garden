Fixed and pushed PR endojs/endo-but-for-bots#1569 at `ac09730794`.

- `GitRemote.pull()` now rejects structured merge conflicts for `merge` and `ff-only` instead of reporting `up-to-date`.
- Added regression coverage for both strategies and audit outcomes.
- Cleared all deterministic pre-push findings.
- Verified: 46 daemon, 34 exo-git, and 20 native-backend tests passed; all 12 pre-push stages passed.
- Posted the completion summary on the PR.
- CI: 30 checks passed; 5 inherited `@endo/sandbox` Ubuntu failures remain, matching the frozen base. Follow-up: repair base CI, then retry the clean stage.
- Self-improvement: reported the warm-cache Node ABI mismatch to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-but-for-bots-pull-request-1569-git-remote-pull-merge-conflict.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3305s

<!-- garden-usage-end -->
