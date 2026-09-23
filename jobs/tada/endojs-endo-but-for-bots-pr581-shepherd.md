Inbox empty. The shepherd job is complete.

## Shepherd report — endojs/endo-but-for-bots PR #581

**Failure diagnosed.** Both red checks were the `lint` job (in the `CI` and `CI (docs-only)` workflows), failing at the `lint:prettier` step (`prettier --check`). The `.js`-suffixed export-key migration in this PR pushed five multi-import lines past prettier's print width, so `prettier --check` flagged 5 files. Because `lint` short-circuits (`prettier && eslint && sh`), that was the sole cause. Class C — tractable, in-scope, no impasse.

**Fix applied.** Re-fetched the live PR head (`d6ecd0cf`, which was ahead of my checkout), installed deps, and confirmed the repo's pinned prettier (3.8.3, matching `yarn.lock`). Ran `prettier --write` on the five files:
- `packages/daemon/index.js`
- `packages/eslint-plugin/lib/rules/jsdoc-import-extensions.js`
- `packages/eslint-plugin/test/jsdoc-import-extensions.test.js`
- `packages/lal/tool-dispatch.js`
- `packages/spaces-util/src/token-autocomplete.js`

All changes are pure import-statement line-wrapping — no logic touched. Verified the full `prettier --check .github packages` passes, and ran eslint on the five files to check the second (masked) lint stage: **0 errors** (only pre-existing warnings, which don't fail `eslint .`).

**Pushed** one atomic commit `3273ea9b8` to `feat/eslint-plugin-jsdoc-import-extensions` via rebase-CAS.

**CI result on new head `3273ea9b8`:** both `lint` checks now **SUCCESS**; **zero failures** in the rollup (10 green, rest of the heavy test matrix propagating — all were green on the prior head and are unaffected by whitespace-only changes). The red check that minted this job is resolved.

**No summary comment posted** — this job was auto-dispatched with no maintainer authorization to comment, and the PR is a DRAFT (not in a review queue). Green-run URL: https://github.com/endojs/endo-but-for-bots/actions/runs/28490938427 (superseded by the re-run on the new head).

**Follow-ups:** none. `next: none` — CI green on the addressed failure.
