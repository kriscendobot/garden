CI is GREEN (rc 0). The fix stage is complete.

## Completion report — gauntlet fix round 3, PR #1310

**Situation on resume:** A prior claimant of this same fix-3 job had already applied and pushed the round-3 fixes as commit `c1dd1eb67b` to the PR head (`bot/build/guest-native-accept`). I verified the work against the panel-3 must-fix items, cleared a CI infra flake, and drove CI to a terminal GREEN.

**Panel-3 must-fix items — all addressed by `c1dd1eb67b`:**
- **assessor** — `bindCorrespondent` was called outside the accept try/catch, so a throw left the speculative peer route squatted. Now wrapped in its own try/catch that retracts `rollbackPeer` before rethrowing. ✓
- **breaker / saboteur** — TOCTOU / self-race on the acceptor's check-then-act writes (loser's presence-only rollback could delete the winner's committed route/bind). Fixed by serializing the whole acceptor critical section on one daemon-wide `makeSerialJobs()` queue. ✓
- **prover / fast-checker (untested-branch findings)** — added branch-covering regression tests: cross-daemon speculative peer-route rollback, additive-only guard (second invitation from a known peer with bogus hints must not redirect), the rollback `remove()` fresh-name branch, and concurrent duplicate `accept(sameLocator, sameName)`. ✓
- **integrator** — PR body "Deferred" section already corrected to match the changeset (facet signatures converged on `correspondentName`; only the persisted `InvitationFormula.guestName` field kept its internal spelling). ✓
- **scribe** — completion-summary comment posted on the PR (01:26:24Z), closing the rounds 1/2 gap and recording round 3. ✓
- **fast-checker #3** (add `@fast-check/ava` devDependency) — disposition `follow-up`, not must-fix-loop; deferred with rationale (the substantive coverage gap is closed by deterministic branch-covering tests). Left as a follow-up.

**CI:** First terminal watch came back RED on `build-xsnap`, but the failure was an uncaught internal yarn crash (`Error: The onCancel handler was attached after the promise settled.`) during `yarn install --immutable` — a transient install flake, not a code regression (the PR adds no deps and touches only `packages/daemon` JS; other install-based jobs in the same run passed). I re-ran the failed job; it now passes. Final verdict: `total=32 failed=0 → CI GREEN` (rc 0) on head `c1dd1eb67b`.

**Follow-ups:** fast-checker's `@fast-check/ava` devDependency + property tests (deferred, lockfile-touching).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 220 tokens (11089032 cached reads)
- Output: 67766 tokens
- Cost: $9.838698999999998
- Wall-clock: 2418s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
