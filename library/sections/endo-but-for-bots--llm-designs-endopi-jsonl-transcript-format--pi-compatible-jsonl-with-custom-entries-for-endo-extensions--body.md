---
title: Body
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

### §The maintainer's directive — Pi-compatible JSONL

The §Motivation (lines 11-24) starts by *quoting the maintainer's existing note* on `endoclaw` § Persistence and Memory:

> whatever else we do internally, message history (sessions) should get stored as Pi-compatible jsonl files (openclaw and localgpt at least both do this, probably most of the others too). This is at least for offline operator inspect-ability, but also the claw itself can use these as a form of memory if within its workspace.

The §two-purpose framing:

- **Operator inspect-ability** — JSONL files are *grep-able*, *jq-able*, *cat-able*. The operator can read sessions without going through the daemon.
- **Agent's own memory** — *the claw itself can use these as a form of memory if within its workspace*. The agent reads its own past transcripts to inform its future behavior.

The §canonical *transparent-persistence-not-opaque-database* discipline: *storage format is the same as the wire format*; both are JSONL with documented entry shapes. The operator and the agent can both read the file with the same tooling.

The §gap-naming (lines 21-24):

> The Lal reply-chain transcripts already implement Pi's tree shape in memory. The gap is the on-disk projection: an inspectable, append-only JSONL file the operator can `cat`, `grep`, and `jq` without going through the daemon.

The §in-memory-vs-on-disk split: cycle's library has the in-memory model from `lal-reply-chain-transcripts`; this design adds the on-disk projection. The §discipline: *separate runtime representation from persistence representation; the JSONL is the file-system projection of the in-memory tree*.

### §The Pi-compatible-with-extension-namespaced-custom-entries discipline

The §five entry types (lines 38-42):

```
header / message / compaction / branchSummary / custom
```

The §`custom` entry type (lines 81-85):

> Pi-foreign fields (the `details` slot on `toolResult`, Endo-specific `replyTo` metadata, the `value`-typed messages from [daemon-value-message](daemon-value-message.md)) go under a `custom` entry type with an `endo:*` discriminator. Pi's spec already accommodates extension-namespaced entries through the `custom` role.

The §canonical *adopt-the-existing-standard-with-namespaced-extension* discipline (parallel to cycle 112's `endopi-skills-markdown-format` *adopt-the-agentskills.io-spec* discipline):

- **Pi's spec is the base** — Pi defines the `header`/`message`/`compaction`/`branchSummary`/`custom` entry types.
- **`custom` is the extension point** — Pi explicitly reserves the `custom` role for *extension-namespaced entries*. Any harness can add custom entries with a discriminator.
- **Endo uses `endo:*` as the discriminator prefix** — `{type: 'custom', kind: 'endo:value', ...}` (or similar). Pi tooling ignores these entries; Endo tooling reads them.

The §discipline: *forward-compatibility via spec-reserved extension mechanism*. The §rationale: *if multiple harnesses converge on a format, joining preserves ecosystem interop while allowing per-harness extensions*. Same pattern as cycle 112's adopt-the-existing-standard.

The §Endo-specific extension content:

- **`details` slot on `toolResult`** — extra context for tool-result entries.
- **`replyTo` metadata** — Endo's reply-chain edge.
- **`value`-typed messages** (from cycle 103's `daemon-value-message`) — Endo's structured-value reply mechanism.

The §`endo:*` discriminator distinguishes these from Pi's native and other harnesses' extensions.

### §The Writer — guest-side, lazy-open, O_APPEND

The §Writer (lines 89-97):

> The writer is a guest-side concern, not a daemon-side concern. The Lal agent (or Fae) opens the file lazily on first message in a given session and appends one line per agent message. The file is mode 0600 under `$ENDO_STATE/sessions/`. On daemon restart, the file is reopened in append mode.
>
> Atomicity: the writer flushes `O_APPEND` writes; a partial line at EOF is recovered on reopen by truncating to the last `\n`. Pi takes the same approach.

The §five-discipline:

- **Guest-side, not daemon-side** — the agent (Lal/Fae) owns the writer; the daemon doesn't even know about the JSONL projection. The §discipline: *agent-level persistence concern*.
- **Lazy open on first message** — no file created for empty sessions.
- **Append one line per agent message** — each line is a complete JSON object.
- **Mode 0600** — owner-only read/write. The §discipline: *transcripts are private to the user*.
- **Reopen-in-append on daemon restart** — the writer survives restart by reopening.

The §atomicity-discipline operationalizes *append-only safety*:

- **`O_APPEND`** — writes are atomic up to the OS's write-size limit (typically the pipe buffer size). Lines that fit in one `write()` syscall are guaranteed atomic.
- **Partial-line recovery** — if a daemon crash leaves a half-written line at EOF, the next reopen *truncates to the last `\n`*. The partial line is discarded; the file remains consistent.

The §*Pi takes the same approach* observation is the *adopt-the-existing-discipline* idiom: rather than inventing a new atomicity strategy, follow Pi's. The §discipline: *consistent-format-consistent-atomicity*.

### §The two-reader pattern

The §lines 101-110:

> Two readers:
>
> 1. **The agent itself.** Lal can resume a session by reading its own JSONL file. This is the "claw uses these as a form of memory" path. Implementation: a `loadFromJsonl(path)` helper that returns the same transcript-node graph the in-memory model uses.
>
> 2. **The operator.** A new `endo session list` / `endo session show <id>` CLI verb walks `$ENDO_STATE/sessions/` and renders sessions. The files are usable with off-the-shelf JSONL tooling (`jq`, `fx`).

The §two reader audiences:

- **The agent** — uses its own past sessions as *memory*. The §discipline: *the agent has access to its own transcripts*. Implementation: `loadFromJsonl(path)` returns the same transcript-node graph the in-memory model uses, so the agent can pick up where a previous session left off.

- **The operator** — uses the CLI (`endo session list` + `endo session show`) for inspection. The §discipline: *the operator has access to all sessions in `$ENDO_STATE/sessions/`*. Additionally, *off-the-shelf JSONL tooling* (`jq`, `fx`) works because the format is *just JSONL*; no daemon-specific tools required.

The §two-audience pattern is reusable for any *file-format-with-multiple-consumers* situation. Each audience uses appropriate tooling; the §format itself is *standard JSONL* serving both.

### §The compaction interaction

The §lines 114-118:

> When [endopi-iterative-compaction](endopi-iterative-compaction.md) runs, it writes a `compaction` entry into the same file with a `firstKeptEntryId` pointer, matching Pi's shape. The full history stays in the file; the in-memory graph is rebuilt with the summary entry in place of the elided ones.

The §three-layer discipline:

- **`compaction` entry written into the same file** — no separate compaction file; the JSONL grows append-only.
- **`firstKeptEntryId` pointer matches Pi's shape** — Pi tooling can read and respect the pointer.
- **Full history stays in the file** — the elided messages are *still on disk*; the compaction summary replaces them *in the in-memory graph*. Operators can still inspect the elided messages via `cat`/`grep`/`jq`.

The §discipline: *compaction is an in-memory-graph concern, not a file-truncation concern*. The on-disk file is *immutable from compaction*; the in-memory model uses the compaction entry to skip the elided range.

The §benefit: *compaction is reversible* — if the agent decides to re-read the elided messages, they're still there. The §discipline preserves *transparent persistence not opaque database*.

### §The four-phase implementation plan

The §lines 131-138:

1. **Writer + reader for plain message entries** — sessions can be serialized, listed, and resumed from disk. No compaction yet.
2. **`custom` entries for Endo-specific message kinds** — `value` messages, daemon-side metadata.
3. **CLI verb (`endo session ...`)** — operator-side inspection.
4. **Compaction integration** — once `endopi-iterative-compaction` lands.

The §phasing matches the dependency graph: plain message entries first (the baseline), then extensions (`custom`), then operator CLI, then compaction (which depends on a sister design landing).

### §The two Open questions

**§Question 1 — location** (lines 142-147):

> Does the file live under `$ENDO_STATE/` (daemon state) or `$HOME/.pi/agent/sessions/` (Pi-compatible default)? The Pi-compatible path makes cross-harness tools work without configuration; the Endo path keeps state co-located. The default should be `$ENDO_STATE/sessions/` with an opt-in symlink or configuration for Pi compatibility.

The §design proposes a *suggested-default + opt-in compat*: default to `$ENDO_STATE/sessions/` (Endo-native location); operators wanting cross-harness compatibility can symlink or configure. The §honest acknowledgment: *the Pi-compatible path makes cross-harness tools work without configuration* — but the Endo-co-located path *keeps state co-located* with the rest of the daemon's state.

**§Question 2 — id** (lines 148-151):

> Should `id` be Pi's UUIDv7 or Endo's 256-bit formula ID? UUIDv7 keeps Pi tooling working; the 256-bit form is what the daemon already uses on `messageId`. Suggest: store both, with the Endo ID under a `endo:messageId` field.

The §suggested-resolution: *store both*. The §discipline: *don't choose between two equally-valid identifiers; carry both with one in the standard slot and the other in an extension slot*.

The §rationale: Pi tooling reads `id` (expecting UUIDv7); Endo tooling reads `endo:messageId` (the 256-bit form). Both work; no info lost.

### §The Pi-mono citation discipline

The §lines 155-158 cite four Pi-mono files:

- **`packages/coding-agent/docs/session-format.md`** — Pi's own session-format documentation.
- **`packages/coding-agent/src/core/session-manager.ts`** — Pi's session manager implementation.
- **`packages/coding-agent/src/core/messages.ts`** — Pi's message types.
- **`packages/ai/src/types.ts`** — Pi's AI-message types.

The §discipline (introduced in cycle 112's `endopi-skills-markdown-format`): *cite the reference implementation*. The §design doesn't re-document Pi's format; it points to Pi's docs + Pi's TypeScript types. A future Endo implementer reads Pi's files to understand the canonical shape.

The §pattern repeats across endopi-* designs: *adopt Pi's format, cite Pi's reference implementation, extend via spec-reserved extension points*.
