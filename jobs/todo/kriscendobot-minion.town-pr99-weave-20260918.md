---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave (rebase + resolve) kriscendobot/minion.town PR #99 — "feat(deploy): provision pinned Claude harness" (arc item 1, https://github.com/kriscendobot/garden/issues/89).

The PR is APPROVED by kriskowal (2026-09-18T00:35Z) but a merge attempt stalled needs-weave: after the conductor unfroze the base from the frozen snapshot main-b83741a to live main, rebasing head 47821c46 onto live main produced a non-lockfile code conflict in .github/workflows/test.yml.

Task: rebase the PR head onto current origin/main and resolve that conflict, preserving the PR's intent (pinned Claude harness provisioning). Push the rebased head. Do NOT merge — after the weave the maintainer must re-approve the rewritten head before a merge job can land it. Leave the PR un-drafted.

Scope: kriscendobot/minion.town only; no identity switch, no ferry.
