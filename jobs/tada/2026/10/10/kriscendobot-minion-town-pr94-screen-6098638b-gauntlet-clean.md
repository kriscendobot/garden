**Clean stage for kriscendobot/minion.town PR #94: nothing to change, and CI is green at the current head (`6098638b`).**

- **PR state:** open, not a draft. The head is `kriscendobot:security/token-client-auth-and-secret-umask` and the base is `main-50aa690`.
- **Coverage:** I checked the diff against the coverage pass and every new branch is already tested.
  - **GitHub sign-in token endpoint (`github-oidc-thunk`):** both ways a client can send credentials (header and request body) are tested. So are the refusals for missing, wrong, empty, non-string or malformed credentials, and for a correct secret under the wrong client ID. The new test file also covers a Secrets Manager outage: a request with no credentials is refused without reading the secret, a 500 `server_error` is returned, and the next request reads the secret again. All of this is in `test/github-oidc-thunk-token-auth.test.ts`.
  - **Sign-In with Ethereum service (`siwe`):** `oidc-face.test.js` covers wrong secrets, a lowercase `basic` scheme name, malformed and non-string credentials, a `+` decoding to a space, a client registered without a secret, and client IDs such as `constructor` that should never match a registered client.
  - **Deploy scripts:** `caddy-environment-sync.test.ts` now checks that the three deploy scripts never save a downloaded secret in `/tmp` and that each one sets `pipefail`.
- **Dead code:** none. The old `/tmp` staging lines were removed outright, and the `secret.js` change only updates a comment.
- **CI:** I ran `ci-wait-merge.sh kriscendobot/minion.town 94 --no-merge` with the one-hour deadline. It exited 0 with all 3 checks passed: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.
- **Changes:** none. Nothing was pushed to the PR and nothing was committed to the garden repo.
- **Follow-ups:** none. The next stage of the gauntlet (the panel review) can go ahead.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (503899 cached reads)
- Output: 2875 tokens
- Cost: $0.6029597999999998
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
