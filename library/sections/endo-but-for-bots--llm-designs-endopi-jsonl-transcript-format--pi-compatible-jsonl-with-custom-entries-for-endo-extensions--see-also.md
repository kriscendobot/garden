---
title: See also
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

- [[daemon]] (topic) — the endo daemon architecture; this design is the *on-disk projection* of in-memory transcripts.
- `endo-but-for-bots--llm-designs-endopi-skills-markdown-format--*` (cycle 112) — the *first* endopi-* design ingest; sibling adopt-Pi's-format with extension-namespace design.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — provides the `value` message shape that maps to Pi's `custom` entry with `endo:*` discriminator.
- `endo-but-for-bots--llm-designs-lal-reply-chain-transcripts` — *provides the in-memory tree* this design projects to disk.
- `endo-but-for-bots--llm-designs-endopi-iterative-compaction` — *writes `compaction` entries* into the same file.
- `endo-but-for-bots--llm-designs-endoclaw` — *source of the maintainer's directive* on Pi-compatible JSONL.
- `endo-but-for-bots--llm-designs-endopi` (queued meta-design parent) — the §parent of this design.
