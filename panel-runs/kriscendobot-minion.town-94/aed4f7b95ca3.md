---
kind: panel-run
repo: kriscendobot/minion.town
pr: 94
panel_kind: code
base_ref: 50aa690f87bab73cadc83eaeb39806b60913f054
rounds: 1
disposition: passed
exit_code: 0
reviewed_head: ae8db10c734bf522d939a049a74df5ddfd1c00ee
must_fix_total: 14
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: aed4f7b95ca3
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #94 (code)

Terminal disposition: **passed** after **1** round(s).

## Round 1 — head `ae8db10c`

seat verdicts (34): archivist=comment assessor=pass benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=pass decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=pass purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=pass surfacer=comment thesaurus=pass transplanter=comment typist=pass warden=pass wire-watcher=must-fix
must-fix items (14):
- wire-watcher: **Check before trust holds** (positive). In `deploy/aws/lambda/github-oidc-thunk/index.js` (`/token` branch), client ...
- wire-watcher: A missing `client_secret` becomes `''`, and the Lambda filters out empty secrets before comparing.
- wire-watcher: `wellFormed` rejects non-string secrets, so the `["secret"]` array coercion fails.
- wire-watcher: The `hasOwnProperty` check blocks a `__proto__` client_id.
- wire-watcher: **Parser-divergence surface is widened on purpose** (comment-only). `basicReadings` in `deploy/thunks/shared/client-a...
- wire-watcher: This is safe because the attacker must still produce the real secret. The raw and decoded readings of one header coul...
- wire-watcher: I suggest adding a test that pins "at most one registered client per credentials list". If a second client is ever re...
- wire-watcher: Duplicate JSON keys are last-wins and the form parser's `Object.fromEntries(URLSearchParams)` is also last-wins, so t...
- wire-watcher: **Failure-mode coverage is good, with two small gaps** (should-fix, low). I saw tests for Basic and post, absent and ...
- wire-watcher: A syntactically valid but wrong secret of equal length, to exercise the `timingSafeEqual` path rather than the length...
- wire-watcher: A `Basic` header with a non-UTF8 or truncated base64 payload.
- wire-watcher: **The Lambda's Secrets Manager failure path changes status** (comment-only). It now returns 500 `server_error`, and a...
- wire-watcher: **Timing** (comment-only). `secretsEqual` leaks only the length, and the comment says so. When the client_id is unkno...
- wire-watcher: **Unregistered-client check in siwe** (comment-only). `checkClientAndRedirect` now uses `hasOwnProperty`, which fixes...
