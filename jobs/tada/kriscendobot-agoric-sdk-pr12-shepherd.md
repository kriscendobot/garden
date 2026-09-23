Inbox is empty; the PR head is now `dc0d4cf964` (my pushed fixes). Work complete for what a shepherd can safely do.

---

## Completion report: shepherd on kriscendobot/agoric-sdk PR #12

**PR:** "Draft: Mirror #11297 — Upgrade XSnap Moddable 3.9.2 → 5.5.0" (XS 11.x → 16.7.1). 10 changed files, from-source xsnap build restored.

**Live CI triage (re-fetched, not the stale rollup).** Red checks fell into two classes:
- **Deterministic / in-scope (fixed by me).** `lint-primary` and `lint-rest`.
- **Engine-behavior adaptations / cascade noise (escalated).** `test-quick`, `test-swingset` (many shards were fail-fast *cancellation cascades*, not independent failures — annotations confirmed "canceled because … failed"), and `test-codegen`.

**Fixes I landed and pushed** (head is now `dc0d4cf964` on `xst/moddable-5.5.0-11297`):
1. `3bf385cf47` — `packages/xsnap/src/build.js`: added `node:` protocol prefixes to the four bare-specifier builtin imports the restored build.js reintroduced. Clears the 4 `n/prefer-node-protocol` errors that failed `lint-primary`.
2. `dc0d4cf964` — `tsconfig.quickcheck.json`: excluded vendored `packages/xsnap/moddable` and `xsnap-native` from `typecheck-quick`. Root cause: this PR restores the from-source build, which repopulates `moddable/`; the repo-wide quickcheck (`include: packages/**/*.*js`) then typechecked Moddable's own `tools/xsbug/*.js` debugger source and hit TS syntax errors. `tsconfig.build.json` (used by the `docs` steps) and `.prettierignore` already exclude these trees; I mirrored that. tsc `extends` does not merge `exclude` arrays, so it had to be repeated in the quickcheck config, not the base.

*Verification note:* both fixes are reasoned from the config and error logs; I did **not** run the full monorepo eslint/typecheck locally (requires a whole-repo install plus a populated `moddable/`). CI on the new head will confirm. The JSON edit was syntax-validated.

**Escalated → `next: fixer`** (posted job `kriscendobot-agoric-sdk-pr12-fixer` with a full inventory). These are hard-escalation-point impasses for a shepherd — they need a local xsnap-from-source build of XS 16.7.1 to regenerate values, and two carry **consensus-affecting design decisions**:
- `xsnap.test.js` "produce golden snapshot hashes" — the test's own text demands a "special accommodation for the new version, not just generating new golden hashes" (within-consensus snapshot format). **Design decision needed** — do not blindly regenerate.
- `xs-perf.test.js` "meter details" — "update METER_TYPE?" (meter accounting changed; METER_TYPE bump is consensus-affecting).
- `boot-lockdown.test.js` "console detail" + `inspect.test.js` "xsnap inspect" — output-format shifts; regenerate expected strings from a real build.
- `test-swingset` — several shards ran 43m+ (possible hang/perf regression under the new engine) plus one real failure; needs local reproduction.
- `test-codegen` — `packages/orchestration/src/fetched-chain-info.js` dirty after `yarn codegen`; **unrelated to XS** (chain-info codegen). Fixer's first step: rebase on latest master and re-run codegen.

**Follow-ups:** the fixer job carries all six items with a recommended order (rebase → build xsnap → regenerate → swingset), and flags items 1–2 for maintainer/liaison escalation if a consensus decision is required. PR stays draft.

**Self-improvement:** candidate shepherd field note — when a PR restores a *from-source* native build, it repopulates vendored source trees that a repo-wide typecheck (`quickcheck`) scans but the prebuilt path never populated, so divergent tsconfig exclusion lists (build.json vs quickcheck.json) surface as new tsc failures; worth a line in `roles/shepherd/AGENT.md` § Notes from the field. Routing to liaison is optional; leaving it here as it is fairly project-specific.
