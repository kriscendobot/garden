**Fix round 10 on kriscendobot/minion.town#186 is pushed and CI is green.** I pushed commit `1c7abcd` to `build/root-canary-principal`. `ci-wait-merge.sh` returned rc 0: the GitHub-hosted test run and the self-hosted test and Claude-harness (arm64/amd64) jobs all passed.

**What I fixed from the panel-10 review:**
- **Shell scripts (decomplector must-fix 1 and 2):** I checked the #150 directive ("use JavaScript for all Minion Town scripts going forward"); it is real. So I replaced the seven `root-canary-*.sh` scripts with `.mjs` entry points that share one module, `root-canary-common.mjs`.
  - Token checks now use `jose`'s `jwtVerify` instead of the inline `node -e` verifier and the `jq`/`base64` claims parsing.
  - The token grants use `fetch` with a form body, so the curl-config injection guards are no longer needed.
  - The mint callback server is now Node `http` instead of Python.
  - I did not stop to ask the maintainer first, as the decomplector suggested, because the directive already covers new scripts.
- **Wrong failure reason (saboteur should-fix 2):** a broken or unreachable JWKS, or any other environment fault, now reports `unreachable` (exit 1) instead of `mismatched` (exit 75, which tells the operator to re-mint).
- **Negative-path gate (saboteur and breaker must-fix 1):** the gate no longer passes on an empty or bogus "unallowed" token. `unallowedTokenProblem` rejects a token that:
  - is not a JWT;
  - names another issuer than the root token;
  - is not an access token;
  - has expired;
  - has no client, or the root canary's client.

  `unallowedClientIsRejected` also now requires the 401 challenge to say "is not in the allowed set", so a 401 for any other reason fails the gate.
- **Concurrent refreshes (comment-only from both):** two refreshes at once now share one helper run, so they can't race on the status file.
- **Surviving refresh token (breaker should-fix 2):** mint and revoke now revoke the refresh token in every stored version of the secret, including deprecated ones. A token left behind by an interrupted re-mint is still revoked.
- **Doc cuts (pruner) and wording (breaker 4 and 5):**
  - DEPLOYMENT.md drops the duplicated helper notes and the copied spike steps; it now links to design § 6 item 0 instead.
  - The design doc loses the speculative § 2.6 sentences (the caching rationale, under § 2.3's no-caching rule).
  - I removed the duplicate comment line in `test/mcp-audit-http.test.ts`.
  - The token-lifetime row now says "at most 15 minutes", and the doc says `env -i` guards against accidental leaks, not a hostile child.
  - Every script reference now points to `.mjs`.

**Tests:**
- I rewrote `test/root-canary-scripts.test.ts` to run the modules in-process with a fake AWS CLI and a fake `fetch`. The `env -i` test now records the helper's actual environment and checks that the child's settings don't reach it.
- New tests cover a malformed JWKS, the stranded deprecated-version token, every way the unallowed-client token can be bad, and the 401-reason check.
- Locally, the two root-canary test files pass (95 tests) and the typecheck is clean.
- The full local run had 3 timeout failures in `endo-guest-lockdown` and `git-remote/capability`, files this change doesn't touch. When I re-ran those two files, only one test still failed. CI's full suite passed.

**Not changed (comment-only or borderline):**
- The inference check still uses `includes("root-canary-ok")`.
- The pruner's two `src/mcp-audit.ts` comments are kept.
- When the status file holds a failure reason, it still overrides a passing child's exit; single-flight makes that race much less likely.

**Follow-ups:**
- `root-canary-mint.mjs` (the PKCE flow and callback server) and the full `deploy-client` provisioning path are not tested end to end; they need real AWS and Cognito.
- The mint and revoke version walk assumes Cognito's `RevokeToken` succeeds on a token that is already revoked (RFC 7009 behavior). The verification spike's revocation drill should confirm that.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (5857338 cached reads)
- Output: 59284 tokens
- Cost: $3.7662755999999993
- Wall-clock: 3027s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
