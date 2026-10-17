---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: weaver
delegation: minion-town-pr-screening
# Weave kriscendobot/minion.town#197 onto current main
PR: https://github.com/kriscendobot/minion.town/pull/197 (head feat/clip-live-frame @ f55f6a2, base main).
The screened delegated conductor (screen-minion-town-pr197-f55f6a2-conduct-r2) was refused by safe-rebase:
non-deterministic content conflict in designs/clip-shell-framework.md rebasing onto main 3a2c1200d5f.
Rebase the head onto current main, resolving the design-doc conflict (keep both sides' intent), run tests,
and force-push the head. The proxy re-screens the new head and posts a fresh conductor; do not merge.
