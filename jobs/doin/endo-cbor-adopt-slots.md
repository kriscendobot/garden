---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-14T23:26:05Z cleared=none -->

# Adopt `@endo/cbor` in `packages/slots` (cbor-codec design, phase 3)

Repo: **endojs/endo-but-for-bots**. Design of record: **`designs/cbor-codec.md`**
(on `llm`) — § What moves, what stays (the `packages/slots/src/cbor.js` row) and
§ Migration Path item 3.

## Why this job is parked `blocked`

`packages/slots` **does not exist on `llm`**. It lives only on the `slot-machine`
branch of https://github.com/endojs/endo-but-for-bots/pull/124 , which is still
**OPEN and DRAFT** as of 2026-07-28. There is nothing to migrate until that PR
resolves; this job is gated on it via `blocked_on`, and the unblock watcher will
promote it when the PR merges (or closes). It is deliberately **not** a child of the
`endo-cbor-adopt-primitives` orchestration — a serial child would simply stall.

**First act on promotion: verify the premise.** If #124 closed *unmerged*, do no
migration work — report that and stop. If it merged, confirm `packages/slots/` is on
the live trunk and that `packages/slots/src/cbor.js` still exists (see the
sequencing escape hatch below — it may already be gone).

Phase 1 has landed: `@endo/cbor` at `packages/cbor/` on `llm` (merge commit
`3b21299`, PR #755).

## The work

The design's easiest migration, because `@endo/cbor`'s identifier style was chosen
to match this file: `writeUint`, `writeByteString`, `writeArrayHeader`, `readUint`,
`readByteString`, `readArrayHeader`, `assertConsumed` keep their spellings, so this
is **import-path-only** at the call sites.

- **Delete `packages/slots/src/cbor.js`** — the whole file; its API is a subset of
  the shared surface under the same names.
- Point `packages/slots/src/payload.js` and `packages/slots/src/descriptor.js` at
  `@endo/cbor`; add the workspace dependency to `packages/slots/package.json`.
- **Retarget `packages/slots/test/cbor.test.js`** at the package, or fold its cases
  into `packages/cbor/test/` (phase 1 already ported the vector tests — check for
  duplication before folding, and prefer deleting a true duplicate over carrying two
  copies of the same vectors).
- The verb and descriptor shapes in `payload.js` / `descriptor.js` **stay behind**.
- Watch the number domain: `@endo/cbor` head arguments are **bigint**; counts
  (lengths, element counts, tag numbers) are `number` in `[0, 2**32)`. The slots
  file's accumulator is a `number[]`; `@endo/cbor` owns a growing `Uint8Array`.

## Acceptance (the design states it)

**The slots adversarial and end-to-end suites plus the Rust parity CI lane
(`.github/workflows/rust-endor.yml`) stay green** — that lane is the proof that the
byte-identity contract with `rust/endo/slots/src/wire/codec.rs` held. Nothing moves
on the Rust side; parity is enforced by shared test vectors.

As with the sibling adopters, capture encoder output before and after and diff it;
an empty diff is the evidence, not merely a green suite. Note `@endo/cbor`'s readers
are **strict** (non-minimal heads rejected) where the slots reader may be tolerant —
if a fixture or the Rust encoder relies on that tolerance, stop and ask the
maintainer via `scripts/jobs/message-user.sh <your-base>`.

## Sequencing escape hatch (from the design)

If #124 instead **rebases onto the landed phase 1**, `packages/slots` may adopt
`@endo/cbor` *in flight* and shed `src/cbor.js` **before** merge — either order
preserves the invariants. If you find on promotion that the adoption already
happened in flight, this job's remaining work is only to verify the acceptance
criteria above (and the test retargeting), then report; do not redo it.

## Norms

- **One package per PR** per the repo's changeset discipline; include a
  `.changeset/` entry. Cut a **frozen base branch** `<trunk>-<short-sha>` — see
  [frozen-base-branch](../../skills/frozen-base-branch/SKILL.md).
- **Pure refactor**: no behaviour change, no wire-format change.
- Open the PR as a **draft**; it **auto-runs the gauntlet** under your supervising
  gardener. Do **not** post a separate gauntlet job.
- Siblings already run under orchestration `endo-cbor-adopt-primitives`:
  `endo-cbor-adopt-ocapn` (phase 2) and `endo-cbor-adopt-daemon-envelope` (phase 4).
  Read their merged PRs first — their bridging decisions are precedent.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T23:26:22Z
