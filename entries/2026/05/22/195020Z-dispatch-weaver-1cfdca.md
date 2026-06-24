---
event: dispatch
role: weaver
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/weaver--1cfdca
repo: endojs/endo-but-for-bots
pr: 64
branch: design/issue-2632-harden-exports-pattern-makers
trigger: kriskowal directive 2026-05-22T19:48:53Z on PR #64 — "Please rebase and resolve conflicts. Retcon if necessary."
---

# Weaver dispatch: rebase #64 + retcon if needed

PR #64 (`feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)`) is 86 behind, 3 ahead of bot-master. Upstream master has moved from `6804b7dc8` to `455ce4749` (86 commits). Bot-master is stale.

Procedure:
1. Sync bot-master to upstream `endo-upstream/master` (`455ce4749`) via force-with-lease.
2. Rebase the PR branch onto the freshly-synced master.
3. Resolve conflicts per skills/conflict-resolution/SKILL.md (no `--ours` / `--theirs`).
4. If the post-rebase commit shape needs cleanup, retcon per skills/retcon/SKILL.md (net-diff invariant verified three ways).
5. Push the rebased branch back to origin; reply on the PR with the new head SHA and a short summary.
