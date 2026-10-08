Fix round 3 for kriscendobot/minion.town#167 is pushed and CI is green: all 3 checks passed.

**Panel input.** The round-3 review (on head `63ffda6`) had one must-fix item. The skeptic found that premise A2 ("same `sub`") had no stated fallback, so a failed spike would leave the maintainer with no path forward. I fixed that and also took the cheap should-fix items from the other seats.

**What changed** (one commit, `3760c2b`, in `designs/root-canary-principal.md`, pushed with `safe-push-pr-head.sh`):
- **Must-fix, fallbacks:** § 2.0 now has an "If a premise fails" table with a decided fallback for every premise:
  - **A1/A8:** add `openid` to the scopes.
  - **A2:** first try linking the GitHub identity to the existing user with `AdminLinkProviderForUser`. If the `sub` still differs, fall back to the § 4 delegated capability. That fallback needs the maintainer's yes on relaxing the root-only `watchInbox` rule (open question 1).
  - **A3:** don't build.
  - **A4:** turn rotation on and let the reader role write the secret back.
  - **A5/A6/A9:** use the shortest access-token lifetime and make "delete the client" the main revoke.
  - **A7:** no change.

  The header and build scope item 0 now point to this table instead of "return to design".
- **New premises A8 and A9:** a token from the refresh grant must carry the scopes, `token_use`, `client_id` and `exp`. The spike now decodes a refreshed token as well as the first one and keeps one MCP session alive across a refresh. The revocation drill must pass before the canary is armed.
- **Expiry date:** the secret now stores `expires_at`, read from the client's settings, so the reminder no longer keeps its own copy of "30 days".
- **Revoke, sessions and children:** § 2.4 now states what I confirmed in `src/http.ts`: every request's token is checked, not just the first. A revoked token therefore keeps a session for at most 15 minutes. Claude children it already created keep answering mail until dismissed, so the incident steps now include dismissing them.
- **Token helper:** `MINION_MCP_BEARER_CMD` now has a defined format (a path to an executable that prints a bare token). The helper also writes a status file, so the wrapper reports "auth unavailable" correctly even if the child drops exit code 75. A small table shows what the wrapper, helper and child each do.
- **Cleanup sweep:** canary runs no longer overlap. Run ids now look like `root-canary-<UTC start>-<nonce>-`, so the sweep reads a run's age from its name, and it logs each name it deletes.
- **Revoke script:** added `root-canary-revoke.sh` (with a `--status` mode) to the runbook and build scope. The ownership map has a new Cognito row. Test scope now covers the status file, the sweep's age filter and the run lock.
- **Wording:** applied the copyeditor's two rewordings.

**Not changed:** the pedant's heading-case finding looks like a misreading, since every heading is already sentence case. I also skipped the pedant's table-punctuation nits and the novice's suggestions to move the glossary and add a worked example. None of these were must-fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (919853 cached reads)
- Output: 10010 tokens
- Cost: $0.9579066
- Wall-clock: 472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
