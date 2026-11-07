Fix round 1 for PR #243 is pushed, but CI hasn't finished. Two checks passed and three were still pending when I stopped, so this is `still-pending`.

- **Style-prepass finding:** `tools/guide-recipes/local-daemon-server.ts` flagged `makeDaemonTmp` as an abbreviated identifier. It is the existing harness API from `test/helpers/endo-daemon.ts` and is imported from there, not added by this PR. I added the repo's existing `// spell-out-exempt -- reuses the established makeDaemonTmp/startEndoDaemon harness API.` line as line 2, after the shebang. Other files already use the same marker for this API (`test/guide-recipes-daemon.test.ts`, `test/web/guest-web-daemon.test.ts`, `dev/guest-web-daemon-demo.ts`).
- **Comment-concision advisory:** I left it alone. It is non-blocking, and the header comment describes the file's purpose.
- **Push:** `safe-push-pr-head.sh` advanced `garden/mcp-invite-tool-removal` from `0e8813c8` to `d41cbe03` as a fast-forward. I didn't re-run the style prepass.
- **Environment:** `ensure-project-worktree.sh` failed because `worktrees/` and `scratch/` are read-only on this host. I did the work in a fresh clone under `$TMPDIR` and pushed from there.
- **CI after the push:**
  - Passed: `gate (chromium)` and `gate (webkit)`.
  - Still pending: `changes`, `test` and `gate (firefox)`. They looked stuck rather than slow; after about 25 minutes of polling `test` hadn't started.
  - `ci-wait-merge.sh` itself hit the 10-minute foreground tool timeout and was killed, so I polled with `gh pr checks` instead. No check has gone red.

Follow-up: the driver should re-post this stage to see CI to a terminal state. If the pending jobs are still stuck then, the runner is the likely cause.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr243-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (4 unmetered)
- Input: 32 tokens (941400 cached reads)
- Output: 4049 tokens
- Cost: $0.352826 (4 engagement(s) unpriced)
- Wall-clock: 3023s

<!-- garden-usage-end -->
