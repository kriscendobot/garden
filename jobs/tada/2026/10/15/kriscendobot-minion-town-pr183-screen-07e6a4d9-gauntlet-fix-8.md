Round-8 fix for kriscendobot/minion.town#183 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 on head `2b7e8d1`.

**Panel must-fixes, both applied**
- **Archivist:** in `src/endo/claude/credentials.ts`, the "PRODUCTION vs. THIS SLICE" paragraph contradicted itself. It now says production keeps the token in the root `@secrets` vault (`secrets-credential-vault.ts`), with the token-free state record beside it. The in-memory and restart caveat is kept, and the dangling line break in the FAIL-CLOSED JSDoc is reflowed.
- **Integrator:** the PR body's ledger `Design:` line now points at `designs/claude-agents-capability.md` § Production sequence and stop gates. The Phase 1–6 rows map onto that section's steps 1–6, with endojs/endo-but-for-bots#1357 kept as a secondary link. I re-ran `phase-evidence-gate.sh panel` on the new body. It returns `hold-draft` (rc 30), the expected result for a slice whose later phases a successor job owns, instead of `blocked`. So the PR stays draft until the successor lands.

**Should-fixes also applied, because they were small and security-relevant**
- **403 handling** (saboteur and locksmith): `isAuthenticationRetry` in `cli-launch.ts` no longer treats a bare 403 as a rejected token. Only a 401 or the `authentication_failed` error counts. Before this, a 403 `permission_error` (for example, a model the plan doesn't include) would delete a working credential. The test now checks that `403` + `permission_error` returns false.
- **Token in error messages** (breaker): in `secrets-credential-vault.ts`, the `@secrets` create and replace calls carry the token. On failure they now rethrow only the error class, not the daemon's message, which could echo the token. A new test checks that neither the raw nor the base64 token reaches a thrown message or a log line, on both the `readToken` and `store` paths.
- **Pruner:** removed three comments that only restated their identifiers.

Typecheck passes, and the three affected test files pass locally (62 tests). I also posted a summary comment on the PR.

**Left for the maintainer or the successor job:** these are design-level changes I didn't attempt in this round:
- purist's separate result type for `needs-containment` and the `WeakMap` handle lookup;
- decomplector's simplifications to containment, vendoring, and splitting the token from its state file;
- making legacy-record migration one-shot.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2391124 cached reads)
- Output: 12925 tokens
- Cost: $1.4230448000000004
- Wall-clock: 1071s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
