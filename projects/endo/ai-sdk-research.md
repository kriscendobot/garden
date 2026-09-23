---
created: 2026-07-14
updated: 2026-07-14
author: scholar
---

# Vercel AI SDK: architecture research for an AI-SDK-vs-pi design

Curated research on the Vercel AI SDK ([ai-sdk.dev](https://ai-sdk.dev/)) as
design input for a subsequent garden design comparing the AI SDK with **pi**.
It covers the seven axes the research ask named (architecture, agent/tool
abstractions, model-provider support, streaming, structured output, operational
requirements, integration constraints) and, at the end, the actionable
reference table and the comparison hooks a designer needs.

**Read the disambiguation first.** "pi" names two distinct layers of the same
Mario Zechner (`badlogic`) ecosystem, and this project already engages both.
The design must say which one it compares against, because the AI SDK meets each
at a different seam:

- **`@mariozechner/pi-ai`** (repo `badlogic/pi-mono`, `packages/ai`): a
  multi-provider LLM *API/registry* library (30+ providers, subscription OAuth,
  cross-provider handoff). This is the "pi" the endopi provider-registry design
  references; `packages/genie` already depends on it directly, so Endo/Lal ships
  a working consumer of pi-ai's registry today. See
  [drafts/endopi-provider-registry-and-oauth.md](drafts/endopi-provider-registry-and-oauth.md).
- **`@earendil-works/pi-coding-agent`**: the Pi *coding-agent harness* runtime
  (built-in `read`/`write`/`edit`/`bash`/`grep`/`glob`/`ls` tools, native
  sessions). This is what the AI SDK's `@ai-sdk/harness-pi` adapter wraps. It is
  a full harness, one layer above the provider registry.

So there are two comparison seams, developed in § Comparison hooks below:
the AI SDK's **provider abstraction** competes with pi-ai's **registry**, and
the AI SDK's **harness layer** (`HarnessAgent`) can already *wrap* the Pi
coding-agent harness rather than compete with it.

## Provenance and caveats

- Primary source is the live [ai-sdk.dev](https://ai-sdk.dev/) documentation and
  the Vercel changelog, read 2026-07-14. The named APIs describe **AI SDK 7**.
  The harness layer is explicitly labelled **experimental** ("expect breaking
  changes between releases").
- These findings were summarized from fetched pages by a small model. Exact
  identifiers (option names, default values, package names) are reliable enough
  to plan a design around but should be confirmed against the source pages (or
  the `vercel/ai` repo) before any build commits to a specific signature.
- This is curation, not endorsement: the garden has not vendored or run the AI
  SDK. Treat capability claims as documented-behavior, not garden-verified.

## Architecture

The AI SDK is a TypeScript toolkit that standardizes LLM integration so
application code is written once and the provider or model is swapped by
configuration. It is organized into three surfaces on top of a provider
specification.

- **AI SDK Core**: the backend-facing, framework-agnostic layer. Unified
  functions for text generation (`generateText`, `streamText`), structured
  output (`generateObject`, `streamObject`), embeddings (`embed`), tool calling,
  and agent construction (`ToolLoopAgent`).
- **AI SDK UI**: framework-agnostic hooks for chat and generative UIs
  (`useChat` and kin), targeting React, Next.js, Vue, Svelte, Nuxt, Expo, and
  TanStack Start. Consumes the Core layer's streams over an HTTP data-stream
  protocol.
- **AI SDK Harnesses** (new in v7, experimental): a uniform API
  (`HarnessAgent`) over complete external agent runtimes (Claude Code, Codex,
  Pi). See § Agent and harness abstractions.

Underneath all three is a **language-model specification**: an open-source
package defining the standardized `LanguageModel` interface that every provider
package implements. This spec is the abstraction boundary that lets one call
site target any provider. It is published so third parties can author custom
providers.

Targeted runtimes span frontend (React, Vue, Svelte) and backend (Node.js,
edge). The Core layer runs server-side; the harness sandboxes assume a Node
runtime (the Vercel sandbox provider names Node 24).

## Agent and harness abstractions

The AI SDK offers three ascending levels of agent control.

1. **Raw loop control via Core functions.** `generateText` / `streamText` with
   `tools` and `stopWhen` give explicit, per-step control. Recommended "when you
   need explicit control over each step for complex structured workflows."
2. **`ToolLoopAgent`** (the primary agent class). Defined around the thesis that
   an agent is "an LLM that uses tools in a loop." Construction and run:

   ```js
   const agent = new ToolLoopAgent({ model: 'provider/model-name', tools: { /* ... */ } });
   const result = await agent.generate({ prompt: 'your task here' });
   // result.text (final answer), result.steps (execution history)
   ```

   It manages the tool-call loop, message array, and stopping conditions so the
   caller does not hand-roll them. State flows through two typed channels:
   `runtimeContext` (shared agent state visible in `prepareStep` and lifecycle
   hooks: tenant settings, credentials, task progress) and `toolsContext`
   (per-tool typed values, each tool receiving only its own context per its
   `contextSchema`). Loop control is via `stopWhen` and `prepareStep`; step
   boundaries surface through a `steps` array and `onStepEnd`/`onStepFinish`
   hooks.
3. **`HarnessAgent`** (harness layer, experimental). Wraps a complete external
   agent runtime and projects its output into AI SDK stream and response types,
   so `HarnessAgent.generate()` returns a standard `GenerateTextResult`
   (`result.text`, `result.steps`, `result.usage`) and its `stream()` yields AI
   SDK stream parts compatible with `useChat`.

### The tool abstraction

Tools are created with the `tool()` helper (which secures type inference):

- **`description`**: string or function influencing tool selection.
- **`inputSchema`**: a Zod schema or JSON schema. Used both to advertise the
  tool to the model and to validate model-generated inputs.
- **`execute`**: optional async function over validated inputs. Optional because
  a call can instead be forwarded to a client or queue.
- **`strict`**: opt into provider-supported strict tool calling.

Runtime shapes: a `tool-call` part carries `toolCallId`, `toolName`, `input`; a
`tool-result` part carries the output; a `tool-error` part surfaces failures back
to the model. Multi-step calling is governed by `stopWhen`, whose built-in
conditions include `isStepCount(count)` (default 20), `hasToolCall(...names)`,
and `isLoopFinished()`. `toolChoice` takes `auto` (default), `required`, `none`,
or `{ type: 'tool', toolName }`. `dynamicTool()` handles runtime-loaded or
schema-less tools (for example MCP tools). `toolApproval` gates execution behind
`tool-approval-request` / `tool-approval-response` parts. Tools may yield an
`AsyncIterable` for preliminary/streaming results (last value wins), and input
streaming exposes `onInputStart` / `onInputDelta` / `onInputAvailable`.

### The harness abstraction

A **harness** is "a complete agent runtime" that owns capabilities larger than a
model call: workspace filesystem/process access, native built-in tools, native
session state, compaction, permission flows, sub-agents, skills, and a sandbox.
`HarnessAgent` normalizes these through four components: the **HarnessAgent** API
surface, a per-runtime **harness adapter**, a **sandbox provider**, and a
**session**.

Adapters and the SDKs they wrap:

| Adapter package | Wraps | Mode |
|---|---|---|
| `@ai-sdk/harness-claude-code` | `@anthropic-ai/claude-agent-sdk` | bridge-backed |
| `@ai-sdk/harness-codex` | `@openai/codex-sdk` | bridge-backed |
| `@ai-sdk/harness-pi` | `@earendil-works/pi-coding-agent` | host-runtime |
| `@ai-sdk/harness-deepagents` | (unspecified) | (unspecified) |
| `@ai-sdk/harness-opencode` | (unspecified) | (unspecified) |

`HarnessAgent` constructor options: `harness` (the adapter instance),
`sandbox` (a `HarnessV1SandboxProvider`), `id`, `instructions` (applied once to
fresh sessions), `tools` (host-executed AI SDK tools the harness may invoke),
`activeTools` / `inactiveTools` (allow/deny lists over built-in and host tools),
`skills` (instruction bundles), `permissionMode`, `toolApproval`,
`sandboxConfig` (working dir and lifecycle hooks), and `telemetry` / `debug` /
`onLog`. Adapter-specific options (Pi's `model`, `thinkingLevel`, `auth`) live on
the adapter factory (for example `createPi({ ... })`), not the agent.

The pitch: "AI SDK has always let you switch models without rewriting your
agent. Now you can switch the harness the same way."

## Model-provider support

- **Scale.** 24+ official providers under the `@ai-sdk/{provider}` package
  pattern (OpenAI, Anthropic, Google + Vertex, Mistral, xAI Grok, Azure, Amazon
  Bedrock, Groq, Cohere, DeepSeek, Cerebras, Perplexity, Fireworks, DeepInfra,
  Together.ai, plus audio/voice providers ElevenLabs, Deepgram, AssemblyAI and
  others), and 30+ community providers (Ollama, OpenRouter, Cloudflare Workers
  AI, Portkey, Mem0, and more).
- **Uniform interface.** Every provider package implements the language-model
  spec, so models are addressed by consistent IDs (for example `provider/model`,
  `gpt-5.4`, `claude-sonnet-5`) and swapped without restructuring call sites.
- **Registry and custom providers.** A provider registry plus a `provider()`
  factory register and namespace models; the open-source spec lets teams author
  custom providers.
- **OpenAI-compatible and self-hosted.** Dedicated compatibility support covers
  any OpenAI-API-shaped endpoint (LM Studio, Heroku, Ollama, Baseten,
  self-hosted).
- **Gateway.** AI Gateway / Vercel AI Gateway is a supported front, and the Pi
  adapter defaults to gateway credentials (`AI_GATEWAY_API_KEY` /
  `VERCEL_OIDC_TOKEN`).
- **Beyond text.** The spec also spans embedding models, and audio/image
  providers, so the provider surface is wider than chat completion alone.

## Streaming

- **Text.** `streamText` returns a `textStream` (async-iterable text deltas) and
  a richer `fullStream` of typed parts. Contrast with the blocking
  `generateText`, which returns only after the whole response.
- **Stream parts.** Parts are typed events (for example `text-delta` with
  incremental `text`, plus tool-call/tool-result/step events), consumed via
  `for await`. Long generations (documented as 5 to 40 seconds) become
  progressively rendered instead of a spinner.
- **Structured streaming.** `streamObject` streams partial objects; array output
  exposes `partialOutputStream` (whole partial array, including incomplete
  elements) and `elementStream` (each emitted element complete and
  schema-validated).
- **Transport.** The UI layer consumes these over an HTTP data-stream protocol
  (SSE-style) wired to `useChat` and kin. The harness layer projects harness
  output into the same stream types, so `stream()` parts feed `useChat`
  unchanged.

## Structured output

- **Dedicated functions.** `generateObject` and `streamObject` produce
  schema-validated objects, and `generateText` / `streamText` accept an `output`
  (the `Output` object) to fold structured output into a tool-loop turn.
- **Output strategies.** `Output.object()` (schema-validated object),
  `Output.array()` (typed elements, with `elementStream`), `Output.choice()`
  (classification over a fixed set of strings), `Output.text()` (plain text), and
  `Output.json()` (unstructured JSON, no schema).
- **Schema systems.** Zod (primary), Valibot, and raw JSON Schema.
- **Validation and failure.** Generated data is validated automatically; a
  failure throws `AI_NoObjectGeneratedError` carrying the generated text,
  response metadata, token usage, and underlying cause.
- **Loop interaction.** Structured output "counts as a step" in the multi-step
  model, so `stopWhen` budgets must account for it alongside tool calls.

## Operational requirements

- **Core.** Provider API keys via environment variables; a Node or edge runtime;
  a schema library (Zod) for tools and structured output. Application agents are
  constructed at **module scope** (they hold configuration, not live state).
- **Harness sessions are mandatory and stateful.** A session owns the harness
  runtime, sandbox, working directory, native conversation history, and pending
  approvals. Lifecycle: `agent.createSession({ sessionId, resumeFrom })`, then
  exactly one of `destroy()` (discard resumability), `detach()` (park, keep
  sandbox warm, return resume state), `stop()` (persist resume state, stop
  runtime and sandbox), or `suspendTurn()` (cross-process hand-off). Resumption
  uses `sessionId` / `resumeFrom` / `continueFrom` with `continueStream()` /
  `continueGenerate()`. Because the session owns history, callers send only the
  latest user message, not the full transcript, and persist/resume across HTTP
  turns instead of replaying.
- **Sandboxes.** Every harness runs in a sandbox. Bridge-backed adapters (Claude
  Code, Codex) execute in an isolated sandbox and talk over a WebSocket bridge,
  so they need a real network sandbox (`@ai-sdk/sandbox-vercel`, Node 24).
  Host-runtime adapters (Pi) run in the host Node process, treat the sandbox as a
  remote filesystem/shell, and can use a lighter sandbox
  (`@ai-sdk/sandbox-just-bash`). Sandbox and harness credentials come from the
  environment. Template reuse is via `prepareHarnessSandboxTemplate()` /
  `prepareSandboxForHarness()` with `sandboxConfig.onBootstrap` (plus a
  `bootstrapHash` to invalidate snapshots) and `sandboxConfig.onSession`.

## Integration constraints (Endo / hardened-JS lens)

Points a design must weigh when placing the AI SDK next to Endo/Lal/pi-ai. These
are analysis, not verified findings.

- **TypeScript-first and dependency-heavy.** Core assumes Zod-style schemas,
  streaming primitives, and provider packages. Endo's SES/hardened-JS surface and
  attenuation discipline would need the whole dependency closure vetted for
  lockdown compatibility, the same bar the endopi work applies to pi-ai (which
  genie already vendors and runs).
- **Harness sandbox model vs the compartment model.** The harness layer's safety
  story is process/OS sandboxes (Vercel Sandbox, just-bash), orthogonal to
  Endo's compartment and ocap attenuation. A design should not read "sandbox" as
  Endo-equivalent isolation; they are different trust boundaries.
- **Experimental harness API.** The harness layer warns of breaking changes.
  Building Endo integration on it now is a moving target; the stable seam is Core
  (provider spec + `ToolLoopAgent`).
- **Gateway assumption.** Pi-through-AI-SDK defaults to Vercel AI Gateway
  credentials. Endo's provider story (endopi) deliberately keeps gateways as
  optional registered providers, not owned infrastructure (see
  [drafts/endopi-provider-registry-and-oauth.md](drafts/endopi-provider-registry-and-oauth.md)
  § Out of scope). A comparison should hold that boundary.
- **Subscription OAuth.** pi-ai ships OAuth scaffolding for subscription
  providers (Claude subscription, ChatGPT Plus/Codex, GitHub Copilot), the
  highest-leverage capability the endopi milestone targets. The AI SDK's provider
  spec centers on API-key and gateway auth; whether its provider surface exposes
  an equivalent subscription-OAuth path is the open question to verify against the
  source, not assume.

## Comparison hooks (for the design)

Two seams, matching the two senses of pi in the disambiguation above.

1. **Provider-abstraction seam: AI SDK language-model spec + `@ai-sdk/*` vs
   `@mariozechner/pi-ai` registry.**
   - Both give one call site over many providers. AI SDK is broader (embeddings,
     audio, image; 24+ official + 30+ community providers; an open custom-provider
     spec). pi-ai centers on chat providers plus the subscription-OAuth and
     cross-provider-handoff capabilities endopi wants.
   - Endo/Lal/Genie already depend on pi-ai, so the design question is
     consolidate-onto-pi-ai vs adopt-AI-SDK-Core vs keep-both. Cross-reference the
     Lal-vs-Genie consolidation question already open in
     [drafts/endopi-provider-registry-and-oauth.md](drafts/endopi-provider-registry-and-oauth.md).
   - Verify against source: does the AI SDK provider spec offer a
     subscription-OAuth path comparable to pi-ai's `oauth.ts`? If not, that is a
     concrete pi-ai advantage for the endopi milestone.

2. **Agent/harness seam: AI SDK `HarnessAgent` (which already wraps
   `@earendil-works/pi-coding-agent`) vs building on Endo's own agent surface.**
   - The AI SDK does not compete with the Pi harness here; it *adapts* it. So a
     third option appears: rather than choosing between AI SDK and Pi, Endo could
     be exposed as an AI SDK harness adapter (a `HarnessV1` implementation), or
     consume `HarnessAgent` to run Pi/Claude Code/Codex under one surface.
   - The harness abstraction's ownership list (sessions, compaction, permission
     flows, skills, sub-agents) maps onto Endo concerns the endopi siblings
     already design (transcript format, iterative compaction, skills markdown,
     prompt templates). A design can use the AI SDK harness contract as a
     checklist of capabilities to match or expose. See the endopi sibling drafts
     linked from [drafts/README.md](drafts/README.md).

## Actionable references

Canonical AI SDK documentation and sources to pull into the design.

| Topic | URL |
|---|---|
| Introduction / architecture | https://ai-sdk.dev/docs/introduction |
| Foundations: overview | https://ai-sdk.dev/docs/foundations/overview |
| Foundations: providers and models | https://ai-sdk.dev/docs/foundations/providers-and-models |
| Foundations: streaming | https://ai-sdk.dev/docs/foundations/streaming |
| Agents: overview (`ToolLoopAgent`) | https://ai-sdk.dev/docs/agents/overview |
| Core: tools and tool calling | https://ai-sdk.dev/docs/ai-sdk-core/tools-and-tool-calling |
| Core: generating structured data | https://ai-sdk.dev/docs/ai-sdk-core/generating-structured-data |
| Harnesses: overview | https://ai-sdk.dev/docs/ai-sdk-harnesses/overview |
| Harnesses: `HarnessAgent` API | https://ai-sdk.dev/docs/ai-sdk-harnesses/harness-agent |
| Harnesses: Pi adapter | https://ai-sdk.dev/providers/ai-sdk-harnesses/pi |
| Harnesses: Claude Code adapter | https://ai-sdk.dev/providers/ai-sdk-harnesses/claude-code |
| Changelog: program agent harnesses | https://vercel.com/changelog/program-agent-harnesses-with-ai-sdk |
| Source repo | https://github.com/vercel/ai |
| DeepWiki: harness adapters | https://deepwiki.com/vercel/ai/5.2-harness-adapters-(claude-code-codex-pi-deepagents-opencode) |

Pi-side references (for the other half of the comparison), from the endopi work:

| Topic | URL |
|---|---|
| pi-ai README (`badlogic/pi-mono`) | https://github.com/badlogic/pi-mono/blob/main/packages/ai/README.md |
| pi-ai provider registry | https://github.com/badlogic/pi-mono/blob/main/packages/ai/src/api-registry.ts |
| pi-ai OAuth | https://github.com/badlogic/pi-mono/blob/main/packages/ai/src/oauth.ts |
| pi-ai models | https://github.com/badlogic/pi-mono/blob/main/packages/ai/src/models.ts |
| pi-ai providers (30+) | https://github.com/badlogic/pi-mono/tree/main/packages/ai/src/providers |
| Pi coding-agent (harness the AI SDK wraps) | npm `@earendil-works/pi-coding-agent` (confirm repo/authorship against source) |

## Related garden material

- [drafts/endopi-provider-registry-and-oauth.md](drafts/endopi-provider-registry-and-oauth.md): the endopi multi-provider registry + subscription OAuth design, the direct counterpart on the pi side.
- [drafts/endopi.md](drafts/endopi.md) and siblings: the pi-vs-Endo comparative analysis and gap spin-outs (edit-tool, transcript format, iterative compaction, prompt templates, skills-markdown, stdio-rpc bridge, extension-package manifest).
- [drafts/README.md](drafts/README.md): index and lifecycle for the endopi drafts.

## Follow-ups for the designer

- Confirm the exact AI SDK 7 API identifiers against source before committing a
  build to any signature (this doc is web-summarized).
- Resolve the subscription-OAuth question (does the AI SDK provider spec match
  pi-ai's OAuth path?): the pivotal capability difference for endopi.
- Decide the comparison's scope: provider seam, harness seam, or both. This doc
  argues both are live and that the harness seam admits an "expose Endo as a
  HarnessV1 adapter" option beyond a straight AI-SDK-vs-pi choice.
