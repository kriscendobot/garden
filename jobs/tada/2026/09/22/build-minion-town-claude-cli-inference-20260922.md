Done. All local gates green, draft PR #105 open, seam shared with Track B.

## Completion report

**Job:** Track A of the `minion-town-claude-inference-exploration-20260922` orchestration — a tentative, gap-revealing Claude **CLI** inference backend for minion.town (kriscendobot/minion.town), executing kriskowal's 2026-09-22 direction on endojs/endo-but-for-bots#1228.

**Deliverable:** Draft PR **kriscendobot/minion.town#105** (base `main-7ea226e`, head `claude-cli-inference-track-a`, commit `399418a`, 18 files, stays draft per gap-revealing-build).

**What I built** (behind `ENDO_CLAUDE_ENABLED=1`; off ⇒ byte-for-byte today's app):
- `src/endo/claude/backend.ts` — the swappable `InferenceBackend` seam + tagged `InferResult` (never throws), provider-neutral `GuestToolProjection`.
- `cli-confinement.ts` — PURE five-flag confinement argv/env/mcp-config/settings builder (prompt on stdin, nonce in header not URL, attenuated env).
- `stream-json.ts` — PURE stream-json reducer + auth-failure heuristic.
- `guest-mcp-endpoint.ts` — nonce-gated loopback MCP surface reusing `registerGuestTools` over one facet ("local MCP surface scoped to that guest").
- `cli-backend.ts` — Track A spawn glue with wall-clock/output-byte (process-group kill) / max-turns limits.
- `claude-tools.ts` — the backend-agnostic `infer` tool sharing the guest guard+facet; config/server/http wiring; `.env.example` docs; `designs/claude-cli-inference-track-a.md`.

**Verification (real execution):** `npm run typecheck`, `npm run build`, `npm test` all green — 399 tests (394 passed incl. my **34** new, 5 pre-existing skips). The integration test round-trips a confined turn through the guest MCP surface via a fake `claude` binary. I also live-verified all five confinement flags present on the fleet CLI 2.1.251 (`claude --help`). Live-model confinement/credential claims are **taken on faith** and enumerated as 6 gaps in the PR body and design doc — no real subscription in this environment.

**Coordination:** Track B (Agent-SDK, peer `build-minion-town-claude-agent-sdk-inference-20260922`) messaged me asking for the seam; I replied with the `InferenceBackend` interface, branch/commit, and PR#. They implement the same seam consuming `buildMcpServer()` in-process.

**Follow-ups:** (1) `ENDO_CLAUDE_BACKEND=cli|agent-sdk` selector — deferred to whichever track lands second (coordinated with Track B). (2) The 6 back-fill findings for the Endo item-4 design. (3) PR stays draft pending the production comparison against Track B.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-cli-inference-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 168 tokens (11532580 cached reads)
- Output: 75375 tokens
- Cost: $9.523927999999996
- Wall-clock: 1355s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
