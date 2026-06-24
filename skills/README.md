# skills

Self-contained playbooks for individual **capabilities**. A role references
skills by path and reads them just-in-time; skills never get inlined into a
role file.

Defined: `job-board` (claim/complete CAS), `message-bus` (inbox + topic +
maintainer channel), `schedule` (recurring jobs), `dispatch-worktree` &
`worktree-per-pr` (ephemeral worktrees). Executables live under
[`scripts/jobs/`](../scripts/jobs/); see [`designs/job-board.md`](../designs/job-board.md).

## Convention

- `skills/<skill>/SKILL.md` — one capability. Sections: purpose, inputs, state
  (if any), procedure, output shape, notes.
- Executable helpers a skill needs live alongside its `SKILL.md` (e.g.
  `skills/<skill>/<helper>.sh`).

Files are named `SKILL.md` (not `CLAUDE.md`) on purpose, so they are not
auto-loaded into a subagent's context; they are read explicitly when a role
calls for them.
