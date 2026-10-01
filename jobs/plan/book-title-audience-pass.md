---
gate: blocked
blocked_on: garden-book-revision-orch
priority: normal
posted_by: producer
posted_at: 2026-10-01T20:03:46Z
---

---
role: researcher
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book: a sharper title, and a pass for the actual audience

By the time this runs, `journal/projects/garden-book/` holds the full
10-chapter book after content, copyedit, and design passes (orchestration
`garden-book-revision-orch`). Read `build/README.md` for the build/publish
mechanics; this is another revision on top of that, not a rebuild from
scratch.

## 1. A better title

The current title, "The Garden That Tends Code," is serviceable but not
evocative or pithy enough. Try again. The maintainer suggested **"Better
Code and Gardens"** (playing on "Better Homes and Gardens") as one option —
use it if it's genuinely the best fit, but don't feel bound to it if you
find something sharper; the brief is evocative and pithy, not "use this
exact phrase." Update `build/intro.html`'s title page (and anywhere else
the title is set, e.g. a `<title>` tag) accordingly.

## 2. Write for the actual audience, not the maintainer

The book's intended readers are:
- people interested in **using** an existing garden instance,
- people interested in **standing up their own** (the "metamorphosis" path —
  forking/creating a new instance), and
- people studying the garden's mechanics **academically** — as a system
  worth understanding on its own terms, not operating it.

**None of these readers is the maintainer** (kriskowal) or a fellow
maintainer of *this specific* garden instance. Read every chapter and find
language that implicitly addresses the maintainer directly or assumes the
reader already has standing authority over a live instance — direct
second-person asides that presume operational responsibility ("your
mandate," "when you muster," framing a decision as something "you" must
approve this week), named references to the current maintainer's own
specific decisions presented as ongoing narration rather than as
illustrative history, and anything that reads like an internal status
update rather than an explanation written for a new reader. Rewrite that
language to address the three audiences above instead: explain what a
maintainer role *is* and *does* in the system (third person, descriptive),
rather than speaking *as if to* one.

This doesn't mean stripping out concrete examples or history — a specific,
real anecdote (a named incident, an actual design decision) is exactly what
makes technical and academic writing credible, and should stay. The
distinction is between **narrating at a reader who is assumed to already be
the maintainer** (wrong register for this book) and **using real examples to
explain the system to someone who isn't** (right register). Chapters most
likely to need this pass: 1 (philosophy/history), 3 (using the garden), 4
(creating your own instance), and 8 (cybernetics/budgeting, which may
narrate maintainer-specific weekly engagements) — but read all 10, since the
tone drifted during independent parallel authorship and may show up
anywhere.

## 3. Rebuild and republish

Follow `build/README.md`. Update its Edition line (keep prior editions
listed as history, per the existing convention in that file). Report the new
title and the new URL in your completion report and via
`scripts/jobs/message-user.sh <this-job-base>`.
