The Monitor confirmed `ALL-TEST-JOBS-DONE` with the final job (`test (22.x, ubuntu-latest): SUCCESS`). The job is complete.

## Completion report

**Job:** Shepherd endojs/endo-but-for-bots#653 (mount glob, PR B of #127) to green — its 4 `test (Node, OS)` matrix jobs were failing across 22.x/24.x on ubuntu/macos, blocking the stacked grep (#655) and json (#657) PRs.

**Root cause (diagnosed, reproduced locally):** The failing test — `mount-revocation › an open followNameChanges stream fails after revoke` — is **not** in #653's own diff; it's inherited from base PR #650. It was a fragile, timing-dependent test: `followNameChanges` re-checked liveness only at the top of each `watchDirectory` event iteration, so a revoked stream failed only on the *next* fs event. The test provoked that event with a single racy `fs.writeFileSync`, which could be missed → the stream hung → AVA "Promise returned by test never resolved". #653's added glob test file shifted AVA's serial file ordering into the failing timing. I reproduced it deterministically: 100% hang under `ava --serial`; passes with warm-up. #650 passed only by timing luck.

**What happened / what I did:**
1. First applied a test-only deflake on #653's head (provoke events on an interval until the stream fails) and pushed it; verified locally (was 5/5 fail → 3/3 pass serial). Messaged the maintainer flagging that the real fix belonged on base #650 and describing the durable source fix.
2. That push went `dirty` because base #650 had **just advanced** with exactly that durable source fix — `fix(daemon): wake open followNameChanges streams on mount revoke` (adds a `whenRevoked` promise, races each event pull against it). CI stopped dispatching (conflicting merge ref).
3. **Rebased** `feat/mount-glob` onto the fixed base, **dropping my now-redundant/conflicting deflake commit** and keeping only the glob feature commit (author preserved, content identical). Verified 44/44 daemon tests pass serially with the new base. Force-pushed with lease to the PR's own head → **`6680a60c20`**.

**Outcome:** CI is fully **green** — all 23 checks pass, all 4 `test` matrix jobs pass (including the previously-hung revocation test). `mergeable_state: clean`. Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/29058573797 . The mount-extensions stack is unblocked; #655 and #657 can rebase onto the green #653.

**Notes / follow-ups:** No PR comment posted (job body carried no external-commenting authorization). Only touched #653's own head (rebase + force-with-lease against the expected anchor) — no writes to the base branch. Final status relayed to the maintainer via the message bus.

`next: none` — CI green on the head SHA; no escalation needed.
