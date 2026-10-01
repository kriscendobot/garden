---
gate: blocked
blocked_on: book-title-audience-pass
priority: normal
posted_by: producer
posted_at: 2026-10-01T20:09:17Z
---

---
role: builder
provider: openai
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book: generate illustrations and background art (Codex)

This job is deliberately dispatched to the Codex/OpenAI harness specifically
(the maintainer asked for a Codex job here, separate from the Claude job that
will integrate your output). You produce standalone art assets only — do not
edit the book's chapters, `build.py`, or `styles.css`; a separate follow-up
job does the integration.

## Brief

Produce a rich set of illustrations and background art for the garden book
(a published HTML book about an AI-agent fleet that tends software across
many repos, organized around a "garden"/"metamorphosis" metaphor — see
`journal/projects/garden-book/ch1-philosophy-history-metamorphosis.md` for
the framing if you want the flavor, though you don't need to read the whole
book to do this job).

**Style, firm requirements:**
- **Seamless with the surrounding page background and coloring** — these
  need to sit naturally behind or alongside text on a light page, not look
  like pasted-in clip art. Favor soft, low-contrast background textures and
  edge treatments (gradients that fade to the page background color, organic
  blob/leaf-shaped fills rather than hard rectangular boxes) over anything
  with a hard edge or a busy, attention-grabbing look.
- **A tidy pastel color scheme drawn from real garden colors** — earthy
  tones (soft terracotta, warm sand, muted browns), vegetable/leaf greens
  (sage, moss, fresh pastel green), and floral tones (dusty pink, lavender,
  soft yellow). Keep the palette disciplined and coordinated across every
  piece, not a grab-bag of unrelated colors.
- Illustrations **need not be figurative** — tileable background patterns,
  organic border/divider shapes, and abstract garden-texture art all count
  — but a few actual garden-themed figures or small illustrations (a
  trellis, leaves, a seed packet, a garden-bed pattern, a simple potted
  plant) would be a welcome addition if you have the budget for them.

**Technical constraints (hard requirements, not optional):** the book is
published as a minion.town clip, whose Content-Security-Policy is
same-origin only — **no external image files, no external fonts, no
raster-image generation pipeline**. Everything must be **inline SVG markup
and/or CSS** (gradients, `clip-path`, repeating patterns via SVG `<pattern>`
or CSS `background-image: repeating-...`) that a browser renders directly,
with no network fetch. Read `skills/minion-town-clip-publishing/SKILL.md`
for the exact CSP if you want the full detail. This is squarely a code-
authoring task (hand-written SVG/CSS), not image generation in the
DALL-E sense — play to that strength.

## Output

Save your work under `journal/projects/garden-book/art/` as a set of
self-contained files (one `.svg` or `.css`-snippet file per distinct piece —
a title-page background, a few chapter-divider motifs, a repeating texture
for body backgrounds, a couple of figurative pieces). Write a short
`journal/projects/garden-book/art/MANIFEST.md` describing each file: what it
is, the suggested use (title page / chapter divider / background texture /
standalone figure), and its exact color values (so the integration pass can
keep things consistent if it needs to adjust anything). Land these files on
`journal2` the same way other scholar/book content lands (a normal
journal commit, no project worktree needed — this is pure asset authoring,
not a code change to any project repo).

Do not attempt to build or publish the book yourself — that's the
follow-up job's work, once it reads your manifest.
