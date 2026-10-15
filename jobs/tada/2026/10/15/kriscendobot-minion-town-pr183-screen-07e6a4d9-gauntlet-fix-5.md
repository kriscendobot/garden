I applied the panel's round-15 must-fix items to kriscendobot/minion.town PR #183, pushed two follow-up commits, and CI came back green at the new head `e376aae`.

**Changes, by seat:**
- **archivist (must-fix):** The `WHERE IT LIVES` note in `src/endo/claude/credential-vault.ts` still described the file store as the live credential store. It now describes the legacy location, the one the `@secrets` vault migrates from. In `DEPLOYMENT.md`, the migration sentence now says the record moves on "the first read that reaches the daemon", because a read during a daemon outage leaves it for the next read. I rewrapped the `containment.ts` header and pointed it at `DEPLOYMENT.md`. The "never retried in-process" note now lives only in `DEPLOYMENT.md`, and the inbox responder's comment links there.
- **migrator (must-fix):** I checked that the migration writes the `@secrets` blob before it rewrites the record without the token. The one-way migration and its rollback effect were already documented under Credentials in `DEPLOYMENT.md`. The PR body's breaking-change section now states that guest callers break until the sliced backend (design phase 6) lands, and points to both `DEPLOYMENT.md` bullets.
- **breaker:** `status()`, `planModels()` and `storedAt()` now go through a new `readLive` helper, which confirms the subject's `@secrets` entry is still present and not revoked. If the `@secrets` lookup itself fails (daemon down), the record is still treated as connected. Before this, a blob revoked directly in the daemon still read as `connected`, so `connect` refused to re-link. I extended the "deleted out from under" and "revoked out from under" vault tests to check `status` (and, for the deleted case, `planModels` and `storedAt`).
- **purist and curator:** I replaced the one-member `CredentialKind` type and its helpers with the single description constant. `ClaudeProvider.refuse?()` now returns the `"needs-containment"` literal, and `NEEDS_CONTAINMENT.reason` is typed `as const` to match.
- **decomplector and purist (refusal stored twice):** I kept both the refusing exo and `refuse`, and added a doc line saying why. The two seats disagreed: the decomplector says the exo is never reached in production; the purist says it still covers callers that mint an exo directly. I didn't delete either path.
- **pruner:** I deleted two test comments that restated the code. The token rule ("never returned, logged, or placed in MCP output") was repeated in `credentials.ts` and `types.ts`; both now point to the vault's Invariants block. I removed the duplicated note about the two truncations in `tools/vendor-endo-claude.sh` and reflowed its header. I also shortened the PR body's breaking-change, rollback and handle-member sections.

**Verification:**
- `tsc` passes, and all 28 Claude-related test files pass (349 tests).
- The full local suite showed 3 failures in files this fix doesn't touch. On a rerun, two of them (`endo-guest-lockdown` and the git-remote e2e test) passed. The third, `test/git-remote/capability.test.ts` ("propagates a git failure"), failed again. I didn't run it against the previous head, so I can't say it was already failing there.
- `ci-wait-merge.sh` returned 0 (green) at `e376aae`.

**Left for later (should-fix and comment-only items):**
- Publishing `@endo/claude` instead of vendoring it (purist). That is a maintainer call.
- Changing `RootAuthoredInfer` to take only the agent handle instead of name plus handle (decomplector and purist).
- Making `makeClaudeAgent` private to its module (curator).
- One line in `DEPLOYMENT.md` noting that refused inbox prompts still count against the rate-limit window (breaker).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2314339 cached reads)
- Output: 14963 tokens
- Cost: $1.5340398000000002
- Wall-clock: 1163s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
