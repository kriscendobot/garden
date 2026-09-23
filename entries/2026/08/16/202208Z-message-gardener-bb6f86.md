---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-16T20:22:09Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #1009 MERGE-NOW

project: endo-but-for-bots

**PR #1009** `chore: bump npm-packlist from 10.0.4 to 11.3.0` (root devDependency).
Verdict **MERGE-NOW**, conducted onto `llm` via the conductor spine
(`ci-wait-merge.sh --dependabot-auto-merge`) after the head was rebased onto live
base (`c1ccf4a7ff2` → `0288e34d425`).

## Diligence
- **Census / supersession:** base `llm` at `npm-packlist@10.0.4`; PR moves forward
  to `11.3.0` (not a no-op/partial-revert). No sibling Dependabot PR on this
  package (watcher preflight).
- **Transitive set:** `npm-packlist` 10.0.4→11.3.0 (published 2026-06-22); new
  `ignore-walk@9.0.0` (2026-05-08) and `proc-log@7.0.0` (2026-05-08), replacing the
  old `ignore-walk@^8`/`proc-log@^6`; `glob@13.0.6` already resolved (no move). All
  official `@npmcli` packages, all published via GitHub Actions npm-OIDC trusted
  publishing with SLSA provenance attestations (supply-chain strengthening).
- **Maturity floor:** freshest moved = headline `npm-packlist@11.3.0` @
  2026-06-22T16:11:01Z → floor **2026-06-29**. Well past at review time
  (2026-08-16). No embargo, no one-shot recheck needed (terminal verdict).
- **Advisories:** OSV clean on every moved version, both sides of the bump.
- **Source read:** pure-JS packaging/logging tooling; no network, no
  child_process/exec/spawn, no new fs writes, no telemetry.
- **Consuming-code impact:** consumed only by `scripts/check-package-uniformity.mjs`
  (CI lint on `.node-version` = `lts/*` → Node 24, satisfying npm-packlist@11's
  `^22.22.2 || ^24.15.0 || >=26.0.0`). The 11.0.0 breaking changes (files[]
  root-anchored globs, slashless-negation scoping, `npm-shrinkwrap.json`/`bun.lock`
  default exclusion) affect no repo package: no `files[]` uses `!` negations, none
  list shrinkwrap/bun.lock, and the two `.npmignore` packages (`bundle-source`,
  `captp`) exclude only `demo`/`scripts`/`test`, never re-included by their
  allowlist. No migration required.

## Disposition
MERGE-NOW executed. Row is terminal — remove on the next sweep; no ledger recheck
wiring (that is only for EMBARGO). Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/1009#issuecomment-5309480466
