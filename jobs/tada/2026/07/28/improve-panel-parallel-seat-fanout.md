Pushed to `main2` as `99eecbd15a`.

## Report

**What I did** — made `scripts/jobs/gardening/panel.sh` fan its jury seats concurrently, so the 28-seat code panel fits a gardener's handler budget by construction rather than by a producer remembering a `handler-timeout:` header.

**Changes**

- `scripts/jobs/gardening/panel.sh`
  - Extracted the per-seat retry-on-empty block into a `run_seat` function, runnable in a background subshell. Attempts, backoff, per-seat `.stderr` capture, and the empty-block-is-never-signal rule are unchanged. Because a subshell's `exit` can't `fail` the panel, it reports through `<block>.status`, written `pending` up front so a subshell that dies mid-flight (a `fail` from inside `seat_review` on an unreadable brief) is distinguishable from one that exhausted its attempts — the join gives each a distinct message.
  - New `GARDEN_PANEL_CONCURRENCY` (default 8), clamped: non-numeric → 8, `0` → 1. Fan-out is bash background jobs plus `wait -n` (a slot frees the moment *any* seat finishes, unlike batch-and-barrier), with `|| true` on both waits so `set -e` can't kill the panel before the join names the failing seat.
  - The `>> $agg` append — the only order-dependent step — is now a deterministic second pass in `$seats` order after the join, so the aggregate is byte-identical to the sequential one, and the panel fails loudly at the *first* non-`ok` seat in seat order.
  - Used background subshells rather than `xargs -P` deliberately: `seat_review` is a shell function closing over the run's hooks, so xargs would need a generated helper script — impossible under the `noexec` `/tmp` constraint. Verified on this host: `/tmp` is `rw,nosuid,nodev,noexec`; a `chmod 755` helper there fails `Permission denied`, `bash <path>` works.
- `roles/COMMON.md` — added the `/tmp` `noexec` sentence to the scratch-discipline list, framed as an execution constraint (silent-looking `Permission denied` in a redirected log), with the `GARDEN_SCRATCH`-or-`bash <path>` remedy and why test stubs are committed in-repo.
- `skills/panel/SKILL.md` — documented `GARDEN_PANEL_CONCURRENCY` and `GARDEN_PANEL_SEAT_ATTEMPTS`/`_BACKOFF` in the knob table, and rewrote procedure step 2 to describe the concurrent fan → join → seat-ordered aggregate.
- New `scripts/jobs/test/panel-parallel-fanout-test.sh` + `panel-parallel-fanout-stub.sh` (committed in-repo, per the noexec rule) — 16 assertions across 5 subtests: real speedup (8×1s seats in 1s at conc 8, 4s at conc 1), the bound never exceeded *and* actually reached, byte-identical seat-ordered `round-1.md` at conc 1 vs 8, a failing seat still failing loudly by name without un-drafting while peers still filed blocks, and garbage/zero knob values clamping instead of wedging.

**Verification** — new test 16/16; the existing `panel-seat-retry-test.sh` passes 11/11 unmodified; `bash -n` and `shellcheck -S warning` clean on all three files. `tests/checks/run.sh` shows 5 suites pass / 2 fail (`test_maintainer_inbox_information_hiding.sh`, `test_run_all.sh`) — I confirmed via `git stash` that both fail identically on pristine `HEAD`, so they are pre-existing and unrelated.

**Follow-ups**

- The gauntlet producers (`auto-gauntlet-handoff.sh`, `comment-watcher.sh`) still stamp `handler-timeout: 7200` on gauntlet jobs. That's still correct — it also covers the CI/shepherd stage — but the *panel* segment no longer depends on it. Left alone deliberately.
- Default 8 means up to 8 concurrent `claude -p` per panel. If that proves too aggressive against rate limits under fleet load, the knob is the dial; a fleet-aware default (deriving from worker count or the fleet brake) is a possible refinement I did not build.
- `test_run_all.sh` and `test_maintainer_inbox_information_hiding.sh` are red on `main2` independent of this work and deserve their own job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-panel-parallel-seat-fanout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2720213 cached reads)
- Output: 26634 tokens
- Cost: $2.8182005
- Wall-clock: 396s

<!-- garden-usage-end -->
