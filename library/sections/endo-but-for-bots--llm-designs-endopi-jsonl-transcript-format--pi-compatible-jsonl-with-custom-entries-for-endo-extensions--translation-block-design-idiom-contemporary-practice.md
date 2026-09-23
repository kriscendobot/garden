---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `Pi-compatible jsonl files (openclaw and localgpt at least both do this)` | The *adopt-the-existing-standard-rather-than-fragment* discipline (parallel to cycle 112). |
| `the claw itself can use these as a form of memory` | The *agent-reads-own-transcripts-for-long-term-memory* pattern. |
| `inspectable, append-only JSONL file the operator can cat, grep, and jq without going through the daemon` | The *transparent-persistence-not-opaque-database* discipline. |
| `Pi's spec already accommodates extension-namespaced entries through the custom role` | The *spec-reserved-extension-point* idiom; `custom` entries with `endo:*` discriminator. |
| `O_APPEND writes; partial line at EOF recovered by truncating to last \n` | The *append-only-atomicity-via-syscall-guarantees + partial-line-recovery* discipline. |
| `Pi takes the same approach` | The *adopt-the-existing-discipline* idiom; don't invent new atomicity. |
| Two readers (agent + operator) with off-the-shelf JSONL tooling | The *file-format-with-multiple-consumers* pattern. |
| Compaction writes `compaction` entry; full history stays in file | The *compaction-as-in-memory-graph-concern-not-file-truncation* discipline. |
| Suggested default `$ENDO_STATE/sessions/` + opt-in symlink for Pi-compat | The *default-to-native-location + opt-in-cross-harness-compat* discipline. |
| `Suggest: store both, with the Endo ID under a endo:messageId field` | The *carry-both-when-two-IDs-equally-valid* idiom. |
| Pi-mono citations (`session-format.md`, `session-manager.ts`, `messages.ts`, `types.ts`) | The *cite-the-reference-implementation* discipline (parallel to cycle 112). |
