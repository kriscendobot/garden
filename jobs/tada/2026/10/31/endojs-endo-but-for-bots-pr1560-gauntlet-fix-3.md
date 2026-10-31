I applied every must-fix from the round-3 panel on PR #1560 and pushed them, but CI was still running when the one-hour deadline ran out (`ci-wait-merge` returned 4). Four test legs (Node 22.x and 24.x on ubuntu-latest and macos-15) were still going after 3600s. Every other check had passed by then, including `lint` on the final head, and none had failed.

**PR head:** `bccc126f` → `949b0a38a8b`, in four follow-up commits pushed with `safe-push-pr-head.sh`. The package's 41 tests and `yarn lint` passed locally, and the root `tsc -p tsconfig.json` showed no errors for this package.

**What changed**
- **Leftover saved inputs (assessor, breaker, wire-watcher, engine-realist, integrator):** a crash could leave capabilities saved that no log entry recorded. Now:
  - `create` clears every `c<key>.e*` endowment slot before reusing an operation key.
  - On restart, the coordinator removes registry, maker and child names that no log entry reached.
  - Revoking a bound namespace now removes its `maker<n>` entry.
- **Faults survive a resumed revocation (breaker):** faults are now written to the journal as a new `Faulted` entry. Removal re-checks the coordinator's guests before deleting anything, and revocation leaves faulted records reserved. Previously a revocation resumed after restart could delete the mismatched name.
- **Queued remove/create/remove (saboteur):** `remove` now looks the name up again once its turn comes. Replay only drops a removed child from the name index if it is the same operation, so it can no longer delete a replacement child.
- **Unbounded memory (engine-realist):** removed operations now leave the in-memory index, both live and on replay.
- **Numeric range (spec-keeper, purist, integrator):** policy counts are now integers from 0 to a new exported `MAX_POLICY_COUNT` (`2**32 - 1`). The README presents this as a four-byte profile choice rather than a JavaScript limit.
- **Types and guards (typist, purist):** `EffectivePolicy.endowmentNames` is `readonly`, and the internal types moved to a type-only `src/internal-types.ts`. The maker's `lifecycle` argument is now guarded as `M.remotable('AgentLifecycle')`.
- **Changelog (packager, curator, changeset-auditor):** `CHANGELOG.md` is now the standard empty stub.
- **Tests (prover, corner-prober):** the stale-endowment test now fails if the cleanup is removed. New tests cover a crash between endowments, a crash before `Derived`, maker release on revoke, a fault followed by revoke and restart, a resumed removal, the queued remove race, zero quota, `__proto__`/`constructor` endowment names, and the 127-versus-128 supplementary-character name limit.
- **PR body and summary comment (gateway, scribe):** the PR body now explains the root `tsconfig.composite.json` change. A summary comment (issuecomment-6543484373) lists the changes, how they were verified, and what was declined.

**Declined or deferred (reasons are in the PR comment)**
- releaser's request to remove the changeset: kept, because the new-package release rule requires it.
- Reusing `isPetName` from `@endo/daemon`: deferred, since it would make this package depend on the daemon.
- A guard for the responder value: left as `M.any()`.
- fast-check property tests: deferred to avoid `yarn.lock` churn.

**Follow-ups**
- **Maintainer decision needed:** decomplector says this PR implements the factory before @kriskowal has approved design #1558. A fix round can't settle that; I flagged it in the PR comment.
- **Local check misses prettier:** my first push failed CI `lint` on a formatting problem in `coordinator.js` that the package's own `yarn lint` didn't catch. Running `npx prettier --check` locally does catch it. I fixed it in a style commit.
- **Shared /tmp logs:** another run's stale `/tmp/pr1560-ci2.log` briefly fooled my CI poll. Workers should write logs under a per-job path instead.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (6229571 cached reads)
- Output: 36153 tokens
- Cost: $3.208566199999999
- Wall-clock: 5177s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
