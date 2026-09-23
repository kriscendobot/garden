---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-09-17T09:42:59Z
---
refs:
  - endojs/endo-but-for-bots#1072:review:5063029094:retro
  - review-misses/dismissed/endojs-endo-but-for-bots-pr1072-review-070ee47a.md

**Prosecutor retrospective (second loop)** on endojs/endo-but-for-bots PR #1072,
maintainer review 5063029094 by @kriskowal (CHANGES_REQUESTED, empty body, four
inline comments). Primary base `endojs-endo-but-for-bots-pr1072-review-070ee47a`.

**Idempotency:** clean — no prior misses/ or dismissed/ record for this primary.

**Verdict: not-a-miss / new-direction.** The review steers an actively-iterated
OCapN-Noise locator wire format on a draft PR: (1) rename scheme ocapn:// ->
endo:// to avoid front-running consensus; (2) add a wss hint path consistent with
minion.town; (3) omit-loopback / prefer-IPv6 / pluggable public-IP discovery;
(4) priority-ordered list of multiple hints per protocol for multi-homed hosts.
Comment 4 reverses the PR's own "one hint per transport" thesis on multi-homing
grounds — design-owner direction first stated in review, not a defect the review
process could anticipate. This is the fourth review in the arc; siblings
5047681541 and 5047696655 were dismissed on the same grounds, 5059889251 was the
one recorded spec-violation miss.

**Grounding:** comment 3's "don't advertise localhost" mirrored the existing
in-repo ws transport's wildcard->127.0.0.1 substitution, so it is the maintainer
changing a convention, not code violating one. Comment 2 was weighed against the
sibling c8a0f42b related-design-contract-cross-check miss and does not rise to it
(additive path evolution, not contradiction of a firm landed contract). No
evaluator-gaming/avoidance: the manual-gauntlet regime runs no panel on a draft
under maintainer design iteration.

**World-grounded deliverable check (no discrepancy):** the primary did not close
as a no-op — it handed off to fixer endo-1072-address-review-multihint, which
delivered all four asks in commit d41e3846e on head fix/ocapn-noise-tcp-single-url-hint
and answered the threads. Confirmed live: PR #1072 OPEN, draft, that head branch.

**Actions:** recorded the dismissal via review-miss-record.sh
(review-misses/dismissed/endojs-endo-but-for-bots-pr1072-review-070ee47a.md). No
cluster minted, no threshold evaluation, no improvement job — correct for a
dismissal. No garden-repo (main2) changes needed.

Self-improvement: nothing this time.
