---
role: web-designer
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-03T03:16:05Z cleared=none -->

---
role: web-designer
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design pass on the garden book

The final pass. By the time this runs, `journal/projects/garden-book/` holds
the full, copy-edited 10-chapter book and `build/` holds the working
HTML/CSS build (read `build/README.md` for the mechanics — `build.py`
generates `index.html` from the chapters plus `intro.html`; styling lives in
`styles.css`).

## Brief

Redesign the book's visual presentation. Take cues from **Edward Tufte** and
from **books on gardening** — two different, specific references, not a
vague "make it nice":

- **Tufte**: high data-ink ratio and minimal chartjunk — every visual element
  earns its place. Generous, deliberate whitespace rather than decoration.
  Restrained color used with purpose, not as ornament. Tight integration of
  marginal/sidenote material with the text it annotates, in the Tufte-CSS
  sidenote tradition (a citation, an aside, or a cross-reference living in
  the margin rather than interrupting the main text flow). Elegant,
  readable typography — a serif body face for sustained reading, a
  restrained sans for structural/UI chrome (headings, nav, captions), using
  only system/web-safe font stacks (the clip's CSP is `style-src 'self'`,
  so no Google Fonts or any external stylesheet — pick a stack that
  actually renders well cross-platform without one).
- **Gardening books**: an organic, cultivated visual language — think of
  how a good gardening book feels: seasonal structure, botanical
  illustration, a sense of things planted and tended and growing over
  time. An earth-and-leaf palette rather than a generic tech-docs blue.
  Simple inline SVG botanical motifs are fair game for chapter dividers or
  section marks if they're restrained and not decorative clutter (they
  don't violate the CSP — they're markup, not an external resource) — but
  only if they serve Tufte's "every element earns its place" standard
  too. The two references should reinforce each other: a gardening book's
  organic warmth, rendered with Tufte's discipline, not cartoonish.

## Constraints

- No external assets of any kind — no external fonts, images, or scripts;
  everything inline or same-origin (`skills/minion-town-clip-publishing/SKILL.md`
  documents the clip's CSP in full; read it).
- Respect both dark and light reading conditions if you have budget for it,
  but a single well-considered light theme done excellently beats a
  half-done light/dark toggle — don't sacrifice polish for a checkbox
  feature.
- Preserve the sidebar table of contents and anchor-link structure the
  prior editions built — you're redesigning its presentation, not removing
  the navigation.
- The book must stay genuinely readable at phone width as well as desktop —
  test both.

## Task

Redesign `styles.css` (and `intro.html`'s markup if it needs restructuring
to support the new design, and `build.py`'s HTML generation if the sidenote/
margin treatment needs structural hooks the current generator doesn't
produce — check before assuming you need to touch it). Rebuild and republish
per `build/README.md`. Update its Edition line (keep prior editions listed
as history). Report the new URL, and a short account of the specific design
decisions you made and how they trace back to the Tufte/gardening brief, in
your completion report and via `scripts/jobs/message-user.sh <this-job-base>`.
