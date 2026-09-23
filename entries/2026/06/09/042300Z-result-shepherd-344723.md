---
ts: 2026-06-09T04:23:00Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--344723
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo-but-for-bots/actions/runs/27182227505
  - https://github.com/endojs/endo-but-for-bots/actions/runs/27182227530
  - https://github.com/endojs/endo-but-for-bots/actions/runs/27183484129
  - https://github.com/endojs/endo-but-for-bots/actions/runs/27183484130
  - entries/2026/06/03/050035Z-result-shepherd-797060.md
  - entries/2026/06/03/204957Z-result-shepherd-9985b3.md
---

# result: shepherd 344723 — PR #401 zizmor fixed in scope; test-xs needs weaver (frozen-base predates esvu fix)

## Branch tips

- Pre: `a7b9b9a7d0aa83fba40008af1cf2eb5c19095586` (`a7b9b9a7d`)
- Post: `8fcb24157ac4665d3c6a614b81650415e5013747` (`8fcb24157`)
- Single shepherd commit: `8fcb24157` — `chore(ci): pin comment for changesets/action says v1.8.0 not v1`
- Append push (no amend of fixer's `a7b9b9a7d` die-idiom commit, no force-push).

## Failure inventory at dispatch time

| Check | State | Run | Job |
| --- | --- | --- | --- |
| zizmor | fail | [27182227530](https://github.com/endojs/endo-but-for-bots/actions/runs/27182227530) | [80243631977](https://github.com/endojs/endo-but-for-bots/actions/runs/27182227530/job/80243631977) |
| test-xs | fail | [27182227505](https://github.com/endojs/endo-but-for-bots/actions/runs/27182227505) | [80243631998](https://github.com/endojs/endo-but-for-bots/actions/runs/27182227505/job/80243631998) |

## zizmor diagnosis: stale version comment on changesets/action

Single warning at exit 13: `release.yml:63: action's hash pin has mismatched or missing version comment: points to commit a45c4d594aa4`.

PR #401 does NOT touch `release.yml`. The finding is from zizmor's pedantic-persona online-audits comparing the file's `# v1` floating-tag comment against the live SHA the `v1` branch of `changesets/action` currently points at (`a45c4d594aa4` = tag `v1.9.0`). The pinned SHA `63a615b9cd06ba9a3e6d13796c7fbcb080a60a0b` corresponds to tag `v1.8.0`. The pinned SHA is correct and intentional; only the comment had drifted (was correct when `v1` pointed at `v1.8.0`).

Verified via `gh api repos/changesets/action/tags`:

- `v1.8.0` -> `63a615b9cd06` (matches pinned SHA)
- `v1.9.0` -> `a45c4d594aa4` (current `v1` branch HEAD)

The same comment update already exists on the `kriskowal-random-chacha12` branch (PR #75), where zizmor passed on the latest push. Mirror-fix from there.

### Shepherd-side fix

Single-character edit (`# v1` → `# v1.8.0`) on `.github/workflows/release.yml` line 63. Committed as `8fcb24157` and pushed. The new run's zizmor job passed in 11s ([80247361167](https://github.com/endojs/endo-but-for-bots/actions/runs/27183484130/job/80247361167)).

In-scope per shepherd norms: one-line workflow-comment edit, no logic, no public-API, no topology change; well under the ~5-file ceiling.

## test-xs diagnosis: stale-base, NOT a flake — needs weaver

Initial failure (run `27182227505`, attempt 1): `esvu ✖ TypeError: body.find is not a function` while resolving XS version. The PR's new push to `8fcb24157` produced a new run (`27183484129`) that ALSO failed test-xs — now at `XS ❯ Extracting ... → esvu ✖ Some engines were not installed`. Two consecutive runs failed at the esvu step.

Cross-referenced against prior shepherd journal entries:

- `entries/2026/06/03/050035Z-result-shepherd-797060.md` and `entries/2026/06/03/204957Z-result-shepherd-9985b3.md` both diagnose the exact same `esvu ✖ Some engines were not installed` mode and classify it as **stale-base-induced**. The fix is upstream commit `ba26f4cdb` (PR #3294) "fix(benchmark): install xs/v8 via direct download instead of esvu", which replaces the esvu install path with direct binary downloads.

### Verification on this branch

```
$ git merge-base --is-ancestor ba26f4cdb a7b9b9a7d
PR base does NOT contain esvu fix

$ git merge-base --is-ancestor ba26f4cdb origin/master-814dfa1
master-814dfa1 does NOT contain fix

$ git merge-base --is-ancestor ba26f4cdb origin/master
origin/master contains esvu fix
```

The PR's frozen base `master-814dfa1` predates the esvu replacement. The live `origin/master` is now at `4a04d078b`; the `master-4a04d07` frozen base branch is already pushed to the fork and contains the fix transitively.

### Why no shepherd-side re-run / no shepherd-side fix

- A pre-shepherd re-run on attempt 1 was triggered defensively but got cancelled when the new push superseded the run. The new run reproduced the failure with a similar esvu-shape error. Two attempts is enough to retire "flake" as a hypothesis.
- The esvu replacement is upstream code, not shepherd-scope; the canonical resolution per `garden/skills/frozen-base-branch/SKILL.md` § Rebase: move both base and head is a weaver dispatch that retargets PR #401 from `master-814dfa1` to `master-4a04d07` and rebases the head onto the new base. Post-rebase the esvu fix arrives transitively and test-xs passes.

## Per-check terminal state on head `8fcb24157` (run `27183484129` + sibling runs)

| Check | State | Duration |
| --- | --- | --- |
| build | pass | 17s |
| check-action-pins | pass | 25s |
| cover | pass | 3m16s |
| lint | pass | 3m51s |
| shellcheck | pass | 8s |
| test (22.x, macos-15) | pass | 5m30s |
| test (22.x, ubuntu-latest) | pass | 5m11s |
| test (24.x, macos-15) | pass | 6m20s |
| test (24.x, ubuntu-latest) | pass | 4m32s |
| test-async-hooks (18, ubuntu-latest) | pass | 44s |
| test-async-hooks (22, ubuntu-latest) | pass | 38s |
| test-hermes | pass | 34s |
| test-ocapn-python | pass | 47s |
| test262 (22.x, ubuntu-latest) | pass | 32s |
| test262 (24.x, ubuntu-latest) | pass | 34s |
| viable-release | pass | 2m11s |
| zizmor | **pass** (was fail) | 11s |
| **test-xs** | **fail** | 33s |

17 pass, 1 fail. Only test-xs remains red and is out-of-scope for shepherd.

## Re-runs issued

- `gh run rerun 27182227505 --failed` on the original test-xs run before the shepherd push landed. The new push superseded it; attempt 2 was cancelled. No useful signal from that re-run.

## Comments / re-requests posted

- **None.** The brief's deliverables for "convergence summary comment" and "re-request review" are conditional on green CI; CI is not green (test-xs red). Per shepherd role norms, the gate is closed and the next role is named below for the orchestrator's auto-pickup chain.

## Escalation classification

**`next: weaver`**

Rationale: PR #401's frozen base `master-814dfa1` predates upstream commit `ba26f4cdb` (PR #3294, "fix(benchmark): install xs/v8 via direct download instead of esvu") which is on the live `origin/master`. A weaver dispatch following `garden/skills/frozen-base-branch/SKILL.md` § Rebase: move both base and head:

1. Pushes / reuses frozen base `master-4a04d07` (already exists; current `origin/master` tip is `4a04d078b`, short SHA `4a04d07`).
2. Rebases `chore/shellcheck-ci` onto `master-4a04d07`.
3. Updates PR #401's base from `master-814dfa1` to `master-4a04d07` via `gh pr edit 401 --base master-4a04d07`.
4. Pushes the rebased head with `--force-with-lease`.

After the rebase, the next CI run on `chore/shellcheck-ci` includes `ba26f4cdb` transitively; test-xs no longer routes through esvu and should pass. The zizmor fix at `8fcb24157` will be carried into the rebase.

No conflicts expected (PR #401 only touches `scripts/*.sh`, `packages/{compartment-mapper,nat}/...sh`, `.github/workflows/shellcheck.yml`, `package.json`, and now `.github/workflows/release.yml`; the esvu fix is in `packages/benchmark/...` — disjoint paths). Weaver verifies and falls through to `skills/conflict-resolution/SKILL.md` if anything surfaces.

## Definition of done

- Each failure diagnosed to root cause: zizmor (stale version comment) and test-xs (frozen-base predates esvu replacement).
- In-scope failure fixed atomically in one chore-scoped commit (`8fcb24157`).
- Out-of-scope failure classified as `next: weaver` with the specific frozen-base rebase prescription and target SHA.
- 17/18 checks green on head `8fcb24157`; test-xs alone red and will resolve via weaver rebase.
- No `--no-verify`, no force-push, no `t.skip`, no `continue-on-error`.

Self-improvement: nothing this time. The journal trail at `entries/2026/06/03/050035Z-result-shepherd-797060.md` and `entries/2026/06/03/204957Z-result-shepherd-9985b3.md` already names this exact esvu-vs-frozen-base pattern with the same fix commit `ba26f4cdb` and the same `next: weaver` escalation; following that precedent here was straightforward. The zizmor pedantic-online-audits finding being precisely the comment-mismatch already fixed on the chacha12 branch is the kind of mirror-by-mirror drift the frozen-base discipline accepts as background noise; the one-character fix needs no skill change.
