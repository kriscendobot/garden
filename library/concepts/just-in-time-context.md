---
id: just-in-time-context
aliases: ["just in time context", "just-in-time retrieval", "JIT context", "lightweight identifiers", "runtime context loading", "agentic search", "load context at runtime", "hybrid retrieval strategy"]
topics: [context-engineering]
---

# just-in-time-context

**Just-in-time context** is the retrieval strategy where, rather than pre-processing all relevant data up front (as in embedding-based pre-inference retrieval), an agent maintains **lightweight identifiers** — file paths, stored queries, web links — and uses tools to **dynamically load data into context at runtime**. It mirrors human cognition: we do not memorize entire corpuses but use external indexing systems (file systems, inboxes, bookmarks) to retrieve on demand. The reference metadata itself carries signal (a `test_utils.py` in a tests folder implies a different purpose than one in `src/core_logic/`; file sizes, naming conventions, and timestamps all hint at relevance), which enables [[progressive-disclosure]]. Claude Code exemplifies just-in-time context, using `head`/`tail`/`glob`/`grep` to analyze large data without loading full objects. The trade-off is that runtime exploration is slower than pre-computed retrieval and demands careful tool/heuristic design to avoid dead-ends; the most effective agents often use a **hybrid** strategy — Claude Code drops `CLAUDE.md` up front and retrieves the rest just-in-time. The garden's `AGENT.md`/`SKILL.md` library, read on demand by the gardener whose job names it, is a just-in-time context surface by design.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Context retrieval and agentic search](../sections/web--anthropic-context-engineering--context-retrieval-and-agentic-search.md) | Defines just-in-time context, lightweight identifiers, reference metadata as signal, and Claude Code's hybrid CLAUDE.md + glob/grep model. |

## See also

- [[progressive-disclosure]] — what just-in-time navigation enables: incremental, layer-by-layer context discovery.
- [[context-engineering]] — the umbrella discipline; just-in-time retrieval is its runtime-retrieval strategy.
- [[context-rot]] — loading on demand keeps token count down, limiting rot.
