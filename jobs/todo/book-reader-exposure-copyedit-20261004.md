---
role: researcher
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Copy-edit pass: track what the reader has been told, and stop assuming insider knowledge (kriscendobot/garden-book)

Maintainer (kriskowal, liaison 2026-10-04), in parallel with the illustration
and data-chapter productions already running (`book-illumination-and-data-orch-20261004`)
— this job is **independent of both**, posted directly, not gated behind
either:

> It would be beneficial for a copy editor to do a pass over each chapter
> monitoring terms and references that the reader may have already been
> exposed to, so that it knows whether to expect the reader to recall the
> reference, to need a short explanation, and a reference to the chapter or
> section where they can learn more. The prose as written sometimes appears
> to assume knowledge from the audience that isn't reasonable to expect if
> they are not the operator or among the maintainers of this garden. For
> example, the section on Cybernetics casually mentions the cybernetics
> audit, which was a procedure the maintainers undertook, but which is not
> explained and isn't even really germane to the audience. An audit
> occurred, and it shaped the garden. The shape of the garden is what is of
> interest.

This builds on, and should catch gaps left by, the earlier audience pass
(merged PR #3 — read it for the audience definition it already established:
readers interested in using the garden, metamorphosing their own garden for
their own purposes, or studying it academically — never the maintainer or an
operator of *this* instance).

## The worked example — your calibration anchor

The Cybernetics section currently treats "the cybernetics audit" as a thing
the reader already knows about, when it's really an internal maintainer
procedure that happened once, off-page. The fix is not "add a sentence
explaining what the audit was" — the audit's mechanics aren't germane to this
audience at all. The fix is to **talk about what it changed**: the audit is
backstory the reader doesn't need; the garden's resulting shape (whatever
practice, safeguard, or design decision the audit produced) is what's
actually interesting to someone trying to understand or build their own
garden. Find every passage with this shape — a casual reference to an
internal event, procedure, or decision-making moment that's standing in for
an explanation of its *consequence* — and rewrite it to foreground the
consequence, not the procedure. This pattern (not just this one example) is
the main thing this pass is for.

## The tracking artifact — internal only, never in the prose

Build a reading-order ledger of every term, concept, and internal reference
(role names, job-system vocabulary, events like "the cybernetics audit" or
other one-off incidents, coinages like "pin the merge base") the book uses:
where it's first introduced, what explanation (if any) it got there, and
every later chapter/section that mentions it again. Use this ledger to decide,
at each later mention, one of three things: **assume recall** (it was
explained clearly enough, recently enough, that a casual back-reference is
fine), **remind briefly with a pointer** ("as in Chapter 2's discussion of
—", a short clause, not a re-explanation), or **replace the casual reference
entirely** with the empathetic-reintroduction treatment from the worked
example above, when the thing being referenced is really an internal detail
standing in for a consequence the reader actually needs.

**This ledger must never appear in the published book** — not as a visible
appendix, glossary-as-written-by-a-robot, or inline annotation. It's a working
document for *you* (and future copy-edit passes) to maintain, not reader-facing
content. Keep it as a repo file **outside the generator's chapter-rendering
path** — check `build/README.md` and the current `build/build.mjs` (or
whatever the retooled generator's entry point now is, post-PR-#6) for how it
decides what's a chapter, and put the ledger somewhere it structurally cannot
get picked up (e.g. a top-level `editorial/reader-exposure-map.md`, well
outside wherever chapters live). Verify after your changes that a built
edition does not expose it as a page.

## Procedure

1. Read every chapter in full, in reading order (order matters — exposure is
   cumulative), including whatever the illumination/data productions may
   have already added if they've landed by the time you run (check
   `kriscendobot/garden-book`'s current `main` and PR list first).
2. Build the ledger as you go.
3. Revise prose using the ledger. You may parallelize the actual editing
   across chapters once the ledger exists (the way `book-title-audience-pass`
   split its audience pass across parallel editing agents and then reconciled
   the combined diff) — but build the ledger itself as one coherent,
   sequential read first; a parallelized first pass can't see "has this been
   explained yet" correctly.
4. Open one draft PR with the prose changes. Commit the ledger file in the
   same PR (or a separate small commit) so it's available for future passes;
   say explicitly in the PR body and your completion report where it lives
   and that it's editorial-only, never rendered.
5. Note any passage where you're genuinely unsure whether something is
   germane to the stated audience or not — leave those as explicit callouts
   in the PR body for a human read, rather than guessing silently either way.

## Scope and authority

`kriscendobot/garden-book` only. This PR will very likely touch the same
chapter files the illumination and data productions are also touching
concurrently — that's expected (the maintainer asked for this to run in
parallel), not a signal something's wrong. Don't block on them; open your PR
against current `main` and flag the likely conflict in the PR body for
whoever integrates last to resolve, the same way earlier concurrent book PRs
handled overlapping chapter edits. No upstream repos, no garden fleet/budget
config changes.
