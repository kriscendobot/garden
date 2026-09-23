from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T06:33:09Z
poison_base: endo-cbor-adopt-daemon-envelope
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T06:33:09Z
last_seen: 2026-08-01T06:33:09Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/endo-cbor-adopt-daemon-envelope; it stays HELD until a human promotes it
(promote-plan.sh endo-cbor-adopt-daemon-envelope) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: endo-cbor-adopt-daemon-envelope

--- original job body ---
---
role: builder
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-30T16:15:35Z cleared=deadline-overrun=1 -->

---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-29T01:40:06Z -->

# Adopt `@endo/cbor` in `packages/daemon/src/envelope.js` (cbor-codec design, phase 4)

Repo: **endojs/endo-but-for-bots**, base line **`llm`**.
Design of record: **`designs/cbor-codec.md`** (on `llm`) — § What moves, what stays
(the `packages/daemon/src/envelope.js` row) and § Migration Path item 4.

Provenance: the "**and elsewhere**" half of kriskowal's 2026-07-28 directive in the
approving review of https://github.com/endojs/endo-but-for-bots/pull/755. Child 2 of
orchestration `endo-cbor-adopt-primitives` (serial; runs **after**
`endo-cbor-adopt-ocapn` lands).

Phase 1 has landed: `@endo/cbor` at `packages/cbor/` on `llm` (merge commit
`3b21299`, PR #755). Cut a **frozen base branch** `llm-<short-sha>` at or after that
commit — see [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md).

## The work

`packages/daemon/src/envelope.js` (389 lines) hand-rolls ~130 of them as a **third
copy** of the same canonical head grammar. Point them at `@endo/cbor`:

- write side: `cborAppendHead`, `cborAppendInt`, `cborAppendBytes`, `cborAppendText`
  over the local `CBOR_UINT` / `CBOR_NEGINT` / `CBOR_BYTES` / `CBOR_TEXT` /
  `CBOR_ARRAY` constants → `writeHead` / `writeInt` / `writeByteString` /
  `writeTextString` / `writeArrayHeader`;
- read side: `cborReadHead`, `cborReadInt`, `cborReadBytes`, `cborReadText`,
  `cborReadArrayHeader` over the local `makeCursor` → `readHead` / `readInt` /
  `readByteString` / `readTextString` / `readArrayHeader` over
  `makeCborReader(bytes, {name})`.

**Stays behind:** the envelope framing (`encodeEnvelope` / `decodeEnvelope` /
`encodeFrame` / `decodeFrame` / `readFrameFromStream` / `writeFrameToStream`) and
the `[handle, verb, payload, nonce]` protocol shape.

### Two shape mismatches scouted in advance

1. **Accumulator.** `envelope.js` appends into a plain `number[]` (`buf`);
   `@endo/cbor` owns a growing `Uint8Array` behind `makeCborWriter()` /
   `cborWriterBytes(writer)`. Convert the encode paths to thread the writer record;
   don't reintroduce a boxed-byte accumulator.
2. **Number domain.** `cborAppendInt` / `cborReadInt` work in `number`;
   `@endo/cbor`'s `writeInt` / `readInt` take and return **bigint** (head arguments
   are the full uint64 range), while counts — lengths, array element counts, tag
   numbers — stay `number` in `[0, 2**32)`. `env.handle` and `env.nonce` are the
   values that cross this line; decide at the envelope boundary whether they become
   bigints internally or are converted at the edge, and keep the *decoded* envelope's
   public field types unchanged unless every caller is updated with them.

## Acceptance — byte-identity is load-bearing across a language boundary

These envelopes are exchanged with a **Rust** peer. Any encoding drift silently
breaks the cross-language bus. The riders to keep green:
`packages/daemon/src/bus-xs-core.js`, `bus-manager-rust-xs.js`,
`manager-go-powers.js`, `bus-manager-node-powers.js`.

- **Capture encoder output before and after and diff it** — a green suite alone is
  not the evidence this job needs. Dump the hex of every envelope/frame fixture on
  the frozen base and on the branch; the diff must be empty. Report that in the PR.
- The daemon test suites and the **bus / XS CI lanes** stay green.
- `@endo/cbor`'s readers are **strict** (non-minimal heads rejected). The Rust peer
  is expected to write canonically, but confirm it — if any bus fixture or Rust
  encoder emits a non-minimal head that today's tolerant `cborReadHead` accepts,
  that is a real behaviour change on live traffic: **stop and ask the maintainer**
  (`scripts/jobs/message-user.sh <your-base>`) before proceeding.

## Standing caveat you must respect

The design marks this adopter **optional**, and `designs/cbors.md` § Dependencies
carries an **older recorded decision** to duplicate head-parsing scaffolding *for
independent auditability* — a decision that predates a shared primitive package
existing. `designs/cbor-codec.md` leaves superseding it *"to the maintainer at
implementation time"*, and kriskowal's "**and elsewhere**" is the natural reading of
that authorization, so proceed. **But** if the migration turns out to cost the
auditability that old decision was protecting — e.g. it entrains a dependency the
daemon's audit surface was deliberately kept free of — **stop and ask the
maintainer** via `message-user.sh` rather than forcing it. Record whichever way it
goes in the PR body, and if the supersession is confirmed, amend
`designs/cbors.md` § Dependencies to point at the new decision.

## Norms

- **One package per PR** per the repo's changeset discipline; include a
  `.changeset/` entry (patch bump for the daemon package).
- **Pure refactor**: no behaviour change, no wire-format change.
- Open the PR as a **draft**; it **auto-runs the gauntlet** under your supervising
  gardener. Do **not** post a separate gauntlet job.
- Predecessor in this orchestration: `endo-cbor-adopt-ocapn` — read its merged PR
  first; the bridging decisions it made (writer/reader state shape, bigint-vs-number
  boundary) are precedent you should follow rather than re-litigate.


<!-- garden-deadline-overrun: 1 -->
