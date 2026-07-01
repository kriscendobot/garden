# Gate: claude-md-inventory-drift

Catches roles and skills present on disk but missing from CLAUDE.md's
"## Current inventory" roster.

## What this gate catches

Every `roles/<r>/AGENT.md` (one level deep; juror seats under
`roles/jurors/<seat>/AGENT.md` are out of scope) and every
`skills/<s>/SKILL.md` whose directory basename does not appear as a
whole hyphen-delimited token in CLAUDE.md's "## Current inventory"
section. The whole-token boundary means `builder` is not considered
indexed merely because `web-builder` is listed, while a bare prose
mention such as "the triager" does count.

## The historical incident

Indexing the top-level inventory is a meta-doc edit reserved for the
liaison. A gardener or scholar that authors a new skill or role (its
own `SKILL.md` / `AGENT.md`, pushed to `main2`) cannot perform the
CLAUDE.md edit, so it falls back to a fire-and-forget self-improvement
note — a lossy path that lets the roster drift behind the dir set on
every authoring job.

The canonical incident: the 2026-06-30 scholar cycle
(`entries/2026/06/30/234719Z-result-gardener-391fc1.md`) authored and
pushed `skills/oauth-use-case-patterns/SKILL.md` to `main2`, but
CLAUDE.md still had zero mentions of it. At the time this gate landed,
the same drift had also left several v2 roles (`foreman`, `mentor`,
`proxy`, `watchman`) and skills (`message-bus`, `schedule`,
`self-healing-wrapper`) unindexed.

## When the gate fires

The runner ships the agent the focused brief at
`scripts/checks/claude-md-inventory-drift/prompt.md`. The brief routes
a focused liaison dispatch to add the missing backticked name(s) — and
a short descriptive clause where the entry is non-obvious — to the
Roles or Skills paragraph, purely additively. The fix is a CLAUDE.md
edit only; the role/skill artifact itself is not touched.

## How to disable

The gate is a pure roster-consistency check; there is no legitimate
"offending pattern" to allowlist. If a project carries no top-level
CLAUDE.md inventory (no `## Current inventory` section, or no
`roles/`/`skills/` layer), the gate passes silently. To stop
enumerating it entirely, move the gate's subdirectory out from under
`scripts/checks/` so `run-all.sh` no longer finds it.
