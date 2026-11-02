---
orchestration-failed: true
---
orchestration-failed: true

# Fix round 1: endojs/endo-but-for-bots PR #1503

I applied the panel-1 fixes and pushed them as one follow-up commit, `a34ba053fb`, to `daemon-agent-network-registration` (fast-forward from `4491104e23`). CI came back **RED** (`ci-wait-merge` rc 3). The red jobs are `test` (22.x and 24.x), `cover` (22.x and 24.x) and `sandbox-drivers`, and in every log I read the failing tests are the two bwrap ones:
- `bwrap › bwrap parent death leaves no owned process group`
- `bwrap › prlimit nproc cap is enforced inside the slice` (fails with `ulimit: Illegal option -u`)

This PR doesn't touch the bwrap tests. They match the known pre-existing bwrap CI red that #1566 ("make bwrap tests runner-portable") fixes. #1566 is still open and is not in this PR's frozen base `llm-330cf99`. The old head `4491104e23` had no failing checks, so the runner environment probably changed since then.

The bwrap failure also stopped the run before `@endo/daemon:test` ran, so **CI has not yet checked the daemon changes**. Locally, `networks-ocapn.test.js` passes 10/10, and a 66-test daemon subset (network, locate, peer, invite, guest, `@nets`) passes. Eslint, prettier and the daemon `tsc` are clean. The repo-root `tsc` aborted locally (rc 134, likely out of memory), so CI is the only check of that.

## Fixes applied
- **locksmith 1 (must-fix, membership oracle):** removed `servesAgent` from the OCapN peer entry point. The network now keeps registered keys in a set that nothing a peer can reach reads. A test checks that the peer entry point no longer answers.
- **breaker 1 (must-fix, cancel race):** registrations now carry a `cancelled` flag. A sync re-checks the registration after its `@nets` read and returns if the agent was cancelled or replaced. Cancelling clears the agent's networks and queues unregisters.
- **integrator 1 (must-fix, PR body):** rewrote the body to follow the template, removed the invented `#138` subheading, named the design step it implements, and cut it from about 800 to about 380 words (also covers pruner 1–7).
- **Should-fix items:**
  - The write-only `agentId` argument is gone from `registerAgentKey` (code, `types.d.ts`, design doc, changeset).
  - The OCapN service now has an interface guard and rejects keys that aren't 64 hex digits.
  - Register and unregister calls are serialized per network and key, so a quick remove-then-re-add or a cancel-then-reincarnate lands in order.
  - A reincarnated agent inherits its predecessor's networks, so networks it no longer reaches get unregistered.
  - A failed method-name probe is no longer cached forever.
  - Failed unregisters are logged instead of silently dropped.
- **Tests:** the daemon test now also covers re-registration after re-adding a network and unregistration on cancel.
- **Cleanup:** cut comments that restated the code (pruner 8–11, 13) and reverted the unrelated `…`→`...` change in `designs/README.md`.

## Not addressed (stated in the PR body)
- **locksmith 3 (separate registrar facet):** a guest holding a `@nets` network can still call register/unregister on it. Today that only affects a set nothing reads; the facet should land with the inbound routing that reads the keys.
- **breaker 4 / decomplector 2:** reading an agent's addresses still waits for the registration sync to finish.

## Follow-ups
- Land #1566 (or carry its bwrap fix) and re-weave this PR, or rerun once runners are fixed, so the daemon suite actually runs in CI.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1503-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (5658877 cached reads)
- Output: 28880 tokens
- Cost: $2.6464394000000007
- Wall-clock: 2405s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
