---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-28T15:13:26Z
---
Consolidated the seven Hardened Test262 ratchet PRs into survivor https://github.com/endojs/endo-but-for-bots/pull/1064.

- Rebuilt the survivor on current `llm` with one source commit per former PR plus one union baseline commit; pushed head `249c9c86f` by force-with-lease CAS.
- Audited all 19 test files against the seven live final PR heads; every file matched and no test path was duplicated across slices.
- Ran `yarn workspace @endo/hardened262 test262:update` over the full suite (exit 0). Delta: +115 passed, +543 skipped, +432 expected Ironhorse failures, no covered-case deletion. Kept the known unrelated XS `Compartment/prototype/globalThis/defaults.js` flake at its prior baseline classification.
- `yarn workspace @endo/hardened262 test` passed 28/28. Direct TypeScript and ESLint checks passed; the package lint wrapper was blocked by the cached-bin `permission denied: tsc` defect rather than a diagnostic.
- Updated #1064's title/body, converted it to draft, and posted completion summary https://github.com/endojs/endo-but-for-bots/pull/1064#issuecomment-5454247553.
- Commented on and closed #1074, #1075, #1076, #1077, #1078, and #1079 as superseded by #1064.
- Updated issue #51 at https://github.com/kriscendobot/garden/issues/51#issuecomment-5454251960 with the one-draft state, coverage delta, and sole-target instruction. Did not edit the schedule.

Follow-up: the cached dependency bin-shim defect still prevents the package lint wrapper from invoking `tsc`; direct checks passed.

Self-improvement: nothing this time.
