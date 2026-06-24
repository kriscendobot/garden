---
ts: 2026-06-02T19:36:50Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--6fff5f
kind: result
cycle: 122
---

# Cycle 122 — endopi-edit-tool.md (Kris Kowal, endo-but-for-bots) — third endopi-* spinout

Ingested `designs/endopi-edit-tool.md` (122 lines, *Proposed* status,
Parent: endopi.md) from `endojs/endo-but-for-bots@f4a9dc6d` (branch
`origin/llm`). **Twenty-second-comment-style design ingest.** One
cohesion-honest section:

- **llm-friendly-edit-by-replacement-with-unique-match-and-line-
  ending-preservation** — adopts Pi's edit-by-replacement tool
  (modeled on `coding-agent/src/core/tools/edit.ts`) as a method
  on the *File* capability (not Dir) — consistent with
  `Dir.lookup(name) → File` data-flow chain. Four Pi-borrowed
  semantic invariants: **unique-match required** (multi-match
  returns error; *the agent must add disambiguating context* —
  the canonical contract-not-heuristic discipline); no overlap
  between edits in one call; **line-ending preservation**
  (normalize to LF for matching + restore on write + BOM
  preserved); structured diff in tool result. **The most
  structurally interesting move**: §File-mutation queueing —
  Pi's explicit `file-mutation-queue.ts` is *unnecessary in
  Endo* because *eventual-send semantics already serialize per
  capability if all writes go through one exo*; §caveat the
  *single-await-per-method discipline* against TOCTTOU (same
  concern cycle 118's exo-tools.js raised for context lookup).

## Why one section

The 122-line argument hangs off one structural claim: *adopt Pi's
edit-by-replacement primitive as a method on the File capability,
with unique-match required and line-ending preservation*. Splitting
would manufacture boundaries the document refuses to maintain.

## Family arc progress

The endopi-* family is now at **4/8 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md` (markdown skill
  format spinout)
- cycle 117 — `endopi-jsonl-transcript-format.md` (JSONL
  transcript format spinout)
- cycle 121 — `endopi.md` (family keystone)
- **cycle 122 (this cycle)** — `endopi-edit-tool.md` (first
  spinout from cycle 121's keystone-named-list)

Five spinouts remain: `endopi-extension-package-manifest` /
`endopi-iterative-compaction` / `endopi-prompt-templates` /
`endopi-provider-registry-and-oauth` /
`endopi-stdio-rpc-bridge`.

## Rotation note

Cycle 122 was nominally **chat-lane** (chat-lane exhausted at
20/20). Papers-lane has been blocked for **16+ consecutive cycles**.
Cycle 122 continued the designs-lane work — picking a *short,
focused follow-on* (122 lines) to balance the prior two heavyweights
(cycle 119's 526-line capability-bus + cycle 121's 583-line endopi
keystone).

## Counts

- 625 → **626** sections (+1).
- 166 → **167** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — third
  endopi-* row in this topic).
- Keywords index extended with ~28 edit-tool-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 123 wakes in 1500s. Rotation lands on **comments-lane**
nominally. Expect more @endo/patterns or @endo/marshal source
material, or another endopi-* spinout if comments-lane is sparse.
