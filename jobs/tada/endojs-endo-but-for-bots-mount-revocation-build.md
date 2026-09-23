The job is complete. Let me write the completion report.

---

## Completion report: `endojs-endo-but-for-bots-mount-revocation-build` (PR A of the #127 reconstruction)

**Outcome: draft PR #650 is open and complete — https://github.com/endojs/endo-but-for-bots/pull/650** (base `llm-7870da1`, head `feat/mount-revocation`, affected package `@endo/daemon`).

### This was a resume
A prior run of this exact job (before a requeue) had already implemented PR A, pushed the frozen base `llm-7870da1` and head `feat/mount-revocation`, and opened **draft PR #650**. Its implementation was in fact *more thorough* than the fresh reconstruction I built in parallel: besides the revocation caretaker + deny set, it also documents the deny behavior in `help.md` / the `EndoMount` help overview and plumbs the `deniedSegments` option all the way through `host.js` `provideMount` / `provideScratchMount` (which I had deferred). Rather than duplicate it, I verified it and closed the one gap it had.

### What I verified on PR #650 (real execution)
- `test/mount-revocation.test.js` + `test/mount.test.js` + `test/mount-platform-fs-conformance.test.js` → **112 tests pass**.
- `tsc`: no errors on any touched file (the lone `host.js` diagnostic is the pre-existing baseline error, at `host.js:778` on `origin/llm`, shifted to `:791` by the added lines).
- `eslint`: **0 errors** (only the repo's usual style warnings); `prettier --check`: clean.
- Design scope is correct: the prior run excluded `glob`/`grep`/`readJson`/`writeJson` (those are PRs B/C/D); the deny-set is exported as `defaultDeniedSegments` and converted to a lowercased Set on `ctx` — no array/Set bug.

### What I contributed (commit `104895edd`, pushed to the PR head)
The design's PR A test list names **"formula cancellation revokes"**, but PR #650's tests only exercised `control.revoke()` directly — the daemon's `context.onCancel(() => control.revoke())` wiring was untested. I added two daemon-level tests to `test/endo.test.js`:
- `cancelling the mount formula revokes live mount and file handles` — provisions a real mount via `provideMount`, hands out a `subView` and file handle, `E(host).cancel(...)` the formula, and asserts all three throw `revoked`.
- `mount denies sensitive segments through the mount formula` — asserts `list()` hides `.ssh`/`.env` and direct reads throw `restricted path` through the real formula path.

Because this worktree's absolute socket path exceeds the 108-byte `AF_UNIX` limit (a pre-existing condition that blocks *every* `endo.test.js` daemon-integration test here, not just these two), I verified the behavior against a **real daemon via a standalone driver** using a short `/tmp` socket: all seven assertions passed against the prior run's implementation (deny listing, deny direct-read ×2, pre-revoke read, post-cancel revoked ×3). The committed tests encode exactly those paths and will run in CI, which uses short paths.

### Follow-up filed
- Filed the design's named **CLI-plumbing follow-up** as **issue #651** (`--denied-segments` flag on the mount / scratch-mount CLI commands) and linked it in the PR body.
- Posted the required completion-summary comment on PR #650 for the pushed commit.

### Notes / hand-off
- PR #650 remains **draft** (correct — the builder hands off to the panel; the gauntlet's panel → fixer → un-draft stages are the gardening state machine's job, not run here).
- **Self-improvement (routing to liaison):** a requeued `build` job re-did the entire implementation before the frozen-base step's branch-existence check surfaced the already-open PR. The builder norm "verify no open PR already implements the issue *before opening a worktree*" would save this rework if the pre-flight `gh pr list --head <deterministic-head-branch>` ran at the very start of a build job (the head name is derivable from the job base), since a `claude -p` builder that dies mid-flight and is requeued restarts with no memory of the PR it opened. Worth a builder-role directive.
