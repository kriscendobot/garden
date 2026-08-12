---
role: builder
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land on main2 (no PR).

# Give long-running stage types a role-appropriate handler budget; fix the notice that misreports it

**Maintainer directive (kriskowal, 2026-08-12).** Three related defects. 13+ jobs
have died at the 2400s default since 08-05, each burning a full mentor-tier claim and
producing nothing — and the deaths are **unmetered**, because a SIGKILLed handler
reports zero tokens, so a spend-based governor cannot see them.

## DEFECT 1 — only two roles have a budget above the fleet default

`GARDEN_SHEPHERD_HANDLER_TIMEOUT` and `GARDEN_BUILD_HANDLER_TIMEOUT` are both 7200.
Every other long-running stage type inherits 2400s:

| stage type | why it exceeds 2400s | has a default? |
| --- | --- | --- |
| conduct / merge | blocks on `ci-wait-merge.sh` | **no** |
| review directive | blocks on CI | **no** |
| panel / repanel | fans out **35 juror seats** | **no** |
| group-bump botany | per-dependency diligence × N | **no** |

**The conductor case is structural, not a tuning question:** `ci-wait-merge.sh`
defaults `GARDEN_CI_DEADLINE_SECS=5400`, and `roles/conductor/AGENT.md` requires
blocking on it — *"'Waiting for CI' is not a terminal state"*, and a conductor may
never `tada` a pending PR (the #178 bug). So a 2400s conductor is **guaranteed** to
die on any CI slower than 40 minutes.

Establish and record the invariant: **any handler that hosts `ci-wait-merge.sh`, or
fans out a panel, MUST have a budget exceeding that bounded wait / fan-out cost.**
Add role defaults accordingly and audit for other roles that block on CI.

Evidence: `pr885-conduct`, `merge-endo-but-for-bots-pr875-…`, `pr903-review` (×2),
`pr894-review`, `pr923-dependabot`, `pr132-report-render-mode`, `pr909-…`,
`pr27-review`, `minion-town-endo-b3-daemon-deploy-verify`, plus five #970 panel
stages and `pr910-mustfix-round2-06-repanel` (2512s — a repanel that also had to
drive CI first).

## DEFECT 2 — the doom notice misreports the budget for role-defaulted jobs

For `minion-town-weblet-powers-reference-build-20260809` (`role: builder`, so 7200s):

- watchdog: *"elapsed=7202s ≈ **handler-budget=7200s**"* — correct
- doom notice: *"The effective handler budget in force for this job is **2400s**"* — wrong

The notice reads the explicit `handler-timeout:` header and falls back to the raw
fleet default, **skipping the role table**. It must resolve the same effective budget
the gardener actually applied, or it sends every reader toward the wrong remedy.

## DEFECT 3 — the PATH idempotency guard never matches (`common.sh` ~line 316)

    GARDEN_BIN="$GARDEN_ROOT/scripts/jobs/bin"
    case ":$PATH:" in
      "$GARDEN_BIN:"*) : ;;
      *) export PATH="$GARDEN_BIN:$PATH" ;;
    esac

The subject `":$PATH:"` always begins with a colon; the pattern begins with `/`. They
can never match, so the guard always falls through and **re-prepends on every
sourcing** — verified: three sourcings yield four copies. The comment claims it is
"Guarded so repeated sourcing in one process tree does not stack the entry." Fix the
pattern to include the leading colon.

This is hygiene, not an identity leak — the wrapper still lands first. Do NOT
conflate it with the separate, unexplained report that a Codex cleric job resolved
`gh` to `/bin/gh` (the wrapper missing from PATH entirely); that needs its own
investigation and is out of scope here.

## Scope discipline

Do not raise the fleet default itself — that would slow the doom signal for the many
jobs where 2400s is correct and generous. Per-role defaults only, with the invariant
written down.

## Verify

Hermetic tests: a conduct/review/panel job resolves the new role budget; an explicit
`handler-timeout:` header still wins over a role default; the doom notice prints the
resolved effective budget for a role-defaulted job; the PATH guard is idempotent
across repeated sourcing. `bash -n` on every edited script; keep `handler-budget-test`
and `timeout-classifier-test` green (note: `timeout-classifier` subtest-4 fails
pre-existing on origin/main2 — verify against baseline before blaming this change).

## Report

Landed revision, the role→budget table you established, where the invariant is
recorded, and any role you found blocking on CI that this job did not cover.
