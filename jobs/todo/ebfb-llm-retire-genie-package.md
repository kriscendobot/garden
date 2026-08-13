---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Retire the genie package and its PLAN/TODO/TADA docs; make sandbox stand alone

Repository: `endojs/endo-but-for-bots`, branch **`llm`** (base the PR on `llm`).

Maintainer directive (kriskowal, 2026-08-13): propose a pull request that **deletes
the `genie` package** together with the `PLAN/`, `TODO/`, and `TADA/` directories,
and then **removes the references thereto from the `sandbox` package**, which was
extracted from genie. **The sandbox package must stand on its own** when the PR
lands — no dangling references to genie or to the deleted design docs, and no
behavior that depends on genie being present.

## Scope

1. Delete `packages/genie/` in full.
2. Delete the `PLAN/`, `TODO/`, and `TADA/` directories (11 / 1 / 172 files plus
   the provenance README).
3. Make `packages/sandbox/` self-contained: remove or rewrite every reference to
   genie and to the deleted docs — code comments, README/DESIGN prose, package
   metadata, test fixtures, and any workspace/dependency wiring. Where a comment
   cites a design decision by doc number (e.g. `// Non-zero exits are data, not
   errors — see TADA/60`), keep the *reasoning* in the comment and drop the dead
   citation rather than deleting the explanation.
4. Sweep the rest of the tree for references the deletion breaks — root workspace
   config, CI workflows, `designs/`, top-level README, any agent-instruction file
   (`AGENTS.md`/`CLAUDE.md`). Repo must build, lint, and test green with genie gone.

## Survey already done — start from it, then re-verify

A prior job (`genie-docs-delete-from-llm-r3`) surveyed the doc references at
`llm` HEAD `a54c3adb` and found **101 references across 43 files outside** the
three directories: **10 breaking markdown links** (in `designs/`,
`packages/genie/README.md`, `packages/genie/DESIGN.md`, `packages/sandbox/README.md`,
and `packages/genie/AGENTS.md`) and **~91 code-comment citations by doc number**
across genie/sandbox source and tests. Deleting `packages/genie/` removes many of
those sites outright, so **re-run the survey against your actual working tree**
rather than trusting the count; what matters is that zero dangling references
remain after your deletions.

## Preservation note (put this in the PR description)

The three doc directories are archived byte-identically in the garden's journal at
`library/endo-but-for-bots/` — but that journal is **private** and this repo is
**public**, so the journal is not a public home for the content. The public
preservation story is this repo's own git history: the content remains readable at
`https://github.com/endojs/endo-but-for-bots/blob/a54c3adb/…`. State that plainly
in the PR description. If any surviving markdown link is worth keeping as prose,
repoint it to a permanent `blob/a54c3adb/` permalink instead of deleting the
sentence.

## Definition of done

A pull request based on `llm` that stands on its own: genie deleted, the three doc
directories deleted, sandbox self-contained, no dangling references, full local
verification green (build, lint, tests), and a PR description that explains the
retirement and where the content is preserved. Keep the PR open; do not merge it.
