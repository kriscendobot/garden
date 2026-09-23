---
title: Connection to the wider library
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

This section is the **canonical *Pi-compatible-on-disk-format-with-extension-namespace* worked example**. Four threads:

1. **The adopt-Pi's-format-with-extension-namespaced-custom-entries discipline** — same shape as cycle 112's `endopi-skills-markdown-format` adopt-the-agentskills.io-spec pattern. Reusable for any *adopt-existing-standard-with-extension* situation.

2. **The transparent-persistence-not-opaque-database discipline** — JSONL files inspectable via `cat`/`grep`/`jq`. The §rationale: *storage format = wire format*; the operator can read with standard tools.

3. **The two-reader pattern** — agent reads own JSONL for memory; operator reads via CLI for inspection. Reusable for any *file-format-with-multiple-consumers* situation.

4. **The store-both-when-two-identifiers-equally-valid suggestion** — Pi's UUIDv7 in `id`; Endo's 256-bit formula ID in `endo:messageId`. The §discipline: *carry both; let each consumer read its preferred field*.

The §endopi-family-context: this is the **second endopi-* design ingest** (cycle 112 was the first, `endopi-skills-markdown-format`). Both designs follow the same pattern: adopt-Pi's-format with extension namespace + cite Pi's reference implementation + phased implementation + honestly-named open questions.

The §cross-cycle complement:

- **Cycle 103** `daemon-value-message` — the `value` message type that maps to Pi's `custom` entry with `endo:*` discriminator.
- **Cycle 112** `endopi-skills-markdown-format` — the agentskills.io adoption; this design's *cross-harness format adoption* sibling.
- **Cycle 117** (this ingest) `endopi-jsonl-transcript-format` — Pi's JSONL adoption with Endo extensions.

Together three cycles document the *Pi-Endo integration design space*: skill format + transcript format + value-message-as-custom-entry.
