---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T02:49:18Z
---
role: scholar
project: garden, endo-but-for-bots

# Result: scholar-langgraph-langchain-gap-analysis (two-phase)

Two-phase scholar job: (1) ingest LangChain + LangGraph into the reference
library, then (2) author a gap-analysis research document and open it as a DRAFT
PR on endojs/endo-but-for-bots. Both phases done.

## Phase 1 — library ingest (focused, llm-agent-frameworks topic)

New topic `llm-agent-frameworks`. Sources all docs.langchain.com (Mintlify SPA;
content fetched via the `.md` endpoint, pinned by `source_content_sha256`).
7 web sources / 9 sections / 3 concepts:

- `web--langchain-overview` (1 sec): create_agent harness + standard interfaces.
- `web--langchain-retrieval` (1 sec): retrieval/RAG pipeline + architectures.
- `web--langgraph-overview` (1 sec): orchestration runtime + product split.
- `web--langgraph-graph-api` (2 sec): state-schema-and-reducers;
  nodes-edges-super-steps-and-command-routing.
- `web--langgraph-checkpointers` (2 sec): threads-checkpoints-fault-tolerance;
  durability-modes-and-time-travel.
- `web--langgraph-persistence` (1 sec): checkpointers-vs-stores.
- `web--langgraph-workflows-and-agents` (1 sec): workflow-and-agent-patterns.

Concepts: `langchain`, `langgraph`, `langgraph-checkpointer`. Keywords appended
(22 lines). Indexes updated: topics/README Index row (+1), sources/README
External web sources (+7), concepts/README (+3 bullets), keywords.md.

Integrity gate: `library-link-check --source-slug` PASSED for all 7 clusters;
`--files` (with `--wikilinks`) on the topic + 3 concept pages PASSED;
`regenerate-topics-counts --check` reported counts already current. Regenerators
run as final landing step: `regenerate-sections-index` landed (rebuilt flat
index); `regenerate-topics-counts` nothing to land (current). All content landed
via `land-journal-edit.sh` (producer-clone CAS), never the live worktree.

Deferred (posted follow-on `scholar-ingest-langchain-langgraph-remainder`):
langchain/{agents,models,tools,messages,short-term-memory,long-term-memory,
structured-output,streaming,middleware}, langgraph/{interrupts,stores,
use-graph-api,use-functional-api,streaming}, langchain/multi-agent/handoffs.

Note: the focused `/tmp/lib/sections` glob I first used for landing collided
with a concurrent gardener's combex/papers ingest files in the same shared
`/tmp` path; the lander is idempotent + CAS-safe so no corruption occurred, but
the remaining lands were done by explicit filename. Lesson recorded below.

## Phase 2 — gap-analysis doc + DRAFT PR (the deliverable)

`designs/langgraph-langchain-gap-analysis.md` on endojs/endo-but-for-bots,
base `llm`, head `langgraph-langchain-gap-analysis`, commit 253cb348.
**DRAFT PR: https://github.com/endojs/endo-but-for-bots/pull/569** (verified
isDraft=true, base llm). Status: Reference; explicit "research, not for
implementation" banner; no build/judge chain. Carries both lenses (Endo bot
harness AND the Garden): what LangGraph/LangChain offer that we lack (explicit
graph orchestration, checkpointing/resumable state + pending-writes fault
tolerance, durability modes, standard model/tool interface, reducer-merged
state, HIL interrupts, long-term store, LangSmith observability); what we have
that they lack (git-as-ledger, multi-host CAS coordination, ocap security in the
Endo lens, durability across context resets, per-dispatch isolation,
capability-mediated handoffs); a ranked "worth a future design" list; a
do-not-import list; and an ocap-lens reading of the multi-agent handoff. Every
claim grounded in the primary docs (URLs) and the Phase-1 library slugs.

Self-improvement: Two lessons. (1) Use a unique per-job scratch dir (mktemp -d
or the `scratch_dir` helper), never a fixed shared path like `/tmp/lib`, and
land by explicit filename rather than a glob, so a concurrent gardener's files
in the same path are never swept into your lands. (2) docs.langchain.com (and
Mintlify docs generally) serve an identical HTML shell per route; the per-page
`.md` endpoint (append `.md` to the URL) is the reliable way to get clean
markdown for ingest, worth noting in conventions.md's web-source acquisition
guidance for future framework-doc ingests.
