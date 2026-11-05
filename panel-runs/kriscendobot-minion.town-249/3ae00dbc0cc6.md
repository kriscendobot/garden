---
kind: panel-run
repo: kriscendobot/minion.town
pr: 249
panel_kind: code
provider: anthropic
base_ref: 7a0bcc903026382582afd97fcc3c2a18a0e85e05
pr_body_hash: 1c399f4a36f396ac9782716e82ec735f52560b48a55dff14058e00864bec31c0
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: de1e42ba087f7654858fafdbb6448309f9ebc919
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 3ae00dbc0cc6
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #249 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `de1e42ba`

seat verdicts (34): archivist=comment assessor=comment benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=pass pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=pass spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- decomplector: **must-fix: `replacementMoves` is a third copy of the factory's ownership knowledge, and it has been patched three ro...
- decomplector: [proposed-rule: when a design cites a downstream authority that already owns a decision, the proxy does not re-derive...
- decomplector: The function re-answers "which grants and agents may move, and is any creation pending?" from three snapshots: `provi...
- decomplector: The doc comment says the result is "advisory across its awaits" and that "a creation that starts after the snapshot c...
- decomplector: The `agent-creation-in-progress` refusal for any grant-only record while any creation is pending on the provider is a...
- decomplector: The `committedRetry` flag adds a second mode, where refusals become an `unmovable` boolean, a registry fallback and a...
- decomplector: Existing path: the factory's `reattach(agentId)` already re-checks state atomically per agent, under a key derived fr...
- decomplector: Smaller primitive: move only `agentIds` through the factory. Let the registry, or a single `reattach` call on the reg...
- decomplector: The code comment itself says the grant/`attachedAgents` joins are "forward-looking" because the cited factory and reg...
- decomplector: The grant path is therefore speculative code. Remove it and add it when the registry can answer, instead of guessing.
- decomplector: **should-fix: `publicAgent` switches on remote `lifecycle` to decide which fields to expose.**
- decomplector: Projection is hand-written three times: creating, deleted/unknown and active. `publicLimits`, `publicOption` and the ...
- decomplector: This braids the wire shape with the type union. Fail-closed is a good property, but a declarative field-allowlist tab...
- decomplector: `DeletingAgentSummary` is "may still report a full record" but typed as only `{agentId, name}`. The type claims less ...
- decomplector: **should-fix: the `operationId` deprecation keeps a validated-but-inert parameter.**
- decomplector: It is accepted, validated only when sent, and changes nothing. That is a place for dead state on the wire.
- decomplector: Reject it, or ignore it entirely. Do not validate it.
- decomplector: The breaking-change note already admits other tightening, so one more tightening is consistent.
- decomplector: **comment-only:** the `agent-service.ts` change from `(d)` to `(directory)` is pure churn and unrelated to this PR. T...
- pruner: **PR body over the concision threshold (391 words).** The "Key replacement keeps both move paths: …" closing paragr...
