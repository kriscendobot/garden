---
kind: panel-run
repo: kriscendobot/minion.town
pr: 119
panel_kind: code
base_ref: origin/main-561472a
rounds: 1
disposition: must-fix
exit_code: 0
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 70ef5fa05ecb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #119 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `5c3cd1f9`

seat verdicts (33): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=must-fix coverage-auditor=comment curator=pass duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=pass locksmith=comment migrator=comment orthographer=pass packager=pass procurer=pass prover=pass pruner=must-fix purist=must-fix reexport-auditor=pass releaser=pass saboteur=must-fix scribe=must-fix spec-keeper=must-fix stylist=must-fix surfacer=comment thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=must-fix
must-fix items (20):
- archivist: **Design-document section reference mismatch** [rule: cross-document references must resolve]
- archivist: **File:** `src/endo/claude/account.ts:32`, `src/endo/claude/agents.ts:235`
- archivist: **Issue:** Comments reference "(§ step 1)" but the design document `claude-agent-credential-reauth.md` uses "§ 1" f...
- archivist: **Fix:** Replace "(§ step 1)" with "(§ 1)" in both locations to align with the design document's actual section num...
- archivist: **Severity:** must-fix — cross-document references must match their targets exactly so readers following them find ...
- archivist: **Type annotation return value documentation** [rule: API documentation belongs in JSDoc, not buried in comments]
- archivist: **File:** `src/endo/claude/types.ts:212-214`
- archivist: **Issue:** The `ChildGuestProvider.removeChild()` JSDoc documents the return type saying "returning the removed child...
- archivist: **Severity:** comment-only — no fix required, the documentation is clear and correct.
- archivist: **Prose claim cross-verification: `ClaudeInferExo` return type with `UsageExhausted`**
- archivist: **File:** `src/endo/claude/types.ts:153-161` and usage in `agents.ts`
- archivist: **Verification:** The JSDoc at line 151-152 states "`ClaudeInferExo` ... `infer` re-validates the credential live and...
- assessor: **[must-fix]** `src/endo/claude/wiring.ts:449-465` (`replaceCredential`) — the credential-generation "epoch" pre-in...
- assessor: **[must-fix]** `src/endo/claude/account.ts:76-78` (`disconnect`) calls `credentials.revoke()` directly, bypassing the...
- breaker: **[must-fix]** `agents.ts:66-69`'s JSDoc claims the credential generation "is ODD exactly while a store is pending," ...
- breaker: **[comment-only]** No sibling-family conversion applies to this diff (a fresh module, not a generalization across twi...
- breaker: Other claimed invariants (DEDUPE's synchronous check-and-set, NEVER-REJECT's fault containment in `persist`/`alert`/`...
- corner-prober: **[must-fix-loop]** Two concurrent `replaceCredential` calls break the documented "epoch is ODD exactly while a store...
- corner-prober: **[summary-fix]** `classify.ts`'s `readResetAt`/`classifyProviderResponse` reset-time path is untested at `resetAt = ...
- corner-prober: **[summary-fix]** `reauth.ts`'s pre-expiry advisory window (`tick()`, `at >= expiresAt - advisoryLeadMs && at < expir...
