# Gauntlet FIX round 2: kriscendobot/minion.town PR #183

I fixed all five must-fix items from the round-2 panel review (5497112812, against head `80f4853`), pushed three follow-up commits to `build/inference-phase3-secrets` (now `80f4853..eee6880`), and CI is green.

**Must-fix items:**
1. **`auth-failed` not mapped** (`312e1c9`): the harness's `auth-failed` result now maps to `needs-auth` in `toMinionOutcome` (`cli-provider.ts`), where it previously fell through to unclassified. A credential the API rejects (401/403) now triggers reauthentication. A normalize test covers it.
2. **Gate refusal held the slot and was booked as a failure** (`299ecc4`): `prompt-origin-gate.ts` now keeps a set of the gated exos and exports `isPromptOriginGated` and `refuseNeedsContainment`. In `agents.ts`, `inferAs` refuses a non-root-authored prompt on a gated exo before the status check, before taking the inference slot, and before `recordOutcome`. A new test holds the single slot with a pending root inference and checks that the guest call gets `needs-containment`, not `subscription-busy`. With the short-circuit disabled, that test fails.
3. **Read paths threw when the daemon was down** (`eee6880`): `readState` takes a `tolerateMigrationFailure` option, used by `status`, `planModels` and `storedAt`. If moving a legacy record onto `@secrets` fails, they log only the error name and message, answer the unmigrated record, and leave the legacy file in place to retry. `activate`, `store` and the token reads still let the error through, so the legacy token is never dropped without being moved.
4. **Bare `catch {}` in `readSecret`** (`eee6880`): a failed lookup now counts as "absent" only when the secret catalog no longer lists the blob. Any other fault propagates.
5. **No timeout on the per-subject queue** (`eee6880`): every daemon call in the vault now has a timeout (`daemonTimeoutMs`, default 30s). A stalled connection fails that one operation, so it can no longer block every later operation on the subject, including `revoke`.

New vault tests cover a lookup fault propagating, a timed-out call followed by a successful `revoke`, and a legacy record read while the daemon is unreachable, then migrated once it is back.

**Checks:**
- `npm run typecheck` is clean.
- Locally, the full `npm test` run had one failure out of 1080 tests: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That file is untouched by this diff, and the same test passed in CI.
- CI waited with `ci-wait-merge.sh --no-merge`, rc 0: test, Claude harness (amd64) and Claude harness (arm64) all passed on `eee6880`.

**Not done:** the should-fix items are left for the next panel round: `harden` instead of `Object.freeze`, guarding the `open.closed` handler, rolling back a failed `store`, type predicates, squashing commits, and stale prose and JSDoc.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2487855 cached reads)
- Output: 16657 tokens
- Cost: $1.5375029999999998
- Wall-clock: 911s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
