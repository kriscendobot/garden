---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr96-review-d423db6e
verdict: not-a-miss
category: new-direction
pr: 96
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#96:review:5272974950
comment_url: https://github.com/kriscendobot/minion.town/pull/96#pullrequestreview-5272974950
review_at: 2026-09-21T23:58:47Z
severity: minor
grounds: |
  Maintainer answers to the design's own open questions, not a review miss.
  PR #96 (design: credential-expiry detection and operator-mediated reauth for
  Claude agents) ran six design-panel rounds on 2026-09-08 (bot reviews
  5146382529..5148222209, "Design panel — round N" bodies), so the evaluator
  ran and was not routed around. Review 5272974950 (CHANGES_REQUESTED,
  kriskowal) has a trivial body plus four inline comments, and every one of
  them is anchored on a bullet in the design's own "Open questions" section:
  (1) who the operator should be -> maintainer picks the simple root-user case
  first, sophistication deferred; (2) whether usage-exhausted should be a
  first-class signal -> yes, automation should be able to react (e.g. switch
  subscription) or escalate; (3) whether to add a pre-expiry advisory -> yes;
  (4) whether the missing browser OAuth relay blocks the default -> no, fall
  through to manual reauth and post a gated tracking job. The design surfaced
  these forks explicitly for maintainer decision; resolving them is product
  direction first stated in the review. No seat brief, skill, or standing rule
  could have decided them in advance. Not evaluator-gaming: no gate skipped,
  no measurement moved.

  World check on the primary: it genuinely delivered. The PR head gained
  "design(reauth): start with root-user notification (#96)" and "design(reauth):
  add pre-expiry advisory and track OAuth-relay follow-up (#96)"; each of the
  four inline threads carries a bot reply citing the commit; the maintainer
  APPROVED (review 5324704742, 2026-09-26) and the PR is merged.
---

Dismissed: the four inline comments on review 5272974950 are the maintainer's
decisions on the four open questions the design itself posed (operator scope,
usage-exhausted as an actionable signal, pre-expiry advisory, not blocking on
the OAuth relay). A six-round design panel ran beforehand. New direction, not
a review-process miss.
