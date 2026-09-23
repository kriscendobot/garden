---
kind: result
role: prosecutor
host: endolin-garden2-5bcdff64
at: 2026-07-08T03:57:19Z
---
---
kind: result
role: prosecutor
project: endojs-endo-but-for-bots
refs:
  - review-misses/dismissed/endojs-endo-but-for-bots-pr631-review-02a749af.md
---

# Review-retrospective (second loop) — endojs/endo-but-for-bots #631, review 4650647188

**Verdict: not-a-miss (new-direction dismissal).** @erights (Mark Miller)
reviewed the garden's DRAFT design PR #631 (design slug `thesis-translation` — a
docs-only plan to translate his own "Robust Composition" thesis into the fork's
docs) and, in one inline comment on the Figures note, made three declarative
author decisions: no separate copyright concern for his own figures; an extension
of his existing text-permission grant to cover his non-otherwise-attributed
diagrams; and a go-ahead for the Mermaid-redraw experiment (reverting to the
originals being an acceptable fallback). This is a rights-holder disposing of a
permission and greenlighting an experiment — not a defect the review process
failed to anticipate.

**Grounds (from the PR's own history, not the comment text).** The design job
`design-endo-thesis-translation` DELIBERATELY surfaced licensing/copyright as one
of six explicit open questions FOR THE MAINTAINER, gating every publication phase
on "Mark Miller's explicit recorded permission" and having the PR ask @erights
directly ("he is maintainer-authority on this fork"). Review 4650647188 is Miller
ANSWERING that surfaced question. A permission grant and an experiment go-ahead by
the copyright holder are first-stated author decisions (taste, scope):
unanticipatable by definition, the same class as the #632/#604/#288
maintainer-process dismissals. No juror seat, gate, or standing instruction has —
or should have — a lens for predicting how a thesis author will dispose of his own
copyright. The review process did not fail: it correctly flagged the question and
the author answered it. Clusters with the other new-direction dismissals on this
repo (a rights holder / maintainer steering already-correct work forward, never
work the panel got wrong).

**Actions.** Recorded the dismissal via `review-miss-record.sh` (idempotency key
`endojs-endo-but-for-bots-pr631-review-02a749af`, verdict not-a-miss). No cluster
minted, no threshold to evaluate, no improvement job — the expensive builder tier
is reserved for genuine misses. The sibling review on the same PR (4650709899,
"don't degrade figure quality to avoid asking permission") is a distinct comment
with its own parked retro (`...-pr631-review-fadcebc1-retro`) and is out of scope
here.

**Self-improvement.** I considered whether my own process on this retro had
friction worth encoding and found none: the idempotency pre-check, the
discriminator grounded in the design job's surfaced open-question, the store
writer, and the dismissal path all worked cleanly. The record leaves a durable
paper trail so this review is never re-litigated.
