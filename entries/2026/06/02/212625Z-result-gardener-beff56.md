---
ts: 2026-06-02T21:26:25Z
kind: result
role: gardener
host: endolinbot
repo: kriskowal/garden
project: garden
refs:
  - entries/2026/06/02/212500Z-dispatch-liaison-beff56.md
  - https://github.com/endojs/endo-but-for-bots/pull/351 (motivating incident, inline 20:45:07Z)
---

# result: gardener — no-latin-shorthand encoded per kriskowal #351

Landed the gardener half of the kriskowal #351 directive ("Please avoid Latin. Dispatch to gardener to improve style guide."). The fixer half had already landed the code fix on `packages/compartment-mapper/src/link.js` line 73 plus a whole-file scan.

## Files changed (garden main, commit `062c3579`)

- **Created** `skills/no-latin-shorthand/SKILL.md` (new file, 67 lines). Sections: the rule, replacement table (`cf.`, `i.e.`, `e.g.`, `etc.`, `et al.`, `vs.`, `viz.`, `ad hoc`), the borderline `via` note, scope (bot-authored prose, fix on encounter, references-exempt), how to write the change, motivating incident citation, pitfalls (don't over-rewrite quoted maintainer prose; don't sweep in passing; `vs.` in compact contexts is a judgment call), and notes-from-the-field with the 2026-06-02 adoption note.
- **Edited** `CLAUDE.md` § Current inventory skills list: added `no-latin-shorthand` between `relative-paths` and `agent-termination`. One-line change.
- **Edited** `roles/COMMON.md` § Style: expanded from "Two prose-style rules" to "Three prose-style rules" and added the `no-latin-shorthand` bullet alongside the existing `em-dash-style` and `relative-paths` bullets. Updated the exemption line to "all three" instead of "both". This is the one-line cross-reference the dispatch authorized; the existing § Style section was the natural prose-conventions slot, so no new section was created.

## Scope of skill (as encoded)

- Applies to bot-authored prose only; maintainer prose preserved verbatim.
- Fix on encounter, no sweep. The skill calls this out explicitly under both *Scope* and *Pitfalls* (don't sweep in passing).
- `references/<source>/` exempt for the same reason em-dash-style exempts it.
- `via` flagged as borderline / fully assimilated, acceptable.

## Push outcome

`git push origin HEAD:main` clean fast-forward: `c6ad5dc4..062c3579`. No PR per `CLAUDE.md` § Conventions (no PR workflows for the garden's own repo).

## Not authorized, not done

- No sweep of existing files for Latin shorthand (per dispatch *Not authorized* and skill scope).
- No new prose-conventions section created; only the one-line cross-reference in the existing `roles/COMMON.md` § Style was added.
- No force-push.

Self-improvement: nothing this time. The dispatch was tightly scoped and the skill shape mirrored existing precedent (`em-dash-style`, `relative-paths`) closely enough that no new skeleton-level pattern emerged. The one observation worth noting (in *Notes from the field* on the new skill itself, not as a separate self-improvement) is that the motivating incident named a single shorthand (`cf.`) but the encoded norm covers the full Latin shorthand category. The maintainer's directive generalized via the phrase "avoid Latin", not "avoid `cf.`".
