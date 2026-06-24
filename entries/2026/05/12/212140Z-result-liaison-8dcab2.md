---
ts: 2026-05-12T21:21:40Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/204131Z-result-liaison-7e730d.md
---

Adopted the em-dash and relative-paths style rules garden-wide and swept
existing material in one engagement.

What changed:

- New `skills/em-dash-style/SKILL.md` and `skills/relative-paths/SKILL.md`
  on main `422a15a`. Both adapted from the references/endo-but-for-bots
  source. The relative-paths skill adds an explicit cross-tree exception
  the source did not need.
- `roles/COMMON.md` gained a Style section pointing to both skills, with a
  note that vendored content under `references/<source>/` is exempt.
- 12 garden-authored documents swept (all of CLAUDE.md, WORKTREES.md,
  references READMEs, every active role, every active skill). Roughly 140
  em-dashes rewritten by reading rather than mechanical substitution.
  Vendored material under `references/endo-but-for-bots/{roles,skills,
  CLAUDE,AGENTS}` left as-is.
- Vocabulary drift cleanup folded in: `coordinator` to `liaison` in three
  places where the legacy phrasing had survived; an example dispatch
  reference in COMMON.md updated; WORKTREES.md bootstrap commands
  simplified to drop the redundant `git -C /Users/kris/garden` prefix
  where cwd is the garden root.
- Follow-up commit `fd5c135` filled in the sweep SHA in the two new
  skills' Notes from the field (the value was not known until the sweep
  commit landed).

Procedural observations to fold in next time:

1. **Sweep + adoption in one engagement is faithful to user direction
   when explicitly given.** The source's pitfall ("don't sweep in a
   passing PR") is good guidance for projects with many contributors and
   long-lived noise; the garden has neither yet, and the user explicitly
   said "anywhere I am working." When in doubt, ask once.

2. **Skill files that demonstrate a rule must contain examples of what
   the rule forbids.** The em-dash and relative-paths skill files
   intentionally retain em-dashes and absolute paths inside code blocks
   and quoted prose to show what the rule covers. The grep-based sweep
   recipe in each skill exempts these by file scope, not by line scope;
   a stricter automated sweep would need to learn fenced-block awareness.

3. **The "fill in the SHA after the sweep commit lands" pattern needs a
   one-line follow-up commit.** Amending the sweep commit would be the
   minimum-noise approach, but the safety norm prefers new commits over
   amends. The follow-up is cheap; document it as the right pattern.

Self-improvement: skills/em-dash-style/SKILL.md, skills/relative-paths/SKILL.md,
roles/COMMON.md, plus 12 swept documents; first garden-wide style sweep,
validates the skill-canonical pointer pattern, and produced three
procedural observations worth keeping for future adoptions.
