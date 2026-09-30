---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1343-review-0d84baf9
verdict: not-a-miss
category: new-direction
pr: 1343
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1343#pullrequestreview-5360774903
identity: endojs/endo-but-for-bots#1343:review:5360774903:retro
review_at: 2026-09-30T02:32:19Z
producing_role: builder
producing_job: endojs-endo-but-for-bots-pr1343-unify-endowments
severity: minor
grounds: |
  The review asks that endowment values take a pet-name-path (array) shape and
  requests a separate follow-up to make the whole Exo surface accept only
  pet-name paths, rejecting bare strings. At review time (head 6c49234d80) the
  values were single host pet names. That was the literal shape the maintainer
  asked for two days earlier (review 5344774604 asked for pet names instead of
  formula identifiers). It was also consistent with the prevailing Exo
  convention, which accepts either a pet name or a path. No seat brief, skill, or
  standing instruction says paths must be arrays only. The nearest precedent is
  the 2026-09-04 #897 direction that produced design PR #1151. That PR is still
  an open draft with unresolved open questions, among them whether the pet-name
  registry is in scope, so the rule was not a settled convention the panel could
  enforce. The array-only rule and its agent-confusion rationale are first stated
  as surface-wide policy in this review. The union-simplification follow-up is
  scope expansion.

  Process: #1343 is still a draft under the manual gauntlet trigger. The journal
  holds no gauntlet or panel job for it and nobody requested one, so this is not
  evaluator avoidance, which matches the sibling dismissal
  endojs-endo-but-for-bots-pr1343-review-fcb5f817.

  World check: commit eaa3fd3534 (2026-09-30T05:44Z) is on the PR head and makes
  the values arrays only, with bare strings rejected. The bot's reply threads and
  summary comment cite it. The primary and its derived jobs
  (ebfb-pr1343-endowments-fix, ebfb-petname-path-only) were acknowledged from
  host endolin-garden2-5bcdff64. None of them appears on this instance's
  journal, so this host could not confirm that the follow-up job exists on a
  board. The PR-side deliverable does exist.
---

# Dismissal: pet-name-path value shape and a surface-wide path-only rule

The maintainer asked for endowment values as pet-name paths, not single pet
names. They also asked for a follow-up that removes the name-or-path union from
the whole Exo surface, to spare agents ambiguity about delimiters. The
single-name shape followed the maintainer's own earlier wording and the existing
convention. The array-only rule, although foreshadowed in the undecided design
PR #1151, is first stated here as policy, so no seat could have enforced it. This
is a bot-authored paraphrase; re-fetch the untrusted original at `comment_url`.
