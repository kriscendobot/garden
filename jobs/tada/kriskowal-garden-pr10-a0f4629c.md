Inbox empty, push confirmed on `origin/main2`. Done.

---

## Completion report

**Job:** attention directive on kriskowal/garden #10 — "Consider using exponential back-off with full jitter, generally."

**Routing.** Re-fetched the comment via `gh api` (treated as data). A prior pass (`63b1837ab`) had already applied full-jitter to the journal-push CAS retry loops (`common.sh backoff()`) and the bulletin reply-CAS. I swept the whole codebase for remaining flat/non-jittered retry, poll, and sleep loops to honor the "generally," and routed the directive to the one genuinely unaddressed **fleet-contention** surface.

**What I changed** (committed `bf6d2040b`, pushed to `main2`):
- **`scripts/jobs/common.sh`** — added `idle_backoff()`, the second-scale analog of `backoff()`: a fresh full-jitter draw in `[0, min(cap, base·2^(attempt-1))]` with `base=GARDEN_IDLE_SLEEP`, `cap=GARDEN_IDLE_SLEEP_CAP` (30s). Verified the distribution (attempt 1→[0,5s], 2→[0,10s], 3→[0,20s], 4+→capped [0,30s]) and the `=0` edge.
- **`scripts/jobs/gardener.sh`** — the three idle/offline sleep sites now use `idle_backoff` on a new `idle_attempt` counter (reset to 1 on a claimed job), kept separate from the ONESHOT-drain `idle_rounds`. This breaks the thundering herd where ~100 lockstep-started gardeners wake on one shared 5s boundary and hammer `journal2` simultaneously; freshly-idle gardeners still poll fast (low pickup latency).
- **`designs/job-board.md`** — refreshed the stale "~50–300ms" backoff description the prior pass left behind, and documented the idle-poll jitter.

**Deliberately *not* touched** (and why, in the commit body): the systemd timers are hand-staggered so each audit runs against a fresh clone (`clone-keeper :00/30 → drift-scan :07 → journal-worktree-keeper :15/45`); `RandomizedDelaySec` would break that ordering. The bulletin/deploy/ci-wait idle polls are single-process (leader-only singleton or short-lived) with nothing to decorrelate.

**Verification.** `bash -n` clean on both scripts. Ran the job-board test suite (`run-test.sh 8 5`): **237 passed, 4 failed**. The 4 failures are all in the issue-source-gh / issue-inbox subsystem with empty `out:` — the missing-external-tool (`gh`/`jq`) signature in this sandbox, in files my diff does not touch. The gardener concurrency subtest (the exact claim/idle path I modified) is among the 237 passed.

**Follow-ups:** none required. The 4 sandbox test failures are pre-existing/environmental (no `gh`/`jq`), worth noting only if a future CI run flags them.
