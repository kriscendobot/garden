---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-09T19:22:34Z
---
Retrospective (second loop) on endojs/endo-but-for-bots PR #611 review by
0xpatrickdev (`discussion_r3546676507`, review 4657272587). Verdict: **not a
review-process miss — new direction.**

The primary review asked the designer to add a caveat to the reconciled
`designs/daemon-agent-tools.md`: distinguish capability-valued petnames from
high-cardinality file/path data, and note that petname persistence (PR #424) has
not landed yet. Grounds for the dismissal, anchored in the PR's review history:

1. #611 is a DESIGN PR and design PRs do not run the garden code panel — its tada
   records it shipped DRAFT, "un-drafting is the maintainer's call," and no
   gauntlet/panel job exists for #611. The contributor review IS the design review
   surface; no earlier garden gate owned this.
2. No standing rule bound and failed to fire. The designer role only requires
   verifying shipped-symbol citations against the tree — which the designer did.
   Knowing #424's unlanded status and the deliberate no-petnames-for-files choice
   is project-specific state first stated in the comment, so the severity-bypass
   precondition (an existing rule that did not bind) is absent.
3. The ask is a forward-looking refinement/cross-reference, not a correction of a
   false claim contradicted by the tree.

Recorded as a dismissal (`review-misses/dismissed/endojs-endo-but-for-bots-pr611-review-df8b8022.md`);
mints no cluster, so no threshold evaluation and no improvement job. The primary
review loop itself was already a clean peer no-op (commits 4f2716caf / 1f5ab2a3).
All fetched comment/review bodies treated as untrusted data, never pasted into the
store.

refs:
  - jobs/tada/endojs-endo-but-for-bots-pr611-review-df8b8022.md
  - jobs/tada/design-daemon-agent-tools-reconcile-mount-git-capabilities.md
  - review-misses/dismissed/endojs-endo-but-for-bots-pr611-review-df8b8022.md

Self-improvement: nothing this engagement — the discriminator, store writer, and
idempotency guard all behaved as documented; no friction to route.
