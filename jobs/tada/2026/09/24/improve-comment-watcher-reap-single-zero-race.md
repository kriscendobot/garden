The cgroup straggler sweep in all three watchers now stops only after two consecutive zero-reads, not one. The change is pushed to `main2` as `098bdfccb51`.

**What changed**
- **The fix.** `reap_cgroup_stragglers` is changed the same way in `scripts/jobs/comment-watcher.sh`, `scripts/jobs/issue-inbox-watcher.sh` and `scripts/jobs/dependabot-watcher.sh`. A new `zero_reads` counter goes up on each pass that finds no live stragglers. The sweep returns only when the counter reaches 2. The two reads are 0.1s apart (the existing sleep), and any pass that finds a straggler resets the count to 0.
- **Deadline.** The per-watcher `*_CGROUP_REAP_DEADLINE_SECS` limit still caps the loop. If the deadline arrives between the first and second zero-read, the sweep returns without the WARN, because nothing was left in the cgroup. The WARN still fires when stragglers really remain.
- **Regression tests.** I added FF4 to `comment-watcher-test.sh`, REAP2 to `issue-inbox-watcher-test.sh` and R2 to `dependabot-watcher-test.sh`. In each, the fixture `cgroup.procs` is a named pipe fed by a helper process, which makes the order of events fixed rather than timing-dependent:
  - the sweep's first read gets nothing;
  - the helper then starts a straggler in its own session after a 0.05s delay;
  - every later read lists that straggler.

  The case passes only if the straggler is dead once the watcher exits.

**Verification**
- With the fix, all three suites pass: dependabot 53/0, issue-inbox 46/0, comment-watcher 381/0.
- I temporarily restored the old loop, and the new case failed in the dependabot and issue-inbox suites (52/1 and 45/1). The old sweep returned on its first empty read, so it never read the straggler. I did not repeat that check for comment-watcher; its FF4 case uses the same fixture.
- shellcheck: no new findings in the watcher scripts or the test files.

**Follow-ups:** none required. The test262 leak should stop recurring once hosts pick up this commit through the normal rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-reap-single-zero-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (972289 cached reads)
- Output: 12553 tokens
- Cost: $0.9422938000000001
- Wall-clock: 340s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
