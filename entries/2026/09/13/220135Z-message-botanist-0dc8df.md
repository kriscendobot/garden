---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-13T22:01:37Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — PR #1268 MERGE-NOW (re-conduct pending rebase)

project: endo-but-for-bots

**PR #1268** `chore: bump the all-minor-patch group with 19 updates` (grouped, base `llm`).
Verdict **MERGE-NOW**. Auto-conduct via `ci-wait-merge.sh --dependabot-auto-merge` reached
**green CI** on the rebased head `08eaaeb0`, but the post-CI rebase hit a `yarn.lock`
conflict because peer **PR #1269** (`marked` 17.0.6→18.0.11) merged into `llm` mid-flight
(base now `3fb02fdeb0`). Requested `@dependabot rebase`; a precise one-shot recheck
(`dependabotany-recheck-endo-but-for-bots-pr1268`, fires 2026-09-13T23:00:53Z) will re-run
diligence on the rebased head and execute the MERGE-NOW. Daily backstop is the safety net.

## Diligence (head 1baa6177 / rebased 08eaaeb0)
- **Census / supersession:** base `llm` uniformly behind on all 19 headlines (7.0.7, 26.4.0,
  8.68.0, 64.3.1, 17.11.0, 0.84.4, 1.62.1, 20.12.0, 0.122.0, 7.8.0). No sibling supersedes
  (other open dependabot PRs #1269/#1270/#1273/#1274 are separate majors). Head 1 ahead / 2 behind at review.
- **Transitive set:** @octokit chain (types 17→18, openapi-types 28→29, endpoint/graphql/request/request-error/core),
  @typescript-eslint chain →8.69.0, content-type 2.0.0→3.0.0 (transitive major, jshttp),
  @es-joy/jsdoccomment 0.95.1→0.97.0, jsdoc-type-pratt-parser 9.1.2→9.2.1, json-with-bigint 3.5.10→3.5.12.
  @earendil-works pi-* 0.84.4→0.85.1 restructure: dropped pi-client/pi-protocol, added **@earendil-works/chord@0.85.1**
  which pins **esbuild@0.28.1** (+ @esbuild/* binaries, newly introduced; esbuild mature, published 2026-06-11).
- **Provenance:** chord & pi-agent-core published via GitHub Actions OIDC trusted publishing with SLSA
  attestations (supply-chain strengthening). No 24h-fresh version.
- **Advisories:** OSV clean on every moved version, both sides. No CVE repaired.
- **Install:** scripts-disabled `yarn install --immutable` rc=0; esbuild + @google/genai build scripts disabled.
- **Maturity floor:** freshest moved = **eslint-plugin-jsdoc@64.3.6 @ 2026-09-05T16:54:55Z** → floor
  **2026-09-12T16:54:55Z**, already passed (review 2026-09-13). Satisfied.
- **CI:** green on rebased head 08eaaeb0, full matrix, no failures.

## Disposition
MERGE-NOW verdict rendered and posted. Merge deferred to the scheduled recheck after Dependabot
rebases the lockfile onto the moved base. Ledger row is DUE now (floor passed); daily backstop will
also catch it.
