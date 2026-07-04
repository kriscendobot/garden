<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-03T20:27:45Z -->

# xs2rust-endor: revise the metering doctrine to accuracy-over-parity

**Program:** the `xs2rust-endor` XS→Rust port (design: `designs/xs2rust-endor-engine.md`).
**Nature:** design-doc revision (designer); it re-states a principle the whole port rests on.
**Gate:** parked/deferred — foundational to the two sibling plans below; ideally decided first.

## Intent
Revise the metering section of `designs/xs2rust-endor-engine.md` to replace the current
**"oracle-locked transliteration of XS on `(result, computron)`"** doctrine with an
**accuracy-over-parity** doctrine:

- The deterministic meter's purpose is to be the **best available deterministic proxy for
  real (wall-clock) execution cost** — NOT to reproduce XS's computron counts.
- **Determinism is per release version.** The cost table is frozen within a release (so
  metered outcomes are fully reproducible for that release), and **recalibrated across
  releases** as measurement improves accuracy.
- The **C-XS differential oracle is retained for RESULT correctness only.** Its computron
  output is no longer an authority the meter must match (at most advisory/comparative).

## Rationale
The original design deliberately locked the meter to XS so the C-XS differential oracle
could check computron *parity* — that made "metering determinism" mean "match XS." The
maintainer's directive is that **meter parity is a non-goal**; the goal is **accuracy as a
deterministic wall-clock proxy.** This moves the target of the metering-determinism crux
from "reproduce XS" to "accurately and reproducibly model real cost, versioned per
release." Determinism is still mandatory — it just no longer implies XS-equivalence.

## What to change in the doc
- The **metering-determinism crux** and thin-first-slice section that name the computron
  differential oracle as the parity target — recast the oracle as result-only, with
  computron comparison demoted to advisory telemetry.
- Define the **release-versioned cost model + recalibration process**: how the per-opcode
  cost table is derived (from the cost-calibration instrumentation), frozen per release,
  and versioned, so any two runs of the same release meter identically.
- Reconcile with the **Agoric XS meter** discussion (the `xs-meter-37` / integer-meter
  material): endor's meter becomes its own release-versioned model, not bound to XS/Agoric
  computron values.

## Open question the designer MUST address — Agoric consensus compatibility
Agoric XS metering is **consensus-critical**: computron counts drive gas/fees and must be
identical across all validators. "Accuracy over XS-parity" is safe for consensus **iff**
endor's meter itself is the consensus meter and every validator runs the same endor
release (the "deterministic per release version" property gives exactly this). But it
raises real questions the doctrine revision must answer:
- Must endor **also** offer an XS-computron-compatible meter mode for chains that need
  bit-for-bit continuity with today's XS metering, or does Agoric adopt endor's meter?
- Switching a live chain's meter changes gas costs — a chain-governance / migration event.
  Flag whether endor targets (a) drop-in XS-meter-compatible operation, (b) a new
  endor-native metered release consumers opt into, or (c) both (a compatibility mode plus
  an accuracy mode). This choice bounds the whole doctrine.

## Relationship to the sibling plans
Foundational to, and referenced by:
- `xs2rust-endor-strings-utf16-replace-cesu8` (re-bases string metering for accuracy), and
- `xs2rust-endor-meter-opcode-cost-instrumentation` (measures the data that drives
  recalibration).
Ideally this doctrine is settled before those two are built, so they inherit a decided
stance rather than each re-litigating it.

<!-- garden-reaped: 1 -->
