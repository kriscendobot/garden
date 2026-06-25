Done. Completion report follows.

---

## Report: fix-reaper-requeue-reliability

**Status: complete.** Committed and pushed to `origin/main2` as **`d455c51b`** (bot identity `endolinbot`, built in an isolated worktree off `origin/main2`).

### Root cause confirmed
`scripts/jobs/reaper.sh` attempted each requeue exactly once per tick (one `commit_and_push`, no retry loop) and conceded any lost CAS push to "next reaper tick." Under steady `journal2` contention (bulletin loop, comment-watcher, schedulers, gardener pushes) it lost that single race essentially every tick, so stale claims were requeued *never* — matching the 15–19h strandings observed 2026-06-25.

### What changed (`reaper.sh`)
1. **Retry within the tick.** The requeue is now a bounded `sync→stage→commit→push` loop (`GARDEN_REAP_PUSH_ATTEMPTS=50`, randomized backoff), reusing the hardened `commit_and_push` (verify-after-push), so a "succeeded-but-didn't-land" push also retries. It concedes the first race, not the tick. Loud non-zero exit if it still can't land after all attempts.
2. **Batched reaps.** All of a tick's stale claims move in **one** commit+push, so N stale claims cost one race, not N.
3. **Safe claim-strip.** Replaced `sed '/^---$/,$d'` (which truncated at the *first* `---`) with an awk strip anchored on the `---` line immediately preceding `claim:` (last such pair). A body containing an internal `---` (Markdown rule / frontmatter) is preserved; if no claim block is found nothing is truncated.
4. **Poison cap.** Requeue cycles are counted via a `<!-- garden-reaped: N -->` body marker that survives strips and re-claims. After `GARDEN_REAP_POISON_THRESHOLD=5` cycles the job is surfaced to the maintainer inbox (full body, via `inbox-send.sh maintainer`) and dropped from the board instead of looping forever.

### Tunable parameters (all env-overridable)
- `GARDEN_REAP_PUSH_ATTEMPTS=50` — bounded requeue-push retries per tick
- `GARDEN_REAP_POISON_THRESHOLD=5` — requeue cycles before a job is poisoned
- (existing `GARDEN_CLAIM_TTL=3600`, `GARDEN_FETCH_REAP_AGE=120` unchanged)

### Tests & verification
- Added `run-test.sh` **SUBTEST 19 — REAPER**: a competing pusher forces the reaper to lose 2 CAS races; asserts the requeue still **lands within the tick**, the claim-strip **preserves an internal `---`**, both stale claims **batch into one commit**, a requeued job is stamped `garden-reaped: 1`, and a past-threshold job is **poisoned to the maintainer** rather than requeued. All 8 assertions pass.
- Full suite: **103 passed, 0 failed** (clean run). `reaper.sh`: `bash -n` clean and `shellcheck -x` clean (exit 0).

### Notes / follow-ups
- One incidental fix in the test (`grep -qxF -- '---'`) — bare `---` was parsed as grep options.
- SUBTEST 8 (scheduler 1s-cadence) is a pre-existing **timing flake** under load, unrelated to this change — it failed once mid-iteration and passed on a clean run. Not addressed here; worth a separate hardening pass if it recurs in CI.
- Diagnostic aside for whoever runs the suite locally: ambient `GARDEN_GARDENER_CLONE`/`GARDEN_ROOT` (present when running as a live gardener) override the test fixtures and make every subtest hit the real board — run with `env -u GARDEN_GARDENER_CLONE -u GARDEN_GARDENER_ID -u GARDEN_ROOT`. Could be worth having `run-test.sh` unset these itself.
