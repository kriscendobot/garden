Done. Completion report follows.

---

**Job `finbot-llm-role-dispatch` — complete.** Pushed to `kriscendobot/finbot` `main` (`c3d304b..8d61e8a`).

## What I did
Connected the harness's stub-LLM injection point to a real provider and built an inference-driven OODA role dispatch where a reasoning subagent calls the deterministic pipeline functions as tools — the "automation born from inference" blend the design asks for.

**Real provider behind the `llm` hook** (`@finbot/harness/providers`)
- `makeAnthropicLlm()` — a `fetch`-based Anthropic provider (`claude-opus-4-8`, `POST /v1/messages`), self-contained so `@finbot/harness` keeps its zero-dependency stance. Pure `toAnthropicMessages` / `toAnthropicToolList` / `fromAnthropicResponse` translators, exported and unit-tested.
- The deterministic **stub stays the default** (`spawn` falls back to it), so all tests remain offline. Thinking is disabled by default because the harness's lossy `{text|toolCall}` message model can't round-trip thinking-block signatures across tool-use turns — documented in the module with the path to flip it on once raw provider blocks are preserved.

**Deterministic pipeline functions as tools** (`@finbot/pipeline/agent-tools`)
- `pipelineToolRegistry()` wraps the orient-phase scorers — `score_opportunities` (= `analyze`), `realized_volatility`, `observe_opportunities` — as harness tools. Same functions `runOodaCycle` calls; single source of truth.

**Inference-driven role dispatch** (`@finbot/pipeline/role-dispatch`)
- `dispatchAnalyzer()` spawns the analyzer over an oracle-watcher observation; it reasons over the opportunities and **calls `score_opportunities` as a tool**; the scored `AnalyzerResult` is extracted from the tool-execution events. `makeScriptedAnalyzerLlm()` is the offline deterministic double.
- `bin/finbot-dispatch` drives the **ORIENT stage end-to-end in dry-run** — offline by default, `--live-llm` for real inference. Read-only; no wallet capability is reachable from the analyzer's tool subset.

## Verification
- 22 new tests (12 provider, 5 agent-tools, 5 role-dispatch); **full suite 356 pass / 0 fail offline.**
- `node bin/finbot-dispatch --seed=7` → analyzer subagent completes, calls `score_opportunities`, emits `propose-rebalance`. `finbot-ooda` unaffected.

## Changed / new
`packages/harness/providers/{anthropic,index}.js`, `harness/{index.js,package.json}`, `harness/test/providers-anthropic.test.js`; `pipeline/{agent-tools,role-dispatch,index.js,package.json}`, `pipeline/test/{agent-tools,role-dispatch}.test.js`; `bin/finbot-dispatch`, root `package.json`, `README.md`.

## Follow-ups
- **SES attenuator wiring deferred** (job's Build item 2) — it depends on `finbot-ses-compartments`, which isn't landed. The permissive v0 attenuator still confines the analyzer's tool subset (the dispatch never exposes a wallet); flipping `spawn`'s attenuator to `@endo/compartment-mapper` is the next step and is already tracked by that job.
- Only the analyzer/ORIENT dispatch is built; the same pattern extends to forecaster/planner/auditor when wanted.
- A live end-to-end smoke test against the real Anthropic API wasn't run (no key in this environment); the provider is covered by injected-`fetch` unit tests.
