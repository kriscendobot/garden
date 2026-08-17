---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

Repo: endojs/endo-but-for-bots (base `llm`)

MAINTAINER DECISION (kriskowal, 2026-08-17): delete the `PLAN/`, `TODO/`, and
`TADA/` directories from `llm`, repointing only the markdown links, and leaving
the code-comment citations alone.

PRECISE SCOPE. A prior audit found 101 references across 43 files outside those
three directories. They get DIFFERENT treatment:

- THE 10 BREAKING MARKDOWN LINKS: repoint each to a COMMIT-PINNED permalink into
  the garden's public archive (details below). These live in `designs/`,
  `packages/genie/README.md`, `packages/genie/DESIGN.md`,
  `packages/sandbox/README.md`, and `packages/genie/AGENTS.md`. That last is an
  AGENT-INSTRUCTION file, so make sure an agent following it still lands somewhere
  useful.
- THE ~91 CODE-COMMENT CITATIONS: LEAVE THEM EXACTLY AS THEY ARE. These are the
  trailing provenance gestures in shipping genie and sandbox source and tests,
  shaped like `// Non-zero exits are data, not errors — see TADA/60`. Do NOT
  rewrite them, do NOT insert URLs into source comments, do NOT delete the
  citation clauses. A short doc number reads better in a comment than a URL, and
  the archive is findable. Touching them is out of scope; a diff that does is
  wrong.

PERMALINK TARGET. The archive is at repo `kriscendobot/garden`, branch `journal2`,
path `library/endo-but-for-bots/`. That repo is PUBLIC and the copy is live and
byte-identical (verified: PLAN 11, TODO 1, TADA 172, plus a provenance README).
Note an earlier analysis called this a private journal; that was wrong.

Use a COMMIT-PINNED URL, not a branch URL:

    https://github.com/kriscendobot/garden/blob/<sha>/library/endo-but-for-bots/<PATH>

For `<sha>`, resolve it yourself and VERIFY rather than trusting these values.
Useful starting points: `174c3a976d` is the commit that added the archive
("docs: archive endo-but-for-bots planning trees"), and `a9e8618b5d2de822f71da1974cfe91ea78bd0769`
was the `journal2` tip when this job was written. `journal2` is an orphan,
append-only branch, so any commit containing the archive stays reachable. Pick ONE
sha and use it consistently across all 10 links.

BEFORE COMMITTING, fetch each of the 10 permalinks you construct and confirm it
resolves to the intended document. A dead permalink is worse than the dangling
relative link it replaced, because it looks authoritative. If any target document
cannot be located in the archive, STOP and report which one rather than guessing
at a path.

ALSO: `llm` has not moved from the migration source commit `a54c3adb`; confirm
that still holds before deleting, and if `llm` HAS advanced, re-verify that the
archive is still byte-identical before proceeding.

PR note: state that the three directories were removed, that the content is
preserved publicly at `kriscendobot/garden@journal2:library/endo-but-for-bots/`
and in this repo's git history at `a54c3adb`, that the 10 markdown links now point
at commit-pinned permalinks into that archive, and that the historical
doc-number citations in code comments were deliberately left untouched. Do NOT
force merge.
