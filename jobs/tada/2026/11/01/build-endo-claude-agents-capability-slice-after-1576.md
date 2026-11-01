I opened draft PR **endojs/endo-but-for-bots#1627**, "test(exo-agent-factory): cover the crash cut inside infer on a real daemon". It is stacked on #1626.

**The job named the wrong PR.** #1576 is an unrelated docs audit of the text codecs. The job came from the foreman's `slice-after-N` series for the plan record `endo-claude-agents-capability` (design #1558, `designs/endo-child-agent-factory.md`), so I worked from that design. I left the API-key provider line (#1543 → #1573/#1575) alone: the `claude-api-build-20261027-resume` orchestration owns it, and it is waiting at phase 3 on #1575.

**What was left to build.** All six implementation-plan steps already have open PRs: #1560–#1564, #1625 and #1626. One verification row was still unbuilt, and #1626's report said so: on a real daemon, a mail loop must survive a crash inside `infer` after a fake tool effect. The design requires that the re-run and the repeated effect be asserted, not hidden.

**What changed** (in `packages/exo-agent-factory`, tests only):
- **New test caplet, `test/_daemon-crash-maker.js`:** the inference maker over a fake backend. Each `infer` call first appends the prompt to an effects file, then stays open for as long as a hold file exists.
- **New serial test in `test/daemon.test.js`:**
  - With the hold in place, the driver's ledger holds only `turn-…-started` and no reply has been sent.
  - After removing the hold and restarting the daemon, the turn runs again, the effect appears twice, and exactly one reply arrives.
  - After a second restart and a new message, only the new message adds an effect, so a turn whose result is recorded is never inferred again.
- **Header comment:** updated to include the new case.

**Tests:**
- **Full daemon suite:** 6 of 6 pass under Node 24.
- **The test can fail:** when the ledger treats a started turn as already finished, the test times out waiting for the reply.
- **Lint and gates:** ESLint and Prettier are clean on the touched files, and the pre-push gates pass.
- **Not covered on a real daemon:** a crash after `TurnResult` but before publication. Nothing in the daemon lets a test stop at that point, so the in-memory tests from #1563 remain its only coverage. The PR body says this.

**Base:** a frozen snapshot of #1626's head, `build/exo-agent-factory-durable-inference-driver-5842e0c`. Basing it on `llm` would drag the five open stack PRs into the diff.

**Follow-ups:**
- **Duplicate job:** `build-endo-claude-agents-capability-slice-after-1573`, still in `todo/`, asks for the same "next slice" of the same design. Every plan step now has a PR, so it should be withdrawn rather than claimed, or it will produce another overlapping PR.
- **Foreman keeps posting:** the foreman keeps posting `slice-after-N` jobs for this record even though nothing unbuilt is left beyond review and merge.
- **Plan record is stale:** `plan/designs/endo-but-for-bots/endo-claude-agents-capability.md` still lists only #1560. It should add #1561–#1564, #1625, #1626 and #1627.
- **Formatting fault in #1626:** the pre-push gates reformat `test/adapters.test.js`, which #1626 added. I reverted that change to keep this diff to my slice, so #1626 still has a Prettier fault for its own fix loop.
- **Retarget when #1626 lands:** #1627 needs a weave once #1626 merges.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-agents-capability-slice-after-1576.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2990695 cached reads)
- Output: 17898 tokens
- Cost: $1.8014109999999997
- Wall-clock: 853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
