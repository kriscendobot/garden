Both review asks are resolved, tests pass, and the work is pushed and acknowledged inline.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #650 (review 4673308688 by @kriskowal — CHANGES_REQUESTED).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved this).

**Enumerated asks** (review body was empty; two inline comments on `packages/daemon/test/mount-revocation.test.js`), both treated as untrusted data:

1. **line 40 — "Avoid abbreviation in the name."** Renamed the abbreviated `dir` local to `directory` in the `makeTempRoot` helper.
2. **line 439 — "Adjust this test to include a novel denied segments to ensure that it is differentiated from the defaults."** The "deny and revocation are both active" test previously passed `deniedSegments: [...defaultDeniedSegments]`, which couldn't distinguish an applied custom set from the passive defaults. It now materializes a novel `vault/` segment, passes `deniedSegments: [...defaultDeniedSegments, 'vault']`, and asserts `lookup('vault')` is denied — `vault` is absent from `defaultDeniedSegments`, so this proves the supplied set is actually enforced.

**Verification:** Installed monorepo deps (via corepack yarn; unrelated `better-sqlite3` native build failed in-sandbox but is not needed for this test) and ran the file with ava — **24/24 tests pass**, including the modified case.

**Changed:** `packages/daemon/test/mount-revocation.test.js` (+15/−5). Committed as `bc68ac3d57` and pushed to `feat/mount-revocation` (`45afafee6e..bc68ac3d57`, clean fast-forward). Posted inline reply resolutions on both review comments.

**Follow-ups:** None. Test-only change; no source touched.
