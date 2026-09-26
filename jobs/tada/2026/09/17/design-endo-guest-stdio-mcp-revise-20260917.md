The PR is still draft, open, and now carries my follow-up commit `8515b8cdef` at the head of `design/endo-guest-stdio-mcp`. Inbox is empty. Work is complete.

## Completion report

**Job:** Revise design PR #1226 (`designs/endo-guest-stdio-mcp.md`, endojs/endo-but-for-bots) per kriskowal's CHANGES_REQUESTED review.

**PR:** #1226 (draft, left draft). **Head branch:** `design/endo-guest-stdio-mcp`. **New commit:** `8515b8cdef24aa26e8382bcc68b28f3295958883`.

**What the review asked and how I resolved each:**
1. **Drop the per-guest domain socket / named pipe + broker** — Adopted. The entire two-process adapter/broker split, per-guest filesystem-path UDS, socket-discovery analysis, and `SO_PEERCRED`/per-guest-uid machinery are removed. The server is now a single `claude`-spawned stdio process.
2. **Thread the formula id via env var or stdin handshake — recommend one** — New § *Threading the formula id from configuration*. Recommends the **environment variable** (`ENDO_GUEST_FORMULA_ID`) with a concrete technical reason to reject the stdin handshake: under stdio MCP the server's stdin *is the client's channel*, so a handshake would either be client-supplied (a forgery vector) or reintroduce a trusted stdin intermediary (the removed broker).
3. **Use the usual endo daemon client to resolve the guest at the bootstrap root host** — Described concretely (daemon client over `whereEndoSock(...)`, resolve formula id at the bootstrap root host — the same resolution endo-claude's host-only `inferenceProvider` performs), including what authority the confined process now inherits.
4. **ocapn framing** — Documented: over ocapn this is a delivery to the offset-0 nonce-locator/gateway; ocapn's domain-socket transport isn't ready, so the daemon client is used today, with the offset-0 gateway as the future/hardening path.
5. **Thread from config** — Gave the `--mcp-config` entry shape (`env` carries the id; catalog derived live; `--allowedTools` generated separately from the same facet).
6. **Prefer process substitution over a temp config file** — Worked a three-rung ladder (inline JSON → process substitution `<(...)` → `0600` temp file), with the honest fifo/read-once caveat and "verify against the pinned claude CLI version."

**Security honesty:** § *Scoping* now states plainly which properties are **preserved** (formula id never on the MCP wire, per-process isolation, fail-closed on empty catalog) and which **change** — cross-guest isolation moves from *structural* to *runtime + formula-id secrecy*, because the server now holds a daemon connection inside the confined tree. Two hardening paths (daemon-issued scoped bootstrap / ocapn offset-0 gateway; or the retained broker model) are documented for multi-tenant deployments.

**Also:** simplified process lifetime to per-call process (dissolving the broker-teardown obligation and capability-gated-re-pin question); preserved catalog pinning, dispatch check, argument-scope check, naming, and error taxonomy (dropped `unscoped-socket-dir`, added `daemon-unreachable`); rewrote Design Decisions, Open Questions (added the endo-claude reconciliation obligation), Dependencies, and Test plan; added a revision note. Synced `designs/README.md` (Updated date, two prose summaries, size estimate). Mermaid diagram re-validated (parse OK, flowchart-v2). The stray `packages/floot/package.json` install side-effect was excluded from the commit.

**Follow-ups (in the doc's Open Questions):** endo-claude's *Local deployment* / *Multiplexing* sections still describe the removed broker and must be reconciled to this single-process model; a daemon obligation to publish a per-session formula-id-scoped bootstrap for multi-tenant hardening; and verifying `claude`'s `--mcp-config` intake against the pinned CLI version.

Left draft; no gauntlet posted — the maintainer promotes with "run the gauntlet #1226" when ready.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-guest-stdio-mcp-revise-20260917.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2935706 cached reads)
- Output: 53075 tokens
- Cost: $4.112814000000001
- Wall-clock: 789s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
