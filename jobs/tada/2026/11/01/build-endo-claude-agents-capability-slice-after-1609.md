I opened draft PR endojs/endo-but-for-bots#1628. It adds real-daemon tests for removal and revocation that a crash interrupts partway through. All 57 package tests pass locally, including the 2 new ones; CI hadn't run when I finished.

**Which slice I picked**
- **Credential lease: not built.** The design PR #1558 explicitly rejects a separate lease-and-revocation protocol (after the #1102 review) and keeps credential handling inside `@endo/inference`'s `CredentialSource`. #1625 reached the same conclusion; the PR body says so.
- **Revocation and fail-closed restart.** The code for these is already on the stack (#1561 and later), and the fake-host tests cover them. On a real daemon, only removal or revocation that had fully finished before a restart was tested. A crash partway through was not. That gap is this slice.

**What the PR adds** (one commit, test-only: `packages/exo-agent-factory/test/daemon.test.js`, +120 lines)
- **How a crash is simulated:** the test writes the `Removing` or `Revoking` record into the factory's journal and restarts the daemon. That leaves the same state as a coordinator that wrote the record and then died.
- **Crash after `Removing`:**
  - the restarted coordinator finishes the removal by itself and no guest, driver or responder is left;
  - the restarted child reports itself inactive, and no faults are recorded;
  - the name and its quota can be used again, and the new child answers mail.
- **Crash after `Revoking`:** the test uses a derived namespace with two children and a nested namespace with one child.
  - Revocation finishes across both levels.
  - Both derived handles reject `list` and `create`, every descendant reports itself inactive, and the root keeps only its own child.
  - The root's quota of four is fully usable again.

**Where it sits**
- The PR is stacked on #1627, the current tip of the stack. I pushed a frozen snapshot branch of #1627's head (`build/exo-agent-factory-real-daemon-infer-crash-cut-a5b9c94`) to use as the base.
- `eslint` reports only the file's existing `@ts-nocheck` warning.

**Follow-ups**
- The tests cover only the crash right after the first record. Crashes at later points inside revocation (some children already removed) are still covered only by the fake-host tests.
- The daemon tests wouldn't start locally until I rebuilt `better-sqlite3` for Node 22. It had been built for a different Node version. Only my project worktree was affected.
- #1625 (durable facets) branches from #1560 rather than the current stack tip, and partly duplicates code already on the stack. It will need reconciling.
- "#1609" in the job name is an unrelated ironhorse PR, not part of this stack.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-agents-capability-slice-after-1609.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2047823 cached reads)
- Output: 17157 tokens
- Cost: $1.5041846
- Wall-clock: 326s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
