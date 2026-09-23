---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T20:45:11Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1053

project: endojs-endo-but-for-bots

**Verdict:** MERGE-NOW (executed — MERGED 2026-08-23T20:44:33Z, merge commit `185510f9d1bcfdd65be46b51ba01eff6574a3123`).

**Upgrade:** `@rollup/plugin-commonjs` 28.0.6 → 29.0.3 (npm, **major**), a devDependency of `packages/benchmark`. Base `llm` was uniformly at 28.0.6 (`^28.0.2`); head fresh (ahead=1 behind=0). Not superseded — no sibling PR, base behind.

- **Transitive set:** only the headline moved; every transitive range unchanged (`@rollup/pluginutils ^5.0.1`, `commondir`, `estree-walker`, `fdir`, `is-reference 1.2.1`, `magic-string`, `picomatch`). No new/24h-fresh transitive; no license change; diff touches only `package.json` + `yarn.lock`.
- **Install:** scripts-disabled (`YARN_ENABLE_SCRIPTS=false`, WARM-CACHE scripts-disabled); installed 29.0.3 verified; package declares no install lifecycle scripts.
- **Source read:** no child_process / network / eval / telemetry (only benign `.exec()` regex + a rollupjs.org doc URL + an issue-link comment).
- **Advisories:** none on either 28.0.6 or 29.0.3 — OSV empty both sides, GHSA feed lists none for the package, `yarn npm audit` surfaces no advisory touching it (axios/brace-expansion/lerna/sigstore rows are pre-existing repo-wide, on both base and head, untouched by this bump).
- **Major-bump migration:** none required. v29.0.0's break (`requireNodeBuiltins`/revert #1909) governs plugin behavior, but `packages/benchmark/rollup.config.js` uses only `nodeResolve()` — plugin-commonjs is a vestigial, unused devDependency (zero source usage repo-wide). No consuming-code impact.
- **Maturity floor:** freshest moved version 29.0.3 published 2026-05-29 → floor 2026-06-05, well past (today 2026-08-23).
- **Releaser change decoded:** shellscape (human, no attestation) → GitHub Actions trusted publishing with SLSA provenance attestation on 29.0.3 — a supply-chain *strengthening*, not a signal against.
- **CI:** conductor spine rebased head onto live `llm` (a81d485 → 32c91bff); 25/25 green on 32c91bff, 0 failures; no migration push needed. Merged via `--dependabot-auto-merge` (author=dependabot[bot], bot-owned scope, approval bypassed).

Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1053#issuecomment-5388200006

No embargo, no recheck wiring required (terminal MERGE-NOW).
