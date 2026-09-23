---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-16T20:38:40Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #1005 EMBARGO-2026-08-21

project: endo-but-for-bots

Grouped `all-minor-patch` bump (44 headline updates + transitive movement, 145
moved lockfile resolutions), base `llm`, head `51e8bd8c5e621622c6be309d33dba55f315ce068`
(fresh: ahead 1 / behind 2). Reviewed 2026-08-16T~20:30Z.

**Verdict: EMBARGO-2026-08-21.**

- **Maturity floor:** `2026-08-21T10:09:28Z` = `@earendil-works/pi-tui@0.84.2`
  (published `2026-08-14T10:09:28.402Z`, ~58h old at review) + 7 days. The floor
  comes from a **transitive**, not the headline: all headline versions are already
  >7d old (freshest headline `esbuild@0.28.2`, ~8d); the group pulled several
  `@earendil-works/pi-*` to `0.84.2`, fresher than the `0.84.1` headline table.
  Fresh `pi-*` releases publish via npm trusted-publishing (GitHub Actions OIDC) +
  SLSA `dist` attestations — a strengthening signal, not a maturity risk. No
  24h-fresh or newly-introduced package.
- **Advisories closed (directional, both sides):** the bump closes 4 advisories on
  the outgoing set, incoming versions OSV-clean: `ws` 8.20.0→8.21.3 clears
  GHSA-96hv-2xvq-fx4p (memory-exhaustion DoS, A:H) + GHSA-58qx-3vcg-4xpx
  (uninitialized-memory disclosure); `esbuild` 0.28.0→0.28.2 clears
  GHSA-g7r4-m6w7-qqqr (dev-server file read, low); `js-yaml` 5.2.1→5.2.3 clears
  GHSA-pm4m-ph32-ghv5 (parsing DoS). `ws` is consumed by daemon/ocapn/relay-server/
  ocapn-noise. All are **already present on base**, so the embargo defers a
  moderate DoS/info-disclosure fix by 5 days without new exposure (no RCE class).
- **CI red (real):** `lint` (`lint:types` in packages/eslint-plugin) fails; green
  on base. Root cause: a `@typescript-eslint` version skew the group left in the
  lockfile — `rule-tester@8.66.0` nests `utils`/`scope-manager@8.66.0` while other
  transitives float to `8.67.0`, so `createRule`'s `RuleModuleWithName` is
  nominally incompatible with the other copy's `RuleModule`/`RuleContext`. The fix
  (consolidate `@typescript-eslint/*` to one version, or add a resolutions
  override) is a manifest/version decision (step-6 edge c), deliberately NOT landed
  here; left for the recheck, likely against a rebased group.

**Scheduling:** precise one-shot `dependabotany-recheck-endo-but-for-bots-pr1005`
placed at **2026-08-21T11:15:00Z** (floor ceil-to-hour + 15m). Daily backstop
`dependabotany-recheck-endo-but-for-bots` ensured.
