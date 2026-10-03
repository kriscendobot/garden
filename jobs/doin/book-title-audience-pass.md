---
role: researcher
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-03T03:36:25Z cleared=none -->

---
role: researcher
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book: a sharper title, and a pass for the actual audience

**Repo update (2026-10-01): the book now lives at
[kriscendobot/garden-book](https://github.com/kriscendobot/garden-book)**,
not in the journal. Read `journal/projects/garden-book/README.md` for the
project's rules of engagement (PR-reviewed, like any garden-maintained
project) before starting. Work in a normal project worktree of that repo;
chapters live at `chapters/ch<N>-<slug>.md`, build tooling at `build/` (see
`build/README.md` in the repo for the current edition's URL and the
build/publish steps — do not run them yourself in this job; see the note at
the end on why).

## 1. A better title

The current title, "The Garden That Tends Code," is serviceable but not
evocative or pithy enough. Try again. The maintainer suggested **"Better
Code and Gardens"** (playing on "Better Homes and Gardens") as one option —
use it if it's genuinely the best fit, but don't feel bound to it if you
find something sharper; the brief is evocative and pithy, not "use this
exact phrase." The title is set in three places — `build/intro.html`'s title
page, and `build.py`'s `<title>` tag and sidebar nav — update all three
together (called out in `build/README.md`'s edition history for exactly
this reason).

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

## 3. Open a draft PR and stop there

Commit your changes on a branch and open a draft PR against `main` on
`kriscendobot/garden-book` (one PR per job, via `ensure-pr.sh`). That's the
end of this job's scope — do not build or publish. Publishing only makes
sense against the merged `main`, and merge timing (and coordinating it with
the separate illustrations work in flight) is the final integration job's
concern, not yours. Report the PR URL plainly in your completion report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T03:40:34Z
