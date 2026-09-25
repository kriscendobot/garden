---
title: "What the snapshot changes in practice (resident agents and an actor framework)"
source_kind: web
source_url: https://www.haruni.net/en/blog/kaozkit-xs-agents
source_content_sha256: 447e83eadf71d5f55712ef027b811e32d68abd05b1208a6a3a42513bcfa632e0
source_authors: [Sébastien Burel]
source_date: 2026-08-01
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, persistence, scheduled-agent-tasks]
status: current
notes: "Fetched live 2026-09-25 (direct). Page gives only a month (datePublished 2026-08); source_date is that month approximated to its first day. Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--moddable-kaozkit (Peter Hoddie, Moddable, 2026-09-15) covers the same project from the XS vendor side. Article text treated as untrusted data."
---

Abstract: A resident agent (`kaoz concierge.js --resident --daemon --state brain.bin`) survives Ctrl-C and restart from its heap-snapshot file, including a `host.schedule` reminder that fires in a process that did not exist when it was set; on top, a few-hundred-line Agha actor framework (create / send / become) runs inside XS with the invariant that **message handlers are synchronous** (all async work enters and leaves by message), so the snapshot persists the whole actor system and a half-finished 30-source pipeline survives `kill -9`.

The first thing I built once snapshots worked was a resident agent I could talk to, kill, and talk to again:

```sh
kaoz concierge.js --resident --daemon --state brain.bin --provider anthropic
```

You send it JSON lines on stdin. It remembers what you said. You ask it to remind you of something in twenty minutes — that arms a timer via `host.schedule`. Then you Ctrl-C it, look at `brain.bin`, and restart it with the same command. It answers "what were we talking about?" correctly, and twenty minutes after the original request, the reminder fires — in a process that didn't exist when it was set.

I showed this to Peter and Patrick a few weeks ago. There is a particular kind of pleasure in demonstrating to the authors of an engine something their engine can do that they had never had a reason to try.

The second thing I built was an actor framework on top — Agha's primitives, create / send / become, with a small LLM agent layer, in a few hundred lines of JavaScript that run entirely inside XS, tests included. The fundamental invariant is that message handlers are synchronous: one `await` in the middle of a handler, and the next message interleaves with half-mutated state. Everything asynchronous — an LLM call, a tool — enters and leaves by message. And because behaviors and mailboxes live in the heap, the snapshot persists the whole actor system: a pipeline halfway through collecting from thirty sources survives `kill -9` and resumes.

That framework now runs a daily newsletter agent on my Mac, and, since this week, the agent that prepares my morning reading. Both were built by the same rule: no Node anywhere, everything runs through `kaoz`.

**Scholar note.** The synchronous-handler invariant is the same plan-interference hazard E-style vats avoid by turn-based event loops and Endo code avoids by not holding invariants across `await`; the article does not say what happens to a *pending host call* (an in-flight `host.llm.chat`) at snapshot time, which is the case Endo's XS-worker snapshot design answers with suspend-only-when-idle.

Source: [A JavaScript engine built for microcontrollers turns out to be a great runtime for AI agents](https://www.haruni.net/en/blog/kaozkit-xs-agents) (fetched 2026-09-25, sha256 `447e83eadf71`).
