---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-16T20:08:57Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1001 MERGE-NOW (merged)

Botanist review of Dependabot PR #1001, `actions/checkout` 6.0.2 → 7.0.1
(github-actions ecosystem), auto-posted by the dependabot-PR watcher.

**Verdict: MERGE-NOW — executed.** Conducted onto base `llm` via the conductor
spine `ci-wait-merge.sh --dependabot-auto-merge`; `state=MERGED`,
`mergedAt=2026-08-16T20:07:37Z`, merge commit
`c3150b666373dfac814fb6ea6124eb84742cb745`. Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/1001#issuecomment-5309431514

## Gate legs (all satisfied)

- **Base census:** base `llm` uniformly on v6.0.2 (`de0fac2e…`) at all 31
  `actions/checkout@` call sites across 13 workflow files — genuine live upgrade,
  not a no-op/partial revert. No sibling Dependabot PR moves this package.
- **Pin verification (tag→commit, 2026-08-16):** incoming v7.0.1 →
  `3d3c42e5aac5ba805825da76410c181273ba90b1` MATCH; outgoing v6.0.2 →
  `de0fac2e4500dabe0009e67214ff5f5447ce83dd` MATCH (both lightweight tags,
  owner `actions/checkout`). Repo's `check-action-pins` check green.
- **Major v6→v7 break assessed:** the sole behavioral break (block fork-PR
  checkout under `pull_request_target`/`workflow_run`, actions/checkout#2454) is
  inert — the repo uses neither trigger. No consuming-code migration needed or made.
- **Advisories:** none on v6.0.2 or v7.0.1 (GH advisory feed + OSV, both sides).
- **Maturity:** floor = freshest moved version v7.0.1 (published
  2026-07-20T15:10:05Z) + 7d = 2026-07-27, well past as of 2026-08-16.
- **CI:** 27 checks, 0 failures, all green at head
  `8c3022059b47698ab2820eb0684d3a74be498de1`. Native green — no migration commit.

Terminal row: no embargo, no one-shot, no ledger residue.

## Spine fix landed alongside

The first conduct attempt was denied because newer `gh` renders the app author as
`app/dependabot` while `ci-wait-merge.sh`'s `--dependabot-auto-merge` gate compared
against `dependabot[bot]`, denying the approval bypass for EVERY dependabot PR.
Fixed on main2 (`c31b2aaf4a`): `canonical_bot_login()` strips a leading `app/` and
trailing `[bot]` on both sides before comparing. The re-run bypassed and merged.

Self-improvement: fixed the gh `app/`-login mismatch that had been silently
defeating dependabot auto-conduct (`scripts/jobs/gardening/ci-wait-merge.sh`).
