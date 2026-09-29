I wove PR #137 in kriscendobot/minion.town ("fix(deploy): reap the endo-daemon manager-node orphan that wedges CD") onto the current `main` tip, which now includes #139 (merged 2026-09-29T21:59Z).

**What I did:**
- **Frozen base:** created `main-7e87a44` from the current `origin/main` tip (the #139 merge) and pushed it to the fork.
- **Rebase:** moved the PR's one commit from `main-e922c49` onto `main-7e87a44` (`git rebase --onto`). It applied without conflicts. Head `14a86a3` → `dbed712`. The PR diff against the new base is still exactly #137's 5 files, with nothing from `main` pulled in.
- **How #137 and #139 fit together:** both touch `deploy/aws/scripts/deploy-endo-daemon.sh`. The PR's probe check now uses #139's `endo_probe`. Both reapers stay in the script:
  - #139's `reap_strays` kills daemon processes running outside the service; it runs after the preflight, before a rollback, and after a healthy swap.
  - #137 replaces `systemctl restart` with stop → free port 8920 → start, and also frees the port before the rollback start.
- **Push and base move:** force-pushed with a lease pinned to the old head, then moved the PR base from `main-e922c49` to `main-7e87a44`. GitHub reports the PR as MERGEABLE.
- **Checks:** `bash -n` passes on both changed scripts, and `test/endo-pin-drift.test.ts` passes (7/7). I did not run the full test suite or wait for CI.
- I posted a comment on the PR describing the weave: https://github.com/kriscendobot/minion.town/pull/137#issuecomment-5900689851

**Follow-ups:** #137 is still a draft. It needs CI and the usual gauntlet or conduct step before it merges. No garden-repo changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-kriscendobot-minion-town-pr130-conduct-prod-validate-20260928-resume-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (523880 cached reads)
- Output: 3649 tokens
- Cost: $0.592908
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
