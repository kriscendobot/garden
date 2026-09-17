---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr59-review-0aebcb48
verdict: not-a-miss
category: new-direction
pr: 59
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#59:review:5119118240:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/59#pullrequestreview-5119118240
review_at: 2026-09-05T01:08:09Z
severity: minor
grounds: |
  New world-state plus a routine staleness request, both first surfaced in the
  review — not a failure any review seat could have anticipated. PR #59
  (deploy(daemon): document live WebSocket and pluribus TCP listeners) is a bot-
  authored DRAFT opened 2026-08-28 on branch daemon/pluribus-tcp-3469 (base main),
  a documentation change recording the daemon's live pluribus raw-TCP listener.
  Under the manual-gauntlet-trigger regime a draft stages no gauntlet until an
  explicit "run the gauntlet #N"; none was requested, so no panel ran on #59
  (journal jobs/tada holds no gauntlet/panel job for minion.town pr59 — only the
  primary review-fix job 0aebcb48). The maintainer reviewed the raw draft directly,
  which is the intended flow for a not-yet-promoted deploy-doc PR.

  Maintainer review 5119118240 (CHANGES_REQUESTED, kriskowal, 2026-09-05T01:08Z,
  part of the same day's review sweep as the #45 dismissal 5119105749) carried two
  directives, both new direction:

  (1) "Please refresh" — a rebase/staleness request. main had advanced to b83741a
  since the PR was authored a week earlier; the branch was stale. A stale-branch
  refresh is not a review-process miss: no seat, gate, or standing instruction
  prevents a draft going stale during a window of maintainer inattention, and the
  garden already owns this as a first-loop verb (weave/refresh #N), not a gauntlet
  responsibility.

  (2) "We have websocket as well now" — new deployment reality. The PR documented
  the pluribus raw-TCP transport as it stood at authoring time; the maintainer is
  supplying the fact that a live WebSocket transport now exists alongside it,
  world-state that postdates the PR (the WebSocket listener became live after
  2026-08-28). No review panel reading the diff at authoring time could have known
  a second transport would later go live; this is the maintainer feeding forward a
  fact about the running deployment, exactly what direct maintainer review is for.

  Neither directive is a bug, spec violation, missed edge case, or a convention the
  panel demonstrably knows from a seat brief, skill, or standing instruction.

  Not evaluator-gaming/avoidance: the manual-gauntlet regime — not the producer —
  is why no panel ran (a not-yet-promoted draft the maintainer reviews directly by
  design); nothing was shaped to route around an evaluator and no measurement moved
  while a target stood still. A hypothetical gauntlet would not have caught either
  item, so the absence of one did not cause this feedback.

  Primary genuinely delivered and did NOT close as a no-op: PR head is now
  460b697e0e ("docs(daemon): record WebSocket alongside pluribus TCP",
  2026-09-05T01:13Z), rebased onto main at b83741a, with the topology doc, PR title,
  and description all updated to present WebSocket as a first-class live transport
  alongside the pluribus raw-TCP listener; completion issue comment posted
  2026-09-05T01:14Z. Both directive deliverables (refresh + websocket documentation)
  exist in the world — no no-op discrepancy to report.
---

Maintainer review 5119118240 (CHANGES_REQUESTED) on draft PR #59 asks the bot to
(1) refresh/rebase the stale branch and (2) document that a live WebSocket transport
now exists alongside the pluribus raw-TCP listener the PR was written about. Both are
first stated in the review: a routine staleness request and new deployment world-state
that postdates the PR's authoring — neither a review-process miss, so a dismissal. No
gauntlet ran on this draft (manual-gauntlet-trigger regime; the maintainer reviews the
draft directly), and a hypothetical panel could not have anticipated either item. The
primary (0aebcb48) genuinely delivered both (head 460b697e0e, rebased onto b83741a,
docs/title/description updated for WebSocket). Re-fetch the verbatim review body at
comment_url.
