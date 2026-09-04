---
role: builder
dispatch: automatic
tier: mentor
fallback-tier: minion
---

# Build the Ironhorse panic mechanism (buildable live-code slice)

Source: approval review on endojs/endo-but-for-bots PR #1018 by kriskowal
(https://github.com/endojs/endo-but-for-bots/pull/1018#pullrequestreview-5109484811),
"please conduct **and dispatch a builder**". The conduct half is done — #1018
merged to `llm` at 2026-09-04T06:55:22Z (merge commit `3bc9e7a03f510abc...`,
`3bc9e7a03f510afc457fab1861701cf26eeb20a7`). This is the builder half.

Repo: **endojs/endo-but-for-bots**, roadmap branch **`llm`**. Design (now merged):
`designs/ironhorse-panic.md` — "Ironhorse Panic and the Slot Machine Recovery
Boundary". READ IT FIRST; it is the contract.

## Scope this build to the LIVE-CODE slice the design calls "The Required First Step"

Most of the design is prospective (the message-embargo/crank-commit/transcript
machinery, the `-e ironhorse` `ExecutionOutcome` seam at roadmap stage 8/9, and
the Coda's `panic-on-reference-error`). The design's own § Scope ("What Is Already
a Panic (The Required First Step)") and the design job's completion note isolate
what actually touches code the live daemon runs today. Build THAT and defer the
rest:

1. **Formal `Panic` category / reclassification (interpreter-side, no behavior
   change).** Per § "The Formal `Panic` Category" and the § Scope inventory table,
   name and generalize the existing abort-to-host `Halt` variants
   (`StackOverflow`, `MeterAbort`, and the panic-adjacent `Decode`) under one
   formal panic concept in `rust/engine/ironhorse-vm/src/interp.rs`, keeping the
   "never match a `Halt` variant shape directly" discipline. No guest-visible
   behavior change — this is naming + a classifier (`is_panic()` / `PanicKind`),
   surfaced through the `Machine` seam where it already exists.

2. **The net-new FFI-abort guard (a REAL live safety fix on today's delivery
   path).** Per § Scope "The already-live FFI abort hazard": the currently-live
   in-process C-XS worker invokes `unsafe extern "C"` callbacks in
   `rust/endo/xsnap/src/worker_io.rs` (`host_send_frame`, `host_issue_command`,
   `host_send_raw_frame`) that already contain panicking calls (e.g.
   `with_transport`'s `.expect(...)` around `worker_io.rs:363`). Since Rust 1.71 a
   panic unwinding past an `extern "C"` frame **aborts the whole process**, killing
   every vat sharing the daemon — the opposite of per-vat isolation. Wrap each
   `extern "C"` callback body (and the machine-thread run entry) in `catch_unwind`
   (or an equivalent panic hook) so a Rust panic is converted into a `Panicked`
   worker-death value BEFORE it crosses the FFI boundary, rather than aborting the
   process. Add regression coverage that a panic in the glue kills only the one
   worker.

## Explicitly OUT of scope (prospective / gated — do NOT build here)

- The message embargo, per-crank commit point, and per-worker write-ahead
  transcript. The design job surveyed the live crank path and found there is NO
  per-crank commit point and NO transcript today; these are net-new and are
  deferred to a to-be-filed follow-on design **`message-embargo-and-crank-commit`**
  (see the design's Open Questions). Do not invent an embargo mechanism here.
- The Coda's `panic-on-reference-error` option — off by default and gated on the
  debugger design's engine-raise-unwind prerequisite; leave it for a later slice.
- Anything requiring the `-e ironhorse` engine-selection integration (roadmap
  stage 8/9).

## Definition of done

A draft PR against `llm` implementing items (1) and (2) with local verification
green (Rust build + the crate's tests, plus the new FFI-guard regression). The
draft PR auto-runs the gauntlet (clean → panel → fix-loop → un-draft) under its
supervising gardener. Note in the PR body which design open questions remain and
that the embargo/transcript and Coda are deliberately deferred follow-ons.

Treat the merged design text as the spec; if a claimed code path (file/line) has
drifted since the design was written, verify against the live tree and report the
drift rather than building against a stale citation.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T07:35:45Z
