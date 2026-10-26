I built the daemon side of step 3 and opened it as draft PR https://github.com/endojs/endo-but-for-bots/pull/1561. All 27 package tests pass locally, including four new ones against a real daemon that restarts; CI has just started and hasn't reported yet.

**Where it sits.** The branch `build/exo-agent-factory-daemon-wiring` (`a6d6066c10`) is stacked on #1560's head. That head moved to `8c4a87e9da` while I worked (a fast-forward that only added tests), so I rebased onto it. `ensure-pr.sh` requires a frozen base, so I pushed the snapshot `build/exo-agent-factory-core-8c4a87e` and used it as the PR base. The work extends #1560's package; the coordinator is not rewritten.

**What changed (all in `packages/exo-agent-factory`):**
- **Real `PrivateHost`** (`src/daemon-host.js`): adapts the `agent-factory` child host to the coordinator's port. Formula type and powers come from `E(host).diagnostics()` → `getFormula(id)`, so the gap the job anticipated does not exist.
- **Pinned coordinator** (`src/daemon-coordinator.js`, `src/install.js`): `installChildAgentFactory(host, { rootPolicy })` creates the child host with `provideHost`, formulates the coordinator with `makeUnconfined('@main', …, { powersName: 'agent-factory' })`, pins it in the root host's `@pins`, and creates the root facet. Running it again converges on the same setup.
- **Durable facets:** `bind`/`attenuate` results and each runner's lifecycle are now `evaluate` formulas over `boundFacet(nsId)` / `lifecycleFor(opKey)`, replacing #1560's in-memory exos.
- **Startup split:** `makeChildAgentCoordinator` exposes `replayed` and `ready`. Facet calls wait for reconciliation, but re-deriving a facet waits only for replay. Without the split, the coordinator waits on itself: the daemon evaluates facet formulas during reconciliation and runner start, and a spike against a live daemon hung exactly that way.

**Contract change to review.** `installDriver` now returns `{ specifier, env? }` instead of `{ responder }`, and the coordinator formulates the runner itself at its own derived name.
- **Why:** the daemon's `storeValue` wraps any value in a new `marshal` formula. A responder handed back by the maker could only be kept behind that wrapper, and no replay can prove the wrapper's formula type or powers. The design's recovery matrix already assumes the coordinator makes this call ("no second `makeUnconfined` call").
- **Knock-on edits:**
  - I amended `designs/endo-child-agent-factory.md` to match.
  - Endowments are now installed with `copy`, which keeps the formula id.
  - The fake daemon gained `copy` and `makeUnconfined`.
  - #1560's newest test ("a responder formulated with other powers fails closed") assumed a maker could pick the runner's powers, which is no longer possible. It now plants the wrong-powers runner directly, as only a coordinator defect could. The fail-closed property is still tested.

**New daemon tests** (`test/daemon.test.js`):
- A committed child's runner comes back after restart with no facet call and no mail, and still answers mail.
- A child that replaces everything in its own `@pins` still comes back and answers mail.
- A stored bound facet and the runner's lifecycle facet work after restart without being re-issued.
- A revoked facet rejects every call after restart.
- Removal leaves nothing behind and stays removed after restart.

Crash injection inside a real daemon isn't attempted; the in-memory tests cover those crash points.

`tsc`, `eslint` and prettier are clean, apart from one `@ts-nocheck` warning in the daemon test, the same as the existing endo-fs-asset-server test. `yarn install --immutable` accepts the lockfile, which is in its own `chore: Update yarn.lock` commit. There is a new changeset.

**Local environment note:** this host only has Node 22, and the shared `better-sqlite3` binary is built for Node 24. To run the daemon tests I pointed this worktree at a Node 22 copy under `$TMPDIR`, then restored the original link. Nothing shared was changed.

**Follow-ups:** the gauntlet for #1561 stages on completion. Plan steps 4–6 (inference/Fae/Lal maker adapters, the turn ledger, reply collapse) remain; the step-4 adapters should target the new `{ specifier, env? }` shape.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-exo-agent-factory-daemon-wiring.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 176 tokens (14472325 cached reads)
- Output: 83571 tokens
- Cost: $6.417805000000002
- Wall-clock: 1277s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
