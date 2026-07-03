# garden-infra: give the foreman an active-job TARGET (default 3), not just idle-only top-up

**Garden-infra change on `main2`.** Isolated worktree off `origin/main2` (`git -C <wt>` discipline). Explicit-pathspec commit, push `HEAD:main2`.

## Directive (kriskowal, 2026-07-03)

The foreman should keep **~3 jobs actively progressing**, not just refill when the board is fully idle. Today only one job progresses (the XS→Rust supervisor) because `scripts/jobs/foreman.sh` returns early whenever `jobs/doin/` OR `jobs/todo/` is non-empty (idle = both zero). Change it to maintain an active-job **target**.

## Task

- Add `GARDEN_FOREMAN_ACTIVE_TARGET` (default **3**). Redefine the trigger: the foreman acts when `count(todo) + count(doin) < TARGET` (under-subscribed), not only when the board is empty.
- When under-subscribed, promote deferred plan jobs (top-by-priority, the existing `promote-plan` path) to bring the in-flight count up toward TARGET — up to `TARGET - (todo+doin)` per tick (or one-per-tick if that is safer for the settle-window semantics; your call, but document it). Fall through to the existing generate-a-step handler only when no deferred plan is available, exactly as today.
- Preserve every existing invariant: the `GARDEN_FOREMAN_IDLE_SETTLE` debounce (don't thrash on a brief gap), **go-ahead plans are NEVER auto-promoted**, blocked plans stay for the unblock watcher, leader-only gating unchanged. Keep it a minimal, well-tested delta.
- Add/extend a test proving: with TARGET=3 and 1 job in doin + N deferred plans, the foreman promotes 2 (to reach 3) and stops; with 3 already in flight it promotes 0; go-ahead/blocked plans are never touched.

## Note on activation

This changes the deployed foreman only after a **deploy** (the running fleet uses the deployed root). Flag that in your report — the maintainer is bridging to 3 by hand-promotion until then.

## Definition of done

`foreman.sh` maintains `GARDEN_FOREMAN_ACTIVE_TARGET` (default 3) in-flight jobs, preserving the settle window and the go-ahead/blocked exclusions, with a cited test. Land on `main2`; journal a `result`.
