---
ts: 2026-05-15T03:34:00Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--ea1194/project
refs:
  - entries/2026/05/15/031826Z-result-cleaner-06e7fc.md
  - entries/2026/05/15/030128Z-result-investigator-9a5955.md
---

# Result: fix Chromium `browser-tests` red on PR #259

## Branch / head

`feat/hardened-text-codecs-shim`, new head `b2a3657fc` (was `6e5b50d98` from the cleaner; fixer advanced by one commit).

PR #259 still in draft, awaiting judge.

## Fix description

The cleaner's report (`031826Z-result-cleaner-06e7fc`) pinpointed the failure: `cauterizeProperty` in `packages/ses/src/cauterize-property.js` performs `delete obj[prop]` for any own property of an intrinsic that lacks a permit entry. Chromium V8 exposes its native `TextEncoder` / `TextDecoder` constructors as `function` style objects that carry non-configurable `arguments` (and `caller`) own properties; `delete` throws `TypeError: Cannot delete property 'arguments' of function TextEncoder() { [native code] }`, aborting lockdown in the browser. Node's class-style implementations do not expose these own properties, which is why the existing test suite passes on Node and the bug only manifested in Chromium browser-tests after the PR added `TextEncoder` / `TextDecoder` to the permits table.

The fix extends `cauterizeProperty`'s tolerate-undeletable escape hatch (which already handles the `prototype` case via reassignment-to-undefined) with a new branch for non-configurable `arguments` and `caller` on functions:

```js
if (typeof obj === 'function' && (prop === 'arguments' || prop === 'caller')) {
  const desc = getOwnPropertyDescriptor(obj, prop);
  if (desc && desc.configurable === false) {
    warn(`Tolerating undeletable ${subPath} on native function`);
    return;
  }
}
```

The detection runs before the `delete` attempt (cheaper than catching the throw) and routes through the same `warn`-and-skip pattern the existing `prototype` escape hatch uses on its fallback path. The property remains in place; in strict mode any subsequent read of `.arguments` or `.caller` still throws, so the property's continued presence is not a post-lockdown integrity hazard. The fix is documented inline with a comment naming the Chromium-native-function case, and the JSDoc on `cauterizeProperty` was extended with a paragraph mirroring the existing `prototype`-case paragraph.

The `.changeset/hardened-text-codecs.md` entry was updated to disclose the additional `cauterizeProperty` behavior change (the existing user-visible surface paragraph already described the permits feature).

## Commit

`b2a3657fc fix(ses): tolerate undeletable arguments/caller on native function intrinsics`

Files touched:
- `packages/ses/src/cauterize-property.js` (+27, -1): import `getOwnPropertyDescriptor`, add the detection branch, extend the JSDoc.
- `.changeset/hardened-text-codecs.md` (+8): disclose the `cauterizeProperty` behavior change in the existing changeset.

No `yarn.lock` change. No test additions (the existing browser-tests Playwright canary is the regression assertion; it failed before this commit and passes after).

## Pre-PR checklist

- `npx corepack yarn ava` in `packages/ses` after the edit: **519 tests passed**, same 2 known failures (pre-existing, unrelated), 2 skipped. Identical to the cleaner's pre-fix baseline.
- `npx corepack yarn lint` in `packages/ses`: clean except the two pre-existing TS2300 errors in `types.d.ts` and `dist/types.d.cts` (`Duplicate identifier 'Compartment'`).
- `npx corepack yarn format --check` at the monorepo root: passes after one prettier reformat of the new edit (the conditional was rewrapped from one line to three).

## CI status on `b2a3657fc`

Initial convergence (run 25898459265 + 25898459267):

- **`browser-tests` (Chromium): PASS in 2m17s.** This is the load-bearing signal; the failure cited in the dispatch is gone.
- All other previously-pending matrices: 25 pass, 1 fail.
- One failure: `test (22.x, macos-15)` — `endo › lifecycle` in `packages/daemon`, rejected with `Error: Unexpected dangling message at offset 4 of <unknown>` from `decodeErrorFromCapData`. This is in the captp/marshal/daemon transport layer, not SES, and not in any of the files this PR or this fix touches.

The failure pattern (captp/marshal error in a daemon lifecycle test, single matrix cell, no platform-wide reproduction) matches cluster A in the investigator's 24-48 h macOS-15 survey (`030128Z-result-investigator-9a5955`), which identified macOS-15 captp/daemon tests as a known flake with ~15 percent rate on that cell. The previous commit `6e5b50d98` ran the same job successfully on the same branch ~33 min earlier (run 25897827272), so this is not a regression introduced by this fix.

Rerun `gh run rerun 25898459265 --failed` triggered; the rerun is in flight as of the result write. If the rerun also fails, the next step is for the judge to surface the flake to the maintainer (or for a shepherd to be dispatched if the failure is reproducible); the fix itself is complete and verified.

## Out of scope

- The `test (22.x, macos-15)` flake (separate issue per `030128Z-result-investigator-9a5955`'s recommendation, tracked by repo issue #260).
- Whether `cauterizeProperty` should also handle `arguments`/`caller` on non-native function intrinsics (it can if they appear, the existing detection covers them; no test in scope exercises that path).

## Self-improvement

Nothing this time. The cleaner's report pinpointed the root cause and even sketched the fix shape ("extend `cauterizeProperty`'s tolerate-undeletable escape hatch"), so the fixer's work was mechanical implementation against an already-diagnosed bug. The `regression-evidence` skill's natural fit here was negative (Node-side tests cannot exercise the Chromium-specific bug because the bug is host-specific), and the load-bearing assertion was the existing Playwright canary, which is the right pattern: the regression evidence for a host-specific bug is a host-specific test, and the SES suite was already correctly scoped to its environment. The `cauterize-property` file's escape-hatch pattern was a clean and well-commented landing zone for the new branch; no new lesson worth indexing.
