---
role: orchestrator
handler-timeout: 10800
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Supervise the garden book to completion (kriscendobot/garden-book)

Maintainer (kriskowal, liaison 2026-10-03): "I am preferring to skip the gauntlet and
in fact would like to put a supervisor in charge of the remaining work, and enable
them to run a gauntlet at their discretion."

You own the rest of the garden-book work. The default is **no gauntlet**. You may
post one (`scripts/jobs/post-gauntlet.sh`) for a PR when you judge it is warranted,
for example for the publish/powers security fix or a large generator rewrite.

State at handoff (2026-10-03T04:4xZ):
- Draft PRs, none reviewed:
  - https://github.com/kriscendobot/garden-book/pull/1 — copy-edit, base main-bab8e7b
  - https://github.com/kriscendobot/garden-book/pull/2 — design pass, stacked on #1 (base book-copyedit-913c8a7); includes the publish.py fix (inert empty powers instead of "sites")
  - https://github.com/kriscendobot/garden-book/pull/3 — retitle to "Better Code and Gardens" plus audience pass, base main-bab8e7b (NOT stacked; conflicts likely with #1)
- Open editorial items: the title, the five part names (PARTS in build.py), and #3's
  reviewer note that ch2 says "(This chapter was landed that way.)", which may be
  untrue now the book lives in its own repo.
- Pending chain: `book-codex-illustrations` (todo, builder) → `book-illustrations-integrate`
  (plan, blocked) → `book-build-js-retool` (plan, blocked).

Authority: you may read and review the PRs yourself, restack/rebase them (#3 onto
the merged copy-edit), un-draft and merge them into main on kriscendobot/garden-book,
make the editorial calls (record each decision and its reason in the PR or report),
re-scope, re-order, withdraw, or add book jobs, and publish the book once the merged
content is ready. Keep the maintainer informed: send one concise maintainer message
(`message-user.sh`) when the text PRs are merged and published, and another at
completion. Ask the maintainer only for a decision you cannot reasonably make
(the title is the most likely candidate; propose, and proceed with the current
title if no reply).

Scope: kriscendobot/garden-book only. No upstream repos, no garden budget or fleet
config changes.

One claim cannot span the whole chain. Before this job ends, if work remains, post a
dated successor supervisor job (same body, updated state, e.g. `blocked_on` the
next child you are waiting for) so supervision continues until the book is done.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-10-03T05:13:09Z -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-03T05:14:12Z
