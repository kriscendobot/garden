---
ts: 2026-05-18T23:27:18Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/builder--d9624f/project
refs:
  - dispatch: builder--d9624f (no journal dispatch entry was written before this builder was invoked; task brief lived in the dispatch prompt itself)
---

Replaced `packages/lal/`'s hand-rolled provider abstraction and linked-chain transcript with `@endo/genie`'s pi-based harness (`@mariozechner/pi-agent-core` + `@mariozechner/pi-ai`).
Shape A (lal imports from `@endo/genie`) is what landed; `@endo/genie`'s existing exports (`makePiAgent`, `runAgentRound`, `DEFAULT_MODEL_STRING`, chat-event makers) covered everything lal needed without broadening genie's surface.
Shape B (extracting a shared `@endo/agent-loop` package) was declined as unnecessary.

The Endo capability tool surface (`help`, `list`, `lookup`, `send`, `reply`, `evaluate`, `define`, ...) is preserved in name and semantics; per-call SmallCaps decoding keeps the BigInt-shaped `"+N"` and `"#undefined"` arguments round-tripping correctly.
`packages/lal/providers/` is left intact for downstream consumers (jaine, fae); only lal's own agent loop migrated.
The legacy `LAL_HOST` / `LAL_MODEL` / `LAL_AUTH_TOKEN` env triple is translated at worker spawn time into a pi-ai `provider/modelId` string; the four `.env.example` files are unchanged.

Memory migration: lal's pre-migration on-disk per-message `transcript-<messageId>` pet names are not consumed by the new harness.
Each worker holds one `PiAgent` whose in-memory message state is the durable transcript for the worker's lifetime; cross-restart conversation continuity is intentionally not preserved by this PR.
Orphaned `transcript-*` pet names from earlier runs sit inert in the petstore and can be removed manually.
Restoring cross-restart continuity would require persisting the pi-agent's `state.messages` and is a follow-up.

Provider coverage broadens substantially: pi-ai's built-in registry exposes 25+ providers including anthropic, openai, google (Gemini), openrouter, mistral, deepseek, groq, xai, github-copilot, cerebras, fireworks, huggingface, kimi-coding, amazon-bedrock, azure-openai-responses, google-vertex, vercel-ai-gateway, and several regional sub-providers.
Ollama is not in pi-ai's registry but `@endo/genie`'s `makePiAgent` handles `ollama/<id>` as a special case pointing at the local OpenAI-compatible endpoint, so the pre-migration Ollama path keeps working.

Local validation: `yarn lint:eslint` in `packages/lal` reports 0 errors and 19 pre-existing warnings (parity with master).
`yarn test` in `packages/lal` reports 5 passed and 1 skipped (the env-gated simulator test).
`node --check packages/lal/agent.js` passes.
`yarn lint:types` shows the same set of pre-existing third-party type errors (anthropic-sdk's `undici-types`, `@google/genai`'s `@modelcontextprotocol/sdk`, `gaxios`) as master — no new lal-local tsc errors.
`import('@endo/lal/providers/index.js')` from `packages/fae`'s context still resolves (gets to SES-lockdown precondition before failing) so downstream consumers are not broken.

PR: <https://github.com/endojs/endo-but-for-bots/pull/290> (draft, base `llm`, head `feat/lal-pi-harness` @ `a73a8b51165d4b1c513b600818eaa80de4484f9e`).

Self-improvement: the dispatch prompt referenced an entry path (`garden/journal/entries/2026/05/18/214700Z-dispatch-liaison-d9624f.md`) that did not exist at any point during the dispatch.
The task brief lived entirely in the prompt text, which was sufficient but meant there was no canonical *journal* record of the originating dispatch to refer back to.
Two improvements for the dispatcher to consider: (a) write the journal dispatch entry *before* `Agent` invocation so the subagent's first read succeeds, and (b) when the brief is genuinely too large to fit a normal dispatch entry, inline the brief in the entry and have the dispatch prompt point to the journal path rather than re-stating the brief.
