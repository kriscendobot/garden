---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Make Ironhorse's resource-limit abort behavior configurable; ratchet coverage on both configurations

Repo: `endojs/endo-but-for-bots`, Rust engine at `rust/engine/ironhorse-262/`.

## Context

The round-3 test262 historical-floor ratchet
(`jobs/tada/2026/09/28/ironhorse-test262-ratchet-round3-20260928.md`, successor
parked at `jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md`
awaiting a maintainer floor-policy answer at
https://github.com/kriscendobot/garden/issues/51#issuecomment-5877917421)
found 443 "ironhorse-aborted-limit" cases: positive test262 paths where the
Rust engine currently ABORTS/panics on hitting a resource ceiling (heap
exhaustion, matcher state/payload caps) rather than returning a classifiable
result. That job's diagnostic notes: a generated RegExp ASCII.js case returns
HeapExhausted at 1,210 slots / ~242MB chunk bytes even after doubling the
chunk ceiling to 512 MiB; the matcher independently caps states at 65,536 and
payload at 64 MiB. These are real, not measurement noise, but the current
all-or-nothing panic-on-limit behavior forecloses classifying what happens
past the limit.

## Task (maintainer directive, 2026-09-29)

1. Make the resource-limit abort behavior **configurable**: add a flag/mode
   so the engine can either (a) panic/abort as it does today, or (b) fail
   over the limit gracefully — return a classifiable resource-exhaustion
   result instead of aborting the process. Use whatever mechanism fits the
   existing engine's error-handling shape (a Result-returning path instead of
   a panic, gated by a runtime flag or Cargo feature — your call on which is
   more idiomatic here).
2. Ratchet up test262/hardened262 coverage to **exercise both
   configurations** — panic mode and non-panic mode — using hardened262's
   existing flag/matrix mechanism (see `designs/hardened262-mirror` context
   and the XS-vs-native hardened262 harness already mirrored to `llm`,
   PR #1040) rather than inventing a new harness. The goal is confidence that
   both configurations behave correctly at and around the resource ceilings,
   not just that the flag exists.
3. Report whether any of the 443 `ironhorse-aborted-limit` cases become
   classifiable (pass/fail rather than abort) under the non-panic
   configuration — this is diagnostic input for the parked floor-resolution
   successor above, not a mandate to change floor policy yourself. Do not
   touch `jobs/plan/ironhorse-test262-ratchet-round3-floor-resolution-20260928.md`
   or its parked maintainer question; just report your findings so whoever
   picks that up next has real data instead of having to re-derive it.
4. Required release Rust gates (cargo +1.88.0 fmt/clippy, the full test
   suite) must still pass. Coordinate with `build-ironhorse-ratchet-autopilot`
   before touching any branch it owns (`inbox-send.sh
   build-ironhorse-ratchet-autopilot` first, per that job's own coordination
   note) if your work would collide with its PR.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T00:28:56Z
