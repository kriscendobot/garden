---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/755
priority: normal
role: orchestrator
posted_by: gardener
posted_at: 2026-07-28T16:19:23Z
---

---
role: orchestrator
---
# Adopt `@endo/cbor` at the existing CBOR call sites (ocapn and elsewhere)

Maintainer directive, kriskowal, 2026-07-28, in the **approving** review of
https://github.com/endojs/endo-but-for-bots/pull/755 :

> Please conduct and post a follow-up job to refactor existing use of CBOR in
> ocapn and elsewhere to use these foundational primitives.

(Review: https://github.com/endojs/endo-but-for-bots/pull/755#pullrequestreview-4799487076 —
an APPROVAL with no inline comments. The *conduct* half was discharged by
`endojs-endo-but-for-bots-pr755-conduct`; **this job is the other half**.)

## Why this job was parked `blocked` on that PR

endojs/endo-but-for-bots#755 is **phase 1** — it *publishes* `packages/cbor`
(`@endo/cbor`) and deliberately leaves every consumer alone. Its own README says
so: *"Phase 1 publishes the package; those two consumers migrate onto it in
phases 2 and 3, so nothing depends on it yet."* There is nothing to migrate onto
until it lands on `llm`, hence the gate. You are reading this because the
unblock watcher saw endojs/endo-but-for-bots#755 resolve.

**First act: verify the premise.** Confirm endojs/endo-but-for-bots#755 actually
**merged** (not merely closed) and that `packages/cbor/` exists on the live `llm`
trunk. If it was closed unmerged, do **no** migration work — report that and stop.

## The authoritative plan already exists — follow it, do not re-derive it

`designs/cbor-codec.md` (on `llm` once endojs/endo-but-for-bots#755 lands) is the
design of record. Read its **§ What moves, what stays** table and **§ Migration
Path** — they name, per call site, the exact functions that move and the exact
acceptance criterion. Do not invent a different decomposition; this job exists to
*execute* phases 2-4, not to redesign them.

## This is a MULTI-PART job — make an ORCHESTRATION (standing pattern, kriskowal 2026-07-01)

Do **not** post a loose pile of sub-jobs. Wear
[orchestrator](../../roles/orchestrator/AGENT.md) per
[orchestration](../../skills/orchestration/SKILL.md): park the children, record
one orchestration, let `orchestrate.sh` sequence and watch them.

### Children, in run order (`--serial`, `--on-child-failure halt`)

**1. `endo-cbor-adopt-ocapn` — design phase 2, the maintainer's headline ask.**
Role `builder`. Replace the module-level primitive helpers in
`packages/ocapn/src/cbor/encode.js` (518 lines) and
`packages/ocapn/src/cbor/decode.js` (800 lines) with imports from `@endo/cbor`.
The design's rename map: `writeTypeAndLength`→`writeHead`,
`writeBytestring`→`writeByteString`, `writeString`→`writeTextString`,
`writeInteger`→`writeBignum`; `parseTypeByte`/`readArgument`→`readHead`,
`readBytestring`→`readByteString`, `readString`→`readTextString`,
`readInteger`→`readBignum`; plus `writeTag`/`readTag`, `writeBoolean`/
`readBoolean`, `writeFloat64`/`readFloat64`, `bigintToMinimalBytes`/
`bytesToBigint`.
**Stays behind:** the `CborWriter`/`CborReader` classes (structure stack, record
labels, the `OcapnReader`/`OcapnWriter` interface), `peekType` type-hinting, the
immutability conversion, the OCapN tag constants, and the whole
`src/cbor/diagnostic/` notation codec.
**Acceptance (the design states it and it is not negotiable): byte-for-byte
identical output.** `packages/ocapn/test/cbor/{encode,decode,interop}.test.js`
and `test/codecs/*` must stay green. Error-message *wording* may change; the
`name` + offset diagnostics **must** survive. Watch the downstream consumers that
ride this codec: `packages/ocapn/src/hub/hub.js`, `src/client/index.js`, and
`packages/ocapn-noise` (which imports `cborCodec` from `@endo/ocapn/cbor`).

**2. `endo-cbor-adopt-daemon-envelope` — design phase 4, the "and elsewhere".**
Role `builder`. `packages/daemon/src/envelope.js` hand-rolls ~130 of its 389
lines as a third copy of the same head grammar (`cborAppendHead`,
`cborAppendInt`, `cborAppendBytes`, and the matching read side, over
`CBOR_UINT`/`NEGINT`/`BYTES`/`TEXT`/`ARRAY`). Point them at `@endo/cbor`.
**Stays behind:** the envelope framing and the `[handle, verb, payload, nonce]`
protocol shape.
**Byte-identity is load-bearing here too** — these envelopes are exchanged with a
**Rust** peer (`packages/daemon/src/bus-xs-core.js`, `bus-manager-rust-xs.js`,
`manager-go-powers.js`, `bus-manager-node-powers.js`). Any encoding drift breaks
the cross-language bus. Keep the daemon suites and the bus/XS lanes green.
*Caveat to respect:* the design marks this adopter **optional**, and
`designs/cbors.md` § Dependencies carries an older recorded decision to duplicate
head-parsing scaffolding for independent auditability — a decision that predates a
shared primitive package existing. The design leaves superseding it *"to the
maintainer at implementation time"*. kriskowal's "**and elsewhere**" is the
natural reading of that authorization, so proceed — but if the migration turns out
to cost the auditability the old decision was protecting, **stop and ask the
maintainer** via `message-user.sh` rather than forcing it.

### Deliberately NOT an orchestration child: the slots migration (phase 3)

Design phase 3 (delete `packages/slots/src/cbor.js`, point `payload.js` /
`descriptor.js` at `@endo/cbor`) **cannot run yet**: `packages/slots` does not
exist on `llm` at all — it lives only on the `slot-machine` branch of
https://github.com/endojs/endo-but-for-bots/pull/124 , which is still **OPEN and
DRAFT**. A serial orchestration child would simply stall on it.

Park it instead as its own gated plan job — an artifact gate, which is what
`blocked_on` is the lighter tool for:

```sh
scripts/jobs/post-plan.sh --blocked \
  --blocked-on https://github.com/endojs/endo-but-for-bots/pull/124 \
  --role builder endo-cbor-adopt-slots <body-file>
```

Its body should record: delete `packages/slots/src/cbor.js`; retarget
`packages/slots/test/cbor.test.js` at the package (or fold it into
`packages/cbor/test/`); **acceptance = the slots adversarial and end-to-end
suites plus the Rust parity CI lane (`.github/workflows/rust-endor.yml`) stay
green**, proving the byte-identity contract with `rust/endo/slots/src/wire/codec.rs`
held. Note the design's sequencing escape hatch: if
https://github.com/endojs/endo-but-for-bots/pull/124 instead rebases onto the
landed phase 1, slots may adopt `@endo/cbor` *in flight* and shed `src/cbor.js`
before merge — either order preserves the invariants.

## Per-child norms (put these in each child body)

- One package per PR, per the repo's changeset discipline — each child opens its
  **own** PR off a fresh frozen base (`llm-<short-sha>`, see
  [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md)), with a
  `.changeset/` entry.
- These are **pure refactors**: no behaviour change, no wire-format change. The
  strongest evidence is a byte-identity check, not merely a green suite — prefer
  capturing encoder output before and after and diffing it.
- Each child's draft PR **auto-runs the gauntlet** under its supervising gardener;
  do not post a separate gauntlet job.

## Set-up commands (this job's actual work)

```sh
scripts/jobs/post-plan.sh --orchestrated --orchestrated-by endo-cbor-adopt-primitives \
  --role builder endo-cbor-adopt-ocapn <body-1>
scripts/jobs/post-plan.sh --orchestrated --orchestrated-by endo-cbor-adopt-primitives \
  --role builder endo-cbor-adopt-daemon-envelope <body-2>
scripts/jobs/post-orchestration.sh --serial --on-child-failure halt \
  endo-cbor-adopt-primitives endo-cbor-adopt-ocapn endo-cbor-adopt-daemon-envelope
```

## Definition of done (for THIS job)

- endojs/endo-but-for-bots#755's merge confirmed and `packages/cbor/` present on `llm`.
- Both orchestration children parked with substantive bodies (not placeholders),
  and the orchestration recorded.
- `endo-cbor-adopt-slots` parked, blocked on
  https://github.com/endojs/endo-but-for-bots/pull/124 .
- Report names the three basenames so the maintainer can track the arc.
