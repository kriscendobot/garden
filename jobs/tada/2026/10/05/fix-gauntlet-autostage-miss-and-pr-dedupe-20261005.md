I fixed both gauntlet-staging defects and landed the fix on main2 as `de50427c6a2`, with regression tests for each.

**1. Why #163 was never staged.** The step that stages a gauntlet when a job completes skips "probe" jobs, which are drafts on purpose. It decided a job was a probe if the job file contained the word "probe" anywhere. The job `build-minion-town-caddy-restart-on-env-change` says "Optionally, strengthen the smoke probe…", so the build was treated as a probe and staged nothing. c051d90c70b didn't touch that check.
- **Fix:** a shared check, `is_probe_job` in `scripts/jobs/common.sh`, now used by both `auto-gauntlet-handoff.sh` and `assert-producer-pr-draft.sh`. A job only counts as a probe when:
  - it uses "probe" as an instruction (`probe #N`, `probe <PR URL>`, `probe owner/repo#N`, "probe the design"), or
  - it mentions `gap-revealing`, or
  - it has a `kind:`/`verb: probe` header or a `probe-*` file name, or
  - the PR title or body says "gap-revealing prototype".
- **#160's earlier miss had a different cause.** Its job file never says "probe". Its `role:` header sat after a second frontmatter block, so the pre-c051 builder detection never fired. c051d90c70b already fixed that.

**2. One active gauntlet per PR.** #160's two gauntlets had different names (`build-…-gauntlet` was staged at 16:52 under the old naming, `kriscendobot-minion.town-pr160-gauntlet` at 18:08). The existing duplicate check only compared names, so both were allowed.
- **`post-gauntlet.sh`** now refuses a second record on the same PR, under any name, while another one is still running. It exits 0 and logs `WARN: DUPLICATE GAUNTLET REFUSED`, naming the running gauntlet and who asked. A gauntlet that has finished or halted doesn't block a fresh run.
- **`gauntlet.sh`** catches two requests that both get past that check at the same moment. Before spending anything on a new record, it yields if another active record on the same PR already has a stage running or was recorded earlier. The yielding record is closed out with `gauntlet-status: coalesced` and `coalesced_into: <winner>`, logged as `WARN: DUPLICATE GAUNTLET COALESCED`, and reported in a maintainer inbox notice.

**Tests**
- `auto-gauntlet-handoff-test.sh` has two new cases: a build that says "smoke probe" now stages a gauntlet, and a job that says "probe #12" still doesn't. I checked that the first case fails against the old handoff script.
- The new `gauntlet-pr-dedupe-test.sh` covers the refused second post, that a halted gauntlet doesn't block a new one, and both driver-side cases. All 10 checks pass.
- These existing suites pass after rebasing onto the peer commit `7d3ec941b11` ("recover missed draft handoffs"): assert-producer-pr-draft, gauntlet, gauntlet-pin-gate, gauntlet-resume, reaper-gauntlet-handoff, design-pr-gauntlet-coverage-audit, comment-watcher, gauntlet-panel-quota, panel-parallel-fanout, followup-posted-gate, panel-head-freshness, retry-narrowing and accountant-arc-apportionment.
- `productive-cycle-test.sh` fails 2 of 14 checks, but it fails the same way on unmodified main2, so my change didn't cause it.

I also added a note on both fixes to `designs/auto-gauntlet-pr-reconciler.md` under "Current failure boundary".

**Follow-ups**
- A yielded record is closed out with a completion report while the winning gauntlet is still running. An orchestration that watches a gauntlet by name as one of its steps would read that as finished. This only happens when a duplicate is actually yielded.
- Gauntlets that were already both running before this change are left alone; the guard only applies to new records.
- `productive-cycle-test.sh` needs its own look.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-gauntlet-autostage-miss-and-pr-dedupe-20261005.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3694293 cached reads)
- Output: 24422 tokens
- Cost: $2.0582666
- Wall-clock: 1260s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
