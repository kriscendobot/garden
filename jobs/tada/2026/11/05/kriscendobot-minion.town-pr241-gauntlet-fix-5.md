I applied the round-5 panel must-fixes to PR #241 (the second review, 5779757239), pushed them, and CI came back green (4 of 4 checks).

**What I did** (project checkout `scratch/project-wt-kriscen-45b7a937fd54-9bcc8ba3`, head moved 5a49e9bd → f2a60634 with `safe-push-pr-head.sh`):

- **Race in frozen `create`** (raised by locksmith, saboteur, breaker, wire-watcher and engine-realist): while onboarding was frozen, `create` checked that the child existed, then awaited the credential and model checks before calling `provideChild`. A `dismiss` in that gap let `create` bring the child back. The tree now has a `teardownEpoch` counter that goes up every time a teardown starts. Just before reserving quota and calling `provideChild`, with no wait in between, a frozen `create` returns `unavailable` if the counter has moved or the child is being torn down.
  - Tradeoff: the counter covers all children, so any teardown in that gap, even of an unrelated child, makes the frozen call return a retryable `unavailable`.
- **Race in frozen `delegate`**: if the label it saw before awaiting `credentials.status()` was revoked in the meantime, it now returns `onboarding-frozen` instead of issuing a replacement delegation.
- **Other methods on the nonce route**: while frozen, `/account/claude/:nonce` now answers 410 to PUT, PATCH and DELETE from an authenticated caller. That route is mounted ahead of the app-wide JSON parser, so no body is read. Otherwise these requests fall through as before. The design now says 410 applies to every authenticated method and that a cross-site POST still gets 403 first.
- **Tests**: I added deterministic race tests that hold `credentials.status()` while `create` races `dismiss` and `delegate` races `revoke`, plus PUT/PATCH/DELETE cases with an unparseable body. All 5 fail on the old code and pass on the new. The three Claude test files pass (79 tests) and `tsc --noEmit` is clean.
- **Pruner items**: I removed the comment in `deploy-app.sh` and the repeated "Deprecated, frozen by default" paragraph from the design, and added one sentence on what happens when a frozen repeat loses those races. In the PR body I cut "Things to check" and "Evidence".
- **Integrator**: the ledger's Acceptance line now says the frozen path has unit tests only, since production keeps the flag on, and that this slice clears none of the `claude-agents-capability.md` production gates. The PR is still a draft.

**Not done:**
- I kept the phase-and-evidence ledger even though the pruner asked to cut it. Garden tooling expects that block (it ends in a `garden-phase-evidence-ledger` marker), and the integrator wants the phases accounted for.
- I did not apply the locksmith's suggestion to give frozen deployments a provider that can only look children up and cannot create them. The runtime check above is the smaller fix; panel-6 may raise it again.
- Prettier isn't run in CI here and the files already failed it at HEAD, so I didn't reformat.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2483197 cached reads)
- Output: 15003 tokens
- Cost: $1.4862353999999995
- Wall-clock: 556s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
