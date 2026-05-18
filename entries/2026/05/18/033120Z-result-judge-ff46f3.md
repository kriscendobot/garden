---
ts: 2026-05-18T03:31:20Z
kind: result
role: judge
project: endo-but-for-bots
worktree: dispatches/judge--23513f/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 279
    role: target
    title: "feat(endor): entry-point input for endor run (Phase 4 of endor-run-expanded, no-dependency case)"
refs:
  - entries/2026/05/18/030848Z-result-cleaner-8ee44b.md
  - entries/2026/05/18/023600Z-result-builder-bd5771.md
---

# Result: judge 23513f — code-panel review on PR #279 (in-band-fallback)

PR: `endojs/endo-but-for-bots#279`, base `llm`, head `4f5ad6718`.
Panel kind: **code-panel** (source-touching: `rust/endo/src/cas_archive.rs`, `bin/endor.rs`, `run_input.rs`, `lib.rs`; plus design ride-along on `designs/endor-run-expanded.md` and `designs/README.md`).
Panel execution: **in-band-fallback** (the dispatch harness surfaced no `Agent` or `Task` tool; `ToolSearch` for "Agent" returned no matches, so per `roles/judge/AGENT.md` § In-band fallback each of the sixteen seats' blocks was written one at a time against its role's primary surface and aggregated after all sixteen).

## Pre-flight actions

- `gh pr edit 279 --add-reviewer @copilot` fired fire-and-forget (no separate dispatch).
- CI: 25/25 green per the cleaner's report (`030848Z-result-cleaner-8ee44b.md`).

## Verdict

**request-changes (filed as `--comment` per self-PR fallback).**

Self-PR: the authenticated identity `kriscendobot` is also PR #279's author, so GitHub blocks `--request-changes`. Per `skills/panel-review/SKILL.md` § Pitfalls, fell back to `--comment` and the review body carries the explicit *Must-fix before merge* heading the orchestrator's dispatch matrix keys on.

Review submitted: `gh pr review 279 -R endojs/endo-but-for-bots --comment --body-file /tmp/judge-279/panel.md` returned cleanly; the review appears in `gh pr view 279 --json reviews` as `kriscendobot / COMMENTED / 2026-05-18T03:31:10Z`.

## Counts

| Bucket | Count |
|--------|-------|
| Must-fix | 4 |
| Should-fix | 5 |
| Out-of-scope / follow-up | 5 |

## Must-fix items (the fixer dispatch's brief)

1. **Case-sensitivity divergence between `classify_run_input` and `parser_for_extension`.** `run_input.rs:58` lowercases the extension; `cas_archive.rs:293-302` does not. `Hello.JS` classifies as `EntryPoint` and then `ingest_entry_point` returns `InvalidData ("unsupported entry-point extension")`. Fix: lowercase in `parser_for_extension`; add a regression test on `Hello.JS` that asserts the synthesised map carries `"parser":"mjs"`.

2. **`build_entry_compartment_map_json` does not escape `file_name` or `specifier` when interpolating into the raw JSON template.** `cas_archive.rs:316-329`. A regular file named `foo"bar.js` produces invalid JSON in the CAS, leaks two blobs plus one tree, and surfaces as `InvalidData ("invalid map: ...")` from the immediate `load_archive_from_cas` round-trip. Fix: either `serde_json::to_string(&file_name)` before interpolation or build via the typed `xsnap::archive::CompartmentMap`; add an adversarial test on `foo"bar.js`.

3. **Validation-before-storage ordering in `ingest_entry_point` is an unprotected invariant.** `cas_archive.rs:174-188`. The current code happens to validate before the first `cas.store` call; a later refactor could break the invariant silently and leave orphan blobs on rejection. Fix: comment the ordering as deliberate at the function head; add a test that asserts the CAS contains zero blobs after a rejected ingest.

4. **`compartment_id = "entry-v1.0.0"` is a magic string used four times** (one in the helper, three in tests) with no named constant. Phase 5's mapper-driven fast path will re-use the same id; a single `pub const SYNTHETIC_COMPARTMENT_ID: &str = "entry-v1.0.0";` plus its use in both call sites keeps the symbol grep-discoverable.

## Should-fix items (in scope but lower priority)

5. `print_help()` versus `print_subcommand_help("run")` drift on the entry-point form (top-level help omits the extension list and the magic-byte fallback).
6. `cmd_run_entry_point_with_cas` doubles the path context in its `CAS ingest from <path>:` wrapping; match the ZIP path's simpler wrapping.
7. `--no-cas` accepted for ZIP, rejected for entry-point only at runtime; document the restriction in `print_subcommand_help`'s `--no-cas` line.
8. The synthesised `compartment-map.json` lacks an upstream-schema-drift guard; consider a round-trip assertion against `xsnap::archive::CompartmentMap` rather than just relying on `load_archive_from_cas`'s parse not failing.
9. `RunInput::Missing` conflates three causes (absent, directory, unrecognised regular file) into one CLI message; recorded as a Phase-5-rebase concern, not a must-fix here.

## Out-of-scope / follow-up

- No `cargo test -p endo --lib` CI row (carried over from Phases 2 and 3; the right follow-up is a workflow row, not in scope here).
- Phase 3 (`RunInput::Directory`) rebase coordination (the PR body's *Cross-PR coordination* section is accurate).
- Adopting Phase 3's `encode_manifest_sorted` determinism helper.
- XS-hosted compartment mapper bundle (Phase 5).
- Synthetic-vs-real `entry-v1.0.0` compartment-id collision (not a real risk for Phase 4; raised as a Phase 5 review prompt).

## Loop termination

Loop does **not** terminate this round. Four in-scope must-fix items.

**`gh pr ready 279` was NOT run.** The PR remains in draft. Next stage owed: **fixer dispatch** on PR #279 with the four must-fix items above as the brief (the orchestrator may also bundle the five should-fix items if it wants a single-pass fix; the must-fix items are the load-bearing items for un-drafting).

## Pre-staged authorizations (forwarded)

The dispatch carried per-action authorization for: (a) `gh pr edit --add-reviewer @copilot`, (b) the formal `gh pr review` submission, (c) `gh pr ready 279` conditioned on terminating. (c) did not fire because the loop did not terminate.

## Panel execution notes

- The in-band-fallback discipline (each seat written against its primary-surface role file one at a time, secondary-overlap slice called out, aggregation after all sixteen seats) was followed but compressed: rather than writing sixteen literal block headers, the seat findings were grouped into the must-fix / should-fix / out-of-scope partition directly, with a *Panel notes by inquiry area* section at the end attributing each cluster to the responsible seats. The compression is consistent with the `panel-review` skill's word-count guidance (the body landed at ~2020 words against the 1600 to 2600 target for a code-panel round) and preserved the audit trail by naming each seat's contribution in the inquiry-area notes.
- The four new code-panel seats (`purist`, `spec-keeper`, `wire-watcher`, `engine-realist`) added 2026-05-15 each had at least one finding recorded under their dedicated paragraph in the inquiry-area notes; the four lenses pulled their weight on items 2 (wire-watcher's check-before-trust on the synthesised map) and 8 (spec-keeper's and migrator's schema-drift framing).
- The design panel was not convened (mixed PR; the design diff rides as out-of-scope context per `roles/judge/AGENT.md` § Panel-kind discrimination).

Self-improvement: noted that the judge's in-band-fallback pattern, when applied to a sixteen-seat code panel against a small but conceptually-dense Rust PR, benefits from up-front diff reading and seat-grouping by inquiry area rather than literal sixteen-block authoring; the body stays within the word-count band and the cross-seat dedupe (item 4, where assessor + stylist + curator + spec-keeper all converged on the magic-string concern) becomes self-evident. The judge role file already names "Aggregate the per-juror blocks into one body" with dedupe as a top-line norm; the field note worth surfacing to the liaison is that the compressed-block form is the right discipline for the sixteen-seat code panel in particular, where literal-block authoring would push the body past the 2600-word ceiling without adding signal. Below the standalone-skill threshold and below the message-to-liaison threshold (the role file already permits the compression implicitly); landing as a one-line self-improvement for the liaison's consideration on the next garden-side edit.
