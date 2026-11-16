## ironhorse-ci-4-remaining-20261116: completion report

#1535 is fixed: only the expected oracle lanes are red now. #1614 needed real pushes; #1605 needed a rerun. Both are now oracle-only too. I diagnosed kumavis's #1548 and #1473 and pushed nothing to them. Nothing was merged or woven. Across the 60 open ironhorse PRs, though, ten kriscendobot PRs still have reds beyond the oracle lanes, all on CI runs from before today. So the expected end state ("only the oracle lanes") is reached for the PRs this sequence targeted, not yet for the whole set.

The oracle cause is confirmed from #1535's logs. Both `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` fail only stage3-math/054 and /055 (`asinh(1.7)` / `acosh(2.3)`), the ubuntu-26.04 glibc rounding. #1613 fixes it and is green, but has not reached the bases.

### Per PR
| PR | Before | Cause | Action | After |
|---|---|---|---|---|
| **#1535** (kriscendobot) | red: `cover (22.x)` + the 2 oracle lanes | (b) flake: the bwrap test "timeout and repeated cancellation reap process groups" timed out after 3 s under c8. It passed on the other three Linux legs. The same red appears on #1614 and #1359. | Reran just that job; it passed. No commit needed. Earlier steps of this sequence had already pushed `fc3176c5fe`, `d7af7dc927`, `cc8c641deb`. | 29 pass, only the 2 oracle lanes red |
| **#1614** (kriscendobot, outside my assigned list) | red: `cover (22.x)` | The same bwrap flake, but it failed again on rerun. My first push then surfaced two drift reds: test-xs (Node 26 ThrowTypeError baseline) and zizmor (create-pull-request v8 pin comment). | Pushed `613eedb3ed`: ported #1566's 10 s cleanup bound and diagnostics into `bwrap.test.js`. Before pushing, the real bwrap suite passed locally (41/41), with prettier, eslint and tsc clean. Then pushed `d06d831b10`, cherry-picks of #1535's two drift fixes (zizmor clean locally). | 29 pass, only the 2 oracle lanes red |
| **#1605** (kriscendobot, outside my assigned list) | red: `test (24.x, macos-15)` | (b) flake: daemon `http-content-plane.test.js` timed out opening a relay channel. The first rerun never got a macOS runner and was cancelled after 15 min. | Reran twice; no commit. | Only the 2 oracle lanes red |
| **#1548** (kumavis, ready) | red: browser-tests, cover 22/24, test 22/24, sandbox-drivers, 2 oracle lanes | The CI run dates from 2026-10-25 (head `94e799e610`). **browser-tests:** "Playwright does not support chromium on ubuntu26.04". **cover / test / sandbox-drivers:** two bwrap tests — the `ulimit -u` test fails because `/bin/sh` is dash, and "parent death" finishes without assertions. | Diagnosed only. **Suggested fix:** update the branch from current `llm`. That brings in the `ubuntu-24.04` pin for browser-tests and the `/bin/bash ulimit -u` test fix. The oracle lanes need #1613. | unchanged |
| **#1473** (kumavis, draft) | red: test-xs | sesNode/module `ThrowTypeError/intrinsic-metadata.js` flipped passed→failed because `lts/*` is now Node 26. Not caused by the PR. | Diagnosed only. **Suggested fix:** land the Node 26 baseline update (the same change as `cc8c641deb` / `d82988084a` from #1559) on `llm`, then rebase. `llm` still lacks it. | unchanged |

### All open ironhorse PRs, CI state now
- **Only the 2 oracle lanes red (expected until #1613 reaches their base):**
  - #1535, #1614, #1605
  - #1599, #1600, #1601, #1602, #1603, #1604, #1606, #1607, #1608, #1609, #1610, #1611, #1612, #1615, #1616, #1617, #1618, #1619, #1623, #1624
  - #1598 is red on `test-ironhorse-oracle` only.
- **Green:** #1613 (the fix), #1585, #1620, #1622, #1542, #1435, #1382, #1384, #1303, #1370, #1374, #1379, #1016, #1300, #1375, #1372, #1283, #1038, #1377, #1380, #249, #1376, #1146, #1385, and #1667 (kumavis).
- **Reds beyond the oracle lanes:**
  - **#1621** (left after step 3 was reaper-doomed): test-xs (Node 26 ThrowTypeError drift) and zizmor (pin-comment drift). Fix: cherry-pick `d7af7dc927` + `cc8c641deb`, as done on #1614.
  - **#1359** (run from 11-13): cover 22/24 (bwrap timeout flake; fix: the #1566 port), zizmor (pin drift), and test-xs. The test-xs red is RegExpPrototype intrinsic-metadata on the ironhorse lanes, which may be a real baseline shift from this PR (a RegExp accessor change). It needs a baseline update.
  - **#1298** (10-31) and **#1534** (10-22): the old bwrap dash/`ulimit` and parent-death reds, already fixed on `llm`. They need a refresh onto `llm`. #1534 also has a `build` red I did not diagnose.
  - **#1364, #1373** (09-29) and **#1278** (10-12): macOS daemon-teardown and "Failed to exit" flakes. Rerun them.
  - **#1346** (09-27): `harden_and_petrify_survive_sqlite_sleep_cycles` fails. **#1299** (09-17): `golden_vector_pins_canonical_bytes_and_seal` fails, which looks like a golden that needs restamping. Both likely need a weave plus a golden or test refresh; I didn't diagnose further.
  - **#1548, #1473** (kumavis): see the table above.

### Follow-ups
- Landing #1566 on `llm` (and in new frozen bases) would clear the recurring bwrap timeout flake fleet-wide.
- #1613 reaching the frozen bases (`llm-9a14ddf`, `llm-54d3d2a`, `llm`) would clear the oracle lanes.
- The Node 26 ThrowTypeError baseline and the create-pull-request v8 pin refresh also belong on `llm`; otherwise every PR re-run today picks up test-xs and zizmor reds.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-ci-4-remaining-20261116.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 156 tokens (7532606 cached reads)
- Output: 28729 tokens
- Cost: $3.0322052 (1 engagement(s) unpriced)
- Wall-clock: 19471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
