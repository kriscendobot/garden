The clean stage for kriscendobot/minion.town PR #183 is done: I added tests for the new credential vault, and CI is green on the new head `1380e9e` (`ci-wait-merge.sh` returned 0, 3 of 3 checks passed).

**What was missing:** CI was already green at the old head `a086ff9`. But the main new module, `src/endo/claude/secrets-credential-vault.ts` (+326 lines), was only tested through its normal path in the live-daemon integration test. None of its error branches had a test.

**What I pushed** (one commit, `a086ff9 → 1380e9e`, via `safe-push-pr-head.sh`):
- **New test file:** `test/claude-secrets-credential-vault.test.ts`, 10 tests that run against a fake in-memory secret store instead of a live daemon. They cover:
  - a state file that doesn't parse, checking the token never appears in the log;
  - a state file with an unexpected shape, including an old-format record with an empty token;
  - a revoked secret being deleted and created again without a second revoke;
  - an active secret being revoked before it is deleted, and a second revoke that finds nothing;
  - a secret deleted while its state file still points to it, which reads as needs-auth;
  - an empty token being refused without touching the secret store;
  - activating when no record exists, which does nothing;
  - storing over an active record, which marks it pending first;
  - `storedAt` only reporting once the credential is active;
  - a failed read of the state file (other than file-not-found) surfacing as an error.
- **Comment fixes:** comments in `src/endo/claude/wiring.ts` and `src/endo/claude/credentials.ts` named `credential-vault.ts` as the production store. They now name `secrets-credential-vault.ts`, which is what production uses after this PR.
- **Local checks:** typecheck passes and `npm test` passes 1052 tests. One test fails locally, `test/git-remote/capability.test.ts`, "propagates a git failure…": it expected an error but got an empty result. That file isn't touched by this PR and the `test` check passes in CI, so I left it alone.

**Left for later:**
- `makeFileCredentialVault` in `credential-vault.ts` no longer has a production caller. I didn't delete it because two other tests use it as a stand-in vault (`claude-cli-backend.test.ts` and `claude-wiring-cli-seams.test.ts`). Removing it later means moving the shared `CredentialVault` type and switching those tests to a different stand-in.
- I couldn't measure coverage numbers locally because `@vitest/coverage-v8` isn't installed in the project.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1776740 cached reads)
- Output: 11636 tokens
- Cost: $1.1523320000000001
- Wall-clock: 865s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
