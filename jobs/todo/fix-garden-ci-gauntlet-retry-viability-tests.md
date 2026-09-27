---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
token-budget: 400000
---
# Fix the garden repo's own CI: two failing test suites, broken 3+ days

Repository: `kriscendobot/garden`, branch `main2` — the garden's own repo, so
land direct to `main2` (no PR) per CLAUDE.md's own-repo convention, unless the
fix genuinely surfaces open questions worth a maintainer decision, in which
case follow the frozen-base-branch PR carve-out. Work in an isolated project
worktree: `scripts/jobs/ensure-project-worktree.sh <base> kriscendobot/garden main2`.
Never run git against `$GARDEN_ROOT` itself (the root checkout is a deployed
version of this same repo — see CLAUDE.md § Deliberate deploy).

## Severity: this has been broken a long time, not a fresh regression

The `checks` workflow's "Run focused tests" step has failed on **every** `main2`
push since at least **2026-09-24T17:02:36Z** (commit `15f3e3815c`) through the
latest push as of this job (2026-09-27T07:30Z) — over 60 consecutive CI runs
across completely unrelated commits (foreman config, watcher fixes, docs,
panel features, etc.), so this is not caused by any single recent change. Full
history: `gh run list -R kriscendobot/garden --branch main2 --json
conclusion,displayTitle,headSha,createdAt`.

## The two failing suites (from the most recent run, `c942c685af`)

```
Checks tests: 10 suite(s) passed, 2 failed
Failing suites:
  - test_gauntlet_stage_retry_budget.sh  (7 failed, 2 passed)
  - test_gauntlet_viability_gate.sh      (5 failed, 4 passed)
```

Full log: `gh run view <run-id> -R kriscendobot/garden --log-failed`
(e.g. run `36302438130`).

`test_gauntlet_stage_retry_budget.sh` failures:
- exhaustion reason names the stage retry budget
- policy-refusal halts immediately without re-posting
- deterministic halt explains why retry would repeat the refusal
- unclassified requeue-exhausted halts without re-posting
- unknown requeue halt says transient evidence was unavailable
(passing: "deterministic refusal does not masquerade as budget exhaustion",
"post-gauntlet records the independent max_stage_retries default of 2",
"stage-death retries do not spend the still-pending resume counter")

`test_gauntlet_viability_gate.sh` failures:
- an overtaken premise retires before clean
  (`cat: .../jobs/tada/overtaken.md: No such file or directory` — a fixture/
  path or write-order bug, not just an assertion mismatch)
- overtaken report preserves status, close option, and deciding question
- an overtaken verdict without the close option fails closed
- a closed PR retires before clean
- a merged PR retires before clean
(passing: "viability is the first stage...", "gate prompt requires...",
"a viable PR advances to clean", "the refusal is reported to the maintainer
inbox")

## What to do

1. Reproduce locally first: run these two suites directly in your worktree
   (find them under the project's test directory — do not guess the path,
   `grep -rl` for `test_gauntlet_stage_retry_budget` to find both the test file
   and the script(s) it exercises).
2. Root-cause each failing suite independently — they may share one cause
   (both are "gauntlet stage disposition" logic) or be two unrelated breaks.
   The `overtaken.md` "No such file or directory" is a concrete lead: something
   in the retirement/overtaken path is not writing where the test expects, or
   the test's own fixture setup drifted from the script's current write path.
3. Fix the actual code (or the test, if the test itself is stale/wrong —
   confirm which side drifted before changing either); do not skip, quarantine,
   or loosen the failing assertions to make them pass.
4. Run the FULL local test suite before pushing (not just these two), per the
   `CI failure = automation defect` standing discipline: local must match CI
   exactly, or the discrepancy is itself a defect to close.
5. Confirm green: after pushing, check the new run's conclusion
   (`gh run list -R kriscendobot/garden --branch main2 --limit 1`) before
   reporting done.

## Report

State plainly whether this was one shared root cause or two independent ones,
and cite the fix commit(s). If you discover the regression's actual origin
commit (a `git bisect` or careful read of the retry-budget/viability-gate
history around late 2026-09-24 may find it), name it — useful for
understanding how CI went unnoticed-red for 3 days.
