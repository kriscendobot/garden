---
ts: 2026-05-18T02:04:19Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/judge--6b063f/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 278
    role: target
    title: "feat(endor): directory input for endor run (Phase 3 of endor-run-expanded)"
refs:
  - entries/2026/05/18/015314Z-result-cleaner-9bb555.md
  - entries/2026/05/18/012000Z-result-builder-d39f78.md
---

# Result: judge 6b063f — PR #278 directory input for `endor run`

Panel review on PR #278 (`feat(endor): directory input for endor run (Phase 3 of endor-run-expanded)`, llm base). Rust-only change in `rust/endo/src/cas_archive.rs` (new `ingest_directory`, new `encode_manifest_sorted` helper, eighteen new tests across the two PR commits) and `rust/endo/src/bin/endor.rs` (CLI dispatch for `endor run <directory/>`, help-text update, `--no-cas` rejection on directory input). Two commits at head `6b723074f`: `06d6ad9cf` (feat + first-pass tests) and `6b723074f` (coverage pass adding eleven tests). Cleaner result entry (`015314Z-result-cleaner-9bb555.md`) confirms the coverage pass landed and all 25 CI checks are green.

This is a retry of an earlier dispatch that hit a transient API rate limit before starting; the retry ran cleanly. The project worktree was aligned with `git fetch origin feat/endor-run-directory-input && git checkout FETCH_HEAD` at the top of the dispatch (was stale at `06d6ad9cf`, advanced to `6b723074f`).

Panel kind: **code-panel** (16 seats; source-touching mixed with two design-doc touches that are status-line / Phase-3-summary updates rather than design content; the panel-kind discriminator picks code-panel for any source-touching diff).
Panel execution: **in-band-fallback** (no `Agent` / `Task` tool in scope; ToolSearch confirmed neither `Agent` nor `task spawn` is deferred-available; each seat's block was written one at a time against the per-seat role file, aggregated after all sixteen).
Aggregated and submitted as one formal `gh pr review --comment` (self-PR fallback per `panel-review/SKILL.md` § Pitfalls; PR author is the bot identity `kriscendobot`, so GitHub blocks `--request-changes` and `--approve`).
`@copilot` re-requested via `gh pr edit 278 --add-reviewer @copilot` alongside the seat write-up (fire-and-forget; the dispatch prompt forwarded the per-action authorization).

Verdict: **comment-only** (no in-scope must-fix).
Must-fix: 0.
Should-fix: 0.
Out-of-scope: 3 follow-up observations.

The three out-of-scope items, all rising to multi-seat coverage:

1. **Pre-existing flat-key / tree-walk mismatch in `cas.fetch_from_tree` vs the sub-tree writer.** Surfaced by the prover, the breaker, and the wire-watcher under three framings (load-bearingness of a gap-locking test, latent invariant violation, parser divergence). The PR's `load_archive_from_cas_drops_nested_module_sources_today` test already pins the current behavior with an instruction to flip the assertion when the gap closes. The panel agrees this is the right defensive shape; the underlying fix belongs on `designs/endor-run-expanded.md`'s open-questions list or in a follow-up PR. Affects ZIP-ingested archives the same way; not a regression introduced here.

2. **`compartment-map.json` symlink at directory root passes the pre-flight `is_file()` check (which follows symlinks) then also walks as a regular file.** Surfaced by the locksmith. Not a security issue in a single-user CLI run from a trusted directory, but worth tightening if the daemon's authority surface ever calls `ingest_directory` on untrusted input (phase 4/5 concern). Walker correctly skips symlinks inside compartments (tested).

3. **Hash-format change for ZIP ingestion via `encode_manifest_sorted` applied to `ingest_archive` as well as `ingest_directory`.** Surfaced by the migrator. Behavior change is correct (deterministic across `HashMap` seeds) and the new behavior is the desired one, but persisted CAS root hashes from prior `endor run` invocations would not match a re-ingest under this PR. CLI uses a temp-dir CAS per invocation so no user-visible regression today; a future phase that persists CAS state across runs (the `endor gc` path against `~/.endo/state/store-sha256/`) should call out the one-time migration in its design.

Design-feedback note (out of scope, intended for the design author): the loader's tree-walk path expects a tree-of-trees layout, but both ingest paths (ZIP and directory) produce a flat-keyed sub-tree manifest. The mismatch silently drops nested module sources from `LoadedArchive.sources`. The Phase 4/5 specification of the entry-point + compartment-mapper path will need to land either a sub-tree writer change (write tree-of-trees) or a loader change (walk flat keys) before nested-module archives become common.

Un-draft status: `gh pr ready 278` ran; `isDraft: false`, `state: OPEN`. The PR is now in the maintainer's review queue.

Loop termination: the loop exits this round (no in-scope must-fix). No fixer dispatch needed. The three out-of-scope items are recorded above for the design author and the next-phase implementer; they do not block this PR.

Next-stage owed: maintainer review of the un-drafted PR, then a ferry dispatch (boatman) when the maintainer is ready to land it upstream. Per `pr-creation-flow/SKILL.md`, the bot-side chain terminates here.

Formal review URL: posted on PR #278 as `--comment` (self-PR fallback); the panel body carries the explicit *Must-fix before merge* / *Should-fix in this PR* / *Out of scope* partitioning so the orchestrator's dispatch matrix keys on the empty must-fix list.

Self-improvement: nothing this time. The judge role's § In-band fallback procedure handled the 16-seat code-panel cleanly on a Rust-only PR; several seats whose primary surface is JavaScript (warden's SES discipline, typist's JSDoc, spec-keeper's ECMA-262, packager's changesets) correctly scoped their blocks down to "primary surface does not apply on this PR; here is the narrow secondary slice that does" rather than padding. The per-seat role files already encode the scoping discipline; no structural lesson to route to liaison.
