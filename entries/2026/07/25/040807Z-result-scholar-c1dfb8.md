---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-07-25T04:08:08Z
---
---
kind: result
role: scholar
job: scholar-ingest-source-claude-5-context-engineering
---

# Ingested: Anthropic — *Effective context engineering for AI agents*

Ingested the Anthropic Applied AI team's framing post **Effective context
engineering for AI agents** (https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents,
published 2025-09-29) as a `web-essay` source. The job name
`scholar-ingest-source-claude-5-context-engineering` names no explicit URL in
its body; the canonical Anthropic guidance on context engineering is this post
(it grounds the Claude 5 / Claude Code context-management features), so it is
the source ingested. Fetched via `fetch-source.sh` (direct curl,
`source_fetched_via=direct`); idempotency anchor is
`source_content_sha256 = 71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.

## Source ingested (10 sections)

- `web--anthropic-context-engineering` — 10 sections (H3 descent on the
  long-horizon section into its three named techniques):
  overview; context-engineering-vs-prompt-engineering;
  why-context-engineering-matters (context rot + attention budget);
  anatomy-of-effective-context (system prompts / tools / examples);
  context-retrieval-and-agentic-search (just-in-time context, hybrid model);
  long-horizon-tasks (section intro); compaction; structured-note-taking;
  sub-agent-architectures; conclusion.

## Topics touched

- **New topic `context-engineering`** (`topics/context-engineering.md`), all 10
  sections filed under it; added to `topics/README.md` Index.
- **`agent-fleet-orchestration`** — cross-filed the `sub-agent-architectures`
  section (the summarize-and-return-condensed shape the garden's fleet runs),
  via `insert-sections-table-row.sh`.

## Concepts touched

- **New:** `context-rot`, `attention-budget`, `just-in-time-context`,
  `context-compaction`, `progressive-disclosure` (each with a section-touch
  table and see-also links); added to `concepts/README.md` and `keywords.md`.
- **Updated:** `context-pruning` (from the Allen Pike essay) — added the
  `context-engineering` topic, two section-touch rows (compaction, anatomy),
  and see-also cross-links to `context-compaction` / `context-engineering`,
  linking the cost-side "fewer tokens" lever to the discipline-side view.

## Curatorial cross-reference

The source-index carries a "Relevance to the garden's own context discipline"
section (scholar's framing, clearly not the post's words) connecting the post's
levers to garden mechanisms: just-in-time role/skill library (the `AGENT.md`/
`SKILL.md` naming that keeps files out of auto-load), `CLAUDE.md` up-front
orientation (the hybrid model), sub-agent distilled summaries (the gardener
fleet's concise completion reports), the journal as external memory (agentic
note-taking), and context-summary roll-forward (compaction). One honest
boundary noted: the post targets engineers building on the Claude Developer
Platform; the garden is a deployment composing Claude Code with its own
conventions — the shared thing is the discipline, not the platform primitives.

## Integrity gate (step 8) — PASSED

- `library-link-check.sh --changed`: OK — every section-table target and
  `sections/README.md` row in the touched cluster resolves to a committed file.
- `regenerate-topics-counts.sh --check`: the only staleness was the two
  benign count deltas (`context-engineering`=10, `agent-fleet-orchestration`+1);
  no missing topic page. Made current by the `--land` step below.

## Landing / regeneration (step 9)

- All 23 content files landed through `land-journal-edit.sh` (17 new + 6
  modified-existing, the latter with `--base-blob` guards; no `--force`).
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` run last;
  both landed. Post-land verification on the fresh `origin/journal2` tip:
  counts idempotent (current), source cluster link-check OK,
  `context-engineering` shows 10 sections.

## Follow-ons / deferred backlog

None. Single-source ingest, complete in one cycle (10 sections, well within
budget). No remainder to defer.

Self-improvement: The job base (`...claude-5-context-engineering`) named a topic,
not a URL, and its body was empty — I resolved it to the canonical Anthropic
post and recorded that resolution explicitly in the source `notes:` so a future
re-ingest or idempotency check is unambiguous about which artifact "claude-5
context engineering" mapped to. When a `scholar-ingest-source-<slug>` job ships
no URL, recording the slug→URL resolution in the source frontmatter is the honest
way to keep the mapping durable.
