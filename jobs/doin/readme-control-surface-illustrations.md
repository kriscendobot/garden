---
model: fable
---

# Document novel control-surface uses in the garden README

**Repo:** the garden's own repo (`kriskowal/garden`), branch `main2`. This is
garden-infra work: build in an **isolated worktree off `origin/main2`** (the
shared root tree is concurrently mutated) and **push directly to `main2`** — no
PR workflow for the garden's own repo (see CLAUDE.md § Conventions; precedent:
`journal/jobs/tada/issue-kriskowal-garden-13.md`).

**Model:** Fable (pinned above — the maintainer asked for it explicitly).

## The task

Mine the **journal** for **recent dispatches from maintainers** that demonstrate
**novel or instructive uses of the garden's control surfaces** — the orchestrator
vocabulary and the mechanisms behind it: job posting and the board, the message
bus, the plan queue, orchestration jobs, schedules, the gauntlet / PR-creation
chain, drain / stand-up / stand-down / restore, leader/follower designation,
deploy-on-upgrade, the ferry and identity-switch authorization, the watch sets
and their arming, model pinning, and any other lever a maintainer pulled in an
interesting way. Turn the vivid ones into **worked illustrations** in the garden
**README** until there are **about 40** such examples.

### Where to look (start here, walk the hierarchy — don't grep first)

- `journal/` context trees: `journal/projects/`, `journal/agents/`, and the
  message / directive history. Read the abstracts at the top of each directory
  README as routing decisions (skill [journalism], skill [context-library]).
- Maintainer directives specifically: dispatches, `message` entries addressed by
  or quoting the maintainer (`kriskowal`), and the completed-job `tada` reports
  in `journal/jobs/tada/` that record what a maintainer asked and how it was
  carried out.
- Cross-reference the vocabulary in CLAUDE.md § Orchestrator vocabulary and
  README § Key vocabulary so each illustration ties a real dispatch to the
  surface it exercised.
- Grep (`journal/entries/`, keyed by `project:` / `role:` / content terms) is the
  **fallback** when the hierarchy gives no entry point, not the first move.

### What makes a good illustration (selection bar)

- **Novel or instructive**, not the textbook one-liner. Prefer a dispatch that
  combined surfaces (e.g. "retcon and ferry #N", an orchestration decomposition,
  a schedule change raced to the journal, a follower stand-up) or used a lever in
  a non-obvious way. Skip rote repeats of the same pattern once it is illustrated.
- **Real and cited.** Each illustration is grounded in an actual journal entry /
  dispatch / tada report. Cite the `journal/...` path so a reader can verify it.
  Do not fabricate or embellish; an approximate paraphrase of a real dispatch is
  fine, an invented one is not.
- **Self-contained.** A reader who knows nothing about the episode should follow
  it from the narration alone.

### Organization and narration (the maintainer emphasized this)

- **Group by control surface** (board & jobs, message bus, plan queue,
  orchestration, schedules, gauntlet/PR chain, fleet ops, leader/follower &
  deploy, ferry & identity, watch sets, model selection, …), each group a short
  section with a one-paragraph lede explaining the surface before its examples.
- **Narrate each example**: the maintainer's phrasing / intent → the surface it
  pulled → what the garden did → why it was the right lever. A sentence or two
  each; well-formatted (a consistent per-example shape), not a raw list.
- Add a short intro to the collection explaining what it is (a living gallery of
  how maintainers actually steer the garden) and where new entries should go.
- Follow the garden's house style: em-dash style ([em-dash-style]), no Latin
  shorthand ([no-latin-shorthand]), no comment banners, relative links.
- Respect README altitude: if ~40 narrated examples would bloat the top-level
  README past a skimmable size, put the gallery in its own linked page (e.g.
  `context/` or a dedicated doc) and land a tight pointer + the intro in the
  README. Use your judgment against the [context-library] abstract-at-the-top
  contract; explain the placement choice in the completion report.

### Scale

Accumulate to **~40** illustrations. If the journal genuinely yields fewer novel
maintainer dispatches than that, document what you found, note the shortfall and
why in the completion report, rather than padding with rote or invented examples.

## Skills to read just-in-time

- [journalism](skills/journalism/SKILL.md) — the journal's layout, frontmatter,
  `refs:` chains, and the `kind:`/`role:`/`project:`/`to:` filters for the walk.
- [context-library](skills/context-library/SKILL.md) — abstract-at-the-top
  exit-criterion; the placement/altitude decision above.
- [em-dash-style](skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](skills/no-latin-shorthand/SKILL.md),
  [no-comment-banners](skills/no-comment-banners/SKILL.md),
  [relative-paths](skills/relative-paths/SKILL.md) — house style.
- [self-improvement](skills/self-improvement/SKILL.md) — the standing last step.

## Done

The gallery (in the README or a README-linked page) holds ~40 well-organized,
narrated, cited illustrations of novel maintainer control-surface uses, committed
and pushed directly to `main2`. The `tada` report states: where the gallery
lives and why, how many illustrations landed, the surfaces covered, the commit
SHA(s), and any shortfall against the ~40 target with its reason.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  claimed_at: 2026-07-10T18:43:11Z
