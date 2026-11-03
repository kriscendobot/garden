---
kind: panel-run
repo: kriscendobot/minion.town
pr: 229
panel_kind: code
provider: anthropic
base_ref: 443519ebee45143cccfe3a36c10635ce24d74ae0
pr_body_hash: 61ef21b75d7a4bd3171da699dfd312400ecdc16a7b894c510752717342aabf15
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 7700cd9dc4d54f2cf620ba7f426e7f3cf62db071
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: e8acea0f10d7
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #229 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `7700cd9d`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=must-fix corner-prober=must-fix coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=must-fix fast-checker=comment gateway=comment integrator=must-fix locksmith=must-fix migrator=must-fix orthographer=pass packager=comment procurer=comment prover=must-fix pruner=must-fix purist=comment reexport-auditor=pass releaser=must-fix saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=must-fix thesaurus=pass transplanter=comment typist=comment warden=comment wire-watcher=must-fix
must-fix items (20):
- archivist: **should-fix: exported endpoint has no JSDoc.** `src/auth/inference-provider-endpoint.ts:52` (`InferenceProviderEndpo...
- archivist: **should-fix (escalate to must-fix if any caller passes non-config input): `lookup` JSDoc overstates its restriction....
- archivist: **should-fix: unresolvable "Phase 3" reference.** `src/endo/inference-provider-service.ts:146-148` ("the approved Pha...
- archivist: **should-fix: new route undocumented.** The PR adds `/account/providers` to the Caddy file and `minion-town-route-adm...
- assessor: **must-fix: a daemon failure in `admit` is never caught.**
- assessor: `src/auth/inference-provider-endpoint.ts`, in `admit`: `return deps.guestService.guestFormulaIdentifierFor(...)` retu...
- assessor: The `catch` therefore never sees the rejection. `admit` rejects out of `run`'s `await admit(...)`, which sits outside...
- assessor: Express 4 does not handle async rejections. The request hangs and an unhandled rejection is raised, instead of the in...
- assessor: Fix: `return await ...`. Add a test for the rejecting case.
- assessor: **must-fix: omitted `limits` silently applies defaults on the limit-edit routes.**
- assessor: `parseLimits(undefined)` returns `DEFAULT_PROVIDER_LIMITS`. That is right for create, but `owner-limits` and `:id/lim...
- assessor: A body of `{}` or `{"confirmed":true}` therefore resets the owner-wide or provider limits to `{2, 20, 5}`. That could...
- assessor: Fix: require `limits` to be present on these two routes (throw `invalid-limits`), and keep the default only in `safeC...
- assessor: **should-fix: the replace route can partly succeed and still report an error.**
- assessor: `/:id/replace` calls `supersede`, then `reattachAgents`, then `list`. If `reattachAgents` or `list` throws, the clien...
- assessor: A retry from the UI would use the same `idempotencyKey` while the old provider is already superseded, and its behavio...
- assessor: Wrap the post-supersede steps so the response still reports the created provider, with a `reattachFailed` marker. The...
- assessor: **should-fix: a missing `operationId` or `idempotencyKey` defaults to a fresh UUID.**
- assessor: This applies to `retire`, `upstream-revoked`, `owner-limits` and `:id/limits`. A client retry without the id is not i...
- assessor: Also, `String(x ?? uuid)` accepts any type or length unvalidated, unlike the `IDENTIFIER` check in `replace`.
