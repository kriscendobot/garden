**Viability report: endojs/endo-but-for-bots PR #1509**, "feat(cli): add endo write for mount files (daemon-mount Phase 6)"

The gauntlet may begin. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:** The PR is OPEN, a draft, and not merged. It was opened today (2026-10-19) by `build-daemon-mount-next-phase` and has one commit (`d830edc6`). Its base is `llm-92b91a7`, and that commit, `92b91a7e`, is also the current `llm` tip, so no newer base history has landed since it was written. There are no reviews or comments yet.

**Deciding question:** On current `llm`, is the `endo write <mount> <path>` CLI verb (daemon-mount Phase 6) still missing, with no other merged or open PR shipping it?

**Evidence:**
- **The command doesn't exist on `llm`.** `packages/cli/src/commands/` on `llm` has no `write.js`, and `packages/cli/src/endo.js` registers no `write` command.
- **The design still lists the phase as open.** `designs/daemon-mount.md` on `llm` reads "Status: In Progress". It says Phase 6 was only partly absorbed by #153 (`8a8e872d4`) and lists `endo write` as remaining work. The phases the PR's ledger claims are done (1–5) match what the design records as shipped (`e22f71327`, #339, #656).
- **Nothing newer replaces it.** Searching PRs for "endo write" and "daemon-mount Phase 6" finds only #1509 itself, #1510 (an unrelated test that composes `Git.filesystemAt` with a Mount), and #283.
- **#283 is the one overlap, and it doesn't supersede this PR.** #283 is older (2026-05-18), halted, and last updated 2026-10-10. It is a broader reshape of the `store`/`cat` flags that also adds `write`/`read`. This PR is deliberately narrower (raw stdin bytes, no mode flags) and says #283 can build on it later. Since #283 is open and not merged, it neither displaces this PR nor settles the need.
- **The premise still holds.** `EndoMount.write` and the `bytesReaderFromIterator` stdin bridge, which the PR reuses, are the existing mechanisms on the base. The design's last open phase is still unshipped.

Follow-ups: none. The next gauntlet stage (clean → panel → fix-loop → un-draft) can start.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1509-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (210748 cached reads)
- Output: 2062 tokens
- Cost: $0.40882159999999995
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
