---
role: researcher
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T20:52:07Z cleared=none -->

---
role: researcher
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Copy-edit pass on the garden book

By the time this job runs, `journal/projects/garden-book/` should hold 10
chapters (the original 8 plus a new library-structure chapter and an
inference-tiers reference) and a titled `build/intro.html`, built from the
prior revision job. Read `build/README.md` for the build/publish mechanics.

## Task

Read every chapter in full and copy-edit for real: consistency of
terminology (the same mechanism shouldn't be called three different names
across chapters — pick the term each chapter-author actually grounded in the
source files and normalize the others to it), consistency of tense and
voice, clarity, dangling references ("as chapter 3 covers" pointing at the
wrong chapter after the ch9/ch10 insertion), redundant explanation now that
the book is unified (a term defined fresh in three different chapters can be
defined once and cross-referenced), and plain grammar/prose quality. Apply
the garden's own house style where it applies to prose you touch:
`skills/em-dash-style/SKILL.md`, `skills/no-latin-shorthand/SKILL.md`,
`skills/no-comment-banners/SKILL.md`.

This is a prose and structure pass, not a fact-checking pass — you're not
re-verifying every cited file path against the repo (the prior job already
did a coherence check); you're making the book read like it was written by
one hand, not eight independent authors stitched together. Don't rewrite
content wholesale; tighten, normalize, and connect it.

Edit the chapter files in `journal/projects/garden-book/` in place. Rebuild
and republish per `build/README.md`, update its Edition line (keep prior
editions listed as history), and report the new URL in your completion
report and via `scripts/jobs/message-user.sh <this-job-base>`.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-30T22:43:03Z -->
