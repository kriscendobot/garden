---
gate: blocked
blocked_on: book-illumination-and-data-orch-20261004
priority: normal
posted_by: producer
posted_at: 2026-10-04T04:56:07Z
---

---
gate: blocked
blocked_on: book-illumination-and-data-orch-20261004
priority: normal
posted_by: producer
posted_at: 2026-10-04T04:40:00Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: researcher
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Follow-up: make every reference in Better Code and Gardens an actual hyperlink (kriscendobot/garden-book)

Maintainer (kriskowal, liaison 2026-10-04): "go through the entire document
ensuring that every reference is a hyperlink, not just textual section
references."

## Why this is parked on the orchestration, and what to check beyond it

You were promoted because `book-illumination-and-data-orch-20261004` (the
illustration production, then the data/equilibrium chapter production,
serial) reached a terminal `tada/` report. That orchestration reaching
`complete` means its own children's PRs merged, but **there is a third,
independent, concurrent production you must also check**:
`book-reader-exposure-copyedit-20261004` (the reader-exposure-tracking
copy-edit pass), which was posted to run in parallel and is not part of this
orchestration at all.

Before doing any work:
1. Read `book-reader-exposure-copyedit-20261004`'s `jobs/tada/` report for its
   PR URL (if the job hasn't completed yet at all, that counts as "not
   ready," same as below).
2. Check that PR's real state via `gh pr view <url> --json state,mergedAt,isDraft`
   — never assume from the job's mere completion (the same
   "wait for the real artifact" discipline `skills/chained-followup/SKILL.md`
   and this book's own `book-illustrations-integrate` job already used for
   exactly this kind of multi-producer wait).
3. If it's missing, still running, or open/unmerged: park a notice that
   waits for it (prefer `blocked_on` the PR URL directly if you have it —
   resolves on merge OR close — else the job's own basename), with a body
   that repeats this same check when promoted. Do not proceed on a guess. If
   it was closed without merging, message the maintainer
   (`scripts/jobs/message-user.sh <this-job-base>`) naming it and stop that
   thread rather than hyperlinking a book that's about to change again
   underneath you.
4. Only once it's confirmed merged (or was never going to produce a
   conflicting structural change — your call, state your reasoning): proceed
   with the actual task on current `main`.

This matters because all three productions (illustrations, data chapter,
copy-edit) could plausibly add or renumber chapters/sections, and this job's
entire point is that cross-references point at the *current, correct*
targets — running it against a half-settled document would just mean doing
it again.

## The actual task

Walk every chapter and any front-matter (title page, table of contents,
edition history in `build/README.md` if it's reader-facing) for anything that
*reads* as a reference but isn't an actual `<a href>`:

- **Cross-references within the book** ("as in Chapter 2", "see the section
  on Cybernetics", "discussed above/below", table-of-contents entries) must
  be real anchor links to the actual chapter/section heading id the
  generator assigns — read how the current generator (post-PR-#6 JS retool;
  check `build/build.mjs` or equivalent, and `build/README.md`) assigns
  heading anchors (likely `markdown-it-anchor` slugs) and link to those
  exactly, not a hand-guessed slug that can drift.
- **External references** (PR/issue numbers, repo names, design doc names,
  anything citing `endojs/endo-but-for-bots`, `kriscendobot/*`, or similar)
  that are currently bare text (e.g. "PR #282" or "endo-but-for-bots#1015"
  with no link) should become real hyperlinks to the actual
  `https://github.com/...` URL. Verify each one actually resolves (a quick
  `gh api` / `gh pr view` check, or at minimum a well-formed URL you're
  confident in) rather than inventing a plausible-looking but dead link.
- **Figure/illustration references**, if the illumination production added
  any ("see the illustration above/below", named figures), should link to
  the image itself (an in-page anchor) where that makes sense.
- Leave plain narrative prose alone — this is about things that are already
  *functioning as references* in the text, not adding new cross-references
  that weren't there.

Verify after your changes: every internal link actually resolves to a real
anchor in the built output (click-test or script-check a built edition, not
just the source markdown), and the build still passes
`build/README.md`'s documented verification steps.

## Output

Open one draft PR against current `main` (one PR per job, this repo's
convention). Note in the PR body and your completion report roughly how many
references you converted and any you deliberately left as plain text with a
reason (e.g. a reference too vague to resolve to one specific anchor). Once
merged, publish per `build/README.md` and record the new edition.

## Scope and authority

`kriscendobot/garden-book` only. No upstream repos, no garden fleet/budget
config changes.
