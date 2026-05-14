---
ts: 2026-05-14T23:07:07Z
kind: result
role: gardener
project: garden
to: "*"
refs:
  - entries/2026/05/14/230219Z-dispatch-liaison-c31b1c.md
---

# Result: gardener encoded "retcon" verb (skills/retcon + vocabulary)

Chose **Option A** per the dispatch's recommendation: the procedure is its own skill at `skills/retcon/SKILL.md`. The pr-formation skill stays focused on PR prose; retcon is a discrete commit-restructuring procedure and warrants its own file.

## One-line procedure summary

Reset PR branch to base (keeping net diff as working tree), restage one commit per affected package with conventional-commit messages, separate `chore: Update yarn.lock`, implementation and tests bundled together; force-push with `--force-with-lease`. The PR's net diff is invariant by construction; only commit grouping changes. Cites `skills/yarn-lock-separate-commit/SKILL.md` for the lockfile discipline.

## Files revised

- `skills/retcon/SKILL.md` (new) — fe45df3
- `roles/liaison/AGENT.md` — vocabulary additions: `retcon #N` under direct-dispatch (dispatches fixer), `retcon and ferry #N` under compound chain idioms, plus disambiguation note vs *weave*. 9ce8571
- `roles/steward/AGENT.md` — vocabulary mirror of the above (autonomous subset). 10a6aec
- `CLAUDE.md` — glossary row for `retcon #N`, compound-chain mention of `retcon and ferry #N`, inventory adds `retcon`. 2afd7e1

After rebase onto two intervening main pushes, the four commits landed on `origin/main` as `2dea99b` and prior.

## Disambiguation captured

- The retcon's load-bearing property: net diff invariant. Step 5 of the procedure verifies via two diffs (against the pre-retcon SHA, and against the base) before pushing.
- Retcon vs weave: weave moves the base; retcon does not. When the maintainer wants both ("weave then retcon"), weave runs first.

## Maintainer framing cited

The skill's *Notes from the field* row records the 2026-05-14 directive verbatim so future readers can see the verb's origin and the three disciplines it bundles (per-package grouping, lockfile separation, implementation+tests together).

Self-improvement: nothing this time. The dispatch was tight, the recommendation was sound, and the procedure fell out of the maintainer's own framing without further generalization needed. If a second retcon dispatch surfaces a wrinkle (e.g., when a cross-package refactor genuinely cannot be split per-package), the skill's *Capture grouping decisions* sub-section is where the lesson lands.
