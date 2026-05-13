---
title: Commit conventions
source: AGENTS.md
source_repo: endojs/endo
source_commit: 052b0487e380b0d241de6b30f4b1c9a08b9226db
source_date: 2026-03-21
source_authors: [Turadg Aleahmad]
ingested: 2026-05-13
ingested_by: liaison
topics: [agent-conventions, repository-governance]
status: current
---

> Abstract: Endo uses conventional commits with a package scope: `feat(pkg):`, `fix(pkg):`, `refactor(pkg):`, `chore:`, `test(pkg):`. Breaking changes append `!` (e.g., `feat(pkg)!:`). File-type conversions (`.js` to `.ts`) get their own `refactor:` commit.

## Commit conventions

- Use conventional commits: `feat(pkg):`, `fix(pkg):`, `refactor(pkg):`, `chore:`, `test(pkg):`
- Breaking changes: `feat(pkg)!:` or `fix(pkg)!:`
- File conversions (`.js` to `.ts`) get their own `refactor:` commit

Source: [AGENTS.md](https://github.com/endojs/endo/blob/052b0487e380b0d241de6b30f4b1c9a08b9226db/AGENTS.md) at commit `052b0487`.
