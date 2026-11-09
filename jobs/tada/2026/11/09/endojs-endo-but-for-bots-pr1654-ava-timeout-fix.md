The ledger message was dead-lettered and will be promoted by garden-deadmail, preserving the intent for the daily backstop. The deliverable is complete.

## Completion report

**Job:** Absorb the ava 8.3.0 strict `t.timeout()` wall-clock deadline on endojs/endo-but-for-bots PR #1654 (dependabot all-minor-patch bump, head branch `dependabot/npm_and_yarn/all-minor-patch-d6528e162d`).

**Root cause (confirmed against ava 8.3.0 source):** `lib/test.js` now records a wall-clock `deadline` in `t.timeout(ms)` and fails the test with "Test timeout exceeded" in `#doFinish()`/`refreshTimeout()` whenever `now > deadline` — even if the timer never fired because the event loop was starved (c8 coverage, loaded macOS runners). Tests whose budgets existed only as hang guards flaked.

**Changes pushed to the PR head branch** (garden bot identity, so the dependabot auto-merge head gate still accepts — head now `fbccb9665`):
1. `test: absorb ava 8.3 wall-clock t.timeout() deadline` — widened every ≤3s budget to 10s; ran the 17 MiB `@endo/sandbox` spawner drain test serially at 60s (its CPU load was starving siblings' deadlines); `@endo/platform` macOS `fs.watch` test to 30s; the bwrap timeout+cancel test to 45s and its process-group reap wait to 10s.
2. `test: raise 5s t.timeout() hang guards to 10s` — repo-wide sweep of 5s budgets (127 files) after the first cover rerun showed `@endo/fae` image-tool finishing at 4.7–5.2s under c8 and flaking; each remains a hang guard.

Both commits prettier-clean and `node --check`-clean.

**CI on `fbccb9665`:** cover (22.x, 24.x ubuntu) **pass**, lint **pass**, test (22.x/24.x × ubuntu/macos-15) all **pass** — after one `--failed` rerun of two flaky legs: the bwrap process-group reap flake (also red on base `llm` runs 41360058457 / 40689797496, so not ava-attributable) and a macOS runner checkout failure. The only remaining red is **test-xs**, confirmed to fail on `test/intrinsics/ThrowTypeError/intrinsic-metadata.js` + `@endo/benchmark` threshold — the pre-existing hardened262 baseline the fixer spec names as not mine (my diff never touches hardened262 intrinsics).

**Ledger:** messaged `endojs-endo-but-for-bots-pr1654-dependabot`; recipient had completed, so it was dead-lettered (`20261109T010715Z-fd3af9`) for garden-deadmail to promote — the daily `dependabotany-recheck-endo-but-for-bots` backstop renders the terminal verdict.

**Follow-ups / notes:**
- The bwrap `bwrap timeout and repeated cancellation reap process groups` reap flake is a pre-existing intermittent on base `llm`, independent of ava; worth a separate look but out of scope here.
- Host `endolin-garden-ece02cb4` scratch volume hit 100% full (ENOSPC) mid-run during this job; it has since recovered to ~5G free. FYI for sysop.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1654-ava-timeout-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 18 tokens (888447 cached reads)
- Output: 5223 tokens
- Cost: $3.736131700000001 (1 engagement(s) unpriced)
- Wall-clock: 524s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
