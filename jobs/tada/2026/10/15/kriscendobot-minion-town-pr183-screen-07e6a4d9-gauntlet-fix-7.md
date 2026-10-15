Fix round 7 for kriscendobot/minion.town PR #183 is pushed as `3b4ce5c`, and CI is green: `ci-wait-merge` reported GREEN with test, Claude harness amd64 and arm64 all passing. I fixed several must-fix items but declined some and left others open (listed below), so panel-8 may still request changes.

**Fixed in the code** (one follow-up commit, "fix(claude): address panel round 17 findings"). Each fix has a new test, and I ran break-and-revert for each: with the fix reverted the test fails, and it passes again once restored.
- **assessor:** when minting the root backend fails, `makeRootAuthoredInfer` now returns `{type:"unavailable"}` instead of an error result from the root `infer` tool. Test is in `test/claude-agents-tools.test.ts`.
- **saboteur and corner-prober:** `isAuthenticationRetry` now treats a 403 retry as a rejected login, like 401. The test covers 401, 403 and `authentication_failed`, plus 429 and 529 as non-login controls.
- **breaker:** when moving an old credential record onto `@secrets` fails, the log now records only the error class, never the message, which could contain the token. The new test uses a fake `@secrets` that puts the token in its error and checks that neither the token nor its Base64 form reaches the log.
- **archivist:** corrected the `ClaudeCredentials` doc comment in `types.ts` and the storage and token-lifecycle text in `designs/claude-agents-capability.md` to describe the `@secrets` vault and the per-run `ANTHROPIC_AUTH_TOKEN` settings file.

**Changed in the PR description** (now about 186 words above the evidence ledger):
- **integrator and pruner:** removed the commit-by-commit section and shortened the breaking-change text.
- **releaser:** added a release note covering the `needs-containment` break and the one-way migration. This repo has no changeset mechanism, so the note lives in the description.
- **benchmarker:** added a short statement that the one-listener-per-connection change won't be benchmarked, because it only removes duplicate listeners.
- **prover:** added the break-and-revert evidence, limited to what was actually run: my three fixes above, plus the existing "reverting the provider split fails a test" claim from an earlier fix pass. I did not re-run break-and-revert for `refuseUncontained` or the legacy-record migration, which is part of what prover asked for.

**Checks:** `tsc` passes. Locally, the three edited test files pass. The full vitest run had one failure, `test/git-remote/capability.test.ts`, in code this PR doesn't touch. The other two failures are files under `tools/claude-harness`, which `npm test` excludes.

**Declined, with reasons:**
- **stylist:** wants `RootAuthoredInfer` / `inferRootAuthored` renamed (for example to `RootUnslicedInfer`). That touches many files; better as its own focused change or a maintainer decision.
- **purist:** wants the vendored `@endo/claude` consumed upstream instead. That's a packaging decision for the maintainer.
- **procurer:** wants `isRecord` in a test helper replaced with `@endo/pass-style`. Low value for a test-only helper.

**Still open (must-fix):**
- **engine-realist:** after a `createBlob` call times out, its write can still land after a later `revoke`, leaving an active credential behind (around `secrets-credential-vault.ts:215`). This needs a real design change to how calls are ordered, which was too much for this round.
- **spec-keeper:** wants captured array intrinsics for `.find`/`.some` on catalog arrays the daemon returns.

fast-checker's two property-test suggestions were summary-level, not must-fix, and are also not done.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2862973 cached reads)
- Output: 14718 tokens
- Cost: $1.5288825999999998
- Wall-clock: 998s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
