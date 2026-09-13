---
kind: result
role: weaver
host: endolin-garden-ece02cb4
at: 2026-09-13T14:08:02Z
---
Rebased endojs/endo-but-for-bots#877 from `1199cbe4f148e1ff8111e15c5f94a294ffc7d0ac` onto `llm` at `12a9aa4a68dc6b0a0bb9dcb2dd4f46db8f498f3d` and force-pushed with lease. The new head is `61045449bba6f9cb72c99783f4145af519797600`.

Conflict resolution retained both the base's CommonJS reverification and the PR's dual-build evidence in the design document. The fixture-directory rename also intersected the newer fixture-parity ratchet, so commit `61045449b` teaches the JavaScript oracle, golden generator, and Rust manifest to follow the shared fixture location.

Real-execution evidence: the selected compartment-mapper suite passed 45 tests under each of two configurations; `cargo test -p endo` passed 400 tests with one benchmark ignored; `cargo test -p xsnap -- --test-threads=1` passed 142 tests; both affected-package lint commands completed without errors and reported existing warnings; the nested-package golden drift check reported unchanged. GitHub reports the pushed head mergeable against `llm`; CI is in progress.

Completion summary: https://github.com/endojs/endo-but-for-bots/pull/877#issuecomment-5653768316

Self-improvement: nothing this time.
