Done. The comment posted under the bot identity (`kriscendobot`), and issue #58 remains **OPEN** (I did not close it — that's the submitter's prerogative).

No garden code changes were warranted (this was an investigation + issue reply), so there is nothing to commit to `main2`.

---

## Completion report

**Job:** dead-lettered `issue-inbox` message for the completed `issue-kriskowal-garden-58` doer — a new comment on kriskowal/garden#58 by **@dckc** reporting that all `mcp/minions:*` tools on `https://minion.town/mcp` are rejected with `insufficient_scope`, requesting a server-side scope grant for `sub=8929a9ae-...`.

**What I did**
- Investigated the `kriscendobot/minion.town` (MCP/Cognito) codebase — the authorization algebra `effective = (static policy ∪ account role) ∩ token`, `config/policy.json`, `src/auth/accounts.ts`, and `set-account-role.sh`.
- Looked the reported `sub` up in the live `minion-town-accounts` DynamoDB table (garden-fleet creds): it is **`dckc@madmode.com`**, auto-provisioned today (`2026-07-20T18:37:52Z`) with the baseline role **`guest`** (grants `{mcp/tools}` only), active, 500 credits — **a third party**, not the maintainer (whose two identities are already full-admin in `config/policy.json`).
- Posted a substantive reply on the issue thread: kriskowal/garden#58 → comment `5026612405`.

**Key finding (reframe):** This is **not a defect** — it is the designed two-layer authorization working correctly, and specifically the documented **V4 Gate-1 acceptance criterion** (`designs/mcp-endo-guest.md`: "from a fresh guest-role identity, `list_minions` fails with `insufficient_scope`"). dckc's session inadvertently **proves V1–V4 of Gate 1 end-to-end** — the interactive OAuth-to-live-MCP validation that has been this issue's primary-phase blocker for weeks, now demonstrated in the wild by an independent contributor. The token legitimately carries all three scopes (Cognito issues the full resource-server set to the app client); the intersection with the guest baseline narrows it to `{mcp/tools}` by design — tokens can only be narrowed, never widened.

**What I deliberately did NOT do:** grant the scopes. The requested fix is a **maintainer authorization decision** for a third party. `:read` is a `resident` role elevation; `:write` is **not grantable through the store at all** (deliberate safety design — the role ladder tops out at `resident`) and requires a git-audited `config/policy.json` commit + deploy. The fleet must not autonomously widen a third party's scopes. I surfaced the exact levers/commands and offered to stage a `config/policy.json` PR for the maintainer's review.

**Changes:** none to the garden repo (no `main2` commit); one issue comment posted under the bot identity; no infra mutated.

**Follow-ups (maintainer decision, surfaced on the issue):**
1. Decide whether to elevate `dckc@madmode.com` — read-only (`set-account-role.sh role … resident`) or full (`config/policy.json` + deploy).
2. Consider recording Gate 1 as passed (a `DEPLOYMENT.md` phase row), since V1–V4 are now demonstrated — the hourly agenda-review reports have been waiting on exactly this.
