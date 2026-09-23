---
ts: 2026-05-22T23:17:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/231700Z-dispatch-general-contractor-595bce.md
---

# Barrister round 1 on endojs/endo-but-for-bots#324

PR: `test(lal): Primer-into-CAS packaged-build smoke (G16 from #231)`.
Branch: `test/familiar-primer-cas-smoke` (HEAD `3787a905b`).
Single-file diff: `packages/lal/test/primer-cas-smoke.test.js`.

## Panel composition

`panel-hints.sh --base origin/llm` recommended 14 of 26 code-panel seats:

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (1): fast-checker
  fast-checker  packages/lal/test/primer-cas-smoke.test.js
Content-triggered (2): warden, wire-watcher
  warden  matched: @endo/init
  wire-watcher  matched: sha256
Cross-panel (0): -
Suppressed (14): benchmarker, breaker, changeset-auditor, curator, gateway, migrator, pruner, surfacer, engine-realist, locksmith, purist, spec-keeper, copyeditor, pedant
Recommended total: 14 of 26 code-panel seats.
```

No barrister-side overrides; dispatched the recommended 14.

## Panel execution

In-band-fallback. The `Agent` tool was not in scope (confirmed via `ToolSearch select:Agent` returning no match). Each seat was written as one block before the next seat was read, per `skills/panel-review/SKILL.md` § In-band fallback. Aggregation ran after every seat landed.

Panel kind: code-panel.

## Verdict

`request-changes` in the body; submitted as `--comment` per self-review fallback (the reviewing identity `kriscendobot` equals the PR author; `--request-changes` blocked with GraphQL `Review Can not request changes on your own pull request`).

The body opens with the request-changes framing so the orchestrator's matrix (which keys on the "Must fix before merge" / `request-changes` heading for self-authored PRs) sees the verdict.

Review URL: posted on PR #324 via `gh pr review --comment`.

## Disposition counts

- **must-fix-loop**: 1.
- **summary-fix**: 6.
- **follow-up**: 2.
- **acknowledge**: 18.
- **drop**: 1.

Total: 28 tagged findings across 14 seats.

### must-fix-loop item

- **integrator** `packages/lal/.gitignore`: file does not exclude `tmp/`; the test writes daemon scratch state under `packages/lal/tmp/` and a failure path leaves untracked debris in `git status`. `packages/daemon/.gitignore` has the canonical `/tmp*` for the same reason. The fixer should add a `packages/lal/.gitignore` with `/tmp*` (or merge into the package's existing ignore file if one is added).

## Next dispatch

**Fixer**, with the single must-fix-loop item inlined. Brief:

> Address the must-fix-loop item from the barrister panel on PR #324: `packages/lal/.gitignore` should exclude `tmp/` (the test directory written by `primer-cas-smoke.test.js`). Pattern after `packages/daemon/.gitignore` (`/tmp*`). After landing, the next round is the **justice** (not the barrister).

The fixer does not need to address the six `summary-fix` items in this dispatch; those bundle into a `summary-fix` job posted after the panel returns no `must-fix-loop` items on a subsequent round.

## Followup ledger

Appended `projects/endo-but-for-bots/followups/endo-but-for-bots--324.md` with two `follow-up` items (packager: changeset policy verification; saboteur: `ensureBundledPrimer` freshness check). Status `parked`; the steward's per-cycle survey revisits on merge.

## Gardener message

Two `[proposed-rule]` findings warrant a gardener message:

1. **assessor**: when a test mirrors a guarded production code path (`if (!hasPrimer) ...`), exercise both sides of the guard.
2. **corner-prober**: when truncating a free-form label for a filesystem path, ensure prefix-disjointness across the set of labels actually used.

A separate `message` entry to `liaison`/`gardener` lands these.

## CI status

Latest commit (`3787a905b`) has CI running. `build`, `zizmor`, `familiar-bundle`, `build-wasm` all green at observation time. Test matrix QUEUED / IN_PROGRESS. The shepherd's prior round caught the original ENOENT-on-sockPath red; the fixer's truncation lands inside the canonical 90-char budget.

## Identity note

Both the PR author and the reviewing `gh` identity resolve to `kriscendobot`; the barrister's local git identity on this host is `endolinbot`. The self-review fallback applies; the review was submitted as `--comment` with the request-changes framing in the body.

Self-improvement: nothing this time.
