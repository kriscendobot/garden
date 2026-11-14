---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1588
panel_kind: code
provider: anthropic
base_ref: 48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c
pr_body_hash: 635ced40f14d584d9f8f15713af58b07012e1e07287d3cc3cfee1eb16b0f6299
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: b5066cca8a9fd67385eca35f79759ddc791b9906
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: c9afc83bddde
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1588 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `b5066cca`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=must-fix decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=comment orthographer=comment packager=must-fix procurer=pass prover=comment pruner=must-fix purist=must-fix reexport-auditor=pass releaser=must-fix saboteur=must-fix scribe=comment spec-keeper=comment stylist=comment surfacer=must-fix thesaurus=pass transplanter=pass typist=comment warden=pass wire-watcher=comment
must-fix items (20):
- archivist: **should-fix: stale present tense in the merged design.** `designs/endo-fetch.md:117-123` says "Today the confinement...
- archivist: **should-fix: understated scope of `@endo/http-confine`.** `designs/endo-fetch.md:113-115` says `@endo/http-confine` ...
- archivist: **should-fix: pre-pass link-status check does not trigger.** `designs/README.md:1122` ("**Complete** on `llm` as of 2...
- archivist: **comment-only: `packages/fetch/README.md:30`.** "`make(powers, context, { env })` ignores its powers and `env`; the ...
- assessor: **should-fix: leaked response body after cancellation.** `packages/confined-fetch/src/transport.js:42-48` uses `Promi...
- assessor: Failure scenario: a request times out while headers are in flight, then the server answers. The body is held open unt...
- assessor: Fix: attach a handler to `response` that cancels `body` when the race has already been lost.
- assessor: [proposed-rule: when racing a resource-yielding promise against cancellation, dispose the resource if the loser later...
- assessor: **should-fix: stale `Revoked` binding for a re-allowed origin.** `packages/exo-http-client/src/http-client.js`, `setA...
- assessor: The request path skips `assertAllowed` for `allowed` members, so B still works now.
- assessor: The persisted table disagrees with the allowlist. It could mislead `listBindings` or any later logic that consults bi...
- assessor: Fix: serialize these control mutations, or re-unpin after the revoke loop for origins that are back in `allowed`.
- assessor: **comment-only: the request-path skip is an invariant shift.**
- assessor: `if (!allowed.includes(origin)) await policy.assertAllowed(...)` replaces the constructor's `pinAllowed`.
- assessor: A `Revoked` binding on an allowed origin is now never consulted.
- assessor: `revokeBinding` and `removeAllowedOrigin` both shrink `allowed`, so no reachable path breaks this today. It is worth ...
- assessor: **comment-only: stale in-flight counts after a limit change.** `packages/http-confine/src/http-confine.js`, `makeRate...
- assessor: **comment-only: swallowed lookup errors.** `packages/confined-fetch/src/index.js` `lookupOptional` swallows every loo...
- assessor: The policy-prompt timeout in `exo-http-client` now cancels its timer in `finally`. The losing `timeout` promise is al...
- assessor: `resolveRedirect` now handles `opaqueredirect` and restricts redirects to the five spec redirect statuses.
