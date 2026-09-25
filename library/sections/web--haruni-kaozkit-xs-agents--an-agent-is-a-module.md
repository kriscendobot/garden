---
title: "An agent is a module (the host global as the whole capability surface)"
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, capability-security, llm-agent-frameworks]
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

Abstract: A KaozKit agent is a JS module exporting `run(input)`; its **only** authority is the injected `host` global (`host.llm`, `host.provider(id)`, `host.tool.call`, `host.memory`, `host.schedule`), with no `fetch`, file system, or `require`, API keys resolved on the Swift side and never entering JavaScript, module resolution confined to registered roots, and the model provider (`apple`, `anthropic`, `mlx`) swapped by the host without changing the agent.

Here is a complete KaozKit agent:

```js
// agent.js — runs inside the engine
export async function run(input) {
  const reply = await host.llm.chat(
    [{ role: "user", content: input.question }],
    { tools: ["current_datetime", "web_search"] }   // the model may call these
  );
  await host.memory.save("last question", input.question);
  return { answer: reply };
}
```

A JS module exports `run(input)`. It talks to a language model through `host.llm.chat`, which runs the whole tool-call loop internally — the model asks for a tool, Swift executes it, the model continues — and resolves with the final text. It reads and writes memory. It returns JSON to the host.

```sh
kaoz agent.js --provider apple --input '{"question":"what day is it?"}'
```

With `--provider apple`, this runs on Apple Intelligence — fully on-device, no API key, no network. Swap in `--provider anthropic` or `--provider mlx` and the agent doesn't change; the host does.

The `host` global is the entire capability surface of an agent. There is no `fetch`, no file system, no `require`. An agent can only do what the host explicitly exposes: `host.llm`, `host.provider(id)`, `host.tool.call`, `host.memory`, `host.schedule`. API keys are resolved on the Swift side and never enter JavaScript. Module resolution is confined to registered roots.

**Scholar note (capability reading).** The surface is *one* powerful global rather than separately-passable object references: the tool-call loop runs host-side, and tools are named by string (`tools: ["web_search"]`), so which tools a given agent may reach is a host-configuration decision, not something the agent holds and can attenuate or delegate. That is least-authority confinement at the process boundary, short of the object-capability discipline of passing narrowed references (compare [principle-of-least-authority](../concepts/principle-of-least-authority.md) and [ambient-authority](../concepts/ambient-authority.md)).

Source: [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (fetched 2026-09-25, sha256 `447e83eadf71`).
