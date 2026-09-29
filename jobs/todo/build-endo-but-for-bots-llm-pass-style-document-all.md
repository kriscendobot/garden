---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Port the pass-style `document.all` fix onto llm (endojs/endo-but-for-bots)

Found in gap analysis by `endojs-endo-but-for-bots-sync-llm-master-20260929`. The fork's `master` branch holds `eecc68394`, "fix(pass-style): treat document.all-like values as objects (#3156) (#69)", which merged as endojs/endo-but-for-bots#69 on 2026-06 against `master`. It fixes the still-OPEN upstream issue https://github.com/endojs/endo/issues/3156. Neither `llm` nor upstream `endojs/endo` `master` has the fix: `llm` has no `document.all` handling in `packages/pass-style/src`.

Task: cherry-pick or re-apply `eecc68394`'s `passStyleOf.js` and `passStyle-helpers.js` change, its tests and its changeset onto current `llm`. Adapt it to llm's pass-style, which has since changed byteArray and other code. Leave out the 400 KB `document-all-result.png` artifact unless the tests need it. Open a DRAFT PR against a frozen `llm-<sha>` base per `skills/pr-creation-flow/SKILL.md`, and stop at draft.
