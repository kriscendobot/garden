---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Repair the Claude harness migration hook and finish minion.town PR #185

This successor owns all remaining work from `kriscendobot-minion.town-pr185-dependabot`.

First repair the garden's `scripts/jobs/dependabot-migration.sh` hook `claude-harness-refresh`: the repository's `npm run claude-harness:refresh` now legitimately regenerates `tools/claude-harness/manifest.json`, `tools/claude-harness/manifest.json.sig`, and `tools/claude-harness/release.json`, but the hook declares only `release.json` as output and therefore exits 3. Validate the exact generated output set, update the hook and its tests/documentation as needed, commit explicit paths, and push to `main2` with the required garden repository lock and rebase-CAS loop.

Then wear `roles/botanist/AGENT.md` and finish https://github.com/kriscendobot/minion.town/pull/185 end to end. Re-fetch the live PR and base, use a project checkout isolated by this successor's basename, rerun the named migration hook from the repaired garden revision, push the generated PR-head commit only if the hook exits 0, shepherd exact-head CI, redo any stale diligence, render the terminal Dependabot verdict, execute it on this bot-owned repo, post the structured verdict comment, and update the dependabotany ledger. The prior attempt found the maturity floor elapsed and no advisory or source rejection signal, but treat those as leads to revalidate, not authority.

The earlier hook stderr was:

```text
refreshed Claude Code 2.1.290 (3897a65075994f4efddcf34b4a32ea7c7c5ebc13) from its signed release manifest
dependabot-migration: 'claude-harness-refresh' modified 'tools/claude-harness/manifest.json', outside its output set (tools/claude-harness/release.json); nothing committed
```
