Comment posted. No garden code changes were needed — this was a research/reply job on the garden's own issue, so nothing to commit.

## Completion report

**Job:** issue-kriskowal-garden-33 — kriskowal/garden#33 "XS Validation". Maintainer asked me to locate the parked effort to upgrade Agoric SDK's version of XS, including the candidate and the relevant PRs/issues.

**What I did:** Searched Agoric/agoric-sdk and mapped the full XS-upgrade cluster, then posted the findings as a comment on the issue (did **not** close it — per issue-inbox contract, the submitter closes).

**Findings (posted to the issue):**
- **The candidate:** PR #11297 "Draft: Upgrade XSnap from Moddable 3.9.2 to 5.5.0" (OPEN/Draft, branch `kriskowal-moddable-5.5.0`, last touched 2025-07-10). Bumps `moddable` + `xsnap-native` submodules 3.9.2→5.5.0, re-baselines SwingSet/xsnap snapshots and xs-limits/xs-perf tests. A contributor flagged a stale `test-swingset` snapshot. This is the change that couldn't justify the full release-validation gauntlet.
- **The Epic (why it's costly):** Issue #10905 "Upgrade Moddable and Native XSnap Worker" (OPEN, Epic) — transcript-replay-with-no-observable-difference constraint, single shared XS version, non-upgradable bootstrap vat.
- **Affordability mechanism:** Issue #11030 + PR #11031 (both OPEN) — the `variant` legacy/latest multiplexing so only restartable vats take the new engine.
- **Priors/infra:** Issues #6361 (OPEN), #6596 (CLOSED); PR #12477 (MERGED, "replace xsnap submodules with pinned archives") — which #11297 now conflicts with and would need rebasing onto.

**Included a shortest-path-to-revival note:** rebase #11297 onto master (absorb #12477's pinned-archive change), refresh snapshots, then decide whether to land as a forced one-time upgrade or route through the #11030/#11031 legacy/latest split to shrink the gauntlet.

**Changes:** none to the garden repo. **Follow-ups:** none required; issue left open for the maintainer.

Reply comment: https://github.com/kriskowal/garden/issues/33#issuecomment-4910173286
