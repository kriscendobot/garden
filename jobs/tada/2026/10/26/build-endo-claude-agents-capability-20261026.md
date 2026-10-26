---
handed-off: orchestrate-endo-exo-agent-factory-remaining
deliverable-complete: false
---
I opened draft PR [endojs/endo-but-for-bots#1560](https://github.com/endojs/endo-but-for-bots/pull/1560), but it covers only part of the design in #1558. The rest of the design's six-step plan is now owned by a posted successor orchestration.

**What #1560 contains**
- **New package:** `@endo/exo-agent-factory`.
- **Branch and base:** head `build/exo-agent-factory-core` at `4bfa9d576b`. It is stacked on the design branch: base `design/endo-child-agent-factory-8e67003` is a new frozen snapshot of that branch, which itself sits on `llm-d5ac419`. `llm` had not moved, so no weave was needed.
- **Scope:** step 1 of the plan, plus the coordinator logic of step 3. That logic is written against a small host interface (`PrivateHost`) rather than the real daemon:
  - The root factory facet, the bound factory facet and the read-only lifecycle facet, with their guards.
  - A policy merge that can only narrow a parent's policy, with the child quota shared across derived namespaces.
  - A per-namespace append-only journal that state is rebuilt from at startup.
  - Each creation step (Intended → GuestCreated → Endowed → DriverCreated → Pinned → Committed) checks the name first and adopts an existing value only after proving its type.
  - Removal is idempotent, `revokeDerived` works, and startup reconciliation fails closed when a name holds the wrong kind of value.
- **Tests:** 20 tests against an in-memory fake daemon that can crash at any step. They include full crash matrices for `create`, `remove` and `revokeDerived`.
- **Checks:** the tests pass. Package type-check, eslint and prettier are clean, and so are the root `tsc -p tsconfig.json`, `build:types:check`, the package-uniformity check and the SECURITY.md check.
- **Commits:** yarn.lock is in its own `chore: Update yarn.lock` commit.

**Interpretations for review (listed in the PR body)**
- The root facet also has `listDerived` and `revokeDerived`. The design's interface lists only `bind`, but its text says the root host can reclaim each `bind` result.
- A revoked derived namespace drops out of `listDerived`, the same way a removed child drops out of `list`.
- `followActive()` returns a remote iterator with a `next()` method.

**Handoff**
I posted `orchestrate-endo-exo-agent-factory-remaining` (serial; halts if a child fails). It has four parked children, each stacking on the previous PR:
1. `build-endo-exo-agent-factory-daemon-wiring`: the daemon side of step 3 (real host, pinned coordinator, facets that survive restart, daemon-backed recovery tests).
2. `build-endo-exo-agent-factory-maker-adapters`: steps 2 and 4 (Fae spawner adapter; inference, Fae, Lal and Claude makers).
3. `build-endo-exo-agent-factory-turn-ledger`: step 5.
4. `build-endo-exo-agent-factory-reply-collapse`: step 6.

**Follow-ups**
- **Maintainer approval:** the design says implementation waits for the maintainer to approve it. #1558's gauntlet finished and it is no longer a draft, but it has no maintainer approval yet. #1560 stays a draft until it does.
- **Possible daemon gap:** the first successor may find the daemon has no way to read which guest a driver was created with (the proof that a driver belongs to its child). If so, it should report that as a gap rather than weaken the proof.

Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-agents-capability-20261026.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (7548982 cached reads)
- Output: 66893 tokens
- Cost: $4.136688400000001
- Wall-clock: 790s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
