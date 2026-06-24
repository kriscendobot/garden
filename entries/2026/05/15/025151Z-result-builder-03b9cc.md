---
ts: 2026-05-15T02:51:51Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--03b9cc/project
---

# Result: hardened-text-codecs-shim Phases 1 + 2 → draft PR #259

## Deliverable

PR endojs/endo-but-for-bots#259 (draft), branch `feat/hardened-text-codecs-shim`, base `master`, head `fc2aa8d3c`.

Implements Phases 1 (permits + sampling) and Phase 2 (tests + changeset) of `designs/hardened-text-codecs-shim.md` (on the `llm` roadmap branch).

## Affected packages

- `ses` (only): `packages/ses/src/permits.js` adds two universal entries and two prototype subtrees. Two new tests under `packages/ses/test/`. One changeset.

## Files

- `packages/ses/src/permits.js`: `TextEncoder` and `TextDecoder` added to `universalPropertyNames`; `TextEncoder` / `%TextEncoderPrototype%` / `TextDecoder` / `%TextDecoderPrototype%` permit subtrees added near the WHATWG section (after `Proxy`, before Annex B). Permitted prototype methods match the design's *Permits table*: `encode`, `encodeInto`, `decode` as `fn`; `encoding`, `fatal`, `ignoreBOM` as `getter` (verified against Node's actual descriptors); `@@toStringTag` as a string.
- `packages/ses/test/text-codecs.test.js` (12 tests): presence on the start compartment, identity across compartments (universal-not-shared), constructor and prototype frozen, `encoding` getter returns `'utf-8'`, round-trip in the start compartment and inside a compartment, `fatal` option, `encodeInto`.
- `packages/ses/test/text-codecs-missing.test.js` (2 tests): deletes `TextEncoder` and `TextDecoder` from `globalThis` before `lockdown()`, confirms lockdown succeeds and compartments observe the absence. This is the XS-style degradation path, exercised on a Node host by removing the codecs first.
- `.changeset/hardened-text-codecs.md`: `ses: minor`, names the new affordance and the monkey-patch-must-happen-before-lockdown obligation.

## Regression evidence

Stashed `packages/ses/src/permits.js` and re-ran `text-codecs.test.js`:

> 7 tests failed
> TypeError { message: 'TextEncoder is not a constructor' }
> TypeError { message: 'TextDecoder is not a constructor' }
> TextDecoder constructor and prototype are frozen — Value is not `true`: false

Restored the change; suite returned to green (12/12 in the new file, 515/515 in the full `packages/ses` suite, with the two pre-existing known failures unrelated to this PR). The `text-codecs-missing.test.js` file is structural (it exercises that lockdown succeeds without the codecs, which the existing `sampleGlobals` already supports); it passes whether or not the permits change is present.

## Test count

14 new tests (12 + 2).

## Pre-PR checklist

- `npx corepack yarn ava` in `packages/ses`: 515 tests passed, 2 known failures (pre-existing, unrelated), 2 skipped.
- `npx corepack yarn lint` in `packages/ses`: clean except for two pre-existing TS2300 errors in `types.d.ts` and `dist/types.d.cts` (`Duplicate identifier 'Compartment'`) which reproduce on a clean checkout without my changes.
- `npx corepack yarn format` at the monorepo root: no files modified by Prettier.
- No `yarn.lock` change (no new deps).
- Duplicate-search: `gh pr list --search "TextEncoder"` and `--search "hardened-text-codecs"` returned no other PR.

## Changeset

`.changeset/hardened-text-codecs.md` — `ses: minor`.

## CI status

PR opened with CI in `pending`. The boatman / liaison / general-contractor will observe convergence on the next pass.

## Out of scope

Phase 3 (downstream `Buffer.from` / `.toString('utf...')` audit) is informational per the dispatch prompt; surfaced as the *Out of scope* paragraph in the PR body.

## Self-improvement

Nothing this time. The library-lookup writeback procedure already pointed at `permits-buckets.md` and the three `htcs/*` section files, which named the universal-bucket placement decision and the test-template the design re-used. The skill's index entries were sufficient; no on-the-fly index improvement was warranted.
