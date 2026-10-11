---
kind: panel-run
repo: kriscendobot/minion.town
pr: 94
panel_kind: code
base_ref: 50aa690f87bab73cadc83eaeb39806b60913f054
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 57d05a58b07acd0b27886c4f683ef10827cca694
must_fix_total: 17
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 2b0c0bd5a1cb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #94 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `57d05a58`

seat verdicts (34): archivist=pass assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=pass migrator=comment orthographer=pass packager=comment procurer=pass prover=pass pruner=pass purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=must-fix spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=comment warden=pass wire-watcher=pass
must-fix items (17):
- decomplector: **should-fix: one secret carries two roles.** The Lambda authenticates Cognito's GitHub IdP against `minion/github-oa...
- decomplector: `deploy-thunk.sh` step 0 must converge the IdP onto the secret before the gate ships.
- decomplector: That step dies if the secret is absent once the IdP exists.
- decomplector: The header comment has to carve out "while Cognito has no GitHub IdP".
- decomplector: The smoke check can only prove the gate is present, not that the IdP's credentials match. The script says so itself: ...
- decomplector: **should-fix: `rawReading` hedges instead of deciding.** `presentedClientCredentials` returns a value with an optiona...
- decomplector: The return type is `ClientCredentials & { rawReading? }`, a record with an optional shadow value. A plain list of can...
- decomplector: Better still, observe what Cognito sends, pick one reading, and drop the second.
- decomplector: Accepting either reading also widens the set of strings that authenticate one secret.
- decomplector: **comment-only: single-entry `clients` map in `index.js`.** The Lambda builds `{ [client_id]: client_secret }` only t...
- decomplector: **comment-only: `install_secret` consolidation.** Extracting one helper for the box-side secret writes is a clean dec...
- scribe: `/token` now requires client authentication.
- scribe: A shared `client-authentication.cjs` module replaces duplicated validation.
- scribe: An `install_secret` helper replaces the box-side secret writes.
- scribe: `deploy-thunk.sh` now converges the IdP instead of comparing it.
- scribe: The Basic-pair check now matches the raw pair as well as the form-decoded one.
- scribe: **The summaries that exist are not discoverable.** `6092132928` (head `c5be627`, gauntlet `269fdc5d`) and `6094423213...
