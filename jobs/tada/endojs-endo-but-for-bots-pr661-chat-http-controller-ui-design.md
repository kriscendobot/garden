The draft PR is confirmed: #735, draft, based on `llm`. Inbox is empty. The job is complete.

## Completion report

**Job:** Design the Chat UI for HTTP controllers — the HTTP-controller show-value modal as an HTTP client control surface (designer role, from kriskowal's APPROVED review of endojs/endo-but-for-bots#661, review 4701071242).

**What I did**
- Grounded the design in the *current* implementation by reading: the Value modal (`packages/spaces-util/src/value-component.js` — the flip-card front/back-face architecture and its blob/tree front-face specializations), the HTTP capability interfaces (`packages/exo-http-client/src/http-client.js` + `types.ts` — `HttpClient` / `HttpClientControl` / `HttpResponse`, and the `Policy` / `Binding` / `AuditEntry` shapes), and the #661 daemon wiring (`packages/daemon/src/{host,daemon}.js` — `provideHttpClient` / host-only `getHttpClientControl` and the `http-client` formula, read off the PR head branch since #661 isn't merged to `llm` yet).
- Verified a load-bearing finding directly in the daemon source: the `http-client` formula record is `{ type, policy }` with the *provision-time* policy, and reincarnation re-bakes from it — so **live `HttpClientControl` edits are session-scoped and revert on daemon restart**. This became the design's primary open question.
- Wrote `designs/chat-http-controller-ui.md` (slug `chat-http-controller-ui`): problem statement, current-implementation grounding, an explicit **capability/authority boundaries** section (client/control split, host-only control recovery, foreign-client read-only degradation, confinement, the persistence boundary), detection, layout, an enumerated modal-interaction table, an enumerated loading/error-states section, a four-phase plan, design decisions, and four open questions. Two mermaid diagrams (capability-boundary flow + layout), respecting the designer role's mermaid mandate and the project design conventions (metadata table, dependencies table, `## Prompt`). Did **not** implement the UI, per the job.
- Integrated into `designs/README.md`: summary-table row, M9 (UX & Tooling) milestone-table row + count bump, dependency-graph node/edge, totals line, and a Recently-added blurb.

**Verification (real-execution evidence)**
- Mermaid parse-only validation (skill `mermaid-validation`): design file → `mm-1.mmd OK flowchart-v2`, `mm-2.mmd OK flowchart-v2`; README after my graph edit → `OK flowchart-v2`, `OK gantt`.
- PR state confirmed via `gh pr view 735`: `{"isDraft":true,"baseRefName":"llm","headRefName":"design/chat-http-controller-ui"}`.

**What changed / output**
- Draft design **PR #735** against `llm`: https://github.com/endojs/endo-but-for-bots/pull/735 (branch `design/chat-http-controller-ui`, commit `fa243102a0`), body citing the originating #661 review.

**Follow-ups for the maintainer (open questions in the design)**
1. Should live control edits **persist** across restart? As built they don't. Options: a durable daemon re-bake path (new work, to be filed), a "session-scoped" UI banner, or deferral to `endo-fetch`'s VFS-pinned policy. Recommended interim: the banner + baked-policy back face; Phase 4 gated on the maintainer's choice.
2. Whether to expose `tofu-prompt` / `tofu-attenuator` policy modes (daemon refuses them at provision; no live `policyAuthority` wired).
3. Whether the request composer belongs in the host's own control view (recommended yes — testing-what-you-granted, fully policy-bounded).
4. Detection precision against non-daemon `fetch`+`allowedOrigins` look-alikes (recommended: method-name detect for read-only, gate steering strictly on a resolved `getHttpClientControl`).
