Round 8 fixes for kriscendobot/minion.town PR #186 are pushed and CI is green. I applied every must-fix item but one, which turned out to be wrong, and the three suggested-only items that were quick (two property tests, the year bound). Head is now `f51219b` (was `81beda5`), pushed with `safe-push-pr-head.sh`.

**Commits:**
- **`441e6d0` (typist, locksmith):**
  - `McpAuditEvent` is now a union type that requires `tool` on tool-call records and forbids it on session records. Type-level tests pin both invalid cases.
  - `auditClaudeTool` now receives only client id, tool and child name, never the caller's bearer token.
- **`0561a84` (engine-realist, corner-prober):**
  - The canary's sweep and cleanup now count only `dismissed` or `not-found` as success. An `unavailable` answer is recorded as a failure.
  - `runPrefix` rejects dates outside years 0000–9999, which would produce names that can't be parsed back.
- **`f51219b` (wire-watcher, saboteur/purist, breaker, archivist, fast-checker):**
  - **Token checks:** access tokens are verified against the user pool's signing keys (JWKS), and must name the pool's issuer and not be expired. This applies to both the refresh and mint paths. New tests reject unsigned, wrong-key, wrong-issuer and expired tokens.
  - **Bearer helper:** it now runs with a cleared environment (`env -i`) and tool paths fixed before the canary child starts, and curl no longer reads `.curlrc`. A test with a hostile `PATH`, `AWS`, `.curlrc`, proxy and subject setting confirms none of them are used. I also checked that the test fails if the environment clearing is removed.
  - **Reader role:** `root-canary-deploy-client.sh` now refuses to reuse a reader role that carries any extra inline or attached policy. It checks before touching the trust policy and again after writing the read policy, and a test covers it.
  - **Docs:** the runbook now says `root-canary-revoke.sh --yes`, and `DEPLOYMENT.md` gains a table of where each script's outputs live and how long they last.
  - **Property tests:** added for the session-name normalizer and the authorization-code validator.

**Declined:** breaker's claim that `root-canary-status.sh:32` runs the token as a command is wrong. The command substitution there only builds the script's path, and the helper's output goes to `/dev/null`. I added a passing `--check` success test that asserts the token appears in neither stdout nor stderr.

**Verification:**
- `npm run typecheck` is clean, and the four touched test suites pass (`root-canary-scripts` 55/55).
- Full `npm test` has one local failure, in `test/git-remote/capability.test.ts`. That file isn't part of this change, and the failure looks like this host's git setup.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. The first wait, with the full 3600s deadline, was killed by the session's background time limit while the run was still queued, so I polled the Actions run until it finished with success and then re-ran `ci-wait-merge` in the foreground.

**PR comment:** I posted a summary for this push on the PR (issuecomment-6192416280). I did not go back and post the earlier per-push summaries the scribe asked for (`63265e4`, `57aafde`); that was a non-blocking note.

**Follow-ups:**
- The next panel (round 9) still needs to run.
- The bearer helper now needs `node` on the canary host to check token signatures.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (6106862 cached reads)
- Output: 44174 tokens
- Cost: $3.2472524
- Wall-clock: 2095s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
