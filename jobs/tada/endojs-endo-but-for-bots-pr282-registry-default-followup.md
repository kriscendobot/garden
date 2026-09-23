Inbox empty. Work complete.

## Completion report

**Job:** Explore reconciling PR #282's compartment-mapper resolution path with the endor registry cache (maintainer review ask 3, 2026-08-16), then go to design or build.

**Decision: design, not build.** I chose a design-record update over more code, and stated the reasoning plainly.

**Assessment.** The sibling pin-the-merge-base weave (`04f03efe98`) had already landed the mechanical reconciliation: default `endor run <entry.js>` → the registry-cache resolver (`cmd_run_entry`), the node_modules walker demoted behind an explicit `--node-modules` flag — exactly the flag shape the review asked for, pinned by unit tests. So there was no competing flag surface to build. I verified the load-bearing question — is the new default a *complete* replacement or a regressing stub? — by reading `assemble::assemble_entry`: it resolves workspace-member edges against local working trees and non-workspace deps from the registry cache, never consulting `node_modules`. That is precisely the "non-workspace deps without the node_modules tree" semantics the maintainer described, and it covers both the monorepo and external-dependency cases. The default flip is functionally sound.

**What was actually missing:** the *design record*. `designs/endor-run-expanded.md` still framed the walker as *the* Phase 5 run path and listed the registry-table path as not-yet-landed — the design lied about the shipped default.

**What changed (commit `86745db2b0` on `feat/endor-run-entry-point-deps`, pushed):**
- Status now records the registry-cache resolver as default, walker as legacy `--node-modules` path.
- New "Reconciliation with the registry-cache resolver" section: the two resolvers' opposed means, the flag-gated dispatch decision, and the justification that the default is complete (workspace + external), not a stub.
- Corrected the stale item-3 note: the registry path landed standalone via `endor-npm-registry-proxy` Phases 4/5, superseding the old "extend `resolve_bare`" plan.
- Recorded the walker's end-state: a legacy escape hatch whose removal is a follow-up gated on the compartment-mapper fixture-parity drift safeguard (the maintainer's separate ask, already a live job on this PR) — I did not pre-empt that thread.

**Also:** posted a summary comment on PR #282 (`#issuecomment-5310900463`) stating the design-vs-build choice and its rationale.

**Follow-ups (already owned elsewhere, not orphaned):** the walker's eventual deprecation depends on `endojs-endo-but-for-bots-pr282-fixture-parity` proving compartment-mapper parity; recorded in the design, not re-posted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr282-registry-default-followup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 41 tokens (1385233 cached reads)
- Output: 19518 tokens
- Cost: $1.8767815000000003
- Wall-clock: 302s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
