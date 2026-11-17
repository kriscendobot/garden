---
gate: orchestrated
orchestrated_by: ironhorse-ci2-refresh-1298-1534-20261117-split
priority: normal
posted_by: orchestrator
posted_at: 2026-11-17T10:06:48Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse #1298: finish CI verification after the llm refresh

Repo endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1298 (head kriscendobot/endo-but-for-bots `ironhorse-fuzz-findings`). This is a split child of ironhorse-ci2-refresh-1298-1534-20261117. The substantive work is already pushed:
- 761ab312fc merged llm 0368767778 into the head. This brings in llm's bwrap dash/ulimit, parent-death, and tred fixes. Conflicts are resolved: the exact-double comparison is kept, and the multi-crank arm uses DualRun.result_agrees.
- f71bf5412f (job ironhorse-1298-repin-fuzz-locks-20261117, since doomed requeue-exhausted) re-pinned the byte-pinned fuzz locks broken by llm's F040 generator re-fold.
- 34bb071b2d keeps comparison.rs standalone for format-ironhorse's `rustc --test`.
- The PR base moved from llm-387ea66 to frozen llm-0368767, because format-ironhorse's check-row-schema.py fails against the stale base and passes against llm-0368767 (verified locally). The base move is deliberate, so keep it.
- a4f8aadd8c is a same-tree amend that re-triggered CI with the new base.

As of 2026-11-17T10:05Z, the only reds were test-xs and the two oracle lanes, with `test (22.x, ubuntu-latest)`, `test (22.x, macos-15)` and `test (24.x, macos-15)` still pending.

Task: wait in the foreground (bounded polling) for the pending lanes. A red that is a known cross-PR flake should be rerun once via `gh api -X POST repos/endojs/endo-but-for-bots/actions/jobs/<current-attempt-job-id>/rerun`. Known flakes:
- the bwrap process-group reap test on a cover/test leg (fix in open PR #1591)
- the macOS daemon "durable environment restores passively" test
- a 45-minute test-ironhorse timeout on a cold cache
A real PR-attributable red should be diagnosed and fixed with local CI-equivalent checks before pushing. Expected and to be left alone:
- test-xs: base-wide Node 26 `Function.prototype.caller` baseline flip, fixed by open PR #1646
- test-ironhorse-oracle and ironhorse-oracle-sanitizers: stage3-math 054/055, until #1613 reaches the base
- compare-ironhorse-math: downstream of the oracle lane

Push only to the kriscendobot head and do not merge. Report the final check state.

