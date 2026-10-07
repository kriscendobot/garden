---
title: The pi-shell cancel token — deadline plus abort reason
source: crates/pi-shell/src/cancel.rs
source_repo: can1357/oh-my-pi
source_commit: 257c0acffbac532da172dbab60212f98e066059f
source_date: 2026-10-06
source_authors: [can1357, Brit, Darafei Praliaskouski]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes]
status: current
notes: The source has no module-level prose header; one function doc comment and a unit test carry the contract recorded here.
---

> Abstract: `CancelToken` combines an optional deadline with an optional shared abort flag that records *why* it was aborted (`Timeout`, `Signal`, `User`, or `Unknown`). `AbortToken` holds only a weak reference to that flag, so the side that aborts cannot keep a finished run alive. `abort_reason()` deliberately ignores an elapsed deadline. A run that finished within budget but was settled late on a busy JavaScript thread is therefore not reported as timed out.

## Shape

- `AbortReason` is a `u8` enum: `Unknown = 1`, `Timeout = 2`, `Signal = 3`, `User = 4`. Zero means "not aborted", and any other unknown byte decodes as `Unknown`.
- `CancelToken { deadline: Option<Instant>, flag: Option<Arc<Flag>> }` is `Clone` and `Default` (never cancels). `CancelToken::new(timeout_ms)` and `with_timeout(duration)` set only the deadline.
- `emplace_abort_token()` creates the flag if needed and returns an `AbortToken` holding a `Weak` reference to it. `abort_token()` returns one only if a flag already exists. `AbortToken::abort(reason)` does nothing once the token's owner is gone.
- The first abort wins the notification: the flag swaps in the reason and wakes waiters only when the previous value was zero.

## Checking and waiting

- `heartbeat()` returns `Err("Aborted: <reason>")` for an explicit abort, or `Err("Aborted: Timeout")` once the deadline has passed. Long loops call it periodically.
- `aborted()` is the boolean form of the same check.
- `wait()` resolves with whichever comes first, the flag's reason or the deadline (as `Timeout`).

## The deadline-versus-signal distinction

`abort_reason()` "Return[s] the explicit abort flag reason, excluding an elapsed deadline. Completion callbacks use this to distinguish an `AbortSignal` from a timeout that elapsed only while the JavaScript thread was busy settling a result that had already completed within budget." The unit test pins this: a zero-duration token fails `heartbeat()` yet has no `abort_reason()`, while an explicitly signaled token reports `Signal`.

This is the token that `terminate_tree` and `wait_for_exit` accept (see [graceful tree termination](oh-my-pi--crates-pi-shell-src-process--graceful-tree-termination-and-harness-protection.md)), and that shell runs use for `timeoutMs` and `AbortSignal` handling.

Source: [crates/pi-shell/src/cancel.rs](https://github.com/can1357/oh-my-pi/blob/257c0acffbac532da172dbab60212f98e066059f/crates/pi-shell/src/cancel.rs) at commit `257c0acf`.
