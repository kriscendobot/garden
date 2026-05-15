---
ts: 2026-05-15T04:20:00Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--a232cc/project
---

# Result: hardened-url-shim Phases 1 + 2 → draft PR #263

## Deliverable

PR endojs/endo-but-for-bots#263 (draft), branch `feat/hardened-url-shim`, base `master`, head `beb0d4e6a`.

Implements Phases 1 (permits + sampling) and 2 (tests + changeset) of `designs/hardened-url-shim.md` (on the `llm` roadmap branch). Mirrors the just-shipped `hardened-text-codecs-shim` (PR #259) for the URL family.

## Implementation choice: universal-cauterize over Date-style split

The design proposes a `Date`-style split that keeps `URL.createObjectURL` and `URL.revokeObjectURL` on the start compartment via `initialGlobalPropertyNames` and removes them only on shared compartments via `sharedGlobalPropertyNames`. The dispatch task explicitly directed the simpler universal path: add `URL` and `URLSearchParams` to `universalPropertyNames` with the dangerous static methods listed as `false` in the permits row so they are cauterized off the constructor everywhere. The Date-style split is documented as an *Out of scope* follow-up in the PR body.

## Affected packages

- `ses` (only):
  - `packages/ses/src/permits.js`: adds `URL` and `URLSearchParams` to `universalPropertyNames`; adds `URL` / `%URLPrototype%` / `URLSearchParams` / `%URLSearchParamsPrototype%` / `%URLSearchParamsIteratorPrototype%` permit subtrees near the WHATWG section (after `Proxy`, before Annex B). `createObjectURL` and `revokeObjectURL` listed as `false` so the whitelist pass cauterizes them with known-removal disposition (no warning).
  - `packages/ses/src/get-anonymous-intrinsics.js`: samples the URL search params iterator prototype via `Object.getPrototypeOf(new globalThis.URLSearchParams().entries())` and seeds `%URLSearchParamsIteratorPrototype%` into the anonymous-intrinsics graph. Guarded on `typeof globalThis.URLSearchParams === 'function'` so XS hosts without `URLSearchParams` skip the sample.
  - `packages/ses/test/url.test.js`: 17 tests.
  - `packages/ses/test/url-missing.test.js`: 2 tests.
  - `.changeset/hardened-url-shim.md`: `ses: minor`, names the new affordance, the cauterized static methods, the iterator-prototype seeding, and the monkey-patch-must-happen-before-lockdown obligation.

## Permits modeled

| Property | Disposition | Notes |
|---|---|---|
| `URL.prototype` | ✓ | bound to `%URLPrototype%` |
| `URL.parse` | ✓ | static parse helper; pure |
| `URL.canParse` | ✓ | static predicate; pure |
| `URL.createObjectURL` | ✗ (false) | ambient blob-registry authority; cauterized everywhere |
| `URL.revokeObjectURL` | ✗ (false) | companion; cauterized everywhere |
| `%URLPrototype%.*` | ✓ | every named accessor (`href`, `origin`, `protocol`, `username`, `password`, `host`, `hostname`, `port`, `pathname`, `search`, `searchParams`, `hash`), `toString`, `toJSON`, `@@toStringTag` |
| `URLSearchParams.prototype` | ✓ | bound to `%URLSearchParamsPrototype%` |
| `%URLSearchParamsPrototype%.*` | ✓ | `size`, `append`, `delete`, `get`, `getAll`, `has`, `set`, `sort`, `entries`, `forEach`, `keys`, `values`, `toString`, `@@iterator`, `@@toStringTag` |
| `%URLSearchParamsIteratorPrototype%.next` | ✓ | sampled into anonymous intrinsics; `[[Proto]]` is `%IteratorPrototype%` |
| `%URLSearchParamsIteratorPrototype%.@@toStringTag` | ✓ | `'URLSearchParams Iterator'` per the host |

## Regression evidence

Stashed both source-file changes and re-ran `url.test.js`:

> 3 tests failed (frozen-constructor): URL/URLSearchParams/iterator prototype `Value is not \`true\`: false`
> 3 tests failed (cauterize + iterator): `createObjectURL is cauterized` — `Value is not \`false\`: true`; iterator prototype `Value is not \`true\`: false`; iterator-prototype `.next` assignment did not throw.

Without the permits + sampling change: the URL constructor is not frozen, the URLSearchParams prototype is not frozen, the iterator prototype is unreachable to the whitelist pass and stays writable, and `createObjectURL` remains on the constructor. Restored the change; suite returned to green (19/19 in the new files, 520/520 in the full `packages/ses` suite, with the two pre-existing known failures unrelated to this PR). The `url-missing.test.js` file is structural (it exercises that lockdown succeeds without `URL`); it passes whether or not the permits change is present.

## Test count

19 new tests (17 + 2).

## Pre-PR checklist

- `npx corepack yarn ava` in `packages/ses`: 520 tests passed, 2 known failures (pre-existing, unrelated), 2 skipped.
- `npx corepack yarn lint` in `packages/ses`: clean except for two pre-existing TS2300 errors in `types.d.ts` and `dist/types.d.cts` (`Duplicate identifier 'Compartment'`) which reproduce on a clean checkout without my changes.
- `npx corepack yarn format` at the monorepo root: no files modified by Prettier.
- No `yarn.lock` change (no new deps).
- Duplicate-search: `gh pr list --search "hardened-url"` returned no other open implementation PR (only the merged design PR #84).

## Changeset

`.changeset/hardened-url-shim.md` — `ses: minor`.

## CI status

PR opened with CI in `queued` / `pending`. The general-contractor / liaison will observe convergence on the next pass.

## Out of scope

The `Date`-style split (powered `URL` on `initialGlobalPropertyNames`, tamed `%SharedURL%` on `sharedGlobalPropertyNames`, shared prototype identity for cross-compartment `instanceof`) is documented as the *Out of scope* paragraph in the PR body. Re-introducing the split is a follow-up if the universal removal proves too aggressive for some embedding.

A polyfill of `URL` for hosts that lack one (XS) is also out of scope; this PR only tames a host-provided `URL`.

Phase 3 (downstream `URL.createObjectURL` / `URL.revokeObjectURL` grep audit) is informational per the design; surfaced as a follow-up rather than blocking the initial PR.

## Self-improvement

Nothing this time. The text-codecs PR #259 was a clear sibling template (same dispatch shape, same file layout, same regression-evidence ritual), and the `cauterize-property.js` escape hatch for Chromium V8's undeletable `arguments` / `caller` on native function intrinsics was already in place from #259 and required no further extension here. The library-lookup writeback procedure was not triggered; the permits/intrinsics terms were already well-indexed by the text-codecs precursor work.
