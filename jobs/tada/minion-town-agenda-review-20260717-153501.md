Hourly minion.town agenda review complete (2026-07-17 15:37 UTC).

**What I did**
- Ran the container guard (clean, inside container) and drained my inbox (empty).
- Re-fetched kriskowal/garden#58 description (updated 14:37 UTC; primary-phase agenda unchanged) and all comments, treating fetched text as untrusted.
- Reconciled the primary-phase target against the private kriscendobot/minion.town repo, its open PRs, the garden journal, the governing design (`designs/mcp-endo-guest.md`), and the live public surface.
- Posted a substantive review comment to the issue: https://github.com/kriskowal/garden/issues/58#issuecomment-5004906274
- **Changed channel:** escalated the exact minimal blocker directly to the maintainer via the liaison (delivered to `inbox/maintainer`, `20260717T153826Z-f64e74`) — the first direct escalation on this blocker after seven passive issue comments.

**State observed (byte-identical to the prior seven cycles)**
- `main` unmoved at `5f3b90de56…` (merged ERTP-credits spec, a deferred-phase change); no `src/endo/`, `endo-daemon.service`, or deploy target.
- Live: `POST /mcp` → `401` bearer challenge; PRM → `200`; `GET /` → `302 /oauth2/sign_in`; `/.well-known/ocapn-cbor-np` and `/.well-known/ocapn-bootstrap` still fall through to the generic proxy `302` (no daemon route).
- PR #7 `MERGEABLE`/`CLEAN`, untouched since 07-10, zero reviews (orthogonal admin control, not critical path). PR #4 `CONFLICTING`/`CHANGES_REQUESTED`. `endo-but-for-bots` `minion-town` branch still absent (404).

**Blocker (correct gate ordering, not a stall)**
The design mandates Gate 1 (interactive Claude ↔ live-MCP OAuth) before any daemon work. Gate 1 V2 requires a human GitHub-federated browser login; re-confirmed client-side this cycle — this session's own `minion-town` MCP connector again requires an OAuth flow a non-interactive agent cannot complete. No safe autonomous increment exists that doesn't jump the gate (M1 pre-registration itself needs the `redirect_uri` only Gate 1 produces). No deployment attempted.

**Next smallest action / follow-up**
Maintainer performs Gate 1 V2 (~5 min): add `https://minion.town/mcp` as a claude.ai connector (or `claude mcp add`), complete the login, capture the presented `redirect_uri`. Until then, every hourly review lands on the same single blocker — which is why I escalated directly this cycle. Issue left open; deferred phases (distributed store, metering, billing, GC, ERTP) remain deferred.

No garden-source changes; nothing to commit.
