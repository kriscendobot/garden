---
ts: 2026-05-13T01:47:44Z
kind: result
role: gardener
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/014210Z-dispatch-liaison-9c3ae6.md
---

# Journalist role landed

Authored `roles/journalist/AGENT.md` plus the interlock edits to `CLAUDE.md`, `roles/liaison/AGENT.md`, `roles/review-queue/AGENT.md`, and `roles/steward/AGENT.md`. Two commits on `main`, one push.

## Design choices in the role file

**Milestone-mapping rule.** The endo roadmap at `endojs/endo-but-for-bots@llm:designs/README.md` carries a *Per-Design Estimates* table (under `### Per-Design Estimates`) that explicitly maps each design slug to a milestone integer (0 through 6). That table is the authoritative lookup. The journalist's classifier walks each PR row in order: (1) match the PR title slug against design filenames (Conventional-Commit-style, e.g. `feat(daemon-mount): …` matches `designs/daemon-mount.md`, look up its milestone in the table), (2) if no title match, scan the table's Notes column for an inline PR-number reference (the column frequently names `PR #134`, `PR #128 reshape blocker`, etc.), (3) repository-binned fallback. I picked this rule because the roadmap already does the design-to-milestone work explicitly; the journalist's job is just lookup. The fallback bin handles PRs against `Agoric/agoric-sdk`, `endojs/endo`, `agoric-labs/*`, and the other repos the endo-but-for-bots roadmap does not cover. Status `**Complete**` / `Implemented` / `Deprecated` rows still classify under their milestone (the row stays until the review-queue daemon drops it); I did not want the journalist guessing at row retirement.

**Designs directory shape.** The `designs/` tree is flat (one file per design, plus a single `README.md` index, plus a `CLAUDE.md` style guide and a `channel threads/` subdirectory I left alone). Every individual design carries a metadata table with a Status field but no milestone field; milestones live only in the README. So the README is the *only* milestone source and the role file says so.

## Section-ownership split

- *Pending kriskowal reviews* (`<!-- BEGIN/END pending-kriskowal-reviews -->`): renderer moved from review-queue to journalist. The review-queue role now produces only a `tick` recording the daemon's ADD/REMOVE deltas; the journalist consumes `/tmp/garden-review-queue/current.json` directly.
- *PR backlog* (`<!-- BEGIN/END pr-backlog -->`): journalist reorganizes existing rows into milestone bins. Steward and per-PR roles still post and clear rows; the journalist does not invent or retire.
- Everything else in `journal/README.md` stays with whichever role posts to it.

## Commits

- `0b0b464`: journalist role: bulletin-board maintainer (milestone-classified review queue + repo-binned remainder). Contains `roles/journalist/AGENT.md` (65 lines, frontmatter-stamped 2026-05-13).
- `c5c1207`: inventory and orchestration: enumerate the journalist role; interlock with review-queue and steward. Touches `CLAUDE.md`, `roles/liaison/AGENT.md`, `roles/review-queue/AGENT.md`, `roles/steward/AGENT.md`.

Pushed: `ae694de..c5c1207  HEAD -> main`.

## Messages routed back

No surplus authority or blocking findings; the dispatch was clean. Two operational observations worth flagging to liaison:

1. The dispatch entry the dispatch prompt told me to read (`014210Z-dispatch-liaison-9c3ae6.md`) was not present in the dispatch's journal worktree at start. It may have been created concurrently or skipped; either way, the dispatch prompt itself carried enough context that the missing entry did not block the work. Worth confirming the liaison's `Per-dispatch worktree triple` norm landed for this dispatch.
2. The journalist's first real rewrite is a separate dispatch the steward fires once this lands. Reasonable next-cycle work: a steward dispatch (or a liaison hand-driven one) that exercises the role end-to-end on the current canonical set and PR backlog. Expect the unclassified bin to capture every non-`endo-but-for-bots` PR in the current set, plus a handful of `endo-but-for-bots` PRs whose titles do not map cleanly (e.g. the `re-opened from #N under the bot` re-creations frequently retain old titles that no longer slug-match the active design).

Self-improvement: roles/journalist/AGENT.md (new), plus interlock edits to CLAUDE.md, roles/liaison/AGENT.md, roles/review-queue/AGENT.md, roles/steward/AGENT.md. The role split between the review-queue (data) and journalist (rendering) lets each evolve independently; if the milestone-mapping rule needs sharpening later, only the journalist file changes.
