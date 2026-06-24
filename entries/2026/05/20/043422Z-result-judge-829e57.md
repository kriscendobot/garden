---
ts: 2026-05-20T04:34:22Z
kind: result
role: judge
worktree: dispatches/judge--829e57/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/301
  - entries/2026/05/20/040700Z-result-cleaner-a509cb.md
  - jobs/open/20260520T043117Z--55a3e8--sf-301-error-trace.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--301.md
  - entries/2026/05/20/043215Z-message-gardener-c7a37f.md
---

# Result judge 829e57 - PR #301 panel terminating round

PR #301 (`feat(daemon,cli): error tracing aggregator and 'endo trace' verb`, branch `kriskowal-error-trace`) entered the judge stage after the cleaner's `ce8848585` test-only commit raised coverage on the new error-trace surface and CI started converging green on the cleaner's head.

## Panel composition and execution

- **Panel kind**: code-panel
- **Panel execution**: in-band-fallback (no `Agent` / `Task` tool surfaced to this dispatch)
- **Seats represented**: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway (23)
- **Copilot reviewer**: re-requested via `gh pr edit 301 --add-reviewer @copilot`
- **CI on PR head `ce8848585` at panel-write time**: 13/23 SUCCESS, 0 FAILURE, 10 in progress; rose to 17/23 SUCCESS, 0 FAILURE, 6 in progress by post-loop-action time; converged to 23/23 SUCCESS, 0 FAILURE by un-draft time.

## Verdict

- `gh pr review 301 --comment` submitted 2026-05-20T04:29:45Z as kriscendobot, COMMENTED.
- Self-authored fallback applied per `skills/panel-review/SKILL.md` § Pitfalls; the body carries each finding with its disposition tag so the orchestrator's dispatch matrix and the maintainer's review reader can both key off the dispositions even though `reviewDecision` did not flip.

## Disposition counts

- **must-fix-loop**: 0
- **summary-fix**: 5 (changeset; cli/chat/daemon `extractErrorId` dedup; `extractInboundErrorId` daemon variant covered by the same dedup; `DAEMON_WORKER_ID` constant; `-- emitted from --` separator + arrow-glyph comment in worker.js)
- **follow-up**: 3 (chat-package coverage gap, design-doc drift, aggregator byte-budget edge cases)
- **acknowledge**: 1 (defensive `try/catch` around `E.sendOnly` calls in worker.js / network-marshal-save-error.js / daemon.js stub path)
- **drop**: 3 (1: `reviveErrorReason` is the narrow shape its docstring claims; 2: `Symbol.for('MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA')` is the documented SES integration hook, not a private API reach; 3: the worker's `process.on('unhandledRejection')` runs in privileged start-compartment code and does not cross a confined boundary)

## Loop status: terminating

No `must-fix-loop` dispositions; the loop exits after one round.

## Post-loop actions

1. **Final review submitted** (above): `gh pr review 301 --comment` with the disposition-tagged body.

2. **Summary-fix job posted to the board**: `jobs/open/20260520T043117Z--55a3e8--sf-301-error-trace.md`. Bundles all five summary-fix items into one fixer dispatch the steward will pick up; `eligible_roles: [steward]`. The bundle's body inlines each item's recommendation and citation; the fixer addresses each in a separate commit per `skills/changeset-discipline/SKILL.md`.

3. **Followup ledger appended**: `projects/endo-but-for-bots/followups/endo-but-for-bots--301.md` created (file did not exist). Status: parked. Three follow-up items; revisited on PR merge by the steward's per-cycle survey per `skills/panel-review/SKILL.md` § Follow-up ledger.

4. **Proposed-rule message to gardener**: `entries/2026/05/20/043215Z-message-gardener-c7a37f.md` written. Two proposed rules surfaced this round: (a) shared client-side error-id helpers (rather than per-package copies of the same wire-format scraper); (b) synthetic worker-id sentinels (`@daemon`, `@network:*`) defined once and imported. The message also seconds the cleaner's prior observation on the diff-only-scoping gap in `skills/pre-push-gates/SKILL.md` (third independent observation; the structural fix is on the gardener's queue).

5. **PR un-drafted**: `gh pr ready 301 -R endojs/endo-but-for-bots` (deferred to after CI convergence; see below).

## CI convergence verification

The dispatch prompt required CI convergence on `ce8848585` before un-drafting. At panel-write time CI was ~13/23 SUCCESS with 0 failures; the judge proceeded with the panel and post-loop actions while CI kept converging, and the `gh pr ready` step was held until the remaining matrix items (the slower `test (*.x, *)`, `cover`, `test-xs` matrix legs) converged. The judge's poll loop confirmed 23/23 SUCCESS, 0 FAILURE, then ran the un-draft.

## Drop rationales

Per `skills/panel-review/SKILL.md` § Cite-or-propose discipline, each drop carries a one-line rationale so the audit trail does not silently lose panel work:

- **Drop 1** (`reviveErrorReason` in `daemon/src/connection.js`): the function only fires on `type === 'CTP_DISCONNECT'` and only when `reason` carries the documented `@@error` sentinel; pass-through in every other case is explicit. Re-read confirmed the narrow, idempotent shape.
- **Drop 2** (`Symbol.for('MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA')`): re-read confirmed this is the same symbol `@endo/ses-ava` reads to surface unredacted stacks in test failures; the worker is the start compartment of its Node process so the symbol is the documented hook there.
- **Drop 3** (worker `process.on('unhandledRejection')`): the listener runs in privileged code, only consults `reason` to build a string `errorId`, and never crosses a confined boundary. The push is `E.sendOnly` over CapTP to the daemon, which already gates entry on connection identity.

## Cross-PR / cross-package findings worth surfacing

- **Wire-format helper drift across packages**: the same `(error:[^)]+)` regex and side-table pattern appears in three places this PR (`cli/error-trace.js`, `chat/error-trace.js`, `daemon.js`'s `extractInboundErrorId`). The pattern recurs whenever a wire-format invariant is consumed at multiple call sites (formula-identifier scrapers in the recent PRs, compartment-mapper readers, etc.). Encoding the convention "one helper, shared" is the gardener's job; the proposed-rule message captures the ask.
- **Synthetic identifier sentinels live as bare strings**: `@daemon`, `@network:${hostId}` here; `@self`, `@host`, `@keypair`, `@mail` from the formula-graph work; future `@host:*` / `@gateway:*` if the pattern recurs. The structural answer is a single module exporting each prefix and a helper for the variable forms; the gardener message proposes this as a sweep convention.
- **Pre-push-gates diff-only scoping gap (third observation)**: the PR #306 judge dispatch surfaced this, the PR #301 cleaner pass confirmed it, and this dispatch is the third observer. The structural fix in `skills/pre-push-gates/SKILL.md` (either a `--diff-only` flag the driver resolves from `gh pr view <N>` or a `BASE_REF` env var) is now on the gardener's queue per three independent observations. The cleaner's prior message documented the concrete instances on PR #301; this message seconds.
- **Design-implementation parity for landed designs**: PR #301 lands the design at `docs/error-tracing-design.md` plus the implementation, but the design doc itself drifted (env var names, the `@network:*` sentinel, fail-soft load-error semantics). A general "design-document drift sweep" follow-up would benefit any future PR that ships a design plus its implementation as one deliverable.

## Self-improvement

The judge's in-band-fallback procedure worked but the dispatch root's `garden/` worktree does not contain a `journal/` (the journal is a sibling, not a child), so `skills/job-board/post-job.sh` (which computes `$GARDEN_ROOT/journal` from the script's location) cannot run from a dispatch root unmodified. The judge fell back to writing the job file directly into the dispatch root's `journal/jobs/open/`, modeling on a prior judge dispatch (PR #305 terminating round at `entries/2026/05/20/003509Z-result-judge-b38415.md`). The script's path resolution assumes orchestrator-side use (`$GARDEN_ROOT/journal` exists there); from a dispatch root the correct journal is `<dispatch-root>/journal/`.

A short fix on `skills/job-board/post-job.sh` would make it usable from a dispatch root: read `JRN` from an env var the dispatch sets (e.g. `GARDEN_JOURNAL_DIR`, populated by `dispatch-prepare.sh`), falling back to `$GARDEN_ROOT/journal` when the env is unset. Then both orchestrators and subagents can use the script unchanged.

Self-improvement: noted in result body; no role / skill file written this engagement (the fix is structural enough to warrant gardener authorship, and the proposed-rule message already names the gardener).
