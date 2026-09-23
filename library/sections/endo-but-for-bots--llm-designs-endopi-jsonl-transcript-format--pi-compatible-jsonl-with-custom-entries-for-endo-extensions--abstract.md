---
title: Abstract
source: designs/endopi-jsonl-transcript-format.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-15
source_authors: [Kris Kowal (prompted)]
source_lines: "1-166 (full file)"
topics: [daemon]
status: current
notes: |
  Thirty-second endo-but-for-bots design ingest. **Status:
  Proposed**. **Second endopi-* design ingest** (cycle 112 was
  the first, endopi-skills-markdown-format). The 165-line design
  adopts Pi's JSONL transcript format with extension-namespaced
  `custom` entries for Endo-specific message types.
  
  Three structurally interesting moves: (1) the *Pi-compatible-
  with-extension-namespaced-custom-entries* discipline — Pi's
  spec already accommodates `custom`-role entries with
  discriminators; Endo extends Pi's format by adding
  `endo:*`-prefixed custom entries (Pi-foreign fields under
  `custom` entry type); Pi tooling can ignore the custom entries
  while Endo tooling reads them; (2) the *operator-inspectability-
  via-off-the-shelf-tooling* — *files are usable with off-the-
  shelf JSONL tooling (`jq`, `fx`)*; *operator can `cat`, `grep`,
  and `jq` without going through the daemon*; the §discipline:
  *transparent persistence not opaque database*; (3) the
  *two-reader pattern* — *the agent itself* (resume session by
  reading own JSONL; *claw uses these as a form of memory* path)
  + *the operator* (`endo session list/show` CLI). The agent uses
  its own transcripts as long-term memory.
  
  Plus the §atomicity discipline (`O_APPEND` writes; partial line
  recovery by truncating to last `\n`; *Pi takes the same
  approach*) and the §two-open-questions (location: `$ENDO_STATE/`
  vs `$HOME/.pi/agent/sessions/` with suggested-default + opt-in
  symlink; id: UUIDv7 vs 256-bit formula ID with *store both*
  suggestion).
  
  Cycle 117 pivoted from chat-lane (exhausted) to endopi-design-
  lane. Single-section cohesion-honest ingest.
parent: endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions
---

The §Motivation block (lines 11-24) cites the maintainer's directive on `endoclaw` § *Persistence and Memory*:

> whatever else we do internally, message history (sessions) should get stored as Pi-compatible jsonl files (openclaw and localgpt at least both do this, probably most of the others too). This is at least for offline operator inspect-ability, but also the claw itself can use these as a form of memory if within its workspace.

The §gap-naming: the sibling `lal-reply-chain-transcripts` already implements Pi's tree shape *in memory*; the gap is the *on-disk projection* — *an inspectable, append-only JSONL file the operator can `cat`, `grep`, and `jq` without going through the daemon*. The §file layout (lines 34-36): `$ENDO_STATE/sessions/<guest-id>/<timestamp>_<session-id>.jsonl` — one file per session. The §entry-shape (lines 44-79) has five types — `header` / `message` / `compaction` / `branchSummary` / `custom` — and entries form a tree via `id` / `parentId` linkage. The §header carries `version: 3` (Pi's v3 = Endo's v1), `sessionId`, `createdAt`, `cwd`. Message entries carry `role`/`content`/`timestamp` plus model metadata (`api`, `provider`, `model`, `usage`, `stopReason`) for assistant messages. The §Pi-foreign fields (the `details` slot on `toolResult`, Endo-specific `replyTo` metadata, the `value`-typed messages from cycle 103's `daemon-value-message`) go under the `custom` entry type with an `endo:*` discriminator: *Pi's spec already accommodates extension-namespaced entries through the `custom` role*. The §Writer (lines 87-97) is *guest-side, not daemon-side* — *the Lal agent (or Fae) opens the file lazily on first message in a given session and appends one line per agent message*. File mode is 0600 under `$ENDO_STATE/sessions/`. On daemon restart, the file is reopened in append mode. The §atomicity discipline: *the writer flushes `O_APPEND` writes; a partial line at EOF is recovered on reopen by truncating to the last `\n`. Pi takes the same approach*. The §Reader (lines 99-110) has two consumers: (1) *the agent itself* — Lal can resume a session by reading its own JSONL file (*This is the "claw uses these as a form of memory" path. Implementation: a `loadFromJsonl(path)` helper that returns the same transcript-node graph the in-memory model uses*); (2) *the operator* — a new `endo session list` / `endo session show <id>` CLI verb walks `$ENDO_STATE/sessions/` and renders sessions; *The files are usable with off-the-shelf JSONL tooling (`jq`, `fx`)*. The §Compaction interaction (lines 112-118) — when `endopi-iterative-compaction` runs, it writes a `compaction` entry with `firstKeptEntryId` pointer (matching Pi's shape); the full history stays in the file; the in-memory graph is rebuilt with the summary entry in place of the elided ones. The §Dependencies (lines 120-127) name four: `lal-reply-chain-transcripts` (provides the tree); `endopi-iterative-compaction` (writes `compaction` entries); `daemon-value-message` (cycle 103's `value` message shape that maps to Pi's `custom`); `endoclaw` (source of the maintainer's directive). The §Phased implementation (lines 129-138) names four phases. The §Open questions (lines 140-151) raise two: (a) file location: `$ENDO_STATE/` (daemon state) vs `$HOME/.pi/agent/sessions/` (Pi-compatible default); suggest default `$ENDO_STATE/sessions/` with opt-in symlink or configuration; (b) id: Pi's UUIDv7 vs Endo's 256-bit formula ID; *Suggest: store both, with the Endo ID under a `endo:messageId` field*. The §Citation (lines 153-158) names four Pi-mono files: `coding-agent/docs/session-format.md`, `coding-agent/src/core/session-manager.ts`, `coding-agent/src/core/messages.ts`, `ai/src/types.ts`.
