---
title: Common confusions
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

- **"`Pi-compatible JSONL` is just a format choice."** It's *cross-harness ecosystem participation*. openclaw, localgpt, Pi, and (now) Endo all use the same format. The §benefit: *agents and operators can use the same tools across harnesses*; Pi tooling can read Endo sessions, and vice versa.
- **"`custom` entries with `endo:*` discriminator pollute the file."** They *don't* — Pi's spec *reserves* the `custom` role for extension-namespaced entries. Pi tooling ignores entries it doesn't recognize; Endo tooling reads them. The §discipline: *forward-compatibility via spec-reserved extension*.
- **"Mode 0600 is excessive — what if the operator wants to share a session?"** Mode 0600 is the §default; operators can `chmod` to share. The §rationale: *transcripts contain conversational content* which may be sensitive; default-private is the safe choice.
- **"`O_APPEND` is unreliable across NFS / Windows."** It is — *and the design doesn't claim multi-platform atomicity*. The §discipline names *Pi takes the same approach* — the same limitations apply. On systems where `O_APPEND` doesn't work atomically (network filesystems, Windows in some configurations), neither Pi nor Endo can guarantee atomicity. The §default assumes local-filesystem semantics.
- **"`loadFromJsonl(path)` is just file reading."** It's *transcript-graph reconstruction*. The function returns *the same transcript-node graph the in-memory model uses* — meaning the agent's memory and the operator's CLI both see the same logical structure, just from different sources.
- **"`endo session list` is just `ls $ENDO_STATE/sessions/`."** It is — *with extra metadata*. The CLI verb can extract session-creation-date + cwd + message-count without parsing the raw JSONL. The §discipline: *daemon-side helper for operator-side inspection*.
- **"Compaction-leaves-history-in-file is wasteful."** It's *deliberate*. The §discipline: *compaction is reversible*. If the agent decides to re-read elided messages, they're still on disk. Truncating the file would *foreclose* recovery.
- **"`$ENDO_STATE/sessions/` location is non-standard."** It's the §Endo-native location. The §Open Question acknowledges the trade-off: Pi-native `$HOME/.pi/agent/sessions/` would work with Pi tools out of the box; Endo-native `$ENDO_STATE/sessions/` keeps state co-located with the rest of the daemon. The §suggested resolution: *default Endo-native; opt-in Pi-compat via symlink*.
- **"`endo:messageId` field is namespace-pollution."** It's *spec-respected-extension*. Pi's spec accommodates `endo:*`-prefixed fields under the `custom` entry type. The §discipline preserves cross-harness compatibility while letting Endo carry its native identifier.
- **"Pi-mono citations make Endo dependent on Pi."** They make Endo *informed by Pi*. The §citations are documentation references, not runtime dependencies. Endo implements the format independently; Pi's docs are the *canonical reference*.
