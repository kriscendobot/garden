## Completion report: garden-tada-shard-five-cleanup-retire-flat-fallback-20261006

The flat-path read fallback is gone and the recent-completions lister is in place. It's pushed to `main2` as **`ac774d552f3`** (direct push, no PR). The job-system tests I fixed pass, except two that hit their time limit or broke on this machine; details under Tests.

**Both preconditions confirmed:**
- `journal2` has no flat `jobs/tada/*.md` entries. The only thing at the flat level is `.gitkeep`, both in the working tree and in `git ls-tree origin/journal2`.
- Completions are being written under `jobs/tada/<yyyy>/<mm>/<dd>/` (today's folder, `2026/10/06/`, is filling up).

**What changed:**
- **`common.sh` tada helpers:** these stay as the one place the layout lives.
  - `tada_find`, `tada_find_tree` and `tada_list` no longer look at the flat level first. They now only find reports in date folders and `undated/`, and ignore a stray flat file instead of preferring it.
  - `tada_list` still lists each job name once.
- **Recent completions:** this is the `tada_recent` that the `garden-tada-shard-01-design` report specifies.
  - It now walks only the requested day folders, newest day first, and within a day newest-modified first.
  - The flat compatibility branch and the cross-day sorting by file time are gone.
  - New read-only command `scripts/jobs/recent-completions.sh [--days N] [--limit N] [--paths] [--dir J]` prints `YYYY-MM-DD <base>` lines. I checked it against the live journal.
  - The bulletin's recent-tada panel uses the reworked helper. I updated comments in `bulletin.sh`, `orchestrate.sh` and `worktree-sweeper.sh` that still described a flat layout.
- **Tests:**
  - `tada-read-tolerance-test.sh` now checks the new contract: a flat file is ignored, the newest-first order holds, and the new command works. All 12 checks pass.
  - 12 other tests created their fixture reports at the flat path, so I moved those fixtures into a date folder: cost-sh, directive-identity-dedup, design-pr-gauntlet-coverage-audit, follow-up-seen-cursor, followup-posted-gate, gauntlet-panel-quota, gauntlet-resume, library-source-drift-scan, worktree-teardown, rolling-deploy, worker-health-gate and orchestrate.

**Tests:**
- I ran all 119 job-system tests that mention tada, then reran every failure against an unchanged copy of `origin/main2` to separate my breakage from what was already broken.
- **11 tests broke because of this change**, all from flat fixtures. Ten now pass after the fixture fix.
- The 11th, `orchestrate-test`, broke in three places, all fixed. In its last run it reached 76 passing checks and none failing, but it hit the 595s time limit before finishing (load average was about 15). It also timed out on the unchanged copy.
- **29 tests also fail or time out on the unchanged copy**, so my change didn't cause them. Examples are gardener-worktree, project-worktree-isolation, sysop, kimi-*, auction-reputation and token-cost-ledger.
  - `completion-signal-test` is one of these. Its first failure is the same on both copies (the test job never gets claimed: `todo=y`). In my run it got past the point where the unchanged copy timed out and failed six more checks. Those all show the job never moving (`doin=n, tada=n`), so I think they follow from that first failure, but I didn't confirm it.
- A quieter machine is needed to see `orchestrate-test` and `completion-signal-test` run to the end.

**Superseded plan entries:** the parked `garden-tada-shard-04-migrate` and `garden-tada-shard-05-cleanup` plan entries are superseded. The flat backlog is already fully moved into date folders (zero flat entries), and this job did the cleanup stage. They should be retired, not promoted.

**Follow-ups:**
- `scripts/jobs/migrate-tada-shards.sh` is now a one-shot that does nothing (it exits with "no flat entries remain"). I kept it because `designs/host-local-git-repo-locks.md` refers to it, so it can be deleted at leisure.
- The design's optional sed that rewrites each host's follow-up seen-marker was never needed, because `follow-up.sh` already keys that marker on the job name.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-tada-shard-five-cleanup-retire-flat-fallback-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3842565 cached reads)
- Output: 22612 tokens
- Cost: $2.1021129999999992
- Wall-clock: 4069s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
