---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-12T18:21:55Z
---
refs:
  - endojs/endo-but-for-bots#169:review:4680376639:retro (this retro)
  - endojs/endo-but-for-bots#169:review:4680376639 (review; primary endojs-endo-but-for-bots-pr169-review-ce5f9073)

# Retrospective on endojs/endo-but-for-bots PR #169 (review 4680376639) — DISMISSED

**Verdict: not-a-miss / new-direction.** Recorded at
`review-misses/dismissed/endojs-endo-but-for-bots-pr169-review-ce5f9073.md`.

PR #169 is a pure design-proposal document (`design: pass-style promise`, +1209 lines adding
`designs/pass-style-promise.md` plus a `designs/README.md` touch — no code, tests, or packaging).
The review body was empty; its two substantive maintainer (kriskowal) comments both land on the
proposed design itself, not on a work product a panel produced:

1. **Naming taste** on a novel primitive being *proposed* in the doc — how `subscribe` differs from
   `when`, floating `listen`/`watch`. No prior art to be consistent with; the design already carried
   the distinction as an open question. The primary loop answered by recording it as the doc's Open
   Question 11 for the maintainer's call.
2. **Scope directive** — "post a plan to create that design" (the separate debug-view ring-buffer doc
   the design flags as a future direction). A first-stated follow-up instruction, satisfied by parking
   the designer plan `endojs-endo-but-for-bots-design-promise-debug-view`.

Grounded in the PR's actual history: #169 ran no code panel because there is no code to review
(design-doc-only, confirmed by the two-markdown-file diff); no `*-gauntlet*`/`*-panel*` job for it
exists in `jobs/tada/`. A design doc is the *input* to review — a maintainer weighing in on a name and
requesting a follow-up plan is the ordinary design-iteration conversation the maintainer owns, not a
defect any juror seat, gate, or standing instruction should have caught. Textbook new-direction
dismissal (taste + scope + first-stated requirements).

Mints no cluster; no threshold to evaluate; no improvement job dispatched. Severity-bypass
precondition absent (nothing reviewed, no standing rule bound-and-failed). No garden-repo (`main2`)
changes were required.

_Self-improvement: none warranted — the idempotency pre-check, the review/data discriminator, and the
grounding in the PR's review history all behaved as `skills/review-retrospective/SKILL.md` prescribes;
this retro was cheap on a clean dismissal._
