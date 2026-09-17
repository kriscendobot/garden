---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1072-review-070ee47a
verdict: not-a-miss
category: new-direction
pr: 1072
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
identity: endojs/endo-but-for-bots#1072:review:5063029094
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1072#pullrequestreview-5063029094
review_at: 2026-08-31T04:10:41Z
producing_role: gardener
producing_job: deadmail-issue-comment-5447781817
severity: minor
grounds: |
  Design steering on an evolving OCapN-Noise locator wire format, first stated
  in the review. PR #1072 is a draft that iterates the connection-hint locator
  design (designs/ocapn-noise-network.md plus the tcp/ws transports) directly
  through repeated maintainer review; this is the fourth review in that arc
  (siblings 5047681541 and 5047696655 were both dismissed as new-direction on
  the same grounds; 5059889251 was a spec-violation miss). The review carries an
  empty body and four inline comments, all trusted-reviewer directives:
  (1) rename the locator scheme ocapn:// -> endo:// so as not to front-run
  consensus on a future registered ocapn: scheme; (2) add a URL path to the
  wss hint, consistent with minion.town; (3) prefer to omit a hint rather than
  advertise loopback, prefer IPv6, leave a pluggable public-IP-discovery seam,
  and advertise IPv6+IPv4 as a prioritized list; (4) make listener hints a
  priority-ordered list, multiple hints per protocol for multiple link-layer
  addresses.

  Comments 1, 3, and 4 are unambiguous new-direction grounded in the design
  owner's domain knowledge: the consensus/standards-registration reasoning for
  the scheme name, the multi-homing rationale (a host with several link-layer
  addresses needs a prioritized list), and the pluggable-discovery seam are all
  facts the maintainer supplies, not requirements any juror seat, skill, or
  standing instruction encodes. Comment 4 in particular REVERSES the PR's own
  thesis ("one hint per transport" — itself a prior direction taken from a
  kriscendobot/garden#58 comment); the design owner changing direction on an
  actively-iterated wire format is exactly the design-fork flow, not a defect the
  review process could have anticipated.

  Comment 3's "don't advertise localhost" is the only piece with a defect flavor
  (a loopback address is unroutable to a remote peer), but it is not a violated
  standing rule: the PR deliberately MIRRORED the existing in-repo ws transport,
  which performs the same wildcard->127.0.0.1 substitution. The convention the
  code followed did the opposite of what the maintainer now wants, so this is the
  maintainer changing the convention (with new IPv6/multi-homing/discovery
  direction), not the code contradicting a firm contract.

  Comment 2 (add a wss path) is the weakest comment and was weighed against the
  sibling c8a0f42b miss (cluster related-design-contract-cross-check: a design
  edit contradicting an already-landed authoritative in-repo contract). It does
  NOT rise to that pattern: the wss path dimension was still being decided across
  this very review arc (the hint grammar evolved review-to-review), so asking to
  ADD a path consistent with a sibling project is additive design evolution, not
  a contradiction of a firm landed contract like the daemon-locator-reference.md
  @-path-vs-query rule that c8a0f42b violated. It does not, alone, make the
  review a review-process miss.

  Not evaluator-gaming/avoidance: the manual-gauntlet-trigger regime runs no
  panel on a draft under active maintainer design iteration, and this review
  arrived while the PR was still in its advertised draft review phase (the
  journal holds no #1072 gauntlet/panel job and the thread has no panel comment).
  The maintainer is iterating WITH the author, not being routed around.

  World-grounded deliverable check (no no-op discrepancy): the primary job
  (070ee47a) did not close as a no-op — it handed the substantive rework off to
  fixer job endo-1072-address-review-multihint, which genuinely delivered all
  four asks in commit d41e3846e on the PR head branch
  fix/ocapn-noise-tcp-single-url-hint, answered the review threads, and left the
  PR draft. Confirmed live: PR #1072 is OPEN, draft, head
  fix/ocapn-noise-tcp-single-url-hint. Nothing to report as missing.
---

Maintainer review 5063029094 (CHANGES_REQUESTED, empty body, four inline
comments) steers the evolving OCapN-Noise locator wire format: rename the
locator scheme to endo:// to avoid front-running consensus, add a wss hint path
consistent with minion.town, omit-loopback / prefer-IPv6 / pluggable public-IP
discovery, and make transport hints a priority-ordered list (multiple hints per
protocol for multi-homed hosts). This is design direction on an actively
iterated wire format — comment 4 reverses the PR's own "one hint per transport"
thesis on multi-homing grounds — first expressed by the design owner in review,
a dismissal rather than a review-process miss. Re-fetch the verbatim comments at
comment_url. See sibling reviews 5047681541 / 5047696655 (also dismissed) and
5059889251 (the one recorded miss on this PR).
