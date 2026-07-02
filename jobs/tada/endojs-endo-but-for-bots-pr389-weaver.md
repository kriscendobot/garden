The weaver task is complete. 

## Completion report

**Job:** weaver on endojs/endo-but-for-bots PR #389 — rebase the conflicting stacked design PR onto its moved base.

**What I did:**
- Confirmed the diagnosis: PR #389 was `mergeable: false, mergeable_state: dirty` because its base `design/gateway-package-phase-2` was force-updated on 2026-06-29 while the head sat unchanged since 2026-06-03.
- Analyzed the divergence: the two phase-3-specific commits (`45e9e20c1` admin daemon, `d9cd28081` admin-sock/bootstrap-sock ACL separation) sat atop the *old* phase-2 tip `785ec6088`; everything below was phase-2 content re-authored in the force-update.
- Rebased with `git rebase --onto origin/design/gateway-package-phase-2 785ec6088`, replaying only the two delta commits onto the new phase-2 tip `590cad28e`. **Zero conflicts.**
- Verified integrity: new phase-2 tip is now an ancestor of the head; the gateway package delta is byte-identical to the original (1786 lines each — the only diff-of-diff differences were blob hashes, hunk offsets, and context lines, all expected from a moved base).
- Force-pushed with a lease anchored to the old SHA: `d9cd28081 → ea06d79b1`.

**What changed:**
- `design/gateway-package-phase-3` head moved from `d9cd2808` to `ea06d79b`.
- PR #389 went `dirty` → `mergeable: true, mergeable_state: unstable` — the conflict is cleared and the `pull_request` workflow re-dispatches on the new head.

**Follow-ups:**
- A shepherd job for #389 is already on the board (my `post-job.sh` reported it present in-lifecycle) to drive the CI re-run green — specifically watching `@endo/cache-map#test` (`TypeError: results.values(...).filter is not a function` from the stale run; may be resolved on the moved base or need a fixer).
- **Surfaced to the maintainer** (via the maintainer inbox, non-blocking): the base PR #388 (phase-2) is closed unmerged and phase-1's PR is also closed — the whole stacked gateway-package series appears reorganized/abandoned, so whether this DRAFT should ultimately live is a liaison/maintainer call, not a weaver/shepherd one.
