---
kind: panel-run
repo: kriscendobot/minion.town
pr: 94
panel_kind: code
base_ref: origin/main-50aa690
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 971365d99e7d991efc427db222e8782bfe74bb2d
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: cb66f3aa8ea8
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #94 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `971365d9`

seat verdicts (34): archivist=comment assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=pass purist=comment reexport-auditor=pass releaser=comment saboteur=pass scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- decomplector: **Client authentication on the GitHub thunk's `/token`:** needed, since the thunk holds the secret and the endpoint w...
- decomplector: **Basic-header parsing and secret comparison:** these already existed inline in `deploy/thunks/siwe/src/openid.js:tok...
- decomplector: **Streaming secrets into place:** needed, since it removes `/tmp` plaintext.
- decomplector: **Should-fix: a validation predicate is braided into the authentication predicate, and the caller runs both.**
- decomplector: `clientAuthenticated` in `client-authentication.js` calls `wellFormedClientCredentials` internally. `index.js` calls ...
- decomplector: The caller does this only to separate "refuse before a Secrets Manager read" from "compare against the secret".
- decomplector: Unbraid it by making `presentedClientCredentials` return a validated value or `undefined`, so well-formedness is esta...
- decomplector: `wellFormedClientCredentials` can then leave the module's public surface.
- decomplector: [proposed-rule: parse, don't validate: establish a value's well-formedness once at construction, not in two predicate...
- decomplector: **Should-fix: the shared module lives in the wrong place, and the dependency points the wrong way.**
- decomplector: `deploy/thunks/siwe/src/openid.js` now imports `../../../aws/lambda/github-oidc-thunk/src/client-authentication.js`.
- decomplector: That makes the generic thunk tree depend on one AWS Lambda's source directory. It also hard-couples the SIWE esbuild ...
- decomplector: The module has no AWS or GitHub content. It belongs under `deploy/thunks/` (shared), with the Lambda zip step copying...
- decomplector: The header comment justifies the CommonJS-versus-bundle split but not the direction of the dependency.
- decomplector: **Should-fix: place-oriented shell state in `deploy-oauth2-proxy.sh`.**
- decomplector: It toggles `set -o pipefail` ... `set +o pipefail` across a block, so any line added between them inherits the mode a...
- decomplector: The other three scripts scope it with a `( set -o pipefail; ... )` subshell. Use the subshell here too.
- decomplector: The same fetch, install `.new` and `mv` triple is pasted five times across three heredocs. One `install_secret <url> ...
- decomplector: **Comment-only: the rollout ordering is encoded as a deploy-time check with an escape hatch.**
- decomplector: Step 0 of `deploy-thunk.sh` couples the thunk deploy to Cognito's IdP state, using `preflight_read` and a Python JSON...
