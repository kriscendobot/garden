Draft PR #36 is open and the builder stage is complete. The gardening state machine will auto-run the gauntlet (clean → panel → fix-loop → un-draft) from here.

## Completion report

**Job:** builder on `kriscendobot/minion.town` — implement `designs/remove-toy-tools-and-prune-minion-scopes.md` (merged design PR #30) as a single removal PR against `main`.

**Delivered:** DRAFT PR **kriscendobot/minion.town#36** (head `remove-toy-tools-and-prune-minion-scopes`, base `main`), opened via `ensure-pr.sh`. The gauntlet auto-runs from here.

**What changed (21 files, +220 / −306):**
- **Code/config** — removed the three toy tools + in-memory minion state (`src/server.ts`); removed `MINIONS_READ`/`MINIONS_WRITE` and their `TOOL_SCOPES` entries (`src/auth/scopes.ts`); collapsed `Role` to `guest`-only, dropping `resident` (`src/auth/accounts.ts`); pruned `minions:*` from `MCP_SCOPES_SUPPORTED` default (`src/config.ts`) and from all five `config/policy.json` identities. `dev/client.ts` already carried no toy references (the repo had moved to guest tools since the design was grounded), so no change there.
- **IaC** — dropped `scopeRead`/`scopeWrite` and their PKCE-client scope entries + the `MCP_SCOPES_SUPPORTED` default (`infra/lib/minion-town-stack.ts`).
- **Ops/web/docs** — `deploy/aws/systemd/minion-mcp.service`, `deploy/aws/www/{index,connect}.html`, `DEPLOYMENT.md` (incl. a new **Phase 12** deploy-ordering row), plus `README.md`, `infra/README.md`, `.env.example`, `Dockerfile` (not in the design's enumerated list, but they carried the exact removed tokens).
- **Tests** — pruned every `minions:*`/toy assertion across `auth`, `accounts`, `policy`, `account-endpoint`, `privilege-page`, `endo-guest-http`; the `mcp/tools` route-gate and `mcp/guest` admission tests are kept and green.

**Design § 6 open questions — took the recommended defaults, all reversible in review (stated in the PR body):** (1) replaced `minion_status` with a minimal non-toy `whoami` tool (`SCOPES.TOOLS`) returning the caller's identity/role/effective scopes; (2) collapsed the role ladder to `guest`-only, leaving `resident -> [mcp/tools, mcp/guest]` to increment B4 — **no `mcp/guest` grant added**; (3) kept the `default.scopes: []` note.

**Verification:** `npm run typecheck` clean; `npm test` 215 passed / 3 skipped (ENDO_CHECKOUT-gated); all four pre-push gate probes pass; net-diff-confirmed no `mcp/tools` or `mcp/guest` enforcement point was dropped. Kept intact: `resolveEffectiveScopes`, `isToolAllowed`/`TOOL_SCOPES`, the route gate, the guest admission gate, and the Cognito `mcp` resource server.

**Flags surfaced to the maintainer (via message bus):**
1. **Overlap with live PR #20** (`feat/endo-daemon-guest-mcp-b5`, OPEN, non-draft): it also retires the toy tools + removes `mcp/minions:*`, but coupled with the B5 "daemon guest = required surface" feature and gated on B4/B5 deploy evidence. #36 is the decoupled *pure removal* design #30 carved out. They collide on the removal — the maintainer should land one and rebase/close the other. Flagged prominently in #36's body rather than silently competing (per builder duplicate-check norm).
2. **Deploy ordering is load-bearing:** the Cognito/IaC change needs `cdk deploy` **before** the app roll (resource server + PKCE client drop `minions:*` first). No deploy performed; recorded as Phase 12 in `DEPLOYMENT.md`.

**Follow-ups / caveats:** `infra/` CDK typecheck couldn't run locally (its `node_modules` aren't populated here) — the edit is a mechanical two-symbol deletion with no dangling references, but CI/`cdk synth` should confirm. The maintainer's reconciliation decision on #20 vs #36 is pending in my inbox.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr30-remove-toy-tools-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 267 tokens (24293348 cached reads)
- Output: 97678 tokens
- Cost: $16.91294899999999
- Wall-clock: 1389s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
