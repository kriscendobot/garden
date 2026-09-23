---
project: endo-but-for-bots
pr_repo: kriscendobot/endo-but-for-bots
pr_number: 1
created_at: 2026-07-26T09:45:00Z
last_appended_at: 2026-07-26T09:45:00Z
status: parked
---

# Follow-ups for kriscendobot/endo-but-for-bots#1

PR title: `feat(daemon): add capability-scoped XS directory watches`
Branch: `build/cap-std-watch` (base `llm-e2c6ff8`)
Head at ledger creation: `979641659`

Auto-gauntlet for the `build-endo-but-for-bots-cap-std-watch` build. The 28-seat code panel ran (seat-cluster reviewers over the diff, foreperson adjudication) and terminated with 0 in-scope must-fix after a one-round fixer loop; CI 23/23 SUCCESS on head `979641659`; PR un-drafted. The must-fix (idle-watch monopolized/could not be cancelled) and the should-fixes (handle leak on a throwing poll, stale contract typedef, `DIR_TOKEN` consistency, zero adapter test coverage) were fixed in-PR. The items below were dispositioned `follow-up`, to revisit at merge.

## Items

- [ ] True host-driven async wakeup for the XS watch, so events are delivered without the 50 ms blocking poll slices. The current pull-shaped backend yields (`await null`) between polls so the watch is cancellable and the vat stays responsive, but a purely external command to an otherwise-idle vat still waits on the microtask loop until the next poll boundary. This was the PR's stated first-cut scope.
  **Source juror(s)**: integrator, assessor, saboteur, warden
  **Recommended action**: integrate the watch fd (kqueue, or an epoll/inotify equivalent on Linux) into the Rust supervisor's netstring driver loop so watch events arrive as unsolicited host-to-guest messages rather than a guest-driven blocking poll.

- [ ] Rust snapshot-diff blind spots. Two distinct non-UTF-8 sibling names collapse to one `BTreeMap` key via `to_string_lossy` (one masks the other); a same-length rewrite within one mtime granule, a chmod-only change, and a transient add+remove entirely between two polls are not reported.
  **Source juror(s)**: prover, corner-prober
  **Recommended action**: either add an inode/ctime discriminator to `EntryIdentity`, or add an explicit "UTF-8 names, eventually-converging semantics" note to the `watchDirectory` contract. The non-UTF-8 collision is shared with the whole string-based host FS bridge (`hostReadDir` and siblings), so a bridge-wide decision is cleaner than a watch-only patch.

- [ ] `host_watch_next` holds the process-global `WATCH_MAP` mutex across the blocking `poll`, and the registry hands out process-global sequential `AtomicU32` handles (the established `dir_map`/`file_map` pattern). Harmless under one-machine-per-process; if a process ever hosts more than one XS machine, one machine's 50 ms poll stalls every other machine's watch open/next/close, and a guessed handle observes or closes another machine's watch.
  **Source juror(s)**: locksmith, warden, engine-realist
  **Recommended action**: confirm the one-machine-per-process invariant, or take the watch out of the map (or use a per-machine map / per-handle lock) around the blocking wait.

- [ ] CI runs no `cargo test` lane, so the Rust `watch.rs::snapshot_diff_reports_add_replace_and_remove` and `lib.rs::fs_watch_dir` tests guard nothing on the gate, and the kqueue wakeup path (`wait_for_kqueue`) is untested on every platform (both Rust tests use a zero timeout, which returns before the `Wakeup` match; the macOS CI matrix would exercise registration but never the wait). Pre-existing CI-infra gap, surfaced by this PR.
  **Source juror(s)**: coverage-auditor
  **Recommended action**: add a `test:rust`/`cargo test -p endor` lane (or fold the xsnap crate tests into an existing job) and a non-zero-timeout kqueue wakeup test on the macOS runner.
