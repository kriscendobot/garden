I applied the round-11 panel's must-fix items to kriscendobot/minion.town#183 and pushed them as follow-up commit `66fcb1b` (`07e6a4d..66fcb1b`, via `safe-push-pr-head.sh`). CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 3/3 checks passing (test, Claude harness amd64 and arm64).

**Must-fix items**
- **archivist:** `src/endo/claude/types.ts` and `src/endo/claude/credentials.ts` no longer say the token is read through `apiKeyHelper`. They now say the provider writes it as `env.ANTHROPIC_AUTH_TOKEN` into each spawn's own `0600` settings file.
- **curator:** I documented the `rootProviderFor` fallback in `wiring.ts`, in both the seam doc and a comment where it is used. Without that seam, the root path gets the same provider as the facet agents, so it refuses wherever they refuse. The fallback can't widen authority, so I documented it rather than adding a hard refusal.
- **migrator:** The PR body already listed the breaking change and the affected callers. I added the restore plan: facet agents answer again once the sliced backend lands, and until then `needs-containment` is deterministic and must not be retried.
- **integrator:**
  - Retitled the PR to `feat(claude): Endo pin 204033b398, credentials on @secrets, contain the root backend (inference phase 3)`.
  - Changed "Gate, vault…" to "Containment, vault…" in the Verification section.
  - **Converted the PR back to draft.** The integrator brief says an `orchestrated-slice` ledger only makes sense while the PR is draft, and the gauntlet holds back the un-draft for slices, so the PR should stay draft until the successor `minion-town-claude-kriscendobot-canary-after-connect-20261006` lands.
- **pruner:** Deleted the 10 test comments that only restated the test, cut the repeated containment explanation in `cli-deployment.ts` to a one-line pointer, and trimmed the comments in `claude-cli-backend.test.ts` and `claude-agents-tools.test.ts`.

**Should-fix items I also took (saboteur #1, purist #1)**
- `makeClaudeAgent` now checks for a refusing exo (a new `isRefusingExo` WeakSet in `containment.ts`) and returns `NEEDS_CONTAINMENT` before the credential check and the inference slot. A mailed prompt can no longer be answered `needs-auth` or `subscription-busy` and then dismissed.
- Inside `agents.ts` the refusal is now matched by object identity. `isNeedsContainment` is still used by the inbox responder, which receives the result across CapTP and can't compare identity.
- I renamed the test that pinned the old `subscription-busy` behavior and changed it to expect the refusal.

**Local checks:** typecheck is clean and all 27 `claude-*` test suites pass (344 tests). The full `npm test` run had one failure, `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`. It doesn't touch the files I changed and passed in CI.

**Left as follow-ups:**
- The other should-fix items. Most notable is the locksmith's: the `@secrets` facet still passes the whole catalog (with each entry's admin) and the unrestricted importer straight through.
- The purist's suggested rename of `inferRootAuthored` to `rootAuthoredInfer`.
- The integrator's non-blocking suggestion to regroup the commits.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2006517 cached reads)
- Output: 11484 tokens
- Cost: $1.3036954
- Wall-clock: 949s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
