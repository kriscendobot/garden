Job complete. Report follows.

---

**Job `scholar-ai-sdk-research` — completion report**

Wore the scholar role. Researched https://ai-sdk.dev/ and its primary documentation across all seven named axes and curated the findings as project-tree growth under the endo project, framed as input for a subsequent design comparing the AI SDK with pi.

**What I did**
- Fetched and synthesized the authoritative AI SDK docs (introduction, foundations/overview, providers-and-models, streaming; agents/overview; core tools-and-tool-calling and generating-structured-data; the harnesses overview + HarnessAgent + Pi adapter pages) plus the Vercel changelog and DeepWiki adapter table.
- Resolved a crucial ambiguity: **"pi" is two layers.** `@mariozechner/pi-ai` (badlogic/pi-mono, the provider registry endopi builds on and genie already depends on) vs `@earendil-works/pi-coding-agent` (the coding-agent harness the AI SDK's `@ai-sdk/harness-pi` adapter *wraps*, not competes with). The design must say which seam it compares; the harness seam even opens a third option (expose Endo/Lal as an AI SDK `HarnessV1` adapter).

**What changed (landed on `origin/journal2` via `land-journal-edit.sh`)**
- New `projects/endo/ai-sdk-research.md` — full research topic file: architecture (Core/UI/Harnesses + the open language-model provider spec), agent/tool abstractions (`ToolLoopAgent`, `tool()` lifecycle, `stopWhen`/`toolChoice`/`dynamicTool`/`toolApproval`, `HarnessAgent` with the adapter table and bridge-backed-vs-host-runtime split), provider support (24+ official + 30+ community, registry, OpenAI-compatible, gateway, embeddings/audio/image), streaming, structured output (`generateObject`/`streamObject`, `Output.*`, Zod/Valibot/JSON schema), operational requirements (mandatory stateful harness sessions and lifecycle, sandbox providers, env credentials), Endo/hardened-JS integration constraints, two comparison hooks, an actionable-references table, and designer follow-ups.
- `projects/endo/README.md` — added the topic index row under `## Per-topic detail` (based on the journal2 tip, so no sibling row dropped).
- Posted a `result` entry (`entries/2026/07/14/064331Z-result-gardener-178018.md`).

**Verification** — every relative link in the new file resolves against the journal2 tip; inbox drained (empty). Library integrity gates correctly do not apply (project-tree growth wrote no `library/` files).

**Follow-ups** (for the designer, not scholar work): confirm AI SDK 7 API identifiers against source before a build commits to signatures; resolve the subscription-OAuth parity question (AI SDK provider spec vs pi-ai `oauth.ts`, the pivotal endopi capability); decide comparison scope. No follow-on job posted — the ask was a single faithful research pass and it is complete.

**Caveat**: findings are web-summarized (small model) from live docs read 2026-07-14; the APIs describe AI SDK 7 whose harness layer is flagged experimental. This is captured in the doc's provenance note.

Self-improvement: no structural lesson routed (single occurrence). Noted only for a mentor if it recurs: the library conventions reference a not-yet-existing `standards-doc`/`web-page` source kind, so an external doc site has no clean *library* home today; project-tree growth was the right call here.
