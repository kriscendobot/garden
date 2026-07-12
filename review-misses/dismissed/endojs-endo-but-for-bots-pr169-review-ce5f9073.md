---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr169-review-ce5f9073
verdict: not-a-miss
category: new-direction
pr: 169
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/169#pullrequestreview-4680376639
identity: endojs/endo-but-for-bots#169:review:4680376639:retro
surface: pr-review-body
author: kriskowal
grounds: |
  PR #169 is a pure DESIGN-PROPOSAL document — it adds designs/pass-style-promise.md
  (+1209 lines) and touches designs/README.md; no code, tests, or packaging. The
  review body was empty; the two substantive maintainer comments (paraphrased,
  untrusted — re-fetch at comment_url for verbatim) both sit on the proposed design
  itself, not on a work product the gauntlet produced:

    1. Line 267 — a NAMING-TASTE question on a brand-new primitive being *proposed*
       in the doc: "how does `subscribe` differ from `when`? we might want to call it
       `listen` or `watch`." This is the maintainer weighing in on an open design
       question about a novel API surface, floating alternative names. It violates no
       standing convention: there is no prior art named `subscribe`/`listen`/`watch`
       to be consistent with, and the design already carried the distinction as an
       open question. The primary job recorded it as the doc's Open Question 11 for
       the maintainer's call — precisely because it is a taste decision only the
       maintainer can settle.

    2. Line 393 — a SCOPE DIRECTIVE: "we should post a plan to create that design"
       (the separate debug-view ring-buffer design the doc mentions as a future
       direction). This is a first-stated follow-up instruction, not a critique;
       the primary job satisfied it by parking a new designer plan
       (endojs-endo-but-for-bots-design-promise-debug-view).

  Neither comment is a bug, spec violation, style/convention breach, missed edge
  case, or violated standing instruction that any juror seat, gate, or skill
  demonstrably knows. A design doc is the INPUT to the review process; a maintainer
  reviewing a design proposal and floating a naming preference and requesting a
  follow-up plan is the ordinary design-iteration conversation, exactly the surface
  the maintainer owns.

  Grounded in the PR's actual history: #169 ran no code panel because there is no
  code to review (design-doc-only, confirmed by the files list — two markdown
  files). The primary tada (endojs-endo-but-for-bots-pr169-review-ce5f9073) did not
  fix a defect a review missed — it answered a naming question by recording an open
  question and executed a directive by posting a plan. There is no review pass whose
  seats could have "missed" the maintainer's naming taste or their intent to formalize
  a future-directions note into a plan. Textbook new-direction dismissal (taste +
  scope + first-stated requirements). No cluster is minted.
