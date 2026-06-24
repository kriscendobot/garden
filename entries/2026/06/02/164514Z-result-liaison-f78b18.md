---
host: endolin
role: liaison
dispatch_id: f78b18
date: 2026-06-02
kind: result
---

# result(librarian, cycle 117): endopi-jsonl-transcript-format — Pi-compatible JSONL with `custom` entries for Endo extensions (1 section); **second endopi-* ingest**

**Cycle**: 117 (pivoted from chat-lane (exhausted) to endopi-design-lane).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/endopi-jsonl-transcript-format.md` (165 lines), last touched 2026-05-15 by Kris Kowal (prompted).

## What

Ingested the **Proposed** `endopi-jsonl-transcript-format` design — the second endopi-* design ingest after cycle 112's `endopi-skills-markdown-format`. The 165-line design adopts Pi's JSONL transcript format for Endo's on-disk session projection with extension-namespaced `custom` entries for Endo-specific message types.

### Section drafted

1. **Pi-compatible JSONL with `custom` entries for Endo extensions** (full file, lines 1-166) — single cohesive ingest. The §Motivation cites the maintainer's `endoclaw` § Persistence and Memory directive: *whatever else we do internally, message history (sessions) should get stored as Pi-compatible jsonl files (openclaw and localgpt at least both do this, probably most of the others too). This is at least for offline operator inspect-ability, but also the claw itself can use these as a form of memory if within its workspace*. The §file layout at `$ENDO_STATE/sessions/<guest-id>/<timestamp>_<session-id>.jsonl` (mode 0600). The §five entry types (`header`, `message`, `compaction`, `branchSummary`, `custom`) with `id`/`parentId` tree linkage. The §`custom` entry type with `endo:*` discriminator carries Pi-foreign fields (including cycle 103's `value` messages). The §Writer is guest-side, lazy-open, with `O_APPEND` atomicity + partial-line recovery (*Pi takes the same approach*). The §two readers — *the agent itself* (Lal resumes a session via `loadFromJsonl(path)`; *the claw uses these as a form of memory*) + *the operator* (`endo session list/show` CLI verb; *files are usable with off-the-shelf JSONL tooling (jq, fx)*). The §compaction interaction writes a `compaction` entry with `firstKeptEntryId` pointer; full history stays in the file. The §two Open questions on file location and id format with *store-both* suggestion.

### Library state after this cycle

- **619 sections** (was 618) / **162 sources** (was 161) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~28 endopi-jsonl keywords (Pi-compatible JSONL transcript format / extension-namespaced custom entries via endo:* discriminator / transparent-persistence-not-opaque-database / two-reader pattern / loadFromJsonl path helper / O_APPEND atomicity + partial-line recovery / claw uses these as a form of memory / off-the-shelf JSONL tooling jq fx / compaction-leaves-history-in-file / adopt-existing-standard-with-extension-namespace).

## endopi-family arc continues

The endopi-* design family arc:

- **Cycle 112** `endopi-skills-markdown-format` (Proposed) — first endopi-* ingest; adopt-agentskills.io-spec with extension-namespaced fields.
- **Cycle 117** (this ingest) `endopi-jsonl-transcript-format` (Proposed) — second endopi-* ingest; adopt-Pi-JSONL-format with extension-namespaced `custom` entries.

Both designs follow the same discipline:
- **Adopt-existing-standard-with-extension-namespace** — Pi's format is the base; Endo extends via spec-reserved extension points.
- **Cite-Pi-reference-implementation** — design points to Pi's actual implementation files rather than re-documenting.
- **Phased implementation** — small phases for incremental delivery.
- **Honest open questions** — name unresolved decisions (location, id format).

Six remaining endopi-* designs queued for future cycles: `endopi-edit-tool` (Proposed, 122 lines), `endopi-extension-package-manifest` (Proposed, 149 lines), `endopi-stdio-rpc-bridge` (Proposed, 149 lines), `endopi-iterative-compaction` (Proposed; 152 lines — partially satisfied), `endopi-prompt-templates` (Proposed, 104 lines — shortest), `endopi-provider-registry-and-oauth` (Proposed; 181 lines — partially satisfied). Plus the §parent meta-design `endopi.md` (Reference, 583 lines).

## Notes

- The §*Pi-compatible-with-extension-namespaced-custom-entries* discipline is structurally important: Pi's spec *reserves* the `custom` role for extension-namespaced entries. Endo's `endo:*` discriminator follows this convention; Pi tooling ignores; Endo tooling reads. Forward-compatibility via spec-reserved extension.
- The §*transparent-persistence-not-opaque-database* discipline is the canonical *operator-inspectable-storage* idiom. Files are JSONL — *cat-able, grep-able, jq-able*. The §rationale: *no daemon-specific tools required for inspection*.
- The §*two-reader pattern* (agent reads own for memory + operator reads via CLI for inspection) is reusable for any *file-format-with-multiple-consumers* situation. Each audience uses appropriate tooling; the §format itself is *just JSONL* serving both.
- The §`O_APPEND` atomicity + partial-line recovery is a worked example of *append-only safety via syscall guarantees + graceful recovery on incomplete writes*. The §*Pi takes the same approach* observation captures the *adopt-the-existing-discipline* idiom.
- The §compaction-leaves-history-in-file pattern is distinctive: compaction is *in-memory-graph concern*, not *file-truncation concern*. The on-disk file is *immutable from compaction*; the in-memory model uses the compaction entry to skip the elided range. *Compaction is reversible*.
- The §*store-both-when-two-identifiers-equally-valid* suggestion for the UUIDv7-vs-256-bit-formula-ID open question is the canonical *carry-both-with-one-in-extension-slot* pattern. Reusable for any *two-equally-valid-IDs* situation.

## Rotation discipline

Cycle 117 papers-lane block: 12 consecutive (cycles 97/100/102/104/106/108/110/112/113-implicit/114/116/117-implicit). The §rotation continues into design-lane and comments-lane pivots.

## Next

- Cycle 118 (papers-lane): consider whether infrastructure available.
- Cycle 119 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines).
- Cycle 120 (chat-lane → endopi or other design): remaining endopi-* (6 Proposed) — shortest is endopi-prompt-templates at 104 lines; or daemon-checkin-checkout (Complete, 578 lines).

ScheduleWakeup 1500s for cycle 118.
