All work complete and pushed. Here is my completion report.

---

## date-sharded-tada stage 2: switch completion writers to sharded paths

**Precondition verified (not assumed).** Stage 1 (`a9adf2ea42`, "tolerate date-sharded tada reads") is deployed fleet-wide: all three `fleet/health/*` hosts (leader `endolin-garden`, `endolin-garden2`, `oros-studio`) report `deployed_sha: 425cf9877a`, which is 367 commits past `a9adf2ea42`. The `common.sh` helpers (`tada_write_path`, `tada_find`, `tada_find_tree`, `tada_exists`, `tada_list`, `tada_recent`) are all present. Proceeded.

**The writer switch.** Flipped all four completion writers to `tada_write_path` so new completions land at `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`, chosen once at write time and frozen into the committed path:
- `complete-job.sh` (the main doin→tada writer, incl. the orchestration-failed / handoff / usage-footer sed chain)
- `ci-watcher.sh` `retire_stale_shepherd`
- `orchestrate.sh` `finish_orch`
- `gauntlet.sh` `finish_gauntlet`

**Reader stranding caught and fixed (the § 4 hazard).** Three post-stage-1 readers scanned only the flat tada dir (`$JOBS_TADA/*.md`) and had **no** tolerant backstop, so the writer switch would have silently stranded them: `orchestrate.sh`'s `resume_recovered_halts` and `supersede_stale_halts` (halt records are written by `finish_orch`, now sharded → the 2026-09-16 credit-controls / clipometer resume+supersede fixes would regress) and `worktree-sweeper.sh`'s terminal-base sweep. All three now enumerate via the flat+sharded `tada_list` helper. The `verify_posted`/`already_owned` exact-path probes in the watchers/deadmail were deliberately left flat: they are backstopped by `post-job.sh`'s tolerant `tada_exists`, so a missed sharded entry only triggers a redundant post that no-ops — self-healing per design § 1, never a drop. `qwen_mentor_trial_slot_unique`'s tada arm was left untouched because completion report bodies don't carry the `trial:` field it matches (a no-op there).

**Verification.** Full suites green, run sequentially (an earlier parallel run collided on the shared test bare repo — a test-infra artifact, not a code issue): orchestrate-test **69/0** (incl. a new explicit proof "the completion writer landed the report at a date shard, not the flat path", plus the stage-1 child-view/`tada_find`/idempotency proofs), ci-watcher **74/0**, gauntlet-resume **8/0**, gauntlet-pin-gate, gauntlet-panel-quota **7/0**, worktree-teardown **9/0**, cost-sh **12/0**, run-test concurrency subtest (real `complete-job.sh`: "all 12 jobs reached tada", 0 failures). Test assertions that read a completion report at a flat path were updated to resolve its shard (recursive `board`/`in_dir`, `tada_report`/`tada_body` resolvers, recursive concurrency counts). `gauntlet-test.sh` fails identically on baseline `origin/main2` (a pre-existing environment issue at the viability stage) — not introduced here.

**Landed commit:** `6de4bf5a57` on `origin/main2` (`feat(jobs): date-shard tada completion writers (stage 2)`).

**DEPLOY STATUS — action needed for the downstream migration job.** This is **landed on main2 only, NOT yet deployed fleet-wide.** All three hosts are still at `425cf9877a`. The stage-3 migration job is blocked on this change being **DEPLOYED to every host** (so no host is still writing flat), not merely merged. Whoever unblocks migration must gate on **deploy state** — `fleet/health/*` `deployed_sha` being an ancestor-descendant of `6de4bf5a57` on leader + garden2 + oros-studio — **not** on merge state. Until the rolling deploy carries `6de4bf5a57` to all hosts, followers may still emit flat completions and the backlog is not yet a closed set.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/date-sharded-tada-writer-switch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 188 tokens (12982187 cached reads)
- Output: 78933 tokens
- Cost: $10.445095499999997
- Wall-clock: 2026s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
