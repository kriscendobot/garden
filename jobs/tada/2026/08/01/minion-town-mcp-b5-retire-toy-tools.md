B5 code is complete and locally validated; the deployed-edge validation is genuinely maintainer-gated and I've handed it off cleanly. No garden-repo (`main2`) changes were needed — this was a project job whose code already lives on the minion.town PR branch. Concluding the builder instance.

---

## B5 — retire toy tools: completion report

**Repo:** kriscendobot/minion.town · **PR:** kriscendobot/minion.town#20 (`feat/endo-daemon-guest-mcp-b5` @ `fa8667f`, OPEN/MERGEABLE, stacked on B4 #19 → B3 #18 DRAFT).

### What I did this run
- **Verified the B5 branch implements §7 B5 completely** (code review): `minion_status`/`list_minions`/`summon_minion`, the in-memory `Map`, `TOOL_SCOPES`, `isToolAllowed`, and `SCOPES.MINIONS_*` are deleted; guest tools mount **unconditionally** (`endoSock` required w/ default `/run/endo-daemon/endo.sock`, `@endo/init` always runs, `createMcpServer` requires a `GuestMount`), a missing socket yields a clean retryable daemon-unavailable tool error (no toy fallback); `server.ts` header rewritten to the facet model; `scopes_supported` trimmed to `mcp/tools mcp/guest`; README + DEPLOYMENT.md phase rows updated; `deploy/aws/scripts/deploy-cognito-guest-scope.sh` added. Only intentional residuals: a `not.toContain("minion_status")` test guard and the DEPLOYMENT.md removal note.
- **Ran full local validation (real evidence):** `npm run typecheck` → exit 0; `npm run build` → exit 0; `npm test` → **135 passed, 3 skipped**. The daemon-unavailable path is exercised green (`test/endo-guest-http.test.ts` with a nonexistent `ENDO_SOCK`).
- **Snapshotted the deployed edge (read-only):** services `endo-daemon`/`minion-mcp`(ENDO_SOCK wired)/`caddy`/`oauth2-proxy` all active (B3/B4 live), but B5 is **not deployed** — `GET /.well-known/oauth-protected-resource/mcp` still lists `mcp/minions:read`/`:write`, and the Cognito `mcp` resource server still defines them.
- **Recorded** status on PR #20 (comment) and **escalated + sent a closure note** to the maintainer via the message bus.

### What did NOT get done (and why) — the deployed-edge validation
The job's required deployed-edge check (`tools/list` guest-only, then full E1–E4 green) was **not performed**. It requires maintainer-supervised production actions I will not take unilaterally on a live 5-tenant service, especially with B3 still DRAFT:
1. **Deploy the B3→B4→B5 stack to the box** + run the Cognito scope cleanup — without it `tools/list` still shows toy tools.
2. **Federated user-principal tokens** for E1/E2/E4 (Gate-1); the repo PKCE client only auto-approves against the local mock AS.
3. **Live-invasive steps**: E3 restarts the production `endo-daemon`+`minion-mcp` (affecting live guests); E4 suspends a real account.

I explicitly asked the maintainer for a decision (deploy-and-I-validate / you-validate / merge-so-CD-deploys) and received no reply across two reaper cycles; the board has no park slot for a claimed job, so I concluded the instance rather than spin.

### Follow-ups (for the maintainer / next gardener)
- Maintainer picks a path (a/b/c in the inbox message) and re-posts/promotes the B5 job; a gardener then runs the deployed-edge `tools/list` + E1–E4 sweep and records evidence.
- B3 (#18) is still DRAFT — its own gauntlet should close before the stack lands via CD.
- PR #20's base retargets from B4 to `main` when B4 lands (stacked); not blocking.

**No claim of deployed-edge verification is made here** — only the local typecheck/build/test and the read-only deployed probes above were actually executed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-mcp-b5-retire-toy-tools.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (994216 cached reads)
- Output: 21703 tokens
- Cost: $1.357963
- Wall-clock: 353s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
