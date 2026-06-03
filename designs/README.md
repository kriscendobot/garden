# Garden designs

Meta-designs for the garden itself: architectural proposals for how the garden's roles, skills, journal, and host infrastructure should evolve. Each design is one Markdown file in this directory, named after the design's short slug.

Project-specific designs (e.g. for `endojs/endo-but-for-bots`) do not live here; they live under that project's upstream repo (typically `designs/<slug>.md` on a roadmap branch like `llm`). The garden's own infrastructure is the subject of this directory.

## Convention

Each design carries a metadata table at the top:

| Created | YYYY-MM-DD |
| Author  | <role-or-name> |
| Status  | Proposed \| Accepted \| Implemented \| Withdrawn |

Status semantics:

- **Proposed**: the design has a PR open against the garden and is under maintainer review. The PR is the discussion venue.
- **Accepted**: the maintainer has approved the design; implementation is in flight or queued. The merged design document is the canonical statement of the agreed approach.
- **Implemented**: the roles / skills / scripts described by the design exist on `main` and are in active use. The design document remains as historical context.
- **Withdrawn**: the design was opened but not adopted. The document remains as the record of what was considered and why it was not pursued.

## PR-against-garden exception

The garden's `CLAUDE.md` § Conventions states that the garden does not generally open pull requests against itself. Garden designs are the deliberate exception: a substantial architectural change is opened as a PR so the maintainer can review and comment in GitHub's PR interface, rather than landing directly on `main`. Smaller changes (single role edits, skill additions, notes-from-the-field rows) continue to land directly on `main` per the existing convention.

## Index

| Design | Status | Summary |
| --- | --- | --- |
| [driver.md](driver.md) | Proposed | Pivot the PR-creation flow from claude-on-top orchestration to claude-under-script worker pool with role-specific job boards. |
