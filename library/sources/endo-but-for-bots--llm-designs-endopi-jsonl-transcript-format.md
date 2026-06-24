---
source: designs/endopi-jsonl-transcript-format.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-15
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-second endo-but-for-bots design ingest. **Status:
  Proposed**. Parent: endopi. **Second endopi-* design ingest**
  (cycle 112 was the first, endopi-skills-markdown-format). The
  165-line design adopts Pi's JSONL transcript format with
  extension-namespaced `custom` entries for Endo-specific message
  types (the `value` messages from cycle 103's daemon-value-message
  map to Pi's `custom` entry with `endo:*` discriminator).
  
  Three structurally interesting moves: (1) the *Pi-compatible-
  with-extension-namespaced-custom-entries* discipline — Pi's
  spec reserves the `custom` role for extension-namespaced
  entries; Endo extends Pi's format with `endo:*`-prefixed custom
  entries while preserving Pi-tooling compatibility (Pi tooling
  ignores; Endo tooling reads); (2) the *transparent-persistence-
  not-opaque-database* discipline — files at `$ENDO_STATE/
  sessions/<guest-id>/<timestamp>_<session-id>.jsonl` are
  *inspectable, append-only* + *operator can cat, grep, and jq
  without going through the daemon* + *files are usable with
  off-the-shelf JSONL tooling (jq, fx)*; (3) the *two-reader
  pattern* — *the agent itself* (Lal resumes a session by reading
  its own JSONL; *the claw uses these as a form of memory* path)
  + *the operator* (`endo session list/show` CLI). Plus the
  §atomicity-discipline (`O_APPEND` writes; partial-line recovery
  by truncating to last `\n`; *Pi takes the same approach*) and
  the §store-both-suggestion for the UUIDv7-vs-256-bit-formula-ID
  open question.
  
  Cycle 117 pivoted from chat-lane (exhausted) to endopi-design-
  lane. Single-section cohesion-honest ingest. The §endopi-family
  arc continues: cycle 112's adopt-agentskills.io-spec + cycle 117's
  adopt-Pi-JSONL-format both follow the *adopt-existing-standard-
  with-extension-namespace* discipline + *cite-Pi-reference-
  implementation* discipline.
---

> Abstract: `designs/endopi-jsonl-transcript-format.md` adopts
> Pi's JSONL transcript format for Endo's on-disk session
> projection. The §Motivation cites the maintainer's endoclaw §
> Persistence and Memory directive: *whatever else we do
> internally, message history (sessions) should get stored as
> Pi-compatible jsonl files ... This is at least for offline
> operator inspect-ability, but also the claw itself can use
> these as a form of memory if within its workspace*. The
> §gap-naming: lal-reply-chain-transcripts already implements
> Pi's tree shape in memory; the gap is the *on-disk projection*.
> The §file layout: `$ENDO_STATE/sessions/<guest-id>/
> <timestamp>_<session-id>.jsonl` (one file per session, mode
> 0600). The §five entry types (header / message / compaction /
> branchSummary / custom) with `id`/`parentId` tree linkage. The
> §Pi-foreign fields go under the `custom` entry type with
> `endo:*` discriminator — *Pi's spec already accommodates
> extension-namespaced entries through the custom role*. The
> §Writer is guest-side, lazy-open, mode 0600, with `O_APPEND` +
> partial-line-recovery atomicity (*Pi takes the same approach*).
> The §two readers — (1) *the agent itself* (Lal resumes a
> session via `loadFromJsonl(path)`; *claw uses these as a form
> of memory* path); (2) *the operator* (`endo session list/show`
> CLI; *files are usable with off-the-shelf JSONL tooling (`jq`,
> `fx`)*). The §compaction interaction writes a `compaction`
> entry with `firstKeptEntryId` pointer (matching Pi's shape);
> full history stays in the file; in-memory graph is rebuilt
> with the summary entry. The §two Open questions on file
> location ($ENDO_STATE/ vs $HOME/.pi/agent/sessions/) and id
> (UUIDv7 vs 256-bit formula ID); store-both suggestion for the
> ID question. The §four Pi-mono citations.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [pi-compatible-jsonl-with-custom-entries-for-endo-extensions](../sections/endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions.md) | daemon | current |

The 165-line file is honestly one cohesive argument-cluster — *one design proposal* adopting Pi's JSONL format with Motivation + Design (5 subsections) + Phased implementation + Open questions + Citations. Single-section ingest preserves the unified structure.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-05-15 by Kris Kowal (*prompted* — LLM-collaborated authoring; same date as cycle 112's `endopi-skills-markdown-format` — both designs are part of the May-2026 endopi push).
- Verified file existence via bare-clone listing: 165 lines.
- **Thirty-second endo-but-for-bots design ingest, second endopi-* ingest** (cycle 112 was the first).
- Cycle 117 was scheduled for chat-lane (exhausted) and pivoted to endopi-design-lane.
- Single-section cohesion-honest count. The 165-line file is *one unified design proposal* — multi-section split would create artificial divisions.
- The §endopi-family pattern repeats: cycle 112 (skills format) + cycle 117 (JSONL transcript format) both follow *adopt-existing-Pi-format-with-extension-namespace + cite-Pi-reference-implementation*.
