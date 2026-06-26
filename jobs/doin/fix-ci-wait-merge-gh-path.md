# Fix the gh-tool-path bug in ci-wait-merge.sh (root cause of #178's silent conduct failures)

Wear the **mentor** role. `scripts/jobs/gardening/ci-wait-merge.sh` (the conductor's
CI-wait-then-merge step) **alerted the maintainer**: *"required tool(s) missing on PATH
(tag=ci-wait-merge): `/tmp/tmp.rrolnKVTO1/gh` — this silently drops work."* It is resolving `gh`
to a **stale temp path** (a `mktemp -d` dir that no longer exists when the check runs), so
`require_tools gh` fails and the step **drops the merge** — the actual root cause of the
**#178 conduct failures** (two conduct jobs ended without merging; the liaison merged #178 by
hand). The loud-tool-failure hardening correctly surfaced it; now fix it. Infrastructure on
`main2` (bot identity; isolated worktree off `origin/main2`; redeploy).

## Fix

- Make `gh` resolution **durable** for the lifetime of the CI-wait: use the **stable fleet gh
  wrapper** (`scripts/jobs/bin/gh`, which pins the bot identity) on PATH rather than a copy in a
  `mktemp -d` dir that gets cleaned up before/while the (potentially many-minute) CI-wait runs.
  If a temp wrapper is genuinely needed, ensure it is created in a location that survives the
  whole wait, and that PATH points at it for every re-invocation.
- Audit the conductor / gardening CI-wait flow for the same stale-temp-PATH pattern and any other
  `require_tools` target pointing at an ephemeral path.
- This complements `harden-conductor-ci-wait-complete-merge` (which fixes the "ends while waiting"
  logic): this fixes the "gh missing → silently drops the merge" tool-path bug. Both are needed
  for the conductor to reliably complete merges.

## Tests & verification

- Simulate the CI-wait spanning past temp-dir cleanup → `gh` still resolves and the merge step
  runs (no missing-tool alert). `require_tools` points at a durable path. `shellcheck`/`bash -n`
  clean.

## Definition of done

ci-wait-merge.sh (and the conductor CI-wait flow) resolve `gh` via a durable path that survives the
full wait, no longer dropping the merge on a stale temp path — committed/pushed to `origin/main2`,
redeployed. Report the SHA and the root-cause path bug.

Posted by the liaison on behalf of the maintainer (root cause of #178; surfaced by the loud-tool alert).

---
claim:
  host: endolinbot
  gardener: 64
  claimed_at: 2026-06-26T01:24:58Z
