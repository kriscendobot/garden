Fix round 3 for endojs/endo-but-for-bots#1574 is pushed and CI is green: 30 checks, 0 failed.

The job had no pre-pass block, so I worked from the latest panel verdict, review 5662962521 ("Must-fix before merge"). It had five must-fix items plus a number of should-fix and comment-only items. All the edits are in `designs/api-key-agent-workbench.md` and `designs/README.md`, in commit `033a55f51b`, which `safe-push-pr-head.sh` pushed onto `design/api-key-agent-workbench`. I also rewrote the PR body.

**Must-fix items:**
- **Second ledger (skeptic 1, critic 1, decomplector 2):** I removed the cached per-grant totals, so there is nothing that can drift or need rebuilding. The chain check now follows `parentGrantId`, which reaches at most 4 grants, and sums the ledger rows directly. The design now also says that each queue entry commits as one durable transaction, and that one provider's broker runs in a single vat. If running totals come back later, a benchmark has to justify them and they must be written atomically.
- **Pause bound (skeptic 2, critic 3):** the design now states the worst case of a default `pause` in absolute terms. Spend is at most the reservations already written, which fit under the paused grant's cap. Time is one wall clock, fixed when the turn is admitted. `pause({ cancelInFlight })` is now a decision in the first release, not open question 5.
- **Minting and the forwarder filter (decomplector 1, critic 4, skeptic 4):** `endow` now only copies values the owner holds. Minting moved into two new operations, `grant-workbench` and `grant-spawner`. I deleted the formula-type endowment filter, which a forwarder could bypass. The design now says plainly that the factory does not confine control-facet authority against forwarders, and that the chain check bounds spend.
- **Wrong identifier (archivist 1):** `isDeniedSegment` does not exist. It is now `assertSegmentAllowed` over `defaultDeniedSegments`.
- **PR body (integrator 1–3):** added the missing Documentation and Testing sections, a note that this PR merges only after #1543, and a note that this PR is where the five open questions get answered.

**Should-fix items, also applied:**
- Every grant that holds a spawner now gets a parent reserve in the first release, so a parent can always afford the turn that pauses or revokes a child. `getHeadroom()` reports it.
- `resize` now returns a `DelegationSummary`, so a resize below current usage reports `blockedBy: 'budget'` instead of looking like plain success.
- `AgentSpawner.list` is gone; the Fae adapter builds it from `listDelegations`.
- The design now states the worst case of the race between `askSubagent` and `pause`, and that the parent's control calls never need an ask slot.
- The design records why `paused` is a grant state rather than a reason field on an active grant.
- Cancelled turns billed at their reservation are now shown in the UI contract.
- W2 now starts with tests that check the code claims the design depends on, and the header says none of the chat-Clip behavior is verified.
- I applied copyeditor items 1–11.
- The README estimate row is marked provisional and non-additive, and the companion design is described as living in the minion.town repo.

**A wrong fact the panel did not catch:** while checking archivist finding 2, I found the design's ask-timeout figure was also wrong. `packages/fae/SUBAGENTS.md` says 300 s, capped at 3600 s, but the code defaults to 24 hours, capped at 7 days. Its depth and child limits are stale the same way (the code says 32 and 1024). The design now says the code governs and has brokered agents pass explicit 300 s and 3600 s ask-timeout limits. `SUBAGENTS.md` itself is still wrong; fixing it was out of scope.

**Items I did not change:**
- **Critic 6:** the claim that the design is missing from the roadmap is wrong; it already has the `akwb` node and edge in the dependency graph and a row in the M3 table.
- **Critic 7:** I added a note that open question 3 should be settled before the design is accepted, but left the question open.

Panel-4 is next (the driver re-posts it). No garden repo changes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3768302 cached reads)
- Output: 29784 tokens
- Cost: $2.2766203999999997
- Wall-clock: 930s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
