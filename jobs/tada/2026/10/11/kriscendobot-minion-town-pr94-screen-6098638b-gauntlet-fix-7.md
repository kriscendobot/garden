Fix round 7 for kriscendobot/minion.town#94 is pushed and CI is green. Two follow-up commits went onto the PR head, moving it from `889c963` to `57d05a5`.

**Must-fix items from the round-7 panel**
1. **breaker: Basic credentials were mangled by decoding.** I could not find out what Cognito actually sends, so the module now accepts both forms rather than guessing.
   - `deploy/thunks/shared/client-authentication.cjs` keeps the Basic pair exactly as sent (`rawReading`) alongside the form-decoded one.
   - The new `authenticatedClientId` (replacing `clientAuthenticated`) tries the decoded pair first, then the raw one, and returns whichever client_id matched. The SIWE thunk ties the code to that client_id.
   - A pair that is not valid form encoding (such as `%zz`) now falls back to the raw pair instead of getting a 401.
   - Both callers are updated, and the SIWE README rules now describe the two-way match.
   - New tests cover raw secrets containing `+` or `%` in the shared-module suite and end to end in the SIWE `oidc-face` test (raw and form-encoded).
2. **archivist:**
   - **README claim:** I checked it against `deploy-cognito-github-idp.sh`. The script and the thunk both read the secret named by `GITHUB_OAUTH_SECRET_ID`, and `deploy-thunk.sh` passes the same value to both. The README now says this explicitly.
   - **Comment:** added a one-line comment on why `parseFormOrJson` turns non-object JSON into `{}`.

**Should-fix items (also done)**
- **assessor:** the `deploy-thunk.sh` header no longer says the thunk can be deployed before `minion/github-oauth-app` exists once the IdP is there.
- **assessor/breaker:** the step-6 log line now says the 401 only proves the gate is present.
- **prover:**
  - The source-grepping deploy and `/tmp` tests are labeled as lint guards.
  - The Secrets Manager outage tests reload the thunk before each test, so they no longer depend on run order.
- **typist:** the body parameter is typed `unknown`.

**Checks**
- Locally, the vitest token-auth and caddy suites passed (71 tests), as did the SIWE `node --test` suite (28) and `npm run typecheck`.
- CI is green: `ci-wait-merge` returned rc 0 with 3/3 checks passing.
- The first CI wait used the full 3600s deadline but ran in the background, hit the GitHub API rate limit and was killed. I reran it in the foreground with roughly 9-minute deadlines until it reported green. The Claude harness jobs sat queued for about 30 minutes waiting for the self-hosted runner.
- The PR body is still accurate, so I didn't change it.

**Follow-ups:** none. The driver posts panel round 8.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3315294 cached reads)
- Output: 22226 tokens
- Cost: $1.8993148000000002
- Wall-clock: 2708s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
