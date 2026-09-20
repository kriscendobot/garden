---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-20T20:04:31Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1315

# Dependabotany ledger: endojs/endo-but-for-bots — PR 1315 zizmorcore/zizmor-action 0.6.3 → 0.6.4 MERGED

## Verdict: MERGE-NOW (executed)

- Base `llm` had the single action call site on v0.6.3; the v0.6.4 target was live, not superseded, and the head was one ahead / zero behind.
- GitHub Actions pin-only change: no consumer lockfile or transitive package set. Both lightweight tags resolved in the tag-to-commit direction on 2026-09-20: v0.6.3 → `70fb788f84895a7701f5643d103d587e460b5c99`; v0.6.4 → `cc914d7f3750a2d13d75c7f184a1060aa0e9d482`.
- v0.6.4 published `2026-09-09T05:40:54Z`; maturity floor `2026-09-16T05:40:54Z` was satisfied.
- GitHub Actions advisories and OSV were empty on both sides. Source read found only the digest-pinned zizmor 1.30.0 → 1.30.1 sync (two bug fixes) plus a nested CodeQL upload action repin, with no new execution surface or compromise indicator.
- Isolated project provisioning used the scripts-disabled botanist cache (`WARM-CACHE built`, 163 trees).
- Exact head `ec35033a8451ae740c8a11f4c89f15b544341728` reached terminal green: 30 check runs, zero failed/pending; all six workflow runs succeeded.
- Conducted through `ci-wait-merge.sh --dependabot-auto-merge`; merged into `llm` at `2026-09-20T20:03:25Z` as `77fe0c603e405b02d3787140f6d1fd021fe05810`.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1315#issuecomment-5752315421

Terminal: no embargo row or recheck schedule is needed.
