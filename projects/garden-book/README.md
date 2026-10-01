# Project: garden-book

The source for a book about the garden itself:
[kriscendobot/garden-book](https://github.com/kriscendobot/garden-book).
Audience is people interested in using an existing garden instance, standing
up their own ("metamorphosing" one), or studying the garden's mechanics
academically — **not** the maintainer or a fellow operator of this specific
instance; content addressed at "you, the maintainer running this garden" is
a defect in the book, not house style.

## Rules of engagement

- **Content lives in the repo, not the journal.** `chapters/ch<N>-<slug>.md`
  (a chapter may split across `-part<M>` files for large chapters) and
  `build/` (the assembler + publisher, see `build/README.md` in the repo for
  the exact steps and the current live edition's URL). The garden's own
  `journal2` is not the source of truth for book content as of 2026-10-01 —
  this README is the only garden-side artifact for this project.
- **Changes land as PRs, reviewed like any other garden-maintained
  project** (draft → gauntlet → merge), not as direct commits to `main` —
  unlike `minion-town`'s build/config carve-out, there's no equivalent
  "doesn't want pre-deploy review" class of change here; every edit is
  editorial judgment worth a pass.
- **Publishing is a separate, explicit step from merging.** A merged PR
  changes the chapters/build tooling; it does **not** automatically
  republish the live book. Run `build/README.md`'s build+publish steps
  (which call `mcp__minion-town__publish` via the minion-town MCP bridge) as
  its own follow-up action, and record the new edition's URL in
  `build/README.md`'s edition history (keep prior editions listed, never
  overwrite the list).
- **Illustrations and background art** live under `art/` in the repo (not
  yet created as of 2026-10-01) with a `MANIFEST.md` describing each asset,
  its suggested use, and its palette — see any `art/`-producing job's own
  instructions for the current style direction (pastel, earthy/vegetable/
  floral, same-origin SVG/CSS only per the clip's CSP).

## Identity and credentials

- The repo is owned by the bot (`kriscendobot`); commits carry the bot
  identity. No ferry or identity switch is involved.
- Publishing goes through the standing minion-town MCP connection
  (`context/operations/minion-town-mcp.md`), not a separate credential.
