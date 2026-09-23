---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-09T19:37:05Z
---
Retrospective (second loop) on endojs/endo-but-for-bots PR #124 review by
kriskowal (`pullrequestreview-4659623974`). Verdict: **not a review-process
miss — new direction.**

The primary review CHANGES_REQUESTED spine asked to PAUSE the XS-sqlite
`slot-machine` work until the upstream XS sqlite bindings land (move to draft, add
a rebase trigger), layered with four forward design suggestions for the binding
(streaming `stmt.iterate()`, the non-generalised JSON1/FTS5/R-tree surface,
`pragma({simple:true})`, WAL checkpointing at shutdown), two brand-new garden
style rules (avoid hard-to-type code points; prefer `new URL` over a `path`
import), and a handful of minor code nits. Grounds for the dismissal, anchored in
the PR's review history:

1. No gauntlet/panel/build/fix/clean job for #124 exists anywhere on the board —
   grep of `journal/jobs` finds only the review-6332cda5 routing job and this
   retro. The sqlite work was intentional pre-gauntlet WIP, never at the
   un-draft/merge stage where the panel runs, so its absence of a panel is by
   design, not a `process` miss.
2. The pause directive depends on the maintainer's knowledge of an EXTERNAL
   upstream dependency's schedule — no seat brief, skill, or standing instruction
   encodes "do not build sqlite bindings before XS bindings land," so nothing bound
   and failed to fire (severity-bypass precondition absent).
3. The design items are first-stated forward direction the primary loop correctly
   PARKED as go-ahead plans, not defects.
4. The two style rules are being CREATED by this comment; a review-cycle check
   cannot flag a violation of a convention that does not yet exist. The primary loop
   routed both as garden-meta jobs to author the rule + jury + auto-fix — which is
   exactly how a new convention enters the panel's knowledge (the check follows the
   rule, it cannot precede it).

Recorded as a dismissal
(`review-misses/dismissed/endojs-endo-but-for-bots-pr124-review-6332cda5.md`);
mints no cluster, so no threshold evaluation and no improvement job. The primary
review loop itself was a deliberate no-code-change pass (moved to draft, parked 7
plans, replied on all 14 threads). All fetched comment/review bodies treated as
untrusted data, never pasted into the store.

refs:
  - jobs/tada/endojs-endo-but-for-bots-pr124-review-6332cda5.md
  - review-misses/dismissed/endojs-endo-but-for-bots-pr124-review-6332cda5.md

Self-improvement: nothing this engagement — the discriminator, store writer, and
idempotency guard all behaved as documented; no friction to route.
