---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T03:46:59Z cleared=none -->

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Garden book, chapter 6: Skills reference (exacting detail)

One chapter of a multi-part "book" (orchestration `garden-book-orch`). Write
to `journal/projects/garden-book/ch6-skills-reference.md` as Markdown. This
is the largest and most voluminous chapter — budget accordingly and expect
to need follow-on jobs (see below).

## Ground this in real sources — every skill file, actually read

The current inventory is listed in `CLAUDE.md` § Current inventory (over 100
skills as of this writing — confirm the live count against `ls skills/`,
since it changes). Read each `skills/<name>/SKILL.md`'s purpose, inputs,
procedure, and output sections; don't guess a skill's contents from its name.

## What this chapter should cover, per skill

A compact but genuinely informative entry per skill:

- **Purpose**, one to three sentences, in the skill's own terms.
- **When it's used** (which roles invoke it, or when in a procedure it fires).
- **Key mechanics worth knowing** — a skill file is often mostly procedure
  detail; pull out the two or three things that actually matter to someone
  deciding whether/when to reach for this skill, not a full transcription.
- **Notable gotchas or hard preconditions**, if the skill file calls any out
  explicitly (these are usually the most valuable lines in a skill file).

## Organize by theme, not alphabetically

Group into sections a reader would actually navigate by intent, for example:
PR lifecycle and review (pr-creation-flow, panel, panel-review, panel-hints,
pr-formation, pre-push-gates, pre-pr-checklist, worktree-per-pr,
frozen-base-branch, conflict-resolution, rebase-hygiene-audit,
retcon, yarn-lock-separate-commit, stacked-pr-build, ...); the job board and
coordination (job-board, message-bus, orchestration, schedule, bid-auction,
dispatch-worktree); the library and documentation (context-library,
library-lookup, journalism, self-improvement); code-quality and style norms
(em-dash-style, no-latin-shorthand, no-comment-banners, relative-paths,
rename-discipline, typist-friendly-code-points, changeset-discipline); the
security/trust surfaces (foreign-content-preclassification,
at-mention-surveillance, fully-qualified-github-urls); infrastructure and
ops (aws-administration, restore, host-disposition-report,
claude-usage-dashboard-scrape); and project-specific technical skills
(the ironhorse/test262/hardened262 family, the endo/daemon-specific skills,
the minion-town-specific skills). Pick groupings that make sense once you've
actually seen the full list — this is a starting suggestion, not a fixed
taxonomy.

## Budget and scope

Do not attempt full depth on 100+ skills in one cycle. Cover 25 to 35 skills
at real depth per cycle — start with the PR-lifecycle and job-board/
coordination groups (the skills a new user or role author most needs), write
what you have to the output file, and post a follow-on job named
`book-ch6-skills-reference-part2` (and `part3` if needed) naming exactly
which skills remain uncovered, so a chain of follow-ups completes the
chapter rather than one cycle silently skimming everything. Each follow-on
appends to the same output file; state clearly at the top of your
contribution which skills you covered this cycle.
