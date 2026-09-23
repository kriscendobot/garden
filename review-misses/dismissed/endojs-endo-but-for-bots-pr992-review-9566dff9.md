---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr992-review-9566dff9
verdict: not-a-miss
category: new-direction
review_at: 2026-08-16T06:11:43Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/992#discussion_r3791104230
identity: endojs/endo-but-for-bots#992:review:4945559559:retro
---

Inline review comment by the maintainer on the design-only PR #992
(`designs/http-adapter-pipeline.md:264`, the `estimateCost` method of the uniform
`HttpStageInterface`). Two asks: (1) the pure cost probe on the general stage
interface is an architectural smell — a cross-cutting concern that communicates
through intermediate stages — and the maintainer proposes an alternative shape
where a stage calls forward to the *next* stage's specialized cost estimate as a
bilateral contract between two stage constructors, not a method on the general
interface; and (2) a terminology preference: stop using the word "middleware" and
call the stages "adapters".

Grounds: new design direction and vocabulary on a design document the maintainer
himself is actively shaping, not an indictment of the review. The #992 review
process ran in full — a design panel of 7-to-35 seats across six rounds plus six
fix rounds (journal/jobs/tada/endojs-endo-but-for-bots-pr992-gauntlet-*), so there
is no skipped-evaluator avoidance shape. On the substance, the panel engaged this
exact mechanism deeply and, if anything, pushed the *opposite* way: round 2's
critic flagged "missing estimateCost from the interface" and drove the probe onto
the uniform interface — the very placement the maintainer now names a smell. That
is a genuine architecture-taste disagreement resolved by the design owner's
principle (avoid cross-cutting concerns that talk through intermediary stages;
prefer a bilateral constructor-to-constructor contract), a forward-looking judgment
("it won't be the last time") that only the design owner holds. No seat brief,
skill, or standing convention encodes "a cost probe must be a bilateral contract
rather than an interface method," so nothing knowable was violated. The naming ask
is likewise a first-stated preference: the doc deliberately used "middleware" to
invoke the Koa/Express prior art it mines, and choosing which of "adapter" (already
in the PR title) versus "middleware" becomes the canonical term is the design
owner's vocabulary call, not a rename-discipline violation the ergonomist could
have pre-empted (that seat did flag other naming drift — inspect/inspectPipeline,
snake_case, CLI verbs — but "don't call them middleware" is taste, not a known
convention). Verified against the world, not the primary report: the primary's
deliverable genuinely exists — commit 53dfdd72bd on the PR head
(kriscendobot/endo-but-for-bots@design-http-adapter-pipeline), message
"design(http): estimateCost as a specialized adapter-pair contract, not a
uniform-interface method," which removed estimateCost from HttpStageInterface,
added the bilateral CostQuoteInterface facet, added a "Specialized adapter-pair
contracts" section, and swept the middleware→adapter terminology — so the directive
was executed, not falsely claimed. Dismissed as new-direction; mints no cluster.
