---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T20:04:51Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1051 escalated (config migration)

Botanist review of Dependabot PR #1051, `changesets/action` **1.9.0 → 2.1.0**
(github-actions ecosystem), auto-posted by the dependabot-PR watcher. Base `llm`.

**Verdict: not MERGE-NOW — escalated to fixer for a v2 config migration.** Not a
maturity floor: this row names an **escalation** (per botanist step 6). PR stays
OPEN pending the repair.

## Diligence (all confirmed 2026-08-23)
- Pins verified tag→commit both sides (annotated tags dereffed): v2.1.0 →
  `198f833dd7d863100ea6e28967bc9a9fdefadb0a` (== PR pin); v1.9.0 →
  `a45c4d594aa4e2c509dc14a9f2b3b67ba3780d0d` (== base pin).
- Base census: single call site `.github/workflows/release.yml`, base uniformly
  on v1.9.0 — genuine live upgrade, no sibling PR moves it, not a no-op/revert.
- Advisories: actions feed `[]`, OSV `{}` — no CVE; maintenance/feature major.
- Maturity floor: v2.1.0 published 2026-08-13T10:59:03Z + 7d = **2026-08-20**
  (past). Maturity is NOT the blocker.

## Why escalated (not MERGE-NOW, not REJECT)
Major v1→v2 bump; Dependabot changed only the pin. `release.yml` still uses v1
config that v2 renamed/removed (verified vs action.yml/src/index.ts @ 198f833):
`publish`→`publish-script` (#681), `createGithubReleases`→`create-github-releases`
(#668), token no longer read from `GITHUB_TOKEN` env (#674 — would push as
`github.token` not `RELEASE_TOKEN`), push default git-CLI→GitHub-API (#692). The
token/push-mode part is a release-security design decision about this repo's own
infra, and `release.yml` runs on `push: master` only — NOT exercised by this PR's
CI — so green CI gives zero coverage. Escalation is in flight → not "cannot
absorb" (not a REJECT).

## Escalation wiring
- Orchestration `endojs-endo-but-for-bots-pr1051-v2migrate` (serial, halt-on-failure):
  child `endojs-endo-but-for-bots-pr1051-fixer` (land preserve-v1 migration on the
  head branch) → child `endojs-endo-but-for-bots-pr1051-conduct` (botanist
  re-review + MERGE-NOW conduct once migrated).
- Daily backstop `dependabotany-recheck-endo-but-for-bots` already exists (idempotent).
- Follow-up worth taking after merge: bump to v2.1.1 (2026-08-19, fixes typo in
  the v1→v2 renamed inputs; not a blocker here).

Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1051
