Fix round 2 for kriscendobot/minion.town PR #183 is pushed as `07e6a4d` (head moved from `a67ed99`), and CI is green: `ci-wait-merge.sh` returned rc 0 with all 3 checks passing.

**Must-fix items from panel round 9 (review 5514724525)**
- **decomplector, with locksmith's matching should-fix (the origin label only protected itself):** I removed the label instead of hardening it again. The `promptOrigin` option, the `PromptOrigin` type and `gateOnPromptOrigin` are gone.
  - `prompt-origin-gate.ts` is now `src/endo/claude/containment.ts`. Its `refuseUncontained(provider)` hands out exos that always answer `needs-containment` without calling the backend.
  - `ClaudeAgentsContext` gains a separate `rootProvider`, set through a new `rootProviderFor` seam in `wiring.ts`. Only `makeRootAuthoredInfer` mints from it.
  - In `claudeCliSeamsOver`, facet agents get `refuseUncontained(backend.providerFor(subject))` and the root path gets the backend itself.
  - When `rootProviderFor` isn't set, it falls back to the facet provider. That keeps non-CLI deployments and tests working as before.
  - `test/claude-containment.test.ts` replaces the old gate test. The two MCP-tool tests in `claude-agents-tools.test.ts` now pin the split.
- **migrator (breaking change):** the PR body now says this is a deliberate breaking change for delegated and inbox callers. It also states that no production caller depends on the root backend, since no production Claude traffic is enabled.
- **pruner (asked for edits to the description, not code):** I cut the "Review notes" section from the PR body. The DEPLOYMENT.md bullet, renamed "Containment refusal", now covers only what is refused, which callers are affected, and the breaking change.

I posted a PR comment covering the changes and answering decomplector's question about reusing `makePromptOriginGate`. With no label left, there is no parallel gate to reconcile with it.

**Local checks:** typecheck is clean and the 27 Claude test files pass (344 tests). The full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). This PR doesn't touch that code, and CI's `test` job passed on the new head.

**Should-fix items left for later rounds:**
- Narrow the `@secrets` facet's raw catalog and importer.
- Keep `inferRootAuthored` out of the shared `ClaudeHandles`.
- Decide whether the vault needs both a JSON sidecar file and the blob description.
- Document or back up the one-way credential migration.
- Confirm nothing outside the repo implements `ClaudeHandles` without the new field.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-78df7d85-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2441041 cached reads)
- Output: 20881 tokens
- Cost: $1.7248762000000004
- Wall-clock: 1021s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
