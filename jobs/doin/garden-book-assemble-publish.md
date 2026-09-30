---
role: researcher
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-30T07:21:05Z cleared=none -->

---
role: researcher
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Assemble and publish the garden book

The 8 chapters of `journal/projects/garden-book/` should now exist:
`ch1-philosophy-history-metamorphosis.md`, `ch2-architecture-operation.md`,
`ch3-using-the-garden.md`, `ch4-creating-your-own-instance.md`,
`ch5-roles-reference.md` (and possibly `ch5-roles-reference-part2.md`, ...),
`ch6-skills-reference.md` (and possibly `-part2`, `-part3`, ...),
`ch7-procedures-workflows.md`, `ch8-cybernetics-budgeting.md`. Read every
file actually present under that directory — include whatever follow-on
parts already landed by the time you run, but do not wait for ones that
haven't; note at the top of the published book which chapters were still
partial (a `-part2`/`-part3` job still in flight) as of publish time, so a
reader knows a fuller edition may follow.

## Task

1. Read all 8 (or more, with parts) chapter files in full.
2. Compose them into **one single self-contained HTML page** — a genuine
   book, not a dump of raw markdown: a title page / introduction, a table of
   contents with in-page anchor links to each chapter, then each chapter
   rendered as proper HTML (headings, lists, tables, code spans — convert
   the markdown faithfully, don't just wrap it in `<pre>`). Inline all CSS,
   no external assets (the clip's CSP is same-origin only — see
   `skills/minion-town-clip-publishing/SKILL.md`). Make it genuinely
   readable: reasonable typography, a sticky or at least easy-to-return-to
   table of contents, sensible heading hierarchy.
3. Do a coherence pass across chapters — fix any obviously duplicated
   explanations or contradictions between chapters written independently
   (a term introduced twice, a script path cited differently), but don't
   rewrite the substance; each chapter's author already grounded it in real
   source files.
4. Publish via `mcp__minion-town__publish` as a clip
   (`skills/minion-town-clip-publishing/SKILL.md`).
5. Report the resulting `<hash>.ocap.site` URL plainly in your completion
   report and via `scripts/jobs/message-user.sh <this-job-base>` to the
   maintainer inbox, naming which chapters (and parts) were included and
   which were still partial/pending at publish time.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T09:41:01Z
