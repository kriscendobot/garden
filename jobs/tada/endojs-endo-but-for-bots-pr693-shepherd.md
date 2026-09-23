CI is fully green. The head SHA is unchanged (`f7cd399`) — I made no code changes; the single red check was a flake I cleared with a re-run. No comment authorization was in the job body and the PR is a draft, so I posted nothing to the PR. Nothing to commit in either worktree.

---

**Shepherd report — endojs/endo-but-for-bots PR #693 (draft, demo-only, M5 cross-host invite/accept)**

**Failure:** One red check, `test (22.x, macos-15)`. Task `@endo/daemon#test` failed with exit 1 despite `569 tests passed` — the culprit was `1 unhandled rejection`, not a failed assertion. The stray rejection was `Error: Connection lost` originating in the daemon test `ws-relay › connect fails gracefully when peer is unknown to relay` (`packages/daemon/test/ws-relay.test.js:354`).

**Diagnosis:** Flake, not attributable to this PR. The PR's entire diff is under `packages/daemon/demo/cross-host-invite-accept/` (README, `.mjs`/`.py`/`.sh` demo scripts, transcripts) — it touches no source and no tests. The failing `ws-relay.test.js` is a pre-existing daemon test with a teardown race: it awaits `t.throwsAsync(Promise.race([E(hostA).lookup(['bogus']), timeout]))`, and when `relay.teardown()`/termination races the still-in-flight `lookup`, the underlying CapTP promise rejects with "Connection lost" *after* the assertion has already settled, leaving one dangling unhandled rejection that ava counts as a task failure. Non-deterministic: only 1 of the 3 macos jobs (22.x) tripped it; 20.x and 24.x macos-15 passed on the same commit.

**Action:** Re-ran the failed job (`gh run rerun 29162316666 --failed`). No push, no code change (head SHA stays `f7cd399`).

**Result:** Green. `test (22.x, macos-15)` now passes (re-run job `86571272262`, 23m45s); the full rollup is all-pass with no fail/pending/error. Shepherd definition of done met — CI green on the head SHA.

**Classification:** `next: none` — operational flake, cleared on re-run.

**Follow-up (not this PR's scope):** The daemon test `ws-relay.test.js:354` has a real teardown-vs-in-flight-lookup race that leaks an unhandled "Connection lost" rejection on macos. It's a latent flaky-test fix owned by the `@endo/daemon` package, worth a separate fixer job against a non-demo branch; it should not gate this demo-only PR.
