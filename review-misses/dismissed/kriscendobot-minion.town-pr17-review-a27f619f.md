---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr17-review-a27f619f
verdict: not-a-miss
category: new-direction
pr: 17
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#17:review:5083252073:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/17#pullrequestreview-5083252073
review_at: 2026-09-01T22:40:53Z
severity: minor
grounds: |
  A CHANGES_REQUESTED review carrying a forward REFRESH directive driven by
  upstream evolution, not a critique of the work as reviewed. Review 5083252073
  (verified live via gh api) is state=CHANGES_REQUESTED by MEMBER kriskowal,
  submitted 2026-09-01T22:40:53Z, with no inline review comments. Its one-line
  body asks the bot to refresh the PR and adapt it to two things that happened on
  main AFTER this PR was authored and reviewed: a migration of tool names and a
  minimization of scopes. This is the maintainer's `refresh #N` verb — re-syncing
  a drifted branch against upstream change — not a bug, spec violation, missed
  edge case, style breach, or convention a juror seat, gate, or standing
  instruction encodes.

  Nothing here was anticipable at review time. PR #17 was authored 2026-07-22 and
  ran its full gauntlet then; the daemon-guest migration that renamed the tools
  and minimized the scope set to `mcp/tools mcp/guest` landed on main later (late
  Aug 2026). At the moment the panel evaluated PR #17, the tool names and scopes
  it used were the current ones. A panel cannot review against a migration that
  has not happened yet, and no standing rule binds a producer to future-proof a
  PR against upstream renames that occur after its review. The staleness is drift
  the world introduced, whose remedy is exactly the maintainer-initiated refresh —
  not a sense-and-correct failure of the review process.

  The evaluator was NOT skipped or gamed. The full gauntlet demonstrably ran on
  PR #17 — journal/jobs/tada/ holds kriscendobot-minion.town-pr17-gauntlet-clean,
  gauntlet-panel-1..5, gauntlet-fix-1..4, and gauntlet-undraft — so the panel
  evaluated the change and drove a fix loop before any of these maintainer
  reviews. The measurement did not move while the target stood still; a
  refresh-onto-current-main directive is the opposite of routing around a gate.

  No no-op discrepancy to report. The primary job (a27f619f) did NOT close as a
  bare no-op: it performed the refresh (report head 0729186 onto main-975a035,
  adopting interface-native tool names, removing toy-tool references, minimizing
  scopes to `mcp/tools mcp/guest`, strengthening the session-pin refresh test).
  Grounding in the world rather than the primary's assertion: the PR body now
  reads "Refreshed onto main after the daemon-guest migration ... only the current
  mcp/tools mcp/guest scope pair ... no toy-tool calls or retired minion scopes",
  its head commits (50b59bc, fe1799df, 464ad2ae, 21eaaa93) carry the scope-label
  fix and the guest-tools-through-PKCE exercise, and PR #17 is MERGED
  (merged=true, merged_at 2026-09-04T06:17:58Z, merge_commit d827af8775). The
  refresh deliverable exists and was carried through to merge. This is new
  direction / upstream-drift refresh first expressed in the comment, not a
  review-process miss. (Sibling review 5095277423 on the same PR — the subsequent
  approval-with-conduct/deploy directive — was likewise dismissed as new-direction
  in dismissed/kriscendobot-minion.town-pr17-review-72d9bc6d.md.)
---

Maintainer review 5083252073 on kriscendobot/minion.town PR #17 is a
CHANGES_REQUESTED whose one-line body asks the bot to refresh the PR and take into
account a migration of tool names and a minimization of scopes. That is a forward
refresh directive answering upstream evolution — the daemon-guest migration that
renamed tools and minimized scopes landed on main after this PR was authored and
gauntleted — not a bug, spec, style, or convention defect the panel should have
caught at review time. The full gauntlet ran on this PR (clean + five panels +
four fixes + undraft in journal/jobs/tada/) before these reviews. The primary
genuinely delivered: it refreshed the branch onto current main, adopted the
interface-native tool names, removed toy-tool references, and minimized scopes to
`mcp/tools mcp/guest`; the PR body reflects it and PR #17 is now merged (merge
commit d827af8775) — no no-op discrepancy. Dismissal (new-direction). Re-fetch the
verbatim review body at comment_url.
