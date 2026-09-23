---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr85-review-ca62c58f
verdict: not-a-miss
category: new-direction
pr: 85
repo: kriscendobot/minion.town
identity: kriscendobot/minion.town#85:review:5109090330:retro
comment_url: https://github.com/kriscendobot/minion.town/pull/85#pullrequestreview-5109090330
review_at: 2026-09-04T04:08:41Z
severity: minor
grounds: |
  Forward design direction, first stated in the comment. PR #85
  (feat(clip): in-place front-content upgrade on the live @sites path) is an
  open DRAFT that upgrades a clip's front content in place on a stable clip id,
  matching the then-current design designs/clip-ocap-synthesis.md §§ 3.2/3.4. In
  CHANGES_REQUESTED review 5109090330 (MEMBER kriskowal, 0 inline comments — the
  review body is the whole unit) the maintainer opens with "it occurs to me that
  the more worthy first experiment would look like this" and lays out a fresh
  design vision that REVERSES this PR's premise: immutable clip content cached
  forever, a nonce-locator CapTP session with the backend formula id carried out
  of band in the URL hash (#?v=1&p=...) and collected by the static site's JS,
  upgrade-by-minting-a-fresh-clip-id + redirect (app migrates local storage), a
  static local-storage schema, and the guest primer as the wiring contract for
  all of it. None of that is a bug, spec violation, missed edge case, or violated
  convention the panel knows from a seat brief, skill, or standing instruction —
  it is a product/design-scope requirement first expressed in this comment. No
  juror seat, gate, or standing rule encodes an immutable-content + nonce-locator
  clip architecture, so nobody could have anticipated it before the maintainer
  named it. This is new direction/taste, not a review-process miss.

  Not a `process` miss for want of a gauntlet: under the manual-gauntlet-trigger
  regime (designs/manual-gauntlet-trigger.md) a build/probe stops at an open
  DRAFT and stages NO gauntlet automatically — the maintainer promotes with an
  explicit "run the gauntlet". journal/jobs/tada/ holds no gauntlet/panel job for
  pr85 precisely because none was ever due to run; the evaluator was not skipped
  or routed around. Not evaluator-gaming: no measurement moved while a target
  stood still — the maintainer is steering the design forward, not being gamed.

  The primary job (ca62c58f) genuinely delivered and did NOT close as a no-op: it
  routed the five directives into designer job
  minion-town-clip-immutable-nonce-locator-design (now in journal/jobs/tada/),
  which produced design PR kriscendobot/minion.town#88 (open, "design(clip):
  immutable content, nonce-locator session, fresh-id-on-upgrade"), and posted the
  review acknowledgment (issue-comment 5535568640) surfacing the supersession
  choice. The directive deliverable exists in the world — no no-op discrepancy to
  report.
---

Maintainer review 5109090330 (CHANGES_REQUESTED, kriskowal) on PR #85 proposes a
new "more worthy first experiment": immutable clip content cached forever, a
nonce-locator CapTP session with the backend formula id carried out of band in
the URL hash, upgrade by minting a fresh clip id + redirect, and a static
local-storage/content schema noted in the guest primer. This reverses PR #85's
in-place front-content upgrade premise. It is forward design direction first
stated in the comment, not a review-process miss — a dismissal. No gauntlet was
due on this draft under the manual-gauntlet regime, so the evaluator was not
skipped; and the primary genuinely delivered (designer job → design PR #88).
Re-fetch the verbatim review body at comment_url.
