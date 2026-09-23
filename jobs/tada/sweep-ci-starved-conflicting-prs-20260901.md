---
handed-off: ebfb-ci-starved-weave-survivors-20260902
deliverable-complete: false
---
Pre-mutation inventory: 12 qualifying PRs across 298 open PRs. After forcing GitHub to resolve `UNKNOWN` states, I checked all 118 `CONFLICTING` heads through the check-runs API. All 12 matches were in `endojs/endo-but-for-bots`; `kriscendobot/minion.town` had none.

| PR | Original head | Disposition |
|---|---|---|
| [#1013](https://github.com/endojs/endo-but-for-bots/pull/1013) | `3f455793a7` | Weave handed off |
| [#994](https://github.com/endojs/endo-but-for-bots/pull/994) | `27f308ea0a` | Do not weave: explicitly a deployment-tracking/cannibalization branch, not a merge candidate |
| [#950](https://github.com/endojs/endo-but-for-bots/pull/950) | `f0bf013a80` | Weave handed off |
| [#855](https://github.com/endojs/endo-but-for-bots/pull/855) | `44e84b4bd1` | Woven |
| [#807](https://github.com/endojs/endo-but-for-bots/pull/807) | `7f08e25870` | Recommend close as superseded |
| [#775](https://github.com/endojs/endo-but-for-bots/pull/775) | `222f849895` | Weave handed off |
| [#592](https://github.com/endojs/endo-but-for-bots/pull/592) | `afeac2919d` | Weave handed off |
| [#335](https://github.com/endojs/endo-but-for-bots/pull/335) | `10a93981ac` | Weave handed off |
| [#322](https://github.com/endojs/endo-but-for-bots/pull/322) | `1fc3996ab8` | Weave handed off |
| [#317](https://github.com/endojs/endo-but-for-bots/pull/317) | `96dfe7a0f8` | Woven |
| [#266](https://github.com/endojs/endo-but-for-bots/pull/266) | `5053f894bc` | Weave handed off |
| [#257](https://github.com/endojs/endo-but-for-bots/pull/257) | `7d5f5d08bb` | Recommend close as superseded |

Woven in this bounded batch:

- [#855](https://github.com/endojs/endo-but-for-bots/pull/855): rebased two commits onto current `llm`, resolving `designs/README.md` additively while retaining its current structure and totals model. Pushed `9c235d73a4` with lease; draft status remained unchanged. `yarn prettier --check designs/README.md designs/endor-packaging.md` passed.
- [#317](https://github.com/endojs/endo-but-for-bots/pull/317): rebased two commits onto current `llm`, integrating the design into the current summary, dependency graph, M9 table, estimates, and totals. Pushed `7c6479a63c` with lease; its ready status remained unchanged. `yarn prettier --check designs/README.md designs/familiar-telemetry-crash-reporting.md` passed.
- Posted SHA-anchored completion comments on both PRs. No PR was closed or merged.

CI restoration is confirmed. Both original heads had zero check-runs. After rebasing, GitHub marked both PRs `MERGEABLE`; exact check-run totals rose to 6 for #855 and 7 for #317, with successful or active Endo workflows. Together with the previously completed #249 experiment, this confirms the mechanism across three PRs: removing the base conflict restores `pull_request` workflow dispatch.

Close recommendations:

- #807’s intended `tree(ref)`/`filesystemAt(ref)` reconciliation is already on current `llm`, including the explicit canonical reconciliation in commit `5adb720ce1`; replaying its older alternative would regress current direction.
- #257 is a historical merge of two parents that are both ancestors of current `llm`, so it contributes no remaining content.

Seven remaining merge candidates were durably assigned to serial orchestration `ebfb-ci-starved-weave-survivors-20260902`: #950, #775, #592, #1013, #335, #322, and #266. Each child rechecks current head/disposition, avoids active-gauntlet races, preserves draft state, verifies its diff and checks, and records whether CI attaches.

Self-improvement: sent the liaison a reusable `git cat-file -e` existence-check pitfall discovered during triage.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/sweep-ci-starved-conflicting-prs-20260901.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1105s

<!-- garden-usage-end -->
