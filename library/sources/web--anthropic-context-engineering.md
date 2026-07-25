---
source_kind: web-essay
source_url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_content_sha256: 71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2
source_author: "Anthropic Applied AI team (Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield)"
source_date: 2025-09-29
retrieved: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
section_count: 10
status: current
notes: "Anthropic engineering-blog post, fetched live and reachable via direct curl (source_fetched_via=direct), so no archive snapshot needed. The idempotency anchor is source_content_sha256 over the live response body, not a git SHA. Seeds the library's context-engineering topic. The job that requested this ingest was named 'claude-5-context-engineering'; the canonical Anthropic guidance on context engineering is this 2025-09-29 post (it predates and grounds the Claude 5 / Claude Code context-management features), so it is the source ingested. See the curatorial 'Relevance to the garden's own context discipline' section below for the honest, non-overstated cross-reference to the garden's context-management machinery (CLAUDE.md, sub-agent summaries, journal-as-external-memory, context-summary roll-forward)."
---

## Abstract

*Effective context engineering for AI agents* (Anthropic Applied AI team, 2025-09-29) is Anthropic's framing document for **context engineering** — the discipline of curating and maintaining the optimal set of tokens available to an LLM during inference. Its thesis is that building with language models has moved from prompt engineering (finding the right words for a prompt) to the broader question **"what configuration of context is most likely to generate our model's desired behavior?"** The post frames context engineering as the natural, *iterative* progression of prompt engineering — the curation happens each turn, not once — and argues that context must be treated as a **finite resource**: it names *context rot* (recall degrades as tokens grow) and the *attention budget* (finite, depleted by every token, rooted in the transformer's n² attention), producing a performance gradient rather than a hard cliff. Its guiding principle is to **find the smallest set of high-signal tokens that maximize the likelihood of the desired outcome**, applied across system prompts (the "right altitude"), tools (token-efficient, unambiguous, non-bloated), and examples (curated and canonical, not a laundry list). It develops **just-in-time context retrieval** (agents hold lightweight identifiers and load data at runtime; Claude Code's hybrid `CLAUDE.md`-plus-`glob`/`grep` model) and three **long-horizon techniques** — compaction, structured note-taking (agentic memory), and sub-agent architectures — for tasks whose token count exceeds the window. This is the framing document for the library's `context-engineering` topic.

## Relevance to the garden's own context discipline

Curatorial cross-reference (scholar, not the post's own words), so a gardener or the liaison reasoning about the fleet's own context spend can find the connection. Offered as Anthropic's framing that happens to line up with mechanisms the garden already runs, not as a claim the post describes the garden.

Where they genuinely meet, mechanism by mechanism:

- **Just-in-time context over up-front loading.** The post's central retrieval recommendation is that agents hold lightweight identifiers and load data at runtime rather than pre-loading everything. The garden's whole role/skill library is built exactly this way: `roles/<role>/AGENT.md` and `skills/<skill>/SKILL.md` are read *just-in-time* by the gardener whose job names them, and the files are deliberately named `AGENT.md`/`SKILL.md`/`COMMON.md` (not `CLAUDE.md`) precisely so Claude Code does **not** auto-load them into every worker's context. That is the post's "maintain lightweight identifiers, load on demand" discipline encoded as a directory convention. This very library — abstract-routed sources, topics, and concepts an agent walks in one or two queries — is a just-in-time retrieval surface by design.
- **`CLAUDE.md` dropped in up front (the hybrid model).** The post cites Claude Code's hybrid strategy — `CLAUDE.md` naively dropped into context up front, `glob`/`grep` for the rest just-in-time. The garden's own `CLAUDE.md` (auto-loaded orientation: layout, vocabulary, current inventory) is exactly the "dropped in up front" half of that hybrid, while the role/skill files are the retrieved-on-demand half.
- **Sub-agent architectures returning distilled summaries.** The post's sub-agent pattern — specialized sub-agents explore with clean context windows and return only a 1,000-to-2,000-token distilled summary — is the shape the garden's gardener fleet already runs: a job's substance never enters the liaison's context; a gardener works in its own worktree and returns a concise completion report. See the `agent-fleet-orchestration` topic for the operational layer.
- **Structured note-taking as external memory.** The post's agentic-memory technique (notes persisted outside the window, pulled back later) is what the garden's **journal** is — the board, bus, and library are durable external memory that survives a `/clear` and a worker's context exhaustion, so a re-issued ask is idempotent and a reaped job resumes rather than restarts.
- **Compaction / context-summary roll-forward.** The post's compaction lever (summarize a near-full window, reinitialize with the summary, preserve architectural decisions and unresolved bugs) is the same shape as the harness's context-summary roll-forward that lets a long garden job continue across a summarization boundary.

One honest boundary so the analogy is not overstated: the post is written for engineers *building* an agent product on the Claude Developer Platform (its concrete levers are the platform's memory tool, tool-result clearing, and compaction features), whereas the garden is a *deployment* that composes Claude Code with its own file-system and journal conventions. The shared idea is the discipline — treat context as finite, retrieve just-in-time, summarize and externalize — not the specific platform primitives. Treat this as Anthropic's framing informing how the fleet thinks about its own context, not a normative rule.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [Overview](../sections/web--anthropic-context-engineering--overview.md) | context-engineering | current |
| [Context engineering vs. prompt engineering](../sections/web--anthropic-context-engineering--context-engineering-vs-prompt-engineering.md) | context-engineering | current |
| [Why context engineering is important](../sections/web--anthropic-context-engineering--why-context-engineering-matters.md) | context-engineering | current |
| [The anatomy of effective context](../sections/web--anthropic-context-engineering--anatomy-of-effective-context.md) | context-engineering | current |
| [Context retrieval and agentic search](../sections/web--anthropic-context-engineering--context-retrieval-and-agentic-search.md) | context-engineering | current |
| [Context engineering for long-horizon tasks](../sections/web--anthropic-context-engineering--long-horizon-tasks.md) | context-engineering | current |
| [Compaction](../sections/web--anthropic-context-engineering--compaction.md) | context-engineering | current |
| [Structured note-taking](../sections/web--anthropic-context-engineering--structured-note-taking.md) | context-engineering | current |
| [Sub-agent architectures](../sections/web--anthropic-context-engineering--sub-agent-architectures.md) | context-engineering, agent-fleet-orchestration | current |
| [Conclusion](../sections/web--anthropic-context-engineering--conclusion.md) | context-engineering | current |
