# Per-role job board: conductor

Per-role job board for the conductor.
Posted by drivers when the state machine reaches `[approved+green]` (the maintainer approved, CI is green); claimed by conductor workers.

The conductor's `gh pr merge` invocation is implicit; the conductor's role file (`<garden-root>/roles/conductor/AGENT.md`) names the canonical merge method. The driver does not override the conductor's choice via the job body.

Phase 1 scaffolds the directory structure only.

See `<garden-root>/designs/driver.md` § Role-specific job boards.
