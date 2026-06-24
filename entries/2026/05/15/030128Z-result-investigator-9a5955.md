---
ts: 2026-05-15T03:01:28Z
kind: result
role: investigator
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    issue: 260
    role: filed
refs:
  - entries/2026/05/14/102529Z-result-shepherd-2f574f.md
  - entries/2026/05/14/152135Z-result-shepherd-a1ff33.md
  - entries/2026/05/15/022323Z-result-judge-28da99.md
---

# Result: investigator survey of `test (20.x, macos-15)` failures (24-48 h window)

Dispatch root: `dispatches/investigator--9a5955/`. Project worktree on `endojs/endo-but-for-bots@llm` (detached).

## Scope and methodology

Surveyed every completed `CI` workflow run on `endojs/endo-but-for-bots` between 2026-05-13T14:46 Z and 2026-05-15T02:42 Z (38 h window, comfortably bracketing the dispatch's 24-48 h target). Filtered to runs whose conclusion is `failure` and whose failing job set contains `test (20.x, macos-15)`. 13 such jobs across 7 branches.

For each failing job: pulled the full log via `gh api repos/.../actions/jobs/<id>/logs`, grepped for `✘ [fail]`, `tests failed`, `command failed in workspace`, and `##[error]@endo/<pkg>` markers, and clustered by the unique sorted set of failed test titles per job. For each cluster, sampled the cross-matrix `conclusion` of sibling `test (Node x os)` jobs to determine platform scope.

## Clusters (5 + 1 intentional)

| Cluster | Signature | Branches | Jobs | Platform scope | Verdict |
|---------|-----------|----------|------|----------------|---------|
| A | `RangeError: offset is out of bounds` in captp `trap › try Node.js worker trap, main host` | `feat/migrate-eslint-plugin-import-x` | 1 | 20.x macos-15 only | flake (prior commit green) |
| B | Turbo cyclic dependency, fails before tests run | `feat/turbo-test-depends-on-build` | 4 | all platforms | PR-side defect (PR #240) |
| C | `@endo/init` `async_hooks › async_hooks Promise patch` timeout cascade | `chore/eslint-numeric-separators-style` | 1 | 20.x macos-15 only | flake (next push green) |
| D1 | `tools › command › bash/exec: \`grep\` with no match reports exitCode 1 as data` | `jcorbin-genie-sandbox` | 3 | macos-only across all Node versions | already fixed (later head green) |
| D2 | `sandbox-slice-mint › mintGenieSlice — *` (4 sub-tests) | `jcorbin-genie-sandbox` | 3 | all platforms | already fixed (later head green) |
| intentional | bundled-dep duplicated-name policy attacks / snapshot mismatch | `mirror/endo-1967` | 1 | all platforms | PR #239 is itself the regression mirror; the red is the point |

## Cross-matrix headline finding

Two truly macOS-only Node-20 flakes in the window (clusters A and C), one of three failures per cluster reproducing exactly the same Node version + OS cell. Both branches' next push was green on the same cell without a content fix targeting the flake, supporting the flake interpretation. Eight of 13 failing jobs are not macos-specific at all; they fail on every matrix cell and are PR-side defects unrelated to macOS.

If the noise floor on `test (20.x, macos-15)` over a one-day window (~2 flakes per 13 attempts targeting that cell, ~15%) continues, an auto-retry policy scoped to 20.x macos-15 may be worth adopting; that policy belongs in a separate design proposal, not in this survey.

## Issue filed (per dispatch authorization)

- `endojs/endo-but-for-bots#260` — *CI survey: `test (20.x, macos-15)` failures cluster across 5 PRs (2026-05-13 → 2026-05-15)* — contains the cluster table, example run links, journal cross-references, and proposed next-step verdicts. Filed under the bot identity per the dispatch brief; no further per-action authorization was needed.

## Files / runs examined

13 failing CI runs (one job per run): 25897103559, 25896636170, 25884648912, 25883674333, 25881546647, 25870453776, 25858961978, 25845573659, 25829399737, 25829062290, 25827921712, 25827505803, 25806633833.

Cross-matrix sibling-job samples: 25710256035 (captp branch baseline), 25867361026 (eslint-numeric branch next-head green), 25891116367 (jcorbin-genie-sandbox next-head green), 25845573659 (captp), 25829062290 (turbo cyclic).

Existing issues on the repo were checked (`#220, #222, #229, #233, #205, #207, #203, #168, #150, #219`); none cover macos-15 CI clustering, so #260 does not duplicate.

Self-improvement: nothing this time. The hypothesis-driven approach in `roles/investigator/AGENT.md` (cluster by signature, validate by sampling cross-matrix scope, name the umbrella) fit this task well and produced a sharper finding than a "list every red row" report would have. The skill that did the most work was implicit: confirming each cluster's true scope via the sibling cells turned what looked like 13 macos-15 failures into 2 true macos-flakes plus 8 platform-wide PR defects plus 3 already-fixed regressions. The framing trick (macOS-only vs. all-platform) is reusable; no role/skill amendment needed.
