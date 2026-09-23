Gauntlet complete on https://github.com/endojs/endo-but-for-bots/pull/847. The PR is un-drafted and in the maintainer's review queue.

## What the PR is

`chore(ci): establish current master baseline` — the diagnostic CI baseline for upstream master snapshot `fb9cef49eee34d8cf65fb8c6f46cc9b333663f41`. Its head `799128b915f6633ac04ad141874a7b02c712d8fe` is an **empty commit** on the frozen base `master-fb9cef4`: 0 files, 0 lines.

This job had been poison-parked since 2026-07-23 after 5 requeue cycles. Reading the two maintainer-inbox notes from that day, the cause was the Claude weekly quota exhaustion (reset Jul 25), not the work; it was promoted off `plan/` today.

## Chain run

- **Clean:** no-op. Zero diff, so no coverage surface and no dead code.
- **Panel:** code panel, 0 rounds, disposition `passed-no-review-surface`. Verdict posted as a `COMMENTED` review. Durable record `panel-runs/endojs-endo-but-for-bots-847/6d28c3e8f083.md` on `journal2`.
- **Un-draft:** done by `panel.sh`'s hook (`gh pr ready`), the only stage authorized to un-draft.
- **Summary comment:** https://github.com/endojs/endo-but-for-bots/pull/847#issuecomment-5150943236 (standing authorization on this repo).

**Verified:** `gh pr view 847 --json isDraft,state,statusCheckRollup` returns `isDraft: false`, `state: OPEN`, and 14/14 checks `SUCCESS` (run https://github.com/endojs/endo-but-for-bots/actions/runs/30035861413). **Not verified:** local `local-verify`. I did not run it and do not claim it — with a zero-line diff there is nothing local to verify that the green rollup on that exact head does not already cover. Nothing was pushed to the PR branch.

## Two automation defects closed on `main2`

1. `cb234e5ae4` — **`panel.sh` dispatched all 28 code seats at an empty diff.** `sense_panel_kind` falls to the code panel on "no changed files", so this PR would have spent 28 `claude -p` calls reviewing nothing, on a fleet whose pool is throttled to 2 for quota. Added a deterministic short-circuit before the round loop: zero rounds, zero seats, no fixer, no appellate, then the un-draft hook as usual; single-round mode emits the same `pass` last token the staged-gauntlet driver reads. Deliberately fail-closed — it fires only when the diff command exits 0 *and* both endpoints resolve, so a git error or non-git worktree still runs the full panel. Guard: `scripts/jobs/test/panel-empty-diff-test.sh` (14 subtests).
2. `79b25ff252` — **the panel-run record's store key missed `ssh://git@host/` origins**, which is the form the fleet's worktrees actually report (hosts set `url.ssh://git@github.com/.insteadOf https://github.com/`). `panel-runs/` had silently split each repo across two directories: 9 vs 4 for endo-but-for-bots, 3 vs 2 for finbot, so a query by repo saw half its history. Guard: `scripts/jobs/test/panel-repo-slug-test.sh` (7 subtests, hermetic against host `insteadOf`).

Both pushed to `main2` (head `79b25ff252`). `skills/panel/SKILL.md` records the gate as Procedure step 2 so the library does not drift from the script. Verification: both new tests plus the four existing panel tests (68 subtests total) pass, `shellcheck -S warning` clean on every changed script, `tests/checks/run.sh` 7/7 suites.

## Follow-up

The ~12 existing `panel-runs/ssh---git-*` directories remain split from their canonical siblings. The fix stops the split widening but does not reunite history; a one-time journal rename would. Not done here — it mutates existing journal paths and is outside this job.

Scratch is clean: the project worktree and the hook dir are removed.

Self-improvement: the empty-diff gate is now in `skills/panel/SKILL.md`, and the pattern it generalizes (the `coverage-auditor`'s deterministic pre-pass, raised from one seat to the whole panel) is named there so the next seat-level cost gate has a precedent to cite.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-master-fb9cef4-ci-build-gauntlet.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 9118 tokens (11705473 cached reads)
- Output: 55758 tokens
- Cost: $8.955573500000002
- Wall-clock: 955s

<!-- garden-usage-end -->
