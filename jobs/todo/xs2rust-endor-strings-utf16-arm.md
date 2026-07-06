<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-06T02:13:05Z -->

# Arm the CESU-8→UTF-16 string-representation revisit (record its orchestration)

**Program:** `xs2rust-endor` XS→Rust port (`endojs/endo-but-for-bots`, PR #600, design
`designs/xs2rust-endor-engine.md`). This job is the deferred activation of the
CESU-8→UTF-16 string-representation revisit (originally plan
`xs2rust-endor-strings-utf16-replace-cesu8`).

## Why this is gated (read before acting)
The revisit's **build** swaps the JS string storage from CESU-8 to UTF-16 and deletes the
O(1)-index machinery. That surface is the active build front while stage 3 runs — stage-3b
children xsre-core, xsre-integration (RegExp + String methods), promises, and
object-statics-intern (the string intern table) all land String code on this same branch.
Firing the swap concurrently would corrupt the in-flight work. So this arm job is
`blocked_on: port-xs-to-rust-memory-safe-engine-s7` — it wakes only after the supervisor's
current stage lands (which is itself after stage-3b, and after the supervisor's stage-3
fresh-checkout reproduction/acceptance). The supervisor chain owns program sequencing; if the
supervisor prefers to fold this revisit into a later roadmap stage instead, it may cancel this
orchestration and re-sequence.

## What to do on wake
The three children are already parked as `orchestrated` (invisible to foreman/unblock; only
the orchestrate watcher promotes them once the orchestration record exists):
- `xs2rust-endor-strings-utf16-design`  (designer — revise design doc to UTF-16 + re-base string meter)
- `xs2rust-endor-strings-utf16-build`   (builder  — swap storage, delete O(1)-index hacks)
- `xs2rust-endor-strings-utf16-test`    (test     — result parity + surrogate-pair cases + recalibrated meter)

1. Re-confirm stage-3b is fully landed (its orchestration `xs2rust-endor-build-stage3b` in
   `jobs/tada/`) and PR #600's String surface is stable on `git log`.
2. Record the orchestration (serial, halt-on-failure), which starts the watcher driving
   design → build → test:
   ```
   /home/kris/scripts/jobs/post-orchestration.sh --serial --on-child-failure halt \
     xs2rust-endor-strings-utf16 \
     xs2rust-endor-strings-utf16-design \
     xs2rust-endor-strings-utf16-build \
     xs2rust-endor-strings-utf16-test
   ```
3. If any child was reaped/lost while parked, re-post it (`post-plan.sh --orchestrated
   --orchestrated-by xs2rust-endor-strings-utf16 <child> <body>`) before recording.

## Context notes for the executor
- The design doc's **metering doctrine is already accuracy-over-parity** (revised 2026-07-04,
  maintainer directive): oracle governs RESULTS only, computrons advisory, meter is endor's
  own release-versioned frozen cost table. The design child only needs the string-*representation*
  section + a string-op cost re-basing note; it must NOT re-litigate the doctrine.
- Meter re-basing coordinates with the live calibration work
  (`xs2rust-endor-meter-calibration-stage-c1`) and the instrumentation plan
  (`xs2rust-endor-meter-opcode-cost-instrumentation`).
- Meter numbers WILL change; that is correct — update expectations to the recalibrated costs,
  never back-fit to CESU-8 byte length or to the C-XS oracle's computrons.
