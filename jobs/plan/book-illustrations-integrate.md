---
gate: blocked
blocked_on: book-codex-illustrations
priority: normal
posted_by: producer
posted_at: 2026-10-01T20:09:47Z
---

---
role: web-designer
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book: integrate the Codex-generated illustrations and publish

A separate Codex job (`book-codex-illustrations`) has produced a set of
illustration/background-art assets under
`journal/projects/garden-book/art/`, with a manifest at
`journal/projects/garden-book/art/MANIFEST.md` describing each piece, its
suggested use, and its color values. Read that manifest and every asset it
lists before doing anything else.

By this point the book has also been through a title/audience revision
(`book-title-audience-pass`) on top of the original content/copyedit/design
passes — read `build/README.md` for the current state and build mechanics.

## Task

1. **Integrate the art with judgment, not by pasting everything in.** The
   prior design pass already established a Tufte-influenced, garden-book-
   inspired visual language (restrained, high data-ink-ratio, earth-and-leaf
   palette) — these new illustrations should extend and harmonize with that,
   not compete with it or clash in color/tone. Use your own judgment on
   which pieces actually earn a place (title page background, chapter
   dividers, a body-background texture, a figure placed where it genuinely
   adds something) versus which should be left unused because they don't fit
   well once you see them in context. Cite which you used and why, and which
   you skipped and why, in your completion report.
2. **Keep it inline and same-origin.** The assets are already SVG/CSS per
   the Codex job's brief; fold them into `styles.css` / the HTML generation
   in `build.py` as inline markup, not as separate fetched files (the clip's
   CSP is same-origin only — see `skills/minion-town-clip-publishing/SKILL.md`
   if you need the exact constraint again).
3. **Don't regress readability or the phone-width layout.** Background art
   behind body text needs to stay low-contrast enough that text stays
   genuinely readable; check phone width too, the way the original design
   pass did.
4. Rebuild and republish per `build/README.md`. Update its Edition line
   (keep prior editions listed as history). Report the new URL, which
   illustrations you used and where, and which you left out, in your
   completion report and via `scripts/jobs/message-user.sh <this-job-base>`.
