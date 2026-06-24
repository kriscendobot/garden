# Weave (rebase) endo-but-for-bots #57 on #475

Maintainer directive on PR #57 (kriskowal, 2026-06-24T20:09Z):
"@kriscendobot Please rebase on #475" —
https://github.com/endojs/endo-but-for-bots/pull/57#issuecomment-4793208270

Posted directly by the liaison because the autonomous PR-comment triage path does
not exist in v2 yet (the v2 triager watches branch commits, not PR comments), so no
triager would pick this up.

Wear the **weaver** role (`roles/weaver/AGENT.md`). Repo:
`endojs/endo-but-for-bots`, PR **#57**.

## Task

- Rebase PR #57 onto **#475** — i.e. #57 is stacked on #475; rebase #57's branch so
  its base is the current head of #475's branch (confirm #475's branch name and head
  via `gh pr view 475 --json headRefName,headRefOid`). Resolve conflicts per
  `skills/conflict-resolution` / yarn-lock discipline.
- If #475 is itself unmerged/in-flight, rebase onto its current head (a stacked
  rebase); note in your report that #57 remains stacked on #475 until #475 lands.
- Push the rebased head to #57's branch (`git push --force-with-lease origin HEAD:<pr-branch>`),
  **bot identity** (a bot-fork PR branch — no identity switch, no ferry).
- Reply on the triggering comment confirming the rebase (the standing authorization
  for endo-but-for-bots permits commenting), and report the new head SHA and any
  conflicts resolved.

## Definition of done

#57 rebased onto #475's current head, force-pushed to its branch under the bot
identity, with a confirming reply on the PR and the new head SHA reported. If the
rebase is non-mechanical or #475's state blocks it, report the precise state rather
than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 47
  claimed_at: 2026-06-24T20:16:49Z
