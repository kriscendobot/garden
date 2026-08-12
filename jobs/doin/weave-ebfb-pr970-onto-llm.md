---
role: weaver
handler-timeout: 10800
priority: urgent
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/970 (`feat/ironhorse-262-language-completion`, base `llm`, DRAFT)

# Unblock the Ironhorse arc: reconcile #970 with `llm` WITHOUT rewriting the shared draft's history

**Maintainer directive (kriskowal, 2026-08-12): get this ball rolling again.**

## Why the whole arc is stopped

#970 is **CONFLICTING/DIRTY**, and GitHub attaches **no `pull_request` checks to an
unmergeable PR** — its `statusCheckRollup` is literally empty. Three pushes on 08-12
(`768a4deca`, `effecb184`, `cb12da4de`) produced **zero CI runs**. Actions works fine
repo-wide; this is specific to the PR's unmergeable state.

Consequently every gauntlet stage that reads a CI signal starves. That is what doomed
five #970 panel stages as `requeue-exhausted` (fast repeated failure, not budget) and
what just halted the `js-06` clean stage.

**Cause:** #600 merged the Ironhorse engine into `llm` on 2026-08-06T14:52
(`18963b77a8`), and #970 carries parallel work on the same files.
`rust/engine/ironhorse-vm/src/interp.rs` now exists on `llm` (~988 KB).

Nine conflicting files reported by the clean stage:

    rust/engine/ironhorse-vm/src/interp.rs
    rust/engine/ironhorse-snapshot/src/sidetable.rs
    rust/engine/ironhorse-262/src/{lib.rs,test262.rs,xst.rs,bin/ironhorse_xst.rs}
    rust/engine/ironhorse-262/Cargo.toml
    rust/engine/README.md
    designs/ironhorse-test262-convergence.md

## THE HARD CONSTRAINT — do not force-push this branch

**Child branches build on this shared draft.** The clean-stage gardener explicitly
declined to rebase for this reason, and it was right. A force-push rewriting
`feat/ironhorse-262-language-completion` would strand every child branch that
descends from it — the same hazard the conductor cited when it refused to unfreeze
#943 off a shared frozen base.

**Therefore: MERGE `llm` INTO the branch. Do NOT rebase.** A merge commit preserves
the history children depend on. If you conclude a merge is genuinely impossible and
only a rebase can work, **STOP and report** with the reason — do not force-push on
your own judgement.

## Resolving the conflicts

These are core VM sources with real semantics, not formatting collisions. For each
conflicting file, determine whether `llm`'s side (from #600) or the branch's side is
authoritative — and where both changed the same logic, **preserve both intents**
rather than taking one side wholesale.

Pay particular attention to `ironhorse-262/src/{lib.rs,xst.rs}`: the js-01 slice
established that `dual_run` bounds the oracle and the engine **in the same thread**,
which mislabels an oracle hang as `ironhorse-hang`. If a conflict touches that path,
do not silently revert a fix for it.

If any conflict requires a semantic judgement you cannot make from the code and its
tests, STOP and report that file rather than guessing.

## Definition of done

- #970 is `MERGEABLE`, and **CI actually attaches and runs** (the rollup is non-empty).
  A non-empty rollup is the real success signal here — that is what has been missing.
- The branch history is intact: no force-push, child branches still descend from it.
- `cargo test` (or the repo's Rust test entry) passes for the touched crates.
- The PR stays **DRAFT**. Do not un-draft, do not merge — the gauntlet owns that, and
  it can finally run once CI attaches.

## Report

The merge commit, the per-file resolution decisions for all nine conflicts, confirmation
that the rollup is now non-empty with the check count, and any conflict you declined to
resolve.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T04:56:39Z
