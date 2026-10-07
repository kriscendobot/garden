Fix round 2 for kriscendobot/minion.town#167 is pushed and CI is green: all 3 checks passed (`ci-wait-merge` exit code 0). Both of round 2's must-fix items are addressed, though the first one only partly, because its real fix needs the maintainer.

**What changed:** one follow-up commit, `63ffda6`, on `design/root-canary-principal` (previously `7c4ddc7`). It only touches `designs/root-canary-principal.md` and was pushed with `safe-push-pr-head.sh` in advance mode.

**Must-fix items (from the skeptic seat):**
1. **The Cognito premises have not been observed.** I could not run the spike: it needs kriscendobot's interactive GitHub sign-in with MFA. So I took the panel's fallback and marked the claims as assumptions instead:
   - A new § 2.0 lists the premises A1–A7 as *assumed*. These include whether the `sub` matches the human root's (the per-pool-user UUID versus the `GitHub_<id>` username), whether tokens stay valid until `exp` after a revoke, and whether refresh skips GitHub.
   - The status block and the § 2 heading now say the recommendation is conditional. "No application code" now reads "no new authorization code", with the one audit log line as the only app change.
   - Build-scope step 0 now has to record an observed run for each premise, including a drill that revokes the token.
2. **Open question 8 (could another minion.town service accept this token?)** is answered by a new § 2.7, based on reading the code at `d750b09`. Only `src/auth/verifier.ts` verifies Cognito JWTs, and it checks `client_id` against an allowlist. oauth2-proxy accepts only its own session cookie, the git remote uses its own hashed per-repository tokens, the npm registry uses its own static token, and the clip gateway is public. The question is removed from the open list.

**Should-fix and comment items also handled:**
- **One owner for "auth unavailable":** the bearer helper is the only code that decides it. It exits 75 with a stderr line `reason=missing|unreadable|refused`, and the wrapper and the canary child only pass that status on. The stale `MINION_MCP_BEARER` token variable is gone; only the helper command remains.
- **Refreshing mid-session:** minion-mcp pins a session to `iss`+`sub`, not to the token (`src/http.ts`). A refreshed token therefore continues the same session without restarting it.
- **Revocation:** `RevokeToken` is now named the primary lever, with each other lever's cost stated, and removing the root `sub` is lever 4. A kriscendobot GitHub account incident now starts with `RevokeToken`. The canary schedule also alerts after two runs in a row that report auth unavailable.
- **Additions:**
  - an operator runbook (§ 2.8)
  - a reserved `root-canary-` name prefix
  - checks that a token from an unlisted client is refused
  - a test item for the helper's exit codes
  - a term glossary and a one-sentence problem summary
  - a lead-in naming the diagram's participants
  - a note that admin access means the reader role gives an audit trail, not isolation
- **Wording and open questions:** the copyeditor and pedant fixes are applied. The open questions are reordered with blocking ones first, each tagged inline, and question 1 is split into "who holds the MFA" and "which machine".

**Not done:** keeping `client_secret` in a separate secret (decomplector, comment-only).

**Follow-ups:**
- The spike (step 0) still needs the maintainer's interactive sign-in, and open questions 1–4 still block the build.
- Panel round 3 is the driver's job, not this stage's.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1770145 cached reads)
- Output: 17867 tokens
- Cost: $1.4100490000000006
- Wall-clock: 471s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
