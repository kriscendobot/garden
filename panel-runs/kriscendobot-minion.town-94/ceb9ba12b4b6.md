---
kind: panel-run
repo: kriscendobot/minion.town
pr: 94
panel_kind: code
base_ref: d750b09b30e9bb6ff00dd13e52e56f2acfdf9b23
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 5f246bac7f39adc65dbf2551f0f240cc1c15564f
must_fix_total: 17
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: ceb9ba12b4b6
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — kriscendobot/minion.town #94 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `5f246bac`

seat verdicts (33): archivist=comment assessor=comment benchmarker=pass breaker=pass changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=comment engine-realist=pass fast-checker=comment gateway=pass integrator=pass locksmith=pass migrator=comment orthographer=pass packager=pass procurer=pass prover=comment pruner=comment purist=comment reexport-auditor=pass releaser=comment saboteur=pass scribe=comment spec-keeper=pass stylist=must-fix surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=pass wire-watcher=must-fix
must-fix items (17):
- stylist: **must-fix: abbreviated identifier `i`** at `deploy/aws/lambda/github-oidc-thunk/index.js` (in `tokenClientAuth`, `co...
- stylist: **should-fix: duplicated helper `secretsEqual`.** The diff defines the same function twice, in `deploy/aws/lambda/git...
- stylist: **should-fix: `credentials` and `expectedSecret` in the thunk handler.** `credentials` (in `/token`) holds the GitHub...
- stylist: **comment-only: test and local names in `test/github-oidc-thunk-token-auth.test.ts`.**
- stylist: The helper `basic` returns a whole Authorization header value, not a Basic credential. `basicAuthorizationHeader` wou...
- stylist: `redeemed` records `getTokens` arguments, not redeemed results. `redeemCalls` would be accurate.
- stylist: `tokenRequest` is fine.
- stylist: **comment-only: `SCRIPT` and `STAGE` shell names in the deploy scripts.** These are existing names and the diff doesn...
- wire-watcher: **should-fix: the `/tmp` secret window is only partly closed.** The `umask 077` change is correct and in the right pl...
- wire-watcher: **should-fix: the two `/token` parsers in this PR read the same bytes differently.** In the GitHub thunk, `tokenClien...
- wire-watcher: With no colon, `i === -1`, so `clientId = decoded.slice(0,-1)` and `clientSecret` becomes the whole decoded string.
- wire-watcher: A bad `%` escape throws `URIError`, and that error escapes the `invalid_client` path.
- wire-watcher: **should-fix: the JSON body path accepts non-string credentials.** `parseFormOrJson` accepts JSON, and `secretsEqual`...
- wire-watcher: **comment-only: the check-before-trust order is right.** `getTokens` is only called after the constant-time compariso...
- wire-watcher: **comment-only (paranoid extra): two cases are untested.**
- wire-watcher: If Secrets Manager fails, `getGitHubCredentials` throws and the handler returns 400 `server_error`, so it fails close...
- wire-watcher: Nothing tests a request that sends right credentials in the Basic header and wrong ones in the body. Per RFC 6749 §2...
