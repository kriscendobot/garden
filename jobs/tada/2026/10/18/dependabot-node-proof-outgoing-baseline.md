## Completion report: dependabot-node-proof-outgoing-baseline

The dependabot compatibility check now compares the incoming version against the outgoing one. It no longer closes a bump as "incompatible" when the outgoing version already had the same Node or peer mismatch. The fix is commit `3c5843b8d09`, pushed to `main2`. All six affected test suites pass.

**What changed**
- **`scripts/jobs/handlers/dep-compat-gh.sh`**: the signature is now `<repo> <pr> <pkg> <old> <new>`. It checks the format of the outgoing version and fetches the outgoing registry manifest as well as the incoming one. If the outgoing manifest can't be fetched or parsed, it emits no proof, so the PR gets the full review.
- **`scripts/jobs/handlers/dep-compat-check.mjs`**: the input now carries a `baseline` (the outgoing manifest), and each proof needs the outgoing version to have been compatible:
  - **`node` proof**: emitted only when the outgoing version satisfies the project's floor and the incoming one does not. An outgoing version with no `engines.node` counts as satisfying the floor.
  - **`peer` proof**: emitted only when the outgoing version either did not require that peer or required a range that overlapped the project's declaration.
  - **No proof**: a missing baseline, or an outgoing range that doesn't parse, emits nothing.
- **Callers**: all four now pass the outgoing version:
  - `dependabot-watcher.sh` (`run_compat` / `compat_preflight`)
  - `dependabotany-preflight.sh` (the job named only two callers; this one also calls the oracle)
  - `handlers/dependabot-engine-close-gh.sh`
  - `handlers/dependabot-terminal-close-gh.sh`, whose revalidation matches the new signature.
  
  The header comments describing the oracle are updated to match.
- **Tests**:
  - `dep-compat-check-test.sh` has six new cases, including the #1493 shape: root `^20.17.0 || >=22.9.0`, with both outgoing and incoming requiring `>=22.19.0`, now yields no proof.
  - `dep-compat-gh-test.sh` has a curl stub that serves each version separately and checks that the outgoing manifest is fetched. It covers three cases: a mismatch the outgoing version already had, a bump that itself raises the floor, and an unreadable outgoing manifest.
  - The watcher, preflight, engine-close and terminal-close tests now check that the outgoing version reaches the oracle.

**Follow-ups**
- endojs/endo-but-for-bots#1441 (`pi-tui`) and #1493 were closed on the old proof. With this fix, Dependabot's future bumps of those packages will get the full review. Whether to reopen the two closed PRs is the maintainer's call.
- The fix takes effect on each host only after the next deliberate deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabot-node-proof-outgoing-baseline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1284625 cached reads)
- Output: 13589 tokens
- Cost: $1.222977
- Wall-clock: 203s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
