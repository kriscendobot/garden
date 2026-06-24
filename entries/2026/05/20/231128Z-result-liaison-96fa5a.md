---
ts: 2026-05-20T23:11:28Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 225513Z-dispatch-liaison-96fa5a
---

# Result: builder 96fa5a — mirror of endojs/endo#3036 onto endo-but-for-bots@llm (PR open, partial mirror by design)

Builder dispatch `96fa5a` complete. **DRAFT PR [endojs/endo-but-for-bots#330](https://github.com/endojs/endo-but-for-bots/pull/330)** open, head `68f4918ad`. Self-report at `journal/entries/2026/05/20/...result-builder-96fa5a.md` (pushed). Sibling builder e1d015 already completed and torn down.

## Key finding: llm-side has already absorbed the package

`@endo/exo-stream` already lives on llm (landed via `kriskowal-exo-stream` branch, commit `3e240f9ff`, plus follow-ups). Module/export names were refactored from PR #3036's snapshot:

- `streamIterator` → `readerFromIterator`
- `iterateStream` → `iterateReader`
- `streamBytesIterator` → `bytesReaderFromIterator`
- `iterateBytesStream` → `iterateBytesReader`

Protocol semantics identical. `@endo/daemon` already lists `@endo/exo-stream` as a dependency. 121 exo-stream tests pass.

The **un-mirrored** piece is PR #3036's first commit (`b66f8149e refactor(daemon,cli): Use new exo-stream package`) — the wire-in migration that switches every caller from the legacy reader-ref API to the new exo-stream API.

## Why a full mirror wasn't viable

`git apply --3way` produces heavy conflicts (4 outright-missing files, 30+ rejected hunks). Deeper structural issue: llm has accreted **many** legacy-API call sites not in PR #3036's diff:

- daemon-side: `mount.js`, `channel.js`, `worker.js`, `daemon-persistence-powers.js`, two extra sites in `daemon.js` (gateway retention sync + `makeBytesBlob`).
- 41 legacy-API call sites across 4 daemon test files.
- Cross-package consumers in `@endo/chat`, `@endo/chat-network-view`, `@endo/fae`, `@endo/genie`, `@endo/jaine`, `@endo/lal`, `@endo/platform`.

The migration is wire-protocol-changing; doing it as a single mirror dispatch would silently break ~100 call sites across ~10 packages. Builder produced a small additive PR instead.

## The shipped PR

25-line additive diff to `packages/daemon/index.js` and `packages/daemon/types.d.ts`: re-exports the four new exo-stream APIs *alongside* legacy, with comments naming the wire pairing and migration constraint. No wire changed; no test broken. PR body documents the full mapping table and gap analysis so a future atomic-migration PR has a starting point.

## Local verification

`@endo/exo-stream`: 0 lint errors, 121 tests pass. `@endo/daemon`: 0 lint errors. Full `yarn test` for daemon skipped (long-running, needs running daemon); `lint:types` has a pre-existing unrelated `@libp2p/utils` resolution error verified against HEAD.

## Gamut continuation

The gamut chain (cleaner / judge / fixer / un-draft) is heavyweight for a 25-line shim PR whose substantive deliverable is the gap analysis in the body. Recommend the maintainer review the gap analysis first and decide whether to:

- **A**: dispatch the gamut on PR #330 as-is (cleaner / judge will look at 25 lines plus a long PR body).
- **B**: defer the gamut; schedule a follow-up *atomic migration* engagement that takes the gap analysis as its design and rewires the ~100 call sites + tests across the ~10 packages in one cleanly-reviewed PR.
- **C**: close #330 entirely and just retain the gap analysis as a `message` journal entry / design doc, since the shim layer may have ergonomic costs the maintainer wants to weigh.

## Teardown

Dispatch root `/home/kris/dispatches/builder--96fa5a/` torn down by the liaison after this entry lands.
