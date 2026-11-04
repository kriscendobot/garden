---
kind: panel-run
repo: kriscendobot/minion.town
pr: 244
panel_kind: code
provider: anthropic
base_ref: 637a9a08856a0f952f7deeffc16d682039f48154
pr_body_hash: 79d5a94ae1716ac7de196680dcd5ba74fd0462d07282eecd14693743a9beb605
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: e9d0a15af337b9a1cd171f114f7dbcd77bc407f1
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 7fda75dacbaa
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #244 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `e9d0a15a`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=pass breaker=comment changeset-auditor=comment corner-prober=comment coverage-auditor=comment curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=comment locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=must-fix scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=must-fix warden=pass wire-watcher=comment
must-fix items (20):
- archivist: **comment-only**: `.env.example:33-34`. `API_KEY_GUEST_AGENTS=off` and `AGENT_FACTORY_NAME=` sit under the existing "...
- archivist: **comment-only, unverified**: `src/auth/agent-endpoint.ts:121-125` (the `mountAgentRoutes` JSDoc). It says the agent ...
- archivist: **comment-only, unverified**: `src/endo/agent-service.ts:619-620` cites `endojs/endo-but-for-bots agent-factory.js` a...
- archivist: **comment-only, unverified**: `src/config.ts:188-190`. The `apiKeyGuestAgents` comment says "the legacy subscription ...
- assessor: **should-fix: the agent step's `reload()` failure is reported as a failed create.** `deploy/aws/www/provider-ui.js`, ...
- assessor: The `await reload()` after the POST sits inside the same `try` as the create call.
- assessor: If the create succeeds (201) and the refresh then fails (a network blip, or `/data` or `/agents` returning `daemon-un...
- assessor: It also mints a fresh `idempotencyKey`, so a retry attempts a second create instead of replaying the first.
- assessor: The dialog stays open on a created agent. Separate the create from the post-success refresh, and treat a refresh fail...
- assessor: [rule: roles/jurors/assessor/AGENT.md § Primary surface, error paths and async boundaries]
- assessor: **should-fix: an agent-factory outage takes down the whole providers page.** `src/auth/inference-provider-endpoint.ts...
- assessor: `agents?.list()` is inside the same `Promise.all` as `providers.list()`, so a factory failure rejects the whole respo...
- assessor: The UI copy says the provider "stays available on this page", and the flag's rollback story assumes the same. With th...
- assessor: Catch the agent list separately and degrade to `agentsEnabled: true` with an empty or unknown attachment list.
- assessor: [rule: roles/jurors/assessor/AGENT.md § Primary surface, Promise rejection propagation]
- assessor: **should-fix: with the flag on, `attachedAgents` comes only from the factory.** `withAttachedAgents` and the `/replac...
- assessor: `withAttachedAgents` overwrites the registry's `attachedAgents` and does not merge them.
- assessor: Grants attached directly through the registry, such as legacy imports or agents created before the flag, vanish from ...
- assessor: They also vanish from the replace-key "move agents" options and from the `remainingAgents` count.
- assessor: After a replace, the old provider can read 0 remaining while grants still sit on the fenced provider, so a user could...
