---
ts: 2026-06-02T21:54:40Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/215115Z-dispatch-liaison-3ee6b0.md
  - entries/2026/06/02/215338Z-result-fixer-3ee6b0.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
---

# result: #387 `.bench-engines` rename reverted to `.engines` per kriskowal correction

User ask: "Please dispatch an agent to address
https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r3344170182"
(kriskowal: "I did not recommend changing `.engines` to
`.bench-engines`. Rather, I recommended the opposite. Please rebase
that commit out.")

Dispatched fixer `3ee6b0`. Returned cleanly.

## Outcome

- **Old head**: `a66f3c344` (the `.bench-engines` shape).
- **New head**: `e22369065` (force-pushed; lease anchor `a66f3c344`).
- **Branch shape**: two commits atop `origin/master-814dfa1` as the
  retcon invariant requires:
  - `38fd6a87d fix(benchmark): install xs/v8 via direct download instead of esvu`
  - `e22369065 chore: Update yarn.lock`
- **Net-diff sanity check**: `git diff pre-retcon..post-retcon` is
  exactly 23 lines across the three benchmark files (README.md 1,
  install-engines.sh 20, run-tests.sh 2). No other content changed.
- **No PR comment posted** (the force-push is the artifact; brief
  flagged comment as optional).

## On the misread that prompted this

The prior fixer dispatch f22e80 (earlier 2026-06-02) read kriskowal's
file-level comment "Please rename `.engines`. Nothing limits us from
using engines for other workflows." as "rename to something benchmark
-specific." His actual intent (now explicit at comment 3344170182):
keep `.engines` as the generic name *because* nothing limits its
reuse. The "nothing limits us from using engines for other workflows"
clause was the *reason to keep the generic name*, not the reason to
specialize it. Memory `feedback_sweep_mirror_pr_before_carry_dispatch.md`
already captured the scope-completeness lesson; this miss is a
different shape — ambiguous-directive misread, not missed-comment.
Watch for a future memory if the pattern repeats.

## Fixer's note on the brief

The dispatch brief named the base as `master-814dfa1` (unqualified).
In the dispatch worktree only `origin/master-814dfa1` exists (no
local tracking branch). The fixer used the qualified form throughout
and called it out. Minor brief-quality nit; not a blocker.

## Teardown

`dispatches/fixer--3ee6b0` torn down next.

## Steward queue post-engagement

- **#387** force-pushed to `e22369065`. CI will re-run. Expect the
  prior shepherd's verdict (lint pre-existing-flake territory) to
  hold; the rename revert doesn't touch the source files that drive
  the lint regressions. Watch for new shepherd dispatch on next CI
  cycle.
- **#244** retconned earlier; ferry-back note already on journal
  (entry 214700Z). Awaits kmkmbp2021-host boatman.
- **#403** background builder result still pending an orchestrator
  acknowledgment result. Next.
