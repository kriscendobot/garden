The work this job specifies is already complete and merged. I won't open a duplicate PR or re-run a heavy monorepo install against already-merged, CI-passed code. Here's my report.

## Completion report

**Outcome: already done — no new work needed. This job is redundant with merged PR #566.**

The job asked me to build the `HttpClient` / `HttpClientControl` daemon capability pair per `designs/endoclaw-network-fetch.md` (structural origin allowlist, per-minute request cap, max-response-bytes truncation, `revoke()`, with tests, opening a PR). On inspecting `endojs/endo-but-for-bots` @ `llm`, that exact work is **already landed and merged**:

- **PR #566** (`c848313193`, "feat: add @endo/http-confine core and @endo/exo-http-client capability") — **MERGED 2026-07-08**.
- The design doc's own Status section already reflects this: "The `HttpClient` / `HttpClientControl` capability shape specified here is realized" by `@endo/http-confine` + `@endo/exo-http-client`.

I verified the four required behaviors are present and tested, not just stubbed:

- **Structural origin allowlist** — `packages/http-confine/src/http-confine.js` parses and exact-matches origin before any transport; exo control exposes `setAllowedOrigins`/`allowedOrigins()`. Tests: `checkOriginAllowed enforces exact origin matches`, `fetch rejects URLs whose origin is not allowed before touching transport`, `origin configuration rejects non-http schemes and path-bearing entries`.
- **Per-minute request cap** — `makeRateLimiter` (injected clock), `setMaxRequestsPerMinute`. Tests: `rate limiting enforces a per-minute request cap`, `policy-denied requests do not consume the rate budget`.
- **Max-response-bytes truncation** — `limitResponseBytes` truncates at read time over a stream reader, cancels on exact fill, rejects non-streaming bodies; `setMaxResponseBytes`. Tests: `response bodies are truncated to maxResponseBytes`, `response truncation cancels when a chunk exactly fills maxResponseBytes`, `non-streaming responses are rejected instead of buffered without bound`.
- **`revoke()`** — sets a revoked flag, cancels in-flight reads with a `RevokedError`. Tests: `control can replace origins, adjust limits, and revoke`, `revoke rejects while response body read is pending`.

The implementation also goes beyond the four asks (method allowlist, CRLF/header-injection guards, redirect confinement, and the trust-on-first-bind policy adapter), all with dedicated tests (~33 tests across the two packages). It passed CI on the way to merge.

**What I changed:** nothing — no commits, no new PR. Opening one would duplicate merged work.

**Follow-ups (out of this job's scope, already tracked):** the design's *remaining* item is the daemon-side wiring — `provideHttpClient` provisioning and the `makeHttpTool` agent-tool binding — tracked as the Network (HTTP) tier (Phase 3.6) in `designs/daemon-agent-tools.md`. That is a separate capability-exposure job, not the capability-pair build this job named.
