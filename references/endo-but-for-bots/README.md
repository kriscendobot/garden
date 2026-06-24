---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Reference: endojs/endo-but-for-bots

A snapshot of the garden materials from the `garden` branch of [endojs/endo-but-for-bots](https://github.com/endojs/endo-but-for-bots). Used as a reference shelf; see [`../README.md`](../README.md) for how references work.

## Source

- Repo: `endojs/endo-but-for-bots`
- Branch: `garden`
- Commit: `cc79140a6` (2026-05-11)
- Imported: 2026-05-12

To refresh against upstream:

```sh
git -C <garden-root>/worktrees/endojs-endo-but-for-bots.git fetch origin garden
# Then re-copy roles/, skills/, CLAUDE.md, AGENTS.md from the worktree.
# Replace the commit SHA above and bump `updated:`.
```

The live working tree of the `garden` branch is at `../../worktrees/endojs-endo-but-for-bots/integrate--liaison--20260512-194515/` (subject to collection per [`../../WORKTREES.md`](../../WORKTREES.md); the snapshot here is the durable copy).

## What's in this shelf (as of 2026-05-14 audit)

The original snapshot held 26 role files and 47 skill files. After the 2026-05-14 audit against the active library, most have been adopted and removed; the residual shelf carries only the roles and skills the garden has not yet incorporated.

- [`roles/`](./roles/): 7 residual role files (chronicler, juror, marshal, namer, scribe, stratego, triager). See [`roles/README.md`](./roles/README.md) for the per-role rationale and the adopted-list.
- [`skills/`](./skills/): 16 residual skill files split into generic-future-use (7) and endo-specific lore awaiting migration to `journal/projects/endo/` (9). See [`skills/README.md`](./skills/README.md).
- [`CLAUDE.md`](./CLAUDE.md): the project-level guidance loaded by Claude Code at the bots repo's root. Heavily endo-flavored (SES, harden, JSDoc, Yarn workspaces, Exo); useful as context for what an adopted endo role assumes about the host project.
- [`AGENTS.md`](./AGENTS.md): short agent-instruction file alongside CLAUDE.md; mostly TypeScript / type-export conventions for endo packages.

## What's *not* in this shelf

- `process/`: the live coordination state for that garden (per-PR / per-issue / per-cycle files). We chose not to import these; they are state, not library, and would not translate cleanly into our orphan-branch journal model. If a specific process pattern needs to be adopted, do it via the relevant skill (e.g., [`skills/process-documents.md`](./skills/process-documents.md), [`skills/pr-cycle-state.md`](./skills/pr-cycle-state.md)).
- `designs/`, `PLAN/`, `TADA/`, `TODO/`, and the endo source tree: project-specific coordination archives and the upstream code. Reachable via the worktree if ever needed.

## Naming and convention drift

When adopting from this shelf, expect to rewrite:

- **Names.** Our `liaison` is broader than theirs (which manages bots-repo issues). Their `steward` is closer to our `liaison`. Adopt with our names; do not import the `liaison` role from this shelf without renaming.
- **State paths.** Roles here reference `process/tracking/<N>.md` and similar. Our equivalent is a `message`-kind journal entry tagged with a `project:` slug; rewrite during adoption.
- **Project specifics.** Sections in CLAUDE.md and many skills speak directly to endo conventions (SES intrinsics, Exo, surface modules, yarn-lock discipline). When the convention is endo-only, keep it endo-only. Record it as a `project: endo` journal entry, not as a generic role/skill rule.
- **File layout.** Single-file `<name>.md` here vs our `<name>/AGENT.md` and `<name>/SKILL.md`. Adoption means creating the directory and renaming.

## How to adopt a role or skill from here

1. Confirm with the user that adoption is wanted.
2. Choose our name (often different from theirs).
3. Create `roles/<our-name>/AGENT.md` or `skills/<our-name>/SKILL.md` with our document frontmatter.
4. Translate the body: rename role/skill references, replace `process/` references with journal-equivalents, drop endo-specific clauses unless the role is being adopted as endo-specialized.
5. Commit on `main` with a message that cites the reference path: `<our-name>: adopted from references/endo-but-for-bots/roles/<their-name>.md`.
6. Write a journal entry recording the adoption and the differences from the source.
