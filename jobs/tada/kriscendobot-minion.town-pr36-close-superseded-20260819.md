Job complete.

## Completion report

**Verified the `whoami` question, ported it forward, closed #36.**

- **State re-derived:** kriscendobot/minion.town#36 was OPEN (superseded); #20 (`feat: retire toy MCP tools for daemon guests`) is APPROVED / CLEAN / MERGEABLE and its merge job `kriscendobot-minion.town-pr20-merge-20260819` is in `jobs/doin/` (in progress; not yet merged). #20 does the same toy-tool + `mcp/minions:*` scope removal #36 does.

- **`whoami` coverage check:** #36's one independent addition beyond the removal is a `whoami` baseline tool (reports the caller's resolved identity, role, and effective scopes, gated by `SCOPES.TOOLS`). Diffed against #20's head (`749a02d`): #20's tool surface is the daemon-guest surface only (`guest_*` + weblet tools). `guest_status` only probes the guest's pet-name count — nothing in #20 reports OAuth identity/role/effective scopes. **#20 does NOT cover `whoami`.**

- **Did not silently drop it:** posted a small blocked follow-up job `kriscendobot-minion.town-port-whoami-tool-20260819` (role: builder), parked in `plan/` and blocked on the #20 merge so it runs against the merged base. Its body points at #36's diff as the source of truth and scopes the work to a pure additive port of just the `whoami` tool + tests + doc blurb.

- **Closed #36** as superseded with a comment pointing at #20 as the superseding PR, and noting `whoami` is being ported forward via the follow-up job.

**Follow-ups:** the whoami-port job auto-promotes when the #20 merge job lands in `tada/`. No garden-repo (main2) changes were needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr36-close-superseded-20260819.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 40 tokens (1159158 cached reads)
- Output: 12462 tokens
- Cost: $1.4099920000000001 (2 engagement(s) unpriced)
- Wall-clock: 219s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
