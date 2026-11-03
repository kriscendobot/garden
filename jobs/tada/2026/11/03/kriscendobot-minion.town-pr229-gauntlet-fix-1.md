Fix round 1 for kriscendobot/minion.town PR #229 is pushed and CI is green: all 7 checks passed (`ci-wait-merge` returned 0). I made four follow-up commits on top of the old head `7700cd9d`, ending at `3a35737b`, and pushed them with `safe-push-pr-head.sh`. The panel will re-run in its own stage.

**Must-fix items applied, from the panel review of 2026-11-03:**
1. **Daemon failure during the owner check (assessor):** the owner lookup is now awaited inside the `try`, so a daemon failure returns the intended 503 `account-service-unavailable` instead of leaving the request hanging. Added a test for that case.
2. **Empty gate secret (wire-watcher, also raised by breaker):** the endpoint now refuses to mount without a gate secret and rejects any request whose gate token is missing or wrong. The `INFERENCE_PROVIDERS_ENABLED` startup check in `src/http.ts` also requires `ACCOUNT_GATE_SHARED_SECRET`. Added tests for both.
3. **Missing `limits` resetting caps (assessor, and a must-fix-loop item from a later juror):** a missing `limits` now gets the defaults only when creating a provider. The owner-limits and per-provider limits routes return 400 `invalid-limits`, and a test checks the stored limits are left unchanged.
4. **Generic `lookup` on the daemon connection (locksmith #2):** removed it. The app now looks the registry up once at startup and gives the provider service only that registry, typed narrowly, never the host or the admin views.
5. **Registry keyed by an owner string (locksmith #1), partly addressed:** each owner's directory is now cached as one object per owner and handed out after authentication. A full fix needs the registry, on the endo daemon side, to hand out per-owner directories itself. That is outside this PR, and the panel may raise it again.
6. **Menu links showing while the feature is off (migrator, integrator, and a later juror):** both provider links now start hidden. `settings.js` shows them only when a new endpoint, `GET /account/providers/enabled`, answers 204. That endpoint exists only when the feature is on, so a default deploy shows no dead links. Tests updated.
7. **Route-admission manifest out of date:** `@landingScripts` now lists `provider-ui.js`, and the `@providerAccount` entry says the route is only mounted when the rollout switch is on.
8. **Undocumented settings:** added `INFERENCE_PROVIDERS_ENABLED` and `INFERENCE_PROVIDER_REGISTRY_NAME` to `.env.example`, plus a new DEPLOYMENT.md section on turning the feature on.
9. **Changeset (releaser):** added `.changeset/api-key-provider-ui.md` (minor) with `New:` and `Migration:` lines.
10. **Design reference and phase ledger (integrator #2):** no change needed. The PR body already names endojs/endo-but-for-bots#1543 as the design, marks this as `orchestrated-slice` with successor `claude-api-build-20261027`, and the PR is still a draft.

**Local checks:** type-check passes and the three directly affected test files pass (61 tests). The full suite had one failure out of 1647, in `test/git-remote/capability.test.ts`. That file isn't touched by this PR, and it looks like a known local false failure caused by the git wrapper. CI passes it.

**Not done:** the should-fix and comment-only items, for example the partial-success `replace`, substring matching in `fixedCode`, bounds on limit values, and tests for the remaining routes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3139568 cached reads)
- Output: 18272 tokens
- Cost: $1.7247296000000005
- Wall-clock: 579s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
