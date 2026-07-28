---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T21:10:07Z -->

# Adopt `@endo/cbor` in `packages/ocapn` (cbor-codec design, phase 2)

Repo: **endojs/endo-but-for-bots**, base line **`llm`**.
Design of record: **`designs/cbor-codec.md`** (on `llm`) — read its
**§ What moves, what stays** table and **§ Migration Path** item 2 before writing
code. This job *executes* that design; it does not redesign it.

Provenance: maintainer directive, kriskowal, 2026-07-28, in the approving review of
https://github.com/endojs/endo-but-for-bots/pull/755 — *"Please conduct and post a
follow-up job to refactor existing use of CBOR in ocapn and elsewhere to use these
foundational primitives."* Child 1 of orchestration `endo-cbor-adopt-primitives`
(serial, halt-on-failure).

Phase 1 has landed: `@endo/cbor` exists at `packages/cbor/` on `llm` (merge commit
`3b21299`, PR #755). Base this PR on a **frozen base branch** `llm-<short-sha>` cut
at or after that commit — see [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md).

## The work

Replace the **module-level primitive helpers** in
`packages/ocapn/src/cbor/encode.js` (~518 lines) and
`packages/ocapn/src/cbor/decode.js` (~800 lines) with imports from `@endo/cbor`.

Rename map (ocapn spelling → `@endo/cbor` export):

| encode.js | decode.js |
|---|---|
| `writeTypeAndLength` → `writeHead` | `parseTypeByte` + `readArgument` → `readHead` |
| `writeBytestring` → `writeByteString` | `readBytestring` → `readByteString` |
| `writeString` → `writeTextString` | `readString` → `readTextString` |
| `writeInteger` → `writeBignum` | `readInteger` → `readBignum` |
| `writeTag` → `writeTag` | `readTag` → `readTag` |
| `writeBoolean` → `writeBoolean` | `readBoolean` → `readBoolean` |
| `writeFloat64` → `writeFloat64` | `readFloat64` → `readFloat64` |
| `bigintToMinimalBytes` → (internal to `writeBignum`) | `bytesToBigint` → (internal to `readBignum`) |
| `writeTypeByte` → `writeHead` / `writeNull` / `writeUndefined` / `writeBoolean` | — |

The actual `@endo/cbor` surface (verify against `packages/cbor/index.js`, do not
work from this list alone): `makeCborWriter`, `cborWriterBytes`, `writeHead`,
`writeUint`, `writeInt`, `writeByteString`, `writeTextString`, `writeArrayHeader`,
`writeMapHeader`, `writeTag`, `writeBoolean`, `writeNull`, `writeUndefined`,
`writeFloat64`, `writeBignum`; `makeCborReader`, `readHead`, `peekHead`, `readUint`,
`readInt`, `readByteString`, `readTextString`, `readArrayHeader`, `readMapHeader`,
`readTag`, `readBoolean`, `readFloat64`, `readBignum`, `readOptionalUndefined`,
`readNull`, `readOptionalNull`, `assertConsumed`.

**Stays behind** (per the design's table — do not move these):
the `CborWriter` / `CborReader` classes (structure stack, `#structureInfo` element
counting, record labels, the `OcapnWriter` / `OcapnReader` interface), `peekType`
type-hinting, `peekTag`, `readSelectorAsString` / `writeSelectorFromString`, the
immutability conversion (`bytesToImmutable`), the OCapN tag constants
(`TAG_UNSIGNED_BIGNUM`, `TAG_NEGATIVE_BIGNUM`, `TAG_RECORD`, `TAG_SYMBOL`,
`TAG_TAGGED_VALUE`, still re-exported for the codec layer), and the whole
`src/cbor/diagnostic/` notation codec.

## Three impedance mismatches to expect (scouted; resolve them, don't be surprised)

1. **Writer/reader state shape.** ocapn's `CborWriter` / `CborReader` are
   constructed over syrup's `BufferWriter` / `BufferReader` (`constructor(bufferWriter,
   {name})`, `get index()` delegating to it), and every module-level helper takes
   that object. `@endo/cbor` owns its own state: a writer record
   `{buffer, length}` from `makeCborWriter()` and a reader record
   `{bytes, index, name}` from `makeCborReader(bytes, {name})`. The design
   deliberately did **not** extract syrup's buffer classes (Design Decision 6), so
   phase 2 must bridge. Pick the smaller bridge and say why in the PR body — either
   swap the classes' private field to the `@endo/cbor` state (adjusting `index` →
   `writer.length` / `reader.index` and the `makeCborReader` factory in
   `decode.js`, which today does `BufferReader.fromBytes`), or keep the syrup
   objects at the class boundary and adapt at each call. Do **not** widen
   `@endo/cbor`'s API to accommodate ocapn; it is a landed leaf package.
   Note `packages/ocapn/src/cbor/decode.js` exports its own `makeCborReader` — the
   name now collides with `@endo/cbor`'s export; alias on import.
2. **Number domain.** `@endo/cbor` head arguments are **bigint** (`writeHead`,
   `writeUint`, `writeInt`, `readHead`, `readUint`, `readInt`), while **counts**
   (byte/text-string lengths, array and map element counts, **tag numbers**) are
   **number**, bounded `[0, 2**32)`. ocapn today holds its tag constants as bigints
   (`TAG_SYMBOL = 280n`) and passes lengths as numbers through one
   `writeTypeAndLength`. Converting the constants is fine; converting the *public*
   re-exported tag constants changes a cross-module contract — check
   `packages/ocapn/src/cbor/index.js`, `src/codecs/*`, and the tests that import
   them, and keep the exported spelling stable if anything depends on `280n`.
3. **Readers are strict, unconditionally.** `@endo/cbor` rejects non-minimal heads
   and non-minimal bignum payloads; today's ocapn decoder accepts them (e.g. a
   length 5 encoded in two bytes). This tightening is **intended** — it is the
   design's Design Decision 5 and resolves its Open Question 2 — but it is an
   observable acceptance change, not a pure refactor, and the design leaves
   *"whether rejecting non-canonical traffic from tolerant peers is acceptable at
   the point of migration"* as **a maintainer call**. If any existing ocapn test,
   interop vector, or downstream consumer asserts that a non-canonical encoding is
   *accepted*, **stop and ask the maintainer** with
   `scripts/jobs/message-user.sh <your-base>` rather than deleting the assertion.

## Acceptance (from the design; not negotiable)

- **Byte-for-byte identical encoder output.** A green suite is necessary but not
  sufficient evidence — capture encoder output **before** the change and diff it
  against **after** (e.g. dump the hex of every vector in
  `packages/ocapn/test/cbor/*` and `test/codecs/*` on the frozen base, then
  re-dump on the branch and `diff`). Put that diff-is-empty result in the PR body.
- `packages/ocapn/test/cbor/{encode,decode,interop}.test.js` and
  `packages/ocapn/test/codecs/*` stay green, unchanged wherever possible.
- Error-message **wording** may change; the `name` + byte-offset diagnostics
  (`... at index N of <name>`) **must** survive — assert that explicitly.
- Downstream riders of this codec must stay green: `packages/ocapn/src/hub/hub.js`,
  `packages/ocapn/src/client/index.js`, and **`packages/ocapn-noise`** (which
  imports `cborCodec` from `@endo/ocapn/cbor`). Run their suites too.
- `packages/ocapn/package.json` gains the `@endo/cbor` workspace dependency;
  `packages/ocapn/src/cbor/README.md` is updated to say the primitives now come
  from `@endo/cbor`.

## Norms

- **One package per PR** per the repo's changeset discipline; include a
  `.changeset/` entry (a patch bump for `@endo/ocapn` — this is a pure refactor).
- **Pure refactor**: no behaviour change beyond the read-strictness tightening
  named above, no wire-format change, no new public API.
- Open the PR as a **draft**; it **auto-runs the gauntlet** (clean → panel →
  fix-loop → un-draft) under your supervising gardener. Do **not** post a separate
  gauntlet job.
- Sibling children of this orchestration: `endo-cbor-adopt-daemon-envelope`
  (runs after you), and the parked, PR-gated `endo-cbor-adopt-slots`.
