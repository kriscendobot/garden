# Harden the conductor's CI-wait: complete the merge, don't end the job while waiting

Wear the **mentor** role. The **conductor** (and any role that "waits for CI then merges") has a
latent bug: when a PR is approved + mergeable but **CI is still pending**, the agent **ends the
job (moves it to tada) while "waiting for CI" without ever completing the merge** — so the PR
sits green-but-unmerged and nothing finishes it. Observed **twice on the same PR**
(endo-but-for-bots #178 → llm): two separate conduct jobs each reported "waiting for CI
completion" and ended; #178 stayed unmerged. Infrastructure on `main2` (bot identity; isolated
worktree off `origin/main2`; redeploy any affected scripts/skills).

## Fix

A conductor/merge dispatch that is waiting on CI must **carry the merge to completion**, not exit
prematurely:
- **Block until CI reaches a terminal state** (all required checks pass → merge; any required
  check fails → do NOT merge, report the failing checks and escalate to shepherd/fixer if
  fixable). Use a robust CI-watch (`skills/pr-ci-watch`) with a real timeout/backoff, and on
  green **perform the merge in the same job** before completing.
- The job is **NOT done while merely waiting** — "waiting for CI" is not a terminal state.
  Completing into `jobs/tada/` is only valid once the PR is **merged**, or CI has **failed**, or
  a genuine blocker is reported. If the CI-watch would exceed a sane bound, the job should
  re-enqueue itself / leave itself claimable rather than silently completing unmerged.
- Make this robust to the `claude -p`/harness "background watch + re-invoke" pattern: if the
  re-invocation does not fire, the job must still not complete unmerged.
- Encode the rule in the conductor role/skill so every merge dispatch inherits it.

## Tests & verification

- Simulate: approved+mergeable PR with CI pending → the job stays active (claimed) until CI
  terminal, then merges on green / reports on red; it never lands in `tada` unmerged-while-pending.
  `shellcheck`/`bash -n` clean.

## Definition of done

The conductor reliably completes the merge once CI is green (or reports/escalates on red) and
never ends a merge job while CI is merely pending — committed/pushed to `origin/main2`,
redeployed, the rule encoded in the conductor role/skill. Report the SHA and the behavior change.

Posted by the liaison on behalf of the maintainer (latent bug; bit #178 twice).

---
claim:
  host: endolinbot
  gardener: 39
  claimed_at: 2026-06-26T01:03:43Z
