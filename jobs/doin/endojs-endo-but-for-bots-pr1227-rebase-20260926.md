---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Rebase endojs/endo-but-for-bots#1227 onto live `llm`

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1227
(design `designs/daemon-guest-bot-incarnation.md`, arc item 6 of kriscendobot/garden#89).

The PR is a draft awaiting maintainer re-review (CHANGES_REQUESTED 2026-09-22, revised in
`ae0929f48d`), and it has gone `CONFLICTING` against `llm`. The diff touches only
`designs/daemon-guest-bot-incarnation.md` and `designs/README.md`; the conflict is most likely
the `designs/README.md` roadmap index. Rebase the head `design/endo-daemon-guest-bot-incarnation`
onto current `llm`, resolve conflicts keeping both `llm`'s README entries and this PR's entry,
and force-push with lease so the PR is `MERGEABLE` when the maintainer re-reviews it.

Do not change the design's substance, do not un-draft, and do not post a gauntlet. If the
conflict is substantive (not an index merge), stop and report it rather than rewriting the design.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-26T06:22:43Z
