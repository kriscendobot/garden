I opened draft PR **endojs/endo-but-for-bots#1625**, "feat(exo-agent-factory): coordinator facet for durable facet formulas". It adds the coordinator side of durable revocation and the fail-closed restart path. It does not add a single-use credential lease, because the design rejects one (explained below).

**Where it stacks:** on #1560, the first factory slice. Its base is a frozen snapshot of that branch (`build/exo-agent-factory-core-21d142a`), and it should be retargeted to `llm` once #1560 lands. I skipped #1593 and #1596 as stacking points: #1596 is an exo-npm resolver fix and #1593 adds HTTP workspace tools, so neither carries child-agent factory code.

**No duplication:** `build-endo-child-agent-factory-slice-2` is still parked in `plan/`, blocked on #1560. It owns the daemon wiring: the pinned coordinator formula, the daemon formulas that rebuild facets, and the Fae/Lal adapters. This PR adds only the coordinator piece those formulas call, so slice 2 needs no coordinator changes.

**Why no lease:** the design (`designs/endo-child-agent-factory.md`, #1558) lists "a bespoke lease and revocation protocol" among the parts it rejects, because the maintainer rejected that breadth when reviewing #1102. Credential acquire and release stay inside `@endo/inference`'s `CredentialSource`. So I built durable revocation and fail-closed restart with what the design already has: the per-namespace journal and durable facets. The PR body says this too.

**What changed** (`packages/exo-agent-factory`):
- **New coordinator facet:** `ChildAgentCoordinator`, exposed as `coordinatorFacet`. It belongs only in the factory's private directory, and the durable formulas use it to rebuild facets after a restart. `src/interfaces.js` defines the interface and `src/coordinator.js` implements it.
- **Revoked namespaces stay revoked:** `boundFacet(namespaceId)` rebuilds a namespace's facet from the running coordinator. A revoked namespace's id is never reused, so its rebuilt facet rejects every call after restart, even after a new namespace takes the old name.
- **Removed children stay inactive:** `lifecycleFor(operationId)` returns the current lifecycle for a child that still exists. For a child that was removed, or swept by a revocation, it returns a lifecycle that is never active. A runner revived from an old formula therefore never starts reading its mailbox.
- **Unknown ids are refused:** both methods reject ids the coordinator never issued. That covers the root namespace, unknown namespaces, malformed keys, and keys the journal hasn't reached yet, so an old formula can't later point at a different child or namespace.
- **Existing helper kept:** the old `boundFacet` on the returned record now goes through the new facet and behaves the same.
- **README:** updated to describe the new facet.

**Tests:** all 47 package tests pass, including 5 new ones; `eslint` and `tsc` are clean. The new tests check that:
- the facet returns the same objects within one run;
- a revoked facet rejects all seven methods after restart;
- a rebuilt lifecycle sees a later removal;
- removed and revoked children get inactive lifecycles;
- ids the coordinator never issued are refused.

**Follow-ups:**
- When #1560 merges, #1625 needs a weave onto `llm`.
- `build-endo-child-agent-factory-slice-2` should stack on #1625 and use `coordinatorFacet` for its formulas.
- The PR is still a draft; the gauntlet will pick it up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-agents-capability-slice-after-1596.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2615751 cached reads)
- Output: 22371 tokens
- Cost: $1.7337382000000003
- Wall-clock: 314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
