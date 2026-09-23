PR #91 is ready for review. Job complete.

## Completion report

**Job:** `fix-minion-town-cli-empty-guest-env-defaults` — flip the guest demo CLI's env-var defaults from `??` to `||` (kriscendobot/minion.town).

**What I did**
- In `dev/client.ts`, changed `GUEST_NAME`/`GUEST_TEXT` from `?? "..."` to `|| "..."`. Under `??`, an empty override (`GUEST_NAME= npm run client`) passed `""` straight into the `name`/`text` arguments of `writeText`/`readText`, whose `src/endo/guest-tools.ts` schemas are `z.string().min(1)` — turning a documented default into a schema violation in the one place an operator runs the demo. `||` substitutes the default for any empty value.
- Added a comment explaining why `||` (not `??`) is correct, citing the `z.string().min(1)` wire contract, so the flip does not read as an unreconciled flip-flop and get reverted. (Note: the job referenced an existing rationale comment at `dev/oauth-client.ts`; that file actually has no env-default sites/comment — the prior applications of this reasoning were in commits `464ad2a`/`21eaaa9` on the guest-mode defaults and the test — so I authored a fresh, self-contained comment.)
- Checked every sibling `dev/` env-default site: none share the shape. `GUEST_SUB`/`GUEST_IDP` are gated by `if (opts.sub)` in `oauth-client.ts` (an empty override degrades to absent, no schema failure); `MCP_BASE`/`MCP_RESOURCE_URL` and the port defaults are not `min(1)` wire contracts. Only the two `client.ts` lines needed the fix.

**Verification**
- `npm test` — 299 passed, 5 skipped (green).
- `npm run typecheck` — clean.
- Empty-override behavior proven: with `||`, `GUEST_NAME=`/`GUEST_TEXT=` resolve to the defaults (both length ≥ 1); with the old `??` they resolved to `""` (length 0, schema violation).

**What changed / landed**
- Branch `fix/cli-empty-guest-env-defaults` pushed to `kriscendobot/minion.town`.
- PR **kriscendobot/minion.town#91** opened (via `ensure-pr.sh`, marker-tracked), top-level summary comment posted, and marked **ready for review**.

**Follow-ups:** none. Standalone bounded fix; awaiting maintainer review on #91. (Note: hit a transient GitHub API rate-limit window mid-run; it cleared and all operations completed.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-cli-empty-guest-env-defaults.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (1911459 cached reads)
- Output: 16514 tokens
- Cost: $1.7388949999999994
- Wall-clock: 421s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
