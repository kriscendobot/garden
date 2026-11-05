---
handed-off: endojs-endo-but-for-bots-pr1648-fix-2-summary-relay
deliverable-complete: false
---
**Result: all must-fix items are pushed, but CI is red on both macOS jobs, so this stage did not reach `fix=done`.**

- **Head:** `28980e08bf`
- **`ci-wait-merge`:** rc 3. `test (22.x, macos-15)` and `test (24.x, macos-15)` failed; both Ubuntu test jobs and lint passed.

## CI failure
- **What failed:** `packages/claude-sandbox/test/restore-context.test.js` on both macOS jobs. 528 tests passed, then "1 uncaught exception" with no stack in the log.
- **Cause not proven:**
  - The test imports no daemon or `hosted-agent` code, and #1651 showed the same failure on Node 24 macOS.
  - The new `@endo/daemon` change is what pulled `claude-sandbox` into the affected test set.
  - It passed 3 of 3 runs locally on Linux Node 22, which says nothing about macOS.
  - Failing on Node 22 as well points to a macOS-specific defect rather than a Node 24 flake.
- **Rerun:** `gh run rerun` returned 403 from this host, so a rerun has to come from a host with Actions write access or the maintainer.

## What changed
- **`a6f19c3bc8`:** adds an atomic `compareAndStoreIdentifier` to daemon directories, hosts and guests, with help text and tests.
- **`a7812852ae`:**
  - **Provider capabilities:** a capability must now designate the exact provider requested and be the registry's own facet. Otherwise the request is refused with `provider-use-mismatch`.
  - **Name races:** naming and unnaming an agent use the new atomic call, so an owner's concurrent rebinding is not overwritten or deleted.
  - **Reattachment:** `priorGrantId` is recorded at intent, so the reconciler can't revoke a grant whose reattachment is unfinished.
  - **Idempotent retries:** these compare canonical data, so field order no longer causes a conflict.
  - **Deleted agents:** their inference facets are evicted and never cached again.
  - **`AGENT_FACTORY_RECONCILE_MS`:** must be an integer from 1 to 2147483647 and fails at start otherwise.
  - **Types and docs:** `wake` and `endowments` are now required, `./agent-factory-module.js` is exported, and the README and changeset describe provisioning rather than running a harness.
  - **Should-fix items also taken:** fixed refusals for mistyped `limits` and `harnessConfig`, the full caplet settings table, and a one-pass active-turn index in `listGrants`.
- **`28980e08bf`:** repairs my own lint failure. `eslint --fix` had stripped unrelated `eslint-disable` lines, so I rebuilt the change from the previous head and formatted with prettier only. No directives are removed now.

## Must-fix findings I did not apply as asked
Both follow the design in #1543, so panel-3 may raise them again:
- **Lal's `adopt` (breaker):** kept, because the design gives both harnesses mail `adopt` and reserves dynamic tool adoption for Fae. I corrected the catalog description instead, which the finding allowed.
- **Root `directoryFor(ownerId)` (locksmith, first half):** kept, because the design has the web tier obtain a directory using the owner key from the account gate. The finding's capability half is fixed.

## Should-fix items not done
- An attenuated facet for `listGrants`.
- Moving the typedefs to a types module.
- Reconciling the catalog with `designs/README.md`.

## Verification
- **Tests:** on the final tree, the `agent-factory`, `agent-factory-module`, registry, store-controller, pet-sitter, help-text and real-daemon `agent-factory-restart` tests pass.
- **Types and lint:** `tsc` is clean in both packages and eslint reports no errors on the changed JavaScript files. CI's lint job passes.
- **Not run locally:** the full daemon suite and the two new-primitive race paths under real concurrency; the race tests use a mock store and sequential calls on a real guest.

## Follow-ups
- **Summary comment:** this host gets a 403 on PR comments, so the scribe's required summary is not posted yet. I posted `endojs-endo-but-for-bots-pr1648-fix-2-summary-relay`, pinned to `endolin-garden-ece02cb4`, which also updates the PR body.
  - I sent it a correction for the new head SHA.
  - Its text still says CI is pending, so it needs updating to red once it runs.
- **macOS failure:** someone should rerun the failed jobs or investigate `restore-context.test.js` on macOS, since it may now block this PR.
- **Memory:** I added this sighting to the macOS failure note.

<<<GARDEN-ORCHESTRATION-FAILED>>>

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1648-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (6408782 cached reads)
- Output: 56839 tokens
- Cost: $4.1144004
- Wall-clock: 5444s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
