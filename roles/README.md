# roles

Operating briefs for the agent **roles** the garden can dispatch.

Defined: `gardener` (job consumer), `triager` (per-repo job producer),
`watchman` (watches `main2`, broadcasts evolution), `liaison` (human-facing;
maintainer inbox + local ops). See [`designs/job-board.md`](../designs/job-board.md).

## Convention

- `roles/<role>/AGENT.md` — operating brief for one role: purpose (one line),
  skills it uses (linked), operating norms, definition of done. Kept short.
  Role files do not repeat anything in `COMMON.md`.
- `roles/COMMON.md` — standing instructions every dispatched subagent reads
  first (not yet written).
- `roles/jurors/<seat>/AGENT.md` — operating brief for one jury seat, dispatched
  only by a judge role, never by an orchestrator directly.

Files are named `AGENT.md` (not `CLAUDE.md`) on purpose, so they are not
auto-loaded into a subagent's context; a dispatched subagent loads its role
file explicitly.
