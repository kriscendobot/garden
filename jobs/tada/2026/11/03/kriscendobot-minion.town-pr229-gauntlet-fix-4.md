PR #229 fix round 4 is done: all four must-fix items are applied and pushed at `62e205ee`, and CI is green. I did not re-run the panel; the driver posts panel-5.

**Must-fix items**
1. **prover (wiring and rollout gate unpinned):** added `test/inference-provider-wiring.test.ts`, which goes through the real `createApp`.
   - It covers flag-off 404, refusing to start on each of three misconfigurations, and the per-request 503 during an outage.
   - With the flag on, it pins the gate secret, policy, store, public origin, registry name, and the `g-<32 hex>` owner key.
   - `test/config.test.ts` gains `loadConfig` parse cases.
2. **breaker (corrected key silently dropped):** fixed in `provider-ui.js`.
   - Back after a commit now offers the committed provider, and "New provider" mints a fresh operation.
   - An unknown outcome locks the key field and Next until a status check rules out a commit.
   - A new browser test covers these flows.
3. **integrator (owner-key conflict):** the key is now recorded outside the PR.
   - The design on endojs/endo-but-for-bots#1543 is amended (`b33bfd4f18`) with the owner key and its consequences.
   - `DEPLOYMENT.md` makes retiring providers on account deletion a rollout precondition.
   - The parked `claude-api-p4-agent-factory` and `claude-api-p6-canary` jobs are annotated, and tracker #227 has a comment inviting the maintainer to change either decision.
4. **decomplector (registry policy in the HTTP layer):**
   - `supersede(request, confirmed?)` on endojs/endo-but-for-bots#1575 (`a1a55ea7a0`) now gates raised caps and inherits unedited ones inside the registry queue, with a new test.
   - On #229, `/replace` lost `raisesLimits`, the prior lookup, and the cap merge, and the adapter, guard copy, and pin were updated.

**Also fixed, though only should-fix**
- The browser gate now fails instead of skipping when `PLAYWRIGHT_BROWSER` names an engine that can't launch.
- `providers` is reset per engine.
- A submit that returns after its dialog closed no longer acts on the newer dialog.
- The PR body's stale pin and acceptance lines are refreshed.

**Verification**
- **PR #229 CI:** `ci-wait-merge` returned rc 0. The browser gate passed on Chromium, Firefox, and WebKit at `62e205ee`. This host's PAT can only see the 2 Actions runs, not commit statuses or non-Actions checks.
- **Local tests:** `tsc` is clean and the registry tests pass 35/35. The full minion.town suite had one failure, in `test/git-remote/capability.test.ts`. I didn't investigate it locally: it's a git subprocess test outside this diff, and CI's vitest run is green.

**Follow-ups**
- **#1575 CI:** at `a1a55ea7a0` 5 runs had succeeded and 1 was still in progress when I last looked; I did not wait for it. That head moved, so its own review state may need refreshing.
- **Account-deletion cleanup:** no phase owns this code yet. It is only a stated precondition plus the note on the Phase 6 job.
- **Should-fix findings left open:**
  - Directory-only registry facet.
  - Reattach dropping the returned capability, which can't happen until Phase 4.
  - Deadline on daemon calls.
  - Trimming and validating the key against the broker's grammar (space or control characters).
  - `grantIds` count cap.
  - Rendering absent attachments as "unknown".
  - Shared gate and CSRF helpers.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (3624752 cached reads)
- Output: 49919 tokens
- Cost: $3.2092824
- Wall-clock: 1889s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
