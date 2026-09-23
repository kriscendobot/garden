---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-14T06:43:34Z
---
role: scholar
job: scholar-ai-sdk-research
project: endo

# Result: Vercel AI SDK research curated for the AI-SDK-vs-pi design

Wore the scholar role for job `scholar-ai-sdk-research`: researched
https://ai-sdk.dev/ and its primary documentation across the seven named axes
(architecture, agent/tool abstractions, model-provider support, streaming,
structured output, operational requirements, integration constraints) and
curated the findings as project-tree growth under the endo project, framed as
input for a subsequent design comparing the AI SDK with pi.

## Written (project-tree growth, not library ingestion)

- `projects/endo/ai-sdk-research.md` (new topic file). Sections: architecture
  (Core / UI / Harnesses surfaces + the open language-model provider spec),
  agent and harness abstractions (`ToolLoopAgent` with `runtimeContext`/
  `toolsContext`/`stopWhen`/`prepareStep`; the `tool()` helper and tool-call
  lifecycle; `HarnessAgent` with the adapter table and bridge-backed vs
  host-runtime split), model-provider support (24+ official + 30+ community,
  registry, OpenAI-compatible, gateway, embeddings/audio/image), streaming
  (`streamText` textStream/fullStream, stream parts, data-stream protocol),
  structured output (`generateObject`/`streamObject`, the `Output.*` strategies,
  Zod/Valibot/JSON schema, `AI_NoObjectGeneratedError`), operational
  requirements (mandatory stateful harness sessions and their lifecycle,
  sandbox providers, env credentials, module-scope agents), integration
  constraints through an Endo/hardened-JS lens, two comparison hooks, an
  actionable-references table (AI SDK docs + pi-side sources), and designer
  follow-ups.
- `projects/endo/README.md` (index update): added the `ai-sdk-research.md` row
  under `## Per-topic detail`, replacing the "(None yet)" placeholder. Landed on
  the current `origin/journal2` tip so no sibling row was dropped.

Both landed through `land-journal-edit.sh` (isolated producer clone, sync + CAS).

## Key finding for the design

"pi" is two distinct layers, and the AI SDK meets each at a different seam:
- `@mariozechner/pi-ai` (`badlogic/pi-mono`, `packages/ai`): the multi-provider
  registry endopi builds on (genie already depends on it). Competes with the AI
  SDK's provider spec.
- `@earendil-works/pi-coding-agent`: the coding-agent harness that the AI SDK's
  `@ai-sdk/harness-pi` adapter *wraps* (not competes with). This opens a third
  option beyond AI-SDK-vs-pi: expose Endo/Lal as a `HarnessV1` adapter.
The pivotal capability difference to verify: whether the AI SDK provider spec
offers a subscription-OAuth path comparable to pi-ai's `oauth.ts` (the
highest-leverage endopi milestone item).

## Provenance / caveats

Web-summarized (small model) from ai-sdk.dev + the Vercel changelog, read
2026-07-14; APIs describe AI SDK 7, whose harness layer is explicitly
experimental. Exact identifiers flagged in the doc as confirm-against-source
before a build commits to a signature.

## Integrity

Project-tree growth, so the library section/source integrity gate and the
sections/topics regenerators do not apply (no `library/` files written). Verified
every relative link in the new topic file resolves against the `origin/journal2`
tip (drafts/endopi*, drafts/README, roles/skills). Inbox drained (empty). No
follow-on jobs posted: the ask was a single faithful research pass and it is
complete; the design itself is the maintainer's next step, not a scholar job.

## Follow-ups (for the designer, not scholar work)

- Confirm AI SDK 7 API identifiers against source before committing to signatures.
- Resolve the subscription-OAuth parity question (AI SDK provider spec vs
  pi-ai `oauth.ts`).
- Decide comparison scope: provider seam, harness seam, or both.

Self-improvement: no structural lesson to route. This was an external-web
research-and-curate cycle rather than an upstream-repo library ingest; the
scholar procedure's project-tree-growth path (step 5) plus `land-journal-edit.sh`
covered it cleanly, and the library integrity gates correctly did not apply. One
minor observation worth a mentor's eye only if it recurs: the conventions file
names a future `source_kind: standards-doc`/`web-page` variant that does not yet
exist, so an external doc-site like ai-sdk.dev has no clean *library* home today;
routing it to project-tree growth was the right call here, but a recurring need
would justify adding that source-kind. Not routed now (single occurrence).
