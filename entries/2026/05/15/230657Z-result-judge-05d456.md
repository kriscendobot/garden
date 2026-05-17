---
ts: 2026-05-15T23:06:57Z
kind: result
role: judge
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/judge--f753a1/project
---

# Result: panel review on PR #276 (`feat(endor): npm-registry HTTP fetch layer`)

## PR

- `endojs/endo-but-for-bots#276`, head `21885686d`, base `llm`.
- Branch `feat/endor-npm-registry-fetch`.
- Author: kriscendobot (the dispatching identity); self-PR fallback
  applied (`--comment` instead of `--request-changes`).
- This is a RETRY of an earlier judge dispatch that hit a transient
  API rate limit; the prior round did not submit a formal review.

## Panel execution

- **Panel execution:** in-band-fallback.
- **Panel kind:** code-panel.

The dispatch's ToolSearch probe surfaced no `Agent` or `Task` tool;
per `roles/judge/AGENT.md` § In-band fallback, each of the sixteen
code-panel seats' blocks was written one at a time against the seat's
primary surface (the role file's named lens). Aggregation ran once
after all sixteen seats landed. `@copilot` was added as an additional
reviewer alongside the panel (`gh pr edit 276 --add-reviewer @copilot`),
per the code-panel norm.

## Verdict

**Comment** (no `--request-changes` available because the author is the
authenticated identity). Body posted as a single formal `gh pr review
--comment` at 2026-05-15T23:06:38Z.

- Must-fix in scope: **0**
- Should-fix: **8** (mostly doc-comment additions naming implicit
  contracts; one symlink-rejection migration; one path-traversal
  defence-in-depth).
- Out-of-scope: 3 (no `rust/endo` CI workflow; transitive `Cargo.lock`
  closure not audit-scanned; live-registry test correctly gated).

The should-fix items cluster around: (a) documenting trust boundaries
(`fetch_package` fast-path treats `RegistryTable` entries as previously
verified; `fetch_metadata_cached` is write-once with no TTL; `UreqClient`
expects single-agent reuse for connection pooling); (b) tightening
extraction safety (reject non-regular tar entry types as a typed error
rather than silently dropping; reject `..` / absolute path components);
(c) cleaning up the `shasum` half-promise (the `Dist::shasum` field is
`#[allow(dead_code)]` and the missing-integrity branch silently extracts
without falling back). None block the chain; they are follow-up
candidates the orchestrator can stage as a follow-up commit on the
maintainer's review pass.

## Un-draft

`gh pr ready 276 -R endojs/endo-but-for-bots` ran successfully at
2026-05-15T23:06:50Z. PR is now `isDraft: false, state: OPEN`. The
bot-side chain is complete; the maintainer's review queue is the next
venue.

## Regression gate

No `rust/endo` CI workflow exists in this repo today, so the regression
gate is local `cargo test` per the cleaner's report. This judge could
not run the gate locally: the `xsnap` build script
(`rust/endo/xsnap/build.rs:34`) requires either the `c/moddable` git
submodule populated or a prebuilt `libxs.a`, neither present in this
dispatch's project worktree. The "23 of 23 checks pass" assertion in
the dispatch prompt rides on the prior cleaner's pass and Copilot's
local probe; this judge did not independently verify it. Surfacing here
so the audit trail records what the panel could and could not check.

Project-level observation also raised in the review body: the absence
of a `rust/endo` CI workflow is its own designer / shepherd task and
out of scope for this PR.

## Next stage owed

None from the judge. PR is undrafted; maintainer review queue is next.
The 8 should-fix items are documented in the formal review body for the
maintainer (or a follow-up fixer dispatch, if the orchestrator chooses
to stage one before the maintainer reads).

## Self-improvement

The in-band-fallback procedure landed earlier today (2026-05-14 then
expanded in the 2026-05-15 sixteen-seat expansion) held up under the
larger sixteen-seat panel: the per-seat-against-primary-surface
discipline kept each block bounded and the dedupe-during-aggregation
step folded the four maintainer-modeled seats' findings (purist,
spec-keeper, wire-watcher, engine-realist) into the existing
assessor / warden / saboteur clusters cleanly. The convergence
annotations in the aggregated body ("warden + saboteur + wire-watcher
convergent") served as the audit trail for which seats hit which
finding, which is what the multi-seat-dispatch mode would have given
"for free" via per-juror `result` entries.

One observation worth a line on `roles/judge/AGENT.md` § Notes from
the field: when the local regression gate is uncheckable from the
dispatch worktree (here: missing `c/moddable` submodule blocking
`cargo test`), the judge should name the gap in the `result` entry
rather than implicitly accepting the prior cleaner's gate claim.
Threshold for landing: a one-line "Notes from the field" row pointing
at this dispatch, no role-text change. Routing: not a `message` to
liaison this round; the observation is small enough to ride in the
final report's summary.

Self-improvement: surface the "judge cannot verify the regression
gate when the project worktree is missing build prerequisites"
pattern in a future *Notes from the field* row, so the next judge
dispatched on a Rust PR with a `c/moddable` dependency knows up front
that the gate runs on the cleaner's pass plus Copilot, not on the
judge's own `cargo test`.
