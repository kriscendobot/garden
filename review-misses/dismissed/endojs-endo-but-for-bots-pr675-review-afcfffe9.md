---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr675-review-afcfffe9
verdict: not-a-miss
category: new-direction
pr: 675
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/675#pullrequestreview-4674906637
identity: endojs/endo-but-for-bots#675:review:4674906637:retro
producing_role: designer
producing_job: design-platform-search-pushdown
severity: minor
grounds: >
  kriskowal reviewed the garden's DRAFT design PR #675 (design slug
  platform-search-pushdown — a docs-only plan for pushing filesystem search
  down into platform hosts) with an empty-body CHANGES_REQUESTED review carrying
  five inline comments on designs/platform-search-pushdown.md. Per the primary
  job's own completion report, each of the five comments RESOLVES one of the five
  entries in the design's explicit "Open Questions" section, which the design job
  deliberately surfaced FOR the maintainer to decide. This retro judges whether
  the garden REVIEW PROCESS should have anticipated these decisions and concludes
  it could not have, for the same dispositive structural reason as the #631 and
  #288 design-PR dismissals: the design correctly deferred each of these to
  maintainer authority as open questions, and the review is the maintainer
  ANSWERING them. Paraphrasing the five: (1) grep default scope — use the whole
  tree; (2) fixtures — agreed to place them under the platform test fixtures;
  (3) batchSize defaults (64/1,024) — fine defaults, revisit after a benchmark;
  (4) isConservativeRegex — a new direction: tackle the Rust implementation to gain
  parity/confidence, likely adopt a ReDoS-mitigating RE2-style subset as its own
  project (potentially @endo/regexp), dispatch a designer and take a dependency on
  the result; (5) glob overflow behavior — reverse the proposed "truncate" default
  to "throw", with truncation an opt-in option. Comments 1, 2, 3, and 5 confirm or
  adjust proposed defaults on questions the design itself posed; comment 4 is a
  genuinely new architectural direction (Rust-parity + a spun-off regexp subset
  design) first stated in the review. None is a bug, type error, spec or style
  violation, missed edge case, or violated convention that any juror seat, gate, or
  standing instruction demonstrably knows and failed to bind. There was no code
  panel to miss anything — #675 is a docs-only DRAFT design PR whose whole purpose
  is to elicit exactly these maintainer decisions. A design's open questions are, by
  construction, decisions the design routes to the maintainer; the review process
  cannot and should not pre-empt them. New direction and first-stated author
  decisions (taste, scope), unanticipatable by any panel seat — the same class as
  the #631/#288/#604 maintainer-process dismissals. Recorded as a durable dismissal
  so the same review is never re-litigated. No cluster minted; no improvement
  dispatched.
---

# Dismissal: endo-but-for-bots #675 review 4674906637 (retro)

kriskowal reviewed the garden's DRAFT design PR #675 (platform-search-pushdown — a
docs-only plan for pushing filesystem search down into platform hosts) with an
empty-body CHANGES_REQUESTED review whose five inline comments each resolve one of
the five entries in the design's own "Open Questions" section.

Not a garden review-process miss. The design job deliberately surfaced these five as
open questions FOR the maintainer to decide, and the review is the maintainer
answering them: confirm the grep default scope (whole tree), agree to platform test
fixtures, accept the batchSize defaults pending a benchmark, take a new direction on
isConservativeRegex (pursue a Rust-parity, RE2-style ReDoS-mitigating subset as its
own @endo/regexp-style project and dispatch a designer for it), and reverse the glob
overflow default from truncate to throw with an opt-in truncation option. Four of the
five confirm or adjust proposed defaults; the fifth is a genuinely new architectural
direction first stated in the review.

None is a defect a juror seat, gate, or standing instruction knows and missed — and
there was no code panel to miss anything, as #675 is a docs-only DRAFT design PR whose
purpose is to elicit exactly these maintainer decisions. A design's open questions are
decisions routed to the maintainer by construction; the review process cannot pre-empt
them. First-stated author decisions (taste, scope) — the same class as the #631/#288/#604
design-PR dismissals. The review process did not fail; it correctly flagged the questions
and the maintainer answered them. See comment_url for the verbatim review.
