---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**False "manual gauntlet handoff" alarms for PRs that already ran a gauntlet** (kriscendobot/garden, main2).

The missed-draft-handoff recovery added in 7d3ec941b11 ("fix(gauntlet): recover missed draft handoffs") sends the maintainer a `manual-gauntlet-handoff-<job>-<repo>-pr<N>.md` notice. The notice says a bot-authored, open, non-draft PR "has no staged or completed gauntlet". It fires for PRs that have had full gauntlets:
- https://github.com/kriscendobot/minion.town/pull/160 got two gauntlets on 10-05: `build-minion-town-claude-guest-scoped-mcp-gauntlet` and `kriscendobot-minion.town-pr160-gauntlet`. One finished complete and took the PR out of draft.
- https://github.com/kriscendobot/minion.town/pull/163 likewise got two: `kriscendobot-minion.town-pr163-gauntlet` and `kriscendobot-minion.town-pr163-gauntlet-20261005`.

It recurs. Every `claude-on-minion-town-press-*` / `-completion-press-*` job that mentions #163 triggers it again; the latest was `claude-on-minion-town-press-20261006-122018`. The liaison has archived four of these.

Fix: decide "has a gauntlet" by PR identity across live `jobs/gauntlet`, `jobs/gauntlet-archived` and `jobs/tada` gauntlet reports, the same lookup d8dfa37f373 added for re-staging. Also dedupe the notice per PR, not per job. Add a regression test. Land on main2.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T12:24:21Z
