Implemented and pushed `03833819f7` to `main2`.

Root cause: successful builder jobs went directly to `tada`; no completion-path code invoked `garden-pr.sh` or posted a gauntlet job. The builder instruction was advisory, so promoted/blocked builds silently stranded draft PRs.

Changed:
- Added durable build-completion handoff that posts `<build>-gauntlet` for open draft feature PRs.
- Failed handoffs leave the build retryable instead of completing silently.
- Logs and gauntlet job metadata provide an audit trail.
- Probe and already-ready PRs are skipped deliberately.
- Documented the invariant and added hermetic tests.

Verified: `auto-gauntlet-handoff-test.sh`, shell syntax checks, and diff checks pass. `gardener-worktree-test.sh` remains blocked by its pre-existing missing `quota-panel.sh` fixture.
