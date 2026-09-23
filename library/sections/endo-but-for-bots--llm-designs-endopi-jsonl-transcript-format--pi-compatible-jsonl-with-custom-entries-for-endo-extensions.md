---
title: The §motivation citing the maintainer's *endoclaw* note (*whatever else we do internally, message history (sessions) should get stored as Pi-compatible jsonl files (openclaw and localgpt at least both do this, probably most of the others too). This is at least for offline operator inspect-ability, but also the claw itself can use these as a form of memory if within its workspace*); the §gap-naming — *The Lal reply-chain transcripts already implement Pi's tree shape in memory. The gap is the on-disk projection: an inspectable, append-only JSONL file the operator can `cat`, `grep`, and `jq` without going through the daemon*; the §file layout at `$ENDO_STATE/sessions/<guest-id>/<timestamp>_<session-id>.jsonl` (one file per session; mode 0600); the §entry-shape with five types (`header`, `message`, `compaction`, `branchSummary`, `custom`) and `id`/`parentId` tree linkage; the §header carries version (v1 = Pi's v3), sessionId, createdAt, cwd; the §message entries carry `role`/`content`/`timestamp` plus model/usage/stopReason for assistant messages; the §Pi-foreign-fields go under the `custom` entry type with `endo:*` discriminator — *Pi's spec already accommodates extension-namespaced entries through the custom role*; the §writer is *guest-side, not daemon-side* — Lal opens the file lazily on first message + appends one line per agent message + mode 0600 under `$ENDO_STATE/sessions/` + on daemon restart reopens in append mode; the §atomicity discipline — *the writer flushes `O_APPEND` writes; a partial line at EOF is recovered on reopen by truncating to the last `\n`. Pi takes the same approach*; the §two readers — (1) *the agent itself*: Lal resumes a session by reading its own JSONL (*claw uses these as a form of memory* path); (2) *the operator*: new `endo session list` / `endo session show <id>` CLI verb walks `$ENDO_STATE/sessions/` (*files are usable with off-the-shelf JSONL tooling (jq, fx)*); the §compaction interaction — `endopi-iterative-compaction` writes a `compaction` entry with `firstKeptEntryId` pointer matching Pi's shape; the §four-phase implementation; the §two Open questions — (a) location: `$ENDO_STATE/` (daemon state) vs `$HOME/.pi/agent/sessions/` (Pi-compatible default; cross-harness tools work without configuration); suggest default to `$ENDO_STATE/` with opt-in symlink/config for Pi compat; (b) id: Pi's UUIDv7 vs Endo's 256-bit formula ID; suggest store both with Endo ID under `endo:messageId` field; the §four Pi-mono citations to `coding-agent/docs/session-format.md` + `core/session-manager.ts` + `core/messages.ts` + `ai/src/types.ts`
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--abstract.md)
- [Body](endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions--common-confusions.md)
