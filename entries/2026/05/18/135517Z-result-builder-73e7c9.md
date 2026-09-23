---
ts: 2026-05-18T13:55:17Z
kind: result
role: builder
host: endolinbot
posture: liaison
short_id: 73e7c9
dispatch_root: dispatches/builder--73e7c9
repo: endojs/endo-but-for-bots
project: endo
branch: feat/cbors-package
pr_number: 288
slot: 1
refs:
  - entries/2026/05/18/134211Z-dispatch-builder-73e7c9.md
---

# Result: `feat(cbors): add @endo/cbors package for CBOR byte-string framing`

**PR**: <https://github.com/endojs/endo-but-for-bots/pull/288> (DRAFT)
**Branch**: `feat/cbors-package` on base `llm`.
**Head**: `ffaac04e4` (lockfile commit) on top of `23460f6cd`
(implementation commit) on top of `68246ad92` (`llm` tip at start).

## Pre-flight gates

1. **Open-PR slug check** clean. `gh pr list --search "endo-cbors OR
   cbors-package OR @endo/cbors OR cbor-frame"` returned no live PR
   implementing `@endo/cbors`. The two same-family open PRs (`#109`
   syrups and `#86` design merged) are siblings, not duplicates.
2. **Design-status drift** clean. `designs/cbors.md` Status was `Not
   Started` at start; bumped to `In Progress` in the implementation
   commit with a Status section recording landed vs. deferred.
3. **Existing-package** clean. `packages/cbors/` did not exist; no
   `@endo/cbors` or `cbor-frame` load-bearing import in the tree.

## Affected files

- `packages/cbors/package.json`, `tsconfig.json`, `tsconfig.build.json`,
  `LICENSE`, `SECURITY.md`, `README.md`, `CHANGELOG.md`, `types.d.ts`
  (package scaffold; LICENSE and SECURITY.md copied from
  `packages/netstring/`).
- `packages/cbors/src/head.js` (228 lines): CBOR major-type-2 head
  encode/decode (1/2/3/5/9-byte widths) plus tag-24 wrapper handling.
- `packages/cbors/src/encode.js` (122 lines): `makeCborsWriter` factory
  with `chunked`, `tagged`, `name`, `maxMessageLength` options. Models
  on `@endo/netstring`'s writer for back-pressure parity.
- `packages/cbors/src/decode.js` (118 lines): `makeCborsReader` factory
  with `name` and `maxMessageLength` options. Rejects bad major types,
  indefinite-length forms, and non-24 tags. Enforces
  `maxMessageLength` before allocation.
- `packages/cbors/src/index.js`: re-exports.
- `packages/cbors/test/cbors.test.js` (508 lines): 31 tests.
- `.changeset/add-endo-cbors.md`: `@endo/cbors` minor (new package at
  0.1.0).
- `designs/cbors.md`: Status section added; Status field
  `Not Started` → `In Progress`; Updated `2026-05-18`.
- `yarn.lock`: workspace registration of `@endo/cbors` (separate
  `chore: Update yarn.lock` commit per project convention).

## Tests

- 31 tests, all passing under `noop-harden`, `base`, and `lockdown`
  ses-ava configurations (yarn test runs all three).
- Coverage:
  - Head encoder canonical-form output at each width boundary (0, 23,
    24, 255, 256, 0xffff, 0x10000, 0xffffffff, 0x100000000).
  - Head decoder accepts canonical heads and tag-24 wrappers, rejects
    indefinite-length, wrong major type, and non-24 tags.
  - Round-trip across each head boundary in four configurations
    (plain, chunked, tagged, tagged+chunked).
  - Streaming: head and payload split across chunk boundaries;
    multiple frames per chunk; mixed tagged and untagged frames.
  - Diagnostic surface: `name` and offset in `Unexpected dangling
    message`, `too big`, and bad-initial-byte errors;
    `maxMessageLength` cap on reader (before allocation) and writer
    (at `next` call time).
  - Edge cases: zero-length payload, exactly-at-cap, just-over-cap,
    truncated head, truncated payload, pipe-close propagation through
    chunked writer.
  - Wire-format specimen: tag-24 + "hello" + tag-24 + "A" decodes to
    the exact byte sequence in the design.
- **Regression evidence spot check**: mutating `MAJOR_2_BASE + length`
  → `MAJOR_2_BASE + length + 1` in the head encoder broke 14 / 31
  tests; reverted. Tests are load-bearing.

## CI at PR-open time

All 24 checks `IN_PROGRESS` or `QUEUED` (lint, test 20.x/22.x/24.x
matrix across ubuntu and macos, cover, test262, test-xs, test-hermes,
test-ocapn-python, sandbox-drivers, browser-tests, viable-release,
check-action-pins, build-wasm, familiar-bundle, test-async-hooks).

## Local pre-PR checklist

- `yarn lint:eslint` clean on the new package (no errors).
- `yarn lint:eslint` workspace-wide: 0 errors, 1760 warnings (all
  pre-existing, none introduced by this PR).
- `yarn lint:types` clean on the new package.
- `yarn lint:prettier` workspace-wide clean.
- `yarn build-ts` workspace-wide clean.
- `yarn test` in `packages/cbors`: 31 / 31 pass.

## Out-of-scope deferrals (recorded in design Status section)

- Wiring `@endo/cbors` into `packages/daemon/src/envelope.js` (the
  existing inline-CBOR encoder, the obvious first consumer).
- Wiring into `packages/daemon/src/bus-xs-core.js`.
- A separate codec for CBOR major types other than byte strings.
- The sibling `@endo/syrups` rename (queued separately).
- Back-pressure / flow-control semantics beyond `chunked`.
- 9-byte (uint64) head lengths above 2^53 - 1 (rejected at the head
  decoder; carrying BigInt-shaped lengths is out of scope).

## Notes for downstream stages

- This PR follows the standard PR-creation-flow gamut: cleaner → judge
  (mixed code-panel review, since the diff is source + one design doc
  + one changeset) → fixer if the panel raises in-scope complaints.
  The design touches `designs/cbors.md` only with a Status-section
  addition; the panel kind is **code** (path predominance:
  `packages/cbors/**`).
- The maintainer's framing on roadmap-branch designs (CLAUDE.md §
  Modeled-on designs / roadmap-branch designs) reads `designs are
  based on llm, implementations are based on master`. This dispatch's
  explicit base of `llm` is per the task prompt; the eventual
  implementation against `master` (if the design lifecycle migrates
  the same way the Node-18-drop pair did) is a future weaver dispatch,
  not this builder's concern. The design lives on `llm`; this PR
  bases on `llm` as instructed.

Self-improvement: nothing this time. The dispatch ran end-to-end on
the standard pre-PR checklist with one expected adjustment (the
pipe-close-propagation test from the netstring template needed its
loop bound retuned because the CBOR writer issues fewer per-frame puts
than netstring; the netstring writer emits prefix + chunks + COMMA
while the CBOR writer emits head + chunks, no trailer, so the
count==N edge in the netstring test was off by one for CBOR). That
adjustment is local to this PR's tests and does not generalize to a
skill or role update.
