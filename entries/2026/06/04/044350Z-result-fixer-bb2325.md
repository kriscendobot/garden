---
ts: 2026-06-04T04:43:50Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
short_id: bb2325
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
refs:
  - entries/2026/06/04/042109Z-dispatch-liaison-bb2325.md
  - entries/2026/06/04/044044Z-message-fixer-bb2325.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4424448137
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4619031047
---

# result: fixer — #417 review 4424448137 addressed (rename, split, move)

## Per-comment status

| # | Comment id | Status | Addressing SHA | Reply id |
|---|---|---|---|---|
| 1 | `3353294634` (permits sliceBufferToImmutable) | addressed | `701662fa8` | `3353512596` |
| 2 | `3353301111` (non-ASCII + gardener directive) | addressed (code) + `message: fixer to gardener` (meta) | `701662fa8` | `3353513209` |
| 3 | `3353303304` ("Reasonable" ack) | acknowledged, no code change | n/a | `3353513546` |
| 4 | `3353305820` (fromImmutable simpler) | addressed (judgment-call flagged) | `701662fa8` | `3353514181` |
| 5 | `3353315386` (RegisteredSymbol(freezable)) | addressed | `b6fdeff8d` | `3353514830` |
| 6 | `3353323302` (move ponyfill into @endo/bytes) | addressed (judgment-call flagged) | `c5bd2a257` | `3353515625` |
| 7 | `3353401644` (drop "spackle" / harden naming) | addressed (judgment-call flagged for DESIGN.md scope) | `c5bd2a257` | `3353516332` |
| 8 | `3353412248` (drop Function suffix; fromText symbol) | addressed | `c5bd2a257` + `701662fa8` | `3353516926` |
| 9 | `3353418383` (toStrictText pair) | addressed | `c5bd2a257` + `701662fa8` | `3353517862` |
| 10 | `3353430209` (split spackle-install.js) | addressed | `c5bd2a257` | `3353518675` |

Top-level summary comment: `4619031047`
(<https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4619031047>).

## Per-package summary

### `@endo/bytes`

Files added (10):
- `src/install-helpers.js` (shared intrinsic capture + `installOrAdopt`)
- `src/install-to-immutable.js` (sliceToImmutable rendezvous)
- `src/install-transfer-to-immutable.js` (transferToImmutable; optional)
- `src/install-concat-immutables.js`
- `src/install-from-immutable.js`
- `src/install-from-string.js` (TextEncoder capture + fromText)
- `src/install-to-string.js` (TextDecoder lenient + fatal + toText/toStrictText)
- `src/install-freezable-typedarrays.js`
- `src/freezable-typedarray-pony.js` (moved from `@endo/immutable-arraybuffer/src/`)
- `test/install.test.js` (renamed from `test/spackle.test.js`, expanded for new symbol surface)

Files moved (2):
- `src/freezable-typedarray-pony.js` (from `packages/immutable-arraybuffer/src/`)
- `test/freezable-typedarray-pony.test.js` (from `packages/immutable-arraybuffer/test/`)

Files removed (2):
- `src/spackle-install.js` (replaced by per-op install modules)
- `test/spackle.test.js` (replaced by `install.test.js`)

Files modified (6):
- `src/to-immutable.js`, `from-immutable.js`, `concat-immutables.js`,
  `from-string.js`, `to-string.js`, `concat.js` (import from new install modules; renamed
  exports drop `Function` suffix)

### `@endo/immutable-arraybuffer`

- Added `src/private-for-bytes.js` (narrow subpath re-exporting
  `hiddenBuffers`, `reverseHiddenBuffers`, `FERAL_GET_ARRAY_BUFFER`,
  `sliceBufferToImmutable`, `makeInternalHeir`, `getGetter`).
- `package.json` exports: dropped `./freezable-typedarray-pony.js`,
  added `./private-for-bytes.js`.
- `README.md`: updated path reference for the moved file.
- `DESIGN.md`: updated the freezable-typedarray-pony location
  paragraph, the eslint allow-list bullet, and the migration-path
  paragraph that named the now-removed subpath.
- Removed `src/freezable-typedarray-pony.js` and
  `test/freezable-typedarray-pony.test.js` (moved to @endo/bytes).

### `@endo/eslint-plugin`

- `lib/rules/no-direct-codec-or-typedarray-constructor.js`: updated
  the allow-files list (now `bytes/src/install-helpers.js`,
  `bytes/src/freezable-typedarray-pony.js`,
  `immutable-arraybuffer/src/immutable-arraybuffer-pony-internal.js`),
  the rule's documentation comment, the suggestion messages, and
  the `Symbol.for('freezableConstructor')` -> `Symbol.for('freezable')`
  references.
- `test/no-direct-codec-or-typedarray-constructor.test.js`: updated
  filename suffixes.

### `@endo/ses`

- `src/permits.js`:
  - Renamed `RegisteredSymbol(sliceBufferToImmutable)` ->
    `sliceToImmutable`, `transferBufferToImmutable` ->
    `transferToImmutable`, `bytesFromImmutable` -> `fromImmutable`,
    `toUtf8String` -> `toText`, `fromUtf8String` -> `fromText`,
    `freezableConstructor` -> `freezable`.
  - Added `RegisteredSymbol(toStrictText)`.
  - Replaced four `§` (U+00A7) with ASCII `#` in spackle-adjacent
    comments. Verified `grep -P '[^\\x00-\\x7F]' permits.js` empty.
  - Trimmed the "Symbol rendezvous shape" cross-link comments
    (the symbol-name itself is the rendezvous shape now).

## Commits (3 on `mirror/3164-freezable-typedarrays`)

```
b6fdeff8d  refactor(bytes, ses): simplify freezable TypedArray symbol to RegisteredSymbol(freezable) (#417 review 4424448137)
701662fa8  feat(ses): admit @endo/bytes-renamed registered symbols and drop non-ASCII (#417 review 4424448137)
c5bd2a257  refactor(bytes, immutable-arraybuffer, eslint-plugin): split installs, rename symbols, move freezable pony into @endo/bytes (#417 review 4424448137)
```

Push: regular append onto the existing branch, no force.

New head SHA: `b6fdeff8d`.

## Local gate exit codes

| Gate | Package | Exit | Notes |
|---|---|---|---|
| `yarn lint` | bytes | 0 | 57 warnings (test code `new Uint8Array(...)` shapes, pre-existing pattern); 0 errors |
| `yarn lint` | immutable-arraybuffer | 0 | 109 warnings, 0 errors |
| `yarn lint` | eslint-plugin | 0 | 0 errors |
| `yarn lint` | ses | 0 | 46 warnings, 0 errors |
| `yarn lint:types` | bytes | 0 | clean |
| `yarn lint:types` | immutable-arraybuffer | 0 | clean |
| `yarn lint:types` | ses | non-zero | 2 pre-existing `Compartment` duplicate-identifier errors on `dist/types.d.cts` and `types.d.ts`, unchanged from base SHA `83133cceb` (verified via `git stash` round-trip) |
| `yarn test` | bytes | 0 | 55 passed |
| `yarn test` | immutable-arraybuffer | 0 | 37 passed, 1 known failure (pre-existing) |
| `yarn test` | eslint-plugin | 0 | 149 passed |
| `yarn test` | ses | 0 | 505 passed, 2 known failures, 2 skipped |
| `yarn cover` | bytes | 0 | 97.1% statements, 93.54% branches |
| `yarn prettier --check` | (touched files) | 0 | all formatted |

## Reply IDs

Inline replies posted on each of the 10 review threads. Top-level
summary comment: `4619031047`.

## Gardener message path

`journal/entries/2026/06/04/044044Z-message-fixer-bb2325.md`

The message is addressed to `gardener` and asks for a driver-level
deterministic check to keep source generally in the ASCII range,
per the maintainer's second-sentence directive on inline comment
`3353301111`. The steward / liaison should pick this up at the
next per-cycle scan; this fixer cannot edit the garden itself.

## Judgment calls

1. **Item 4 (`fromImmutable`)**: Maintainer wrote "Simply
   `fromImmutable` should suffice, not even a symbol". I read this
   as the simpler *symbol name* (drop the `bytes` prefix). The
   alternative ("not even a symbol" -> use a plain property name)
   would land at `Uint8Array.fromImmutable` rather than at
   `Uint8Array[Symbol.for('fromImmutable')]`. Plain-property
   shapes do not survive multiple bytes loads across realms the
   way registered symbols do, so I kept the symbol form. Flagged
   in the inline reply and top-level summary; maintainer can
   correct on the next review pass.

2. **Item 6 (encapsulation seam for the moved pony)**:
   `hiddenBuffers` and `reverseHiddenBuffers` are encapsulated in
   `@endo/immutable-arraybuffer` and explicitly marked as
   "must not be accessible from outside this package". Moving
   `freezable-typedarray-pony.js` to `@endo/bytes` without breaking
   that encapsulation required a seam. I chose a narrow private
   subpath (`@endo/immutable-arraybuffer/private-for-bytes.js`)
   re-exporting only the four things the pony needs, documented as
   bytes-internal in its own docstring. The alternative is
   inversion of control (the pony accepts the hidden-WeakMap
   callbacks as parameters from its install module). The IoC shape
   is cleaner but more invasive; flagged for maintainer preference.

3. **Item 7 (DESIGN.md "spackle" scope)**: I purged "spackle" from
   code, file paths, test variable names, eslint rule body, and the
   user-facing README. `DESIGN.md` retains the term as an
   architectural-pattern name (it links to the upstream
   [docs.endojs.org/documents/spackle.html](https://docs.endojs.org/documents/spackle.html)
   page). The maintainer's "Don't use 'spackle' term explicitly in
   code" scopes the ask to code identifiers, not to architectural
   prose, so I left DESIGN.md alone. Flagged for confirmation.

4. **CI status**: Re-request review not yet posted from this
   dispatch. CI is running on `b6fdeff8d`; the new test refactor
   and the permits change are non-trivial. The steward's per-cycle
   scan will pick up #417 once CI converges and either dispatch a
   shepherd (if red) or re-request review (if green) per the
   "drive CI to green BEFORE re-requesting" norm in
   `roles/fixer/AGENT.md`. The top-level summary comment already
   names the reviewer (@kriskowal) so the maintainer will see the
   work even before the re-request lands.

## Self-improvement

A modest skill-grade improvement: the "drop `Function` suffix"
ask (item 8) and "split monolithic install into per-source
modules" ask (item 10) are both first-instance examples of a
pattern that has been recurring in this PR series ("the install
file should not be a megastructure" + "do not Hungarian-mark
helper exports"). The existing `skills/rename-discipline/SKILL.md`
covers the gratuitous-rename case but not the "consolidate-then-split"
case where the first round of review condenses a stub and the
second round asks for it to be split back out along the source
contour. A short skill (or a section in `pr-formation`) on
"co-locate-with-consumer" file shaping would let the next
builder/fixer split files this way on the first draft rather than
reactively after maintainer review. Out of scope for this dispatch
but flagged for the next garden-meta retrospective.

Self-improvement: nothing immediately actionable for landing; one
candidate skill-section addition queued for retrospective.
