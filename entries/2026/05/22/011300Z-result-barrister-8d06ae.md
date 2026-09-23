---
ts: 2026-05-22T01:13:00Z
kind: result
role: barrister
worktree: dispatches/judge--8d06ae/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/005611Z-result-builder-23d295.md
  - entries/2026/05/22/005836Z-result-cleaner-653bfc.md
---

# Barrister round 1 on PR #344 (`docs: populate READMEs`)

PR: endojs/endo-but-for-bots#344 (mirror of endojs/endo#3047). Branch `mirror/3047-readmes`, post-weave head 1fa8102b6. Author kriscendobot; the gh-authenticated identity is also kriscendobot (the bot fork).

The dispatch was framed as "judge" with the note that the role split into solicitor / barrister / justice on 2026-05-21. Discriminator: source-touching PR (one .js tweak in `packages/netstring/reader.js` plus the CONTRIBUTING.md addition), no prior panel verdict on this PR. Picked **barrister**.

**Panel kind:** code-panel (narrowed for docs-heavy PR).
**Panel execution:** in-band-fallback. ToolSearch surfaced no `Agent` / `Task` tool in the harness; ran the panel in-band against the per-seat role files, with each block written one at a time. The bias-isolation property the role names ("a foreperson who also reviews biases the aggregation toward its own findings") is compensated by per-block bounding rather than separate dispatches.
**Composition:** twelve seats selected for genuine load-bearing surface on a 28-README + 7-line CONTRIBUTING + 1-line JS-tweak PR: archivist, scribe, stylist, typist, purist, spec-keeper, surfacer, pruner, copyeditor, changeset-auditor, corner-prober, packager. The other fourteen code-panel seats (warden, prover, breaker, migrator, locksmith, engine-realist, integrator, benchmarker, fast-checker, releaser, wire-watcher, assessor, curator, gateway, saboteur) have no docs-only surface; each was considered and stood down before in-band writing began.

## Findings

- **must-fix-loop (1)**: `packages/cli/README.md:60` documents `endo run program.js --powers AGENT`; the actual `run` command's powers enum at `packages/cli/src/commands/run.js:50-57` is `NONE | HOST | ENDO` (plus an arbitrary pet name treated as a guest). There is no `AGENT` value. The fix is to replace `AGENT` with `HOST` (the prose "All of the primary user's agency" maps to `HOST`), or rewrite to document the actual three-value enum.
- **summary-fix (3)**: `packages/netstring/README.md:25` stray space before comma (`999_999_999 ,`) plus comma-vs-underscore inconsistency between code and comment; `packages/stream-node/README.md:7-8` second sentence starts mid-line (violates "start each sentence on a new line"); `packages/cli/README.md:35` documents `make`'s `--powers` flag without noting it accepts `NONE | SELF | ENDO` rather than `run`'s `NONE | HOST | ENDO`.
- **follow-up (3)**: filed at [`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--344.md`](../../../../projects/endo-but-for-bots/followups/endo-but-for-bots--344.md). Items: (1) netstring legacy aliases (`netstringReader`/`netstringWriter`) exported but undocumented; (2) cli README should reference `endo --help` for the full command set; (3) cli README should mention daemon-not-running guidance.
- **acknowledge (5)**: skel README skeleton placeholder, nat README stale Agoric badges (pre-existing), "indiom" typo in upstream commit subject 1fa8102b6 (mirror PRs do not amend upstream messages), hardened-JavaScript boilerplate repetition (deliberate stand-alone-per-page), CONTRIBUTING unabbreviated-names rule is the correct closure shape.
- **drop (0)**: none.

## Submission

`gh pr review 344 -R endojs/endo-but-for-bots --request-changes` returned the expected self-PR GraphQL block ("Review Can not request changes on your own pull request"). Fell back to `--comment` with the full panel body per `skills/panel-review/SKILL.md` § Pitfalls; the verdict is preserved in the body under the "Must-fix before merge" heading; `reviewDecision` does not flip. The orchestrator's dispatch matrix that keys on `reviewDecision` will also key on the heading for this bot-authored PR.

`@copilot` reviewer fired via `gh pr edit 344 -R endojs/endo-but-for-bots --add-reviewer @copilot`. Idempotent on re-rounds.

## State

- PR remains DRAFT (must-fix-loop item present; un-draft is the next round's responsibility if it terminates).
- Followup ledger created at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--344.md` with three items, all `status: parked`.
- No summary-fix job posted this round; summary-fix items are inlined in the panel body so the fixer can pick them up alongside the must-fix item. The next terminating round's judge will post a summary-fix job to the board if any summary-fix items remain after the fixer's response.
- No `[proposed-rule]` message to gardener this round; the proposed-rule tags in the panel body (e.g., "README documenting a CLI flag should match the source-of-truth in the command definition", "legacy aliases that remain exported should be either documented as deprecated or removed") will route to gardener on the next terminating round so they aggregate with subsequent panels rather than producing per-round noise.

## Next step

Orchestrator should dispatch a **fixer** with the must-fix-loop item inline (and optionally the three summary-fix items in the same brief to land them together). After the fixer's `result` lands, the next panel round is the **justice** (not the barrister); the justice's briefing reads the prior verdict and the fixer's response so the panel reads the delta.

Self-improvement: nothing this time.
