---
ts: 2026-06-02T19:06:45Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--a604bc
cycle: 121
---

# Cycle 121 — endopi.md (Kris Kowal, endo-but-for-bots) — endopi family keystone

Ingested `designs/endopi.md` (583 lines, *Reference* status) from
`endojs/endo-but-for-bots@32799a923` (branch `origin/llm`).
**Twenty-first-comment-style design ingest.** Two cohesion-honest
sections:

1. **comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-
   contrasts** — the *Lal/Fae path* (re-implement Pi's shape in
   Endo's idioms). Covers the §Architecture Comparison 12-row table
   (*ambient authority + ergonomics* vs *least authority +
   auditable structure*), §Target disambiguation (4 rejected
   alternatives; `badlogic/pi-mono` as canonical reference), 8
   §Feature-by-Feature Mapping tables each spinning out a sibling
   design (edit-tool / jsonl-transcript-format / provider-registry-
   and-oauth / extension-package-manifest / skills-markdown-format
   / prompt-templates / context-files / stdio-rpc-bridge) + 2 more
   (iterative-compaction + html-export), and the §Already-available
   / §Designed / §Endo-specific advantages / §Pi-specific moves
   Endo declines inventories.

2. **genie-pi-inside-endo-and-the-four-architectural-contrasts** —
   the *Genie path* (embed Pi inside Endo directly). Covers
   `packages/genie` 0.0.1 depending on `@mariozechner/pi-agent-core`
   + `pi-ai`, the custom `buildOllamaModel` adaptor masquerading
   ollama as `openai-completions` at `http://127.0.0.1:11434/v1`,
   the SOUL.md/HEARTBEAT.md Claw-compatible workspace, the observer
   + reflector compaction subagent pair (shipped substrate), the
   heartbeat autonomous executor, and the makeIntervalScheduler
   cron-style runner. Plus the §What Genie's existence tells us
   three implications (provider-registry partially closed today;
   compaction substrate now exists; confinement is the open
   question via `packages/sandbox` OR a 9p filesystem server), the
   §Upstream-Pi cross-reference (Genie is closer to pi-agent than
   to pi-coding-agent), and the four §Architectural Contrasts.

## Why two sections

The 583-line design holds two argument clusters operating on
different Endo-side surfaces (Lal/Fae vs Genie) and answering the
same comparative questions with different answers. Splitting along
that axis is cohesion-honest. The §Architectural Contrasts
subsection lives in section 2 because *that's where the worldview
difference becomes the load-bearing claim*; section 1's gap tables
describe *what to adopt*, while the architectural contrasts
describe *what makes Pi and Endo not the same thing in the first
place*.

## Family-keystone closure

The endopi family arc is now mostly knit together:

- **cycle 112** — `endopi-skills-markdown-format.md` (markdown
  skill format spinout).
- **cycle 117** — `endopi-jsonl-transcript-format.md` (JSONL
  transcript format spinout).
- **cycle 121 (this cycle)** — `endopi.md` (family keystone).

Both spinouts named this file as their Parent; ingesting it now
gives the family arc its keystone. Six unindexed spinouts remain:
endopi-edit-tool / endopi-extension-package-manifest /
endopi-iterative-compaction / endopi-prompt-templates /
endopi-provider-registry-and-oauth / endopi-stdio-rpc-bridge.

## Rotation note

Cycle 121 was nominally **papers-lane** (cycle 120 was comments;
the rotation lands on papers next). Papers-lane has been blocked
for **15+ consecutive cycles** (97/100/102/104/106/108/110/112/
113/114/116/117/118/119/120) due to lack of PDF-fetching
infrastructure. Cycle 121 pivoted to designs-lane to ingest the
endopi family keystone.

## Counts

- 623 → **625** sections (+2).
- 165 → **166** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+2 rows — *first*
  endopi-* presence in this topic), `capability-security.md` (+2
  rows).
- Keywords index extended with ~69 endopi-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 122 wakes in 1500s. Rotation lands on **chat-lane** nominally
(still exhausted at 20/20). Expect a pivot to designs-lane or
comments-lane.
