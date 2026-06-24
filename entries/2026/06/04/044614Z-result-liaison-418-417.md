---
ts: 2026-06-04T04:46:14Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/04/043501Z-dispatch-liaison-ca5cd9.md
  - entries/2026/06/04/044129Z-result-fixer-ca5cd9.md
  - entries/2026/06/04/044238Z-dispatch-liaison-dfff95.md
  - entries/2026/06/04/044509Z-result-conductor-dfff95.md
  - entries/2026/06/04/042109Z-dispatch-liaison-bb2325.md
  - entries/2026/06/04/044350Z-result-fixer-bb2325.md
  - entries/2026/06/04/044044Z-message-fixer-bb2325.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 418
    role: target
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: target
---

# result: #418 MERGED at 682281a4; #417 all 10 asks revised at b6fdeff8d

Two major closes simultaneously.

## #418 chain: fixer follow-up → conductor → MERGED

- Fixer `ca5cd9`: replaced module-level TextDecoder/TextEncoder
  singletons in `worker-archive-parsers.js` with `bytesToText`
  / `bytesFromText` from `@endo/bytes` (per-symbol subpath).
  New head `89d502fbd`. Inline reply `3353511940`.
- Conductor `dfff95`: defensive checks passed (local HEAD
  matched, MERGEABLE, APPROVED, 0 behind). Un-drafted +
  merged via `--merge` + `--delete-branch`.
- **Merge SHA**: `682281a4` on `llm-2bd9e0c` (true merge
  commit; parents `2bd9e0cbb` + `89d502fbd`).
- **Branch cleanup**: `fix/endo-make-node-evasive-runtime`
  deleted; frozen base `llm-2bd9e0c` deleted (no other open
  PRs depended on it).
- Merged at 2026-06-04T04:44:40Z.

## #417 fixer: substantial 10-comment revision

Three commits:
- `c5bd2a257` — refactor(bytes, immutable-arraybuffer,
  eslint-plugin): split installs, rename symbols, move
  freezable pony into @endo/bytes
- `701662fa8` — feat(ses): admit @endo/bytes-renamed
  registered symbols and drop non-ASCII
- `b6fdeff8d` — refactor(bytes, ses): simplify freezable
  TypedArray symbol to RegisteredSymbol(freezable)

**Per-comment status** (all 10):
- 9 addressed, 1 acknowledged (positive ack only).
- Top-level summary: `4619031047`.

### Per-package changes

- **@endo/bytes**: monolithic 276-LOC `spackle-install.js` →
  8 per-operation install modules. Dropped `Function`
  suffixes. Renamed symbols. Added `Symbol.for('toStrictText')`.
  Moved `freezable-typedarray-pony.js` in from
  immutable-arraybuffer. Test renamed → `install.test.js`.
  Coverage 97.1%.
- **@endo/immutable-arraybuffer**: dropped public ponyfill
  export; added narrow `./private-for-bytes.js` internal
  subpath. README/DESIGN.md updated.
- **@endo/eslint-plugin**: rule allow-list + suggestions
  updated for new paths and renamed symbol.
- **@endo/ses**: 7 registered-symbol names renamed; 4
  non-ASCII `§` → ASCII `#`; `toStrictText` admitted.

### Gates (all 0)

- yarn lint, yarn lint:types (bytes + immutable-arraybuffer),
  yarn test (bytes 55/55, immutable-arraybuffer 37/37,
  eslint-plugin 149/149, ses 505/505), yarn prettier --check.
- SES has 2 pre-existing `Compartment` duplicates unchanged
  from base.

### Gardener message journaled

`044044Z-message-fixer-bb2325.md` — driver-level
deterministic ASCII enforcement per kriskowal's ask #2.

### Judgment calls

1. Item 4 (`fromImmutable`): kept as registered symbol;
   cross-realm rendezvous shape requires it. Maintainer can
   correct.
2. Item 6 (encapsulation): chose narrow private subpath over
   IoC refactor. More invasive alternative offered as
   follow-up.
3. Item 7 (DESIGN.md "spackle"): purged from code/paths/
   identifiers; retained in DESIGN.md as architectural
   pattern name with link to upstream docs.
4. CI re-request deferred — fixer norm is drive-CI-to-green
   before re-requesting; top-level summary names @kriskowal
   so maintainer sees the work.

## Teardown

`dispatches/fixer--ca5cd9`, `dispatches/conductor--dfff95`,
`dispatches/fixer--bb2325` all torn down.

## Steward queue post-engagement

- **#418** MERGED.
- **#417** revised at `b6fdeff8d`; CI running; awaits CI
  green + maintainer reassessment.
- **#411** at `56c3e9ddb` (timeout extended); CI re-queued.
- Gardener follow-up queued: driver ASCII enforcement.
