# Gauntlet fix round 2: endojs/endo-but-for-bots PR #1558

I applied every finding from the latest panel review (5646300388): must-fix and should-fix items from all eight jurors. I pushed the fix as one follow-up commit, `4b21866de6`, to `design/endo-child-agent-factory`. CI on that head is green: 30 checks, 0 failed (6 passed, 24 skipped, which is expected for a docs-only change). The job carried no pre-pass block, so the review was the source of findings.

## Fixes in `designs/endo-child-agent-factory.md`

- **skeptic, `@pins` tampering:** I checked the daemon source and the finding is correct: a guest can write its own `@pins`. The daemon does keep a host-only pins directory per guest, but nothing lets a host write to it today. So the responder now lives in the coordinator's private directory, and the coordinator revives it at daemon start. The doc records that a future host-side writer could add wake-on-mail. I added a test where the child wipes its `@pins` and still resumes.
- **critic, coordinator revival:**
  - The coordinator is now specified as one `makeUnconfined` formula whose powers are a dedicated `agent-factory` child host, not the root host.
  - It is pinned in the root host's `@pins`, so it revives when the daemon starts.
  - It reconciles before it serves any call, then revives every committed child's runner.
  - The factory facets and each child's `AgentLifecycle` are durable `evaluate` formulas that depend on the coordinator, so they survive a restart.
- **skeptic, crash before the reference is recorded:** recovery now proves ownership by where a value lives (a directory only the coordinator writes) and by an intent entry written before the effect. Each step is a daemon call that creates and names a value in one go, and returns the existing value if the name is taken, so a replay adopts what the first attempt made. A wrong-type entry fails closed. The new tests cover both sides of that crash point.
- **decomplector, duplicate output:** new § Turn publication. Delivery is at-least-once, keyed by the child's message number, with a ledger of turn started, result recorded, and published. A recorded result is never sent back through inference. The only possible duplicate is an identical republish carrying the same key.
- **ergonomist:** `create` now returns `{ summary, handle }`, the child's mailbox handle, and there is a new `lookup(name)`. A new § Operation semantics says when `create`, `remove`, `list` and `lookup` resolve or reject, including duplicate, unknown and in-progress names.
- **critic (should-fix) and novice:** every `bind` and every new `attenuate` call gets a fresh namespace, and nested namespaces count against their parents' quotas. A new § Issuance has an end-to-end example of a host binding a maker and handing only the bound facet to a UI.
- **copyeditor:** all three wording fixes applied.
- **pedant:** replaced the en dash.
- **pruner:**
  - Deleted the paragraph that repeated the replacement claim.
  - Cut the prose under the ownership table down to its one new point.
  - Removed the prompt footer.

## `designs/README.md`

- **pedant:**
  - Removed the two added em dashes in the endo-claude row.
  - Added the design to "Recently added or revised".
  - Added a totals line: Proposed 33, 252 indexed records.
- **Follow-on from the redesign:** updated the factory row and the estimate row to describe the pinned coordinator instead of `@pins`.

## PR body

- **pruner:** removed the per-file tour and cut "Testing Considerations" to one line.

## Checks I ran

- Prettier passes on both files.
- Both Mermaid diagrams in the design parse.
- I did not re-run `yarn docs` this round, and I took that claim out of the PR body.

## Follow-ups

- The panel-3 re-review is the gauntlet driver's to post; this job did not run it.
- The `endo-claude-inference-backends` M3 row says "In Progress" while its summary-table row says "Draft". That mismatch was already in the PR, no juror flagged it, and I left it alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1558-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3132328 cached reads)
- Output: 23328 tokens
- Cost: $1.9361135999999997
- Wall-clock: 959s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
