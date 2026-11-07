I pushed the round-4 fixes to PR #254, but CI is still running at the 1-hour deadline. This stage ends as still-pending, not done. The final `ci-wait-merge.sh` returned rc 4 with 4 of 7 checks pending. `test`, `changes` and `gate (webkit)` passed; `gate (chromium)`, `gate (firefox)` and both `Claude harness` legs had not finished. Nothing has failed. The checks sat queued for about 45 minutes because the whole repo was backed up (7 runs queued, 1 running), not because of anything in this PR.

**Fixes from the latest panel review (5815150937), commit `864dd26`:**
- **archivist (the only must-fix):** the "this guest key did not work" card no longer says "No saved guest was replaced." It now says that if the browser had saved the rejected key, it has forgotten it, and no other saved guest was touched. That matches what `home.js` does.
- **pruner:** dropped the "Signing in does not create a guest, so we brought you here instead" sentence from the recovery card.
- **changeset-auditor, releaser, pruner, archivist:** rewrote `.changeset/guest-recovery-outcome.md`:
  - The bump is now `minor`.
  - Each sentence is on its own line.
  - It describes only what visitors see, plus the "reload Caddy" step for operators.
  - The internal details and the probe paragraph are gone, along with the inaccurate claim that only the recovery route reads the provider.
  - It now mentions the wait-list "temporarily unavailable" message.

**Earlier stylist renames, commit `57d3cec`:** the round-3 renames had never been applied, so I made them: `app` → `application`, `call` → `request`, `init` → `requestInitialization` (in the new wait-list probe test only), and `named` → `providerName`.

**PR body:** removed the outdated screenshot table, the "tests pass" sentence that had no link, and the regression-test narration. The note that the wait-list probe check posts a fixed address on every run moved here from the changeset.

**Summary comment:** posted https://github.com/kriscendobot/minion.town/pull/254#issuecomment-6713502033, covering all four rounds.

**Local checks:** this clone had no installed dependencies, so I borrowed `node_modules` from another scratch checkout. With it, `node --test deploy/probe/prod-objectives.test.mjs` passed 36 of 36 and `tsc --noEmit` printed no errors. The rename commit was pushed before those checks finished, because my command didn't stop on an earlier failure. That failure was a missing package (`@modelcontextprotocol/sdk`), not the rename, and the rerun with dependencies passed.

**Workaround and follow-up:** `ensure-project-worktree.sh` failed with "Read-only file system" (the monk sandbox issue already in memory). I worked from a clone in `$TMPDIR` with `GARDEN_PR_WORKTREE` set and pushed with `safe-push-pr-head.sh`. The sandbox fix (`7fd074b62d5`/`3c7f9ce045e`) is on main2 but evidently not on this host yet, so that host needs a deploy. When the driver re-posts this stage, it only needs to wait for CI on head `57d3cec`.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2352115 cached reads)
- Output: 12685 tokens
- Cost: $1.3372829999999998
- Wall-clock: 3600s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
