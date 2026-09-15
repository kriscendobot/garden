---
tier: mentat
dispatch: manual
---
# Demolish the XS-computron-parity myth in Iron Horse

handler-timeout: 14339

Repo: endojs/endo-but-for-bots, branch `llm`. Open one PR against `llm`.

## The directive (kriskowal, 2026-09-15)

There is a persistent myth in Iron Horse that it needs **computron parity with
XS**. That myth has been denounced and deprecated, yet it keeps regrowing. Make
the corpus reflect reality:

> **Iron Horse's metering objective is to approximate actual CPU time. To that
> end it MAY diverge from XS's computron counts. XS-computron parity is a
> non-goal, not a deferred goal.**

Adjust Iron Horse and the plans about Iron Horse holistically so that this is
what the code, the tests, and the documents say. Tests that hem in expected
computron ranges against XS should be deleted or relaxed. Stale plans that state
(or once stated) the mythical premise should be corrected.

## Do NOT over-delete: three things that look like the myth but are not

This is the crux of the job, and why it is mentat tier. Roughly 230 files
mention computrons. Only some of that is myth. Preserve, and do not weaken:

1. **Determinism of Iron Horse's OWN meter.** Identical computrons across
   repeated runs of the same binary on the same platform is a hard requirement
   for Agoric consensus (`designs/ironhorse-engine.md` around line 792). It is
   completely distinct from XS parity. A sweep that deletes "computron equality"
   assertions indiscriminately would destroy it. If anything, make the
   distinction between these two ideas explicit wherever both appear.
2. **Meter correctness properties that do not reference XS.** For example
   `MeterAbort` reporting `computrons == limit` at the abort point; `computrons
   > 0` ("the meter is real"); the raw-to-scaled relation
   `computrons == meter_raw >> 16`; and monotonicity such as
   `big.meter().computrons() >= small.meter().computrons()`. These are internal
   consistency, keep them.
3. **Result parity with XS**, which remains a real goal. Same values, same
   completion, same errors. Only the *metering* parity is the myth. Do not let
   the sweep bleed into result/semantic conformance or into test262 acceptance.

The test to apply to each site: *does this assert Iron Horse's numbers match
XS's numbers?* If yes, it is myth. If it asserts Iron Horse is self-consistent,
deterministic, or semantically correct, it stays.

## Known myth sites (a starting map, not an exhaustive list)

Code and tests:
- `rust/engine/ironhorse-262/src/lib.rs`: `is_bit_exact()` is defined as
  `oracle_computrons == ironhorse_computrons` (see lines ~224, ~520, ~877,
  ~1281). A harness-level concept that treats computron equality with the XS
  oracle as a success criterion is the myth's load-bearing beam. Rework the
  concept, do not just rename it.
- `rust/engine/ironhorse-262/tests/promise_combinator_meter_parity.rs`: a test
  file whose entire premise is meter parity.
- `rust/engine/ironhorse-262/tests/error_messages_calls.rs` (~512-513): asserts
  exact computron values against oracle values (14 vs 20).
- `rust/engine/ironhorse-262/src/xst.rs` (~3474): reports a "computron-gap",
  framing divergence as a defect.
- `rust/endo/tests/ironhorse_meter_bounds.rs`: mixed. Contains both legitimate
  bound properties and range-hemming. Triage per-assertion.
- `rust/engine/ironhorse-vm/src/interp/metering.rs`, `rust/engine/ironhorse-fuzz/src/lib.rs`.

Plans and designs:
- `designs/ironhorse-engine.md` is self-contradictory today: it states the
  non-goal in several places (~73, ~390, ~560, ~1122, ~1168) while still
  carrying "must produce identical computrons" (~397) and "to match XS.
  Ironhorse must be" (~525). Line ~966 preserves a historical section "as
  written, with its bit-exact computron parity" language, which plausibly
  re-seeds the myth every time someone reads it. If a historical section is kept
  for the record, fence it unmistakably as superseded.
- `designs/ironhorse-known-defects.md` (~316): **`F074` is an open P1 item that
  literally says "Make the new coercion tests enforce computron parity."** That
  is a live work order for the myth. Retire it explicitly rather than silently
  dropping it, and say why.
- Also sweep: `designs/ironhorse-meter-opcode-cost-instrumentation.md`,
  `designs/ironhorse-test262-convergence.md`, `designs/ironhorse-w6-decisions.md`,
  `rust/engine/ARCHITECTURE.md`, `rust/engine/README.md`,
  `rust/engine/architecture-review/2026-09-06/lenses/metering-architecture.md`.

## Why it keeps regrowing

Do not just edit the current instances. Identify the mechanism by which this
myth regenerates and cut it. Candidates worth weighing: a harness API named for
bit-exactness makes parity the default success criterion; preserved historical
text reads as current doctrine; an open P1 defect instructs future contributors
to add parity tests; and the XS oracle's presence in the test path invites
"differences are bugs" reasoning. State your conclusion in the PR description.

## Deliverables

1. One PR on `llm` with the code, test, and document changes.
2. A single clear statement of the metering objective, placed where a
   contributor will actually encounter it (the engine design and the crate
   README at minimum), that both asserts CPU-time approximation as the goal and
   names XS-computron parity as a non-goal.
3. In the PR description: what you deleted, what you relaxed, what you
   deliberately kept and why (especially the determinism requirement), and your
   answer on the regrowth mechanism.
4. Report the effect on the test262 and meter gates. Note that the
   `feat/ironhorse-262-language-completion` branch has carried ~51 meter-exact
   failures; if this work legitimately resolves that class, say so, and if it
   does not, say that too rather than implying it.

Do not change metering behavior itself in this job. This is about the stated
objective, the tests that encode it, and the plans that perpetuate it. If you
find a place where the implementation actually chases XS counts at a cost to
CPU-time fidelity, report it as a follow-up rather than fixing it here.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-15T23:00:35Z
