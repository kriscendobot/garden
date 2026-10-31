I didn't open a new PR. This job duplicates work the fleet has already done, and a second PR would compete with the stack that's already open.

**Why it's a duplicate**
- The design PR #1102 was closed. It had been rewritten into a different design ("introduced special names"), which #1343's unified guest-endowments work then replaced.
- The design this job wants was redone as `endo-child-agent-factory.md` in **endojs/endo-but-for-bots#1558** (job `design-endo-claude-agents-capability-20261026`). It is open and out of draft but has no maintainer approval yet. Its design says implementation waits for that approval.
- The implementation was built by `build-endo-claude-agents-capability-20261026` and the orchestration `orchestrate-endo-exo-agent-factory-remaining`, which finished with every child reporting success. It is a stack of five open PRs:
  - **#1560** core coordinator (`@endo/exo-agent-factory`), out of draft. Its gauntlet is still running its last (un-draft) stage.
  - **#1561** daemon wiring (draft), on top of #1560.
  - **#1562** child topology and maker adapters (draft), on top of #1561.
  - **#1563** journaling and replaying driver turns (draft), on top of #1560.
  - **#1564** collapsing republished replies (draft), on top of #1563.
- The other half the job mentions, `@endo/claude` (#1015), merged on 2026-09-29, so nothing is blocked on it.

**Likely cause of the re-post:** `designs/README.md` on `llm` still lists `endo-claude-agents-capability` as "Proposed" and calls #1102 an open draft. Whatever posted this job probably read that row. #1558 deletes it, so the stale entry disappears once #1558 merges.

**What I changed:** nothing. No garden commits, no project pushes, no PR.

**Follow-ups**
- The maintainer needs to approve #1558. #1560 and the rest of the stack stay pending until then.
- If another `build-endo-claude-agents-capability*` job appears before #1558 merges, it should be closed as a duplicate the same way. A producer reading the README roadmap could also check for an existing `exo-agent-factory` stack before posting a build.

Self-improvement: nothing this time.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8e670033771d50d42aa23d0c6c1f362db2e7a275`; this job presented `dcf4d6034ed9f0e16db5a0d943823e8ba166a088`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-agents-capability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1004457 cached reads)
- Output: 5642 tokens
- Cost: $0.8789153999999999
- Wall-clock: 102s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
