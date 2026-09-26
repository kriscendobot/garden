I've completed the investigation and surfaced the finding. Here is my report.

---

**Job:** `build-endo-but-for-bots-endoclaw-network-fetch` (builder — EndoClaw confined-outbound-HTTP, M3)

**Outcome: no PR opened — a complete duplicate already exists.** Per the builder skip-and-surface-on-duplicate norm, I did not open a competing PR.

**What I did:**
- Read the design (`designs/endoclaw-network-fetch.md` on `origin/llm`) and its parent `endoclaw.md`; confirmed `endoclaw-network-fetch` is an M3 (Remote Access & Tools) row and the clause is "confined outbound HTTP."
- Established the model and base branch: the endoclaw capability-exo family (`exo-playwright`, `exo-git`, `agent-tools`) lives **only on `llm`** (`packages/exo` is the sole `exo-*` on master), so this work belongs on the `llm` roadmap branch. `exo-playwright` (the sibling `endoclaw-browser` build) is the direct structural precedent.
- Pre-flight duplicate check (builder norm): found **endojs/endo-but-for-bots#566** — "feat(exo-http-client): add confined HttpClient" (DRAFT, base `llm`, author **0xpatrickbot**).

**Why #566 satisfies the job (verified against the fetched branch, not just its description):**
- `@endo/exo-http-client` / `makeHttpClientAndControl` → `HttpClient` + `HttpClientControl` exo pair under `M.interface` guards.
- **Structural exact-origin allowlist** (`allowedOrigins`, `validateOrigin`; guest cannot construct an escaping URL).
- **Per-minute rate limits** (`maxRequestsPerMinute` / `setMaxRequestsPerMinute` + `enforceRateLimit`).
- **Max-response-byte caps** (`maxResponseBytes` / `setMaxResponseBytes`, streaming read cancels at the cap).
- Revocation (client + per-binding), plus an opt-in trust-on-first-bind layer beyond the design.
- **All CI checks green**; it passed a code panel and the author addressed every semantic blocker in commit 18a31773 (2026-06-29).

**What I did not do (and why):** I did not open a competing PR (would waste effort and collide on the same package/design landing on `llm`), and I did not comment on or push to #566 — 0xpatrickbot is a mention-only PR author, so absent an @-mention their PR is off-limits.

**Surfaced:** messaged the maintainer (via the liaison inbox, `20260706T040517Z-72bbd0`) with the above, offering to either shepherd #566 toward merge (it's still draft) or build a garden-owned implementation if they'd prefer one.

**Follow-ups for the maintainer to decide:** whether to review/un-draft/merge #566, or to have the garden own its own `exo-http` implementation. No garden artifact requires cleanup — no project worktree, branch, or PR was created.
