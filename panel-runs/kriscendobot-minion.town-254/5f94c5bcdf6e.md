---
kind: panel-run
repo: kriscendobot/minion.town
pr: 254
panel_kind: code
provider: anthropic
base_ref: 7a0bcc903026382582afd97fcc3c2a18a0e85e05
pr_body_hash: 192c2a4825e49a253e6c185605c61a65ba7ed2cd82d1a9d1b7f5da029694e8a1
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 27ff5fb8c62135c5ab7663fc751490d15133e4fd
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 5f94c5bcdf6e
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #254 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `27ff5fb8`

seat verdicts (34): archivist=comment assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=comment orthographer=must-fix packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=pass surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- assessor: **must-fix: a stale remembered outcome overrides a valid guest.**
- assessor: **Where:** `deploy/aws/www/home.js`, `rememberedRecovery` → `landingOutcome = 'recovery-unavailable'`, plus the `la...
- assessor: **Failure:** the session record is consumed only on the next load. After a failed recovery, if the visitor accepts an...
- assessor: **Fix:** clear the record on every successful landing, and/or let a verified `guestId` beat a remembered (not live) o...
- assessor: [proposed-rule: a persisted "last failure" hint must be cleared on any later success and must never outrank a freshly...
- assessor: **should-fix: the provider header may never be set, which would make `identityProvider` dead code.**
- assessor: **Where:** `deploy/aws/caddy/conf.d/minion-town.caddy`, `copy_headers X-Auth-Request-Provider`.
- assessor: **Failure:** my grep found nothing in the diff or repo that makes oauth2-proxy emit that header. The only mention is ...
- assessor: **Fix:** confirm or document where the header originates. Otherwise the changeset claim "names the provider" is unver...
- assessor: **should-fix: the generic catch-all in `resolveGuest` conflates failure kinds.**
- assessor: **Where:** `home.js`, recovery `catch`. Any non-404 error, including 401/403 from the recovery route (an expired OAut...
- assessor: **Failure:** the visitor gets a "try again" card that cannot succeed, and the retry replays the same failing request.
- assessor: **comment-only: `retryLanding` resets `deletionPending` but not `recoveryProvider`.**
- assessor: **Where:** `home.js`, `retryLanding`.
- assessor: **Failure:** after a retry that ends in a different outcome, a stale provider label can persist. It is only used by t...
- breaker: **must-fix: a stale recovery outcome hides a valid guest.**
- breaker: **Where:** `deploy/aws/www/home.js`, `landingOutcome` initialised from `rememberedRecovery`, plus `landingMode`, wher...
- breaker: **Invariant:** a visitor with a working guest lands in the shell.
- breaker: **Attack:**
- breaker: In a tab, a recovery sign-in returns 404, so `rememberRecoveryOutcome` writes the sessionStorage key.
