---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-03T03:36:11Z cleared=none -->

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
will integrate your output). You produce standalone art assets and open a
draft PR with them — do not edit the book's chapters, `build.py`, or
`styles.css` beyond adding your new asset files; a separate follow-up job
does the integration into those.

**Repo update (2026-10-01): the book now lives at
[kriscendobot/garden-book](https://github.com/kriscendobot/garden-book)**,
not in the journal. Read `journal/projects/garden-book/README.md` for the
project's rules of engagement before starting. Work in a normal project
worktree of that repo.

## Brief

Produce a rich set of illustrations and background art for the garden book
(a published HTML book about an AI-agent fleet that tends software across
many repos, organized around a "garden"/"metamorphosis" metaphor — see
`chapters/ch1-philosophy-history-metamorphosis.md` in the repo for the
framing if you want the flavor, though you don't need to read the whole book
to do this job).

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

## Output: a draft PR, not a build

Add your files under `art/` in the repo (one `.svg` or `.css`-snippet file
per distinct piece — a title-page background, a few chapter-divider motifs,
a repeating texture for body backgrounds, a couple of figurative pieces),
plus a short `art/MANIFEST.md` describing each file: what it is, the
suggested use (title page / chapter divider / background texture /
standalone figure), and its exact color values (so the integration job can
keep things consistent if it needs to adjust anything). Commit on a branch
and open a draft PR against `main` (one PR per job, via `ensure-pr.sh`).

Do not attempt to build or publish the book yourself — that's the
follow-up job's work, once your PR merges and it reads your manifest.
Report the PR URL plainly in your completion report.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-03T05:06:58Z
