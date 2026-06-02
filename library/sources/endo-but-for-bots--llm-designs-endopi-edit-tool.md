---
source: designs/endopi-edit-tool.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f4a9dc6d13234bc5a8b6c8642b3082d5d8a488d8
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Third endopi-* design ingest (after cycle 112's
  endopi-skills-markdown-format, cycle 117's
  endopi-jsonl-transcript-format, and cycle 121's family-keystone
  endopi.md). The 122-line *Proposed* design (Parent: endopi.md)
  closes the §Feature-by-Feature Mapping §Built-in tool core gap
  named by the family keystone: *Endo's daemon-agent-tools design
  lists readFile and writeFile but no edit-by-replacement
  primitive*.

  Tight cohesion-honest one-section count. The whole 122-line
  argument hangs off one structural claim: *adopt Pi's
  edit-by-replacement primitive as a method on the File
  capability, with unique-match required and line-ending
  preservation*.

  Three structurally interesting moves:
    (1) `M.arrayOf(M.splitRecord({oldText, newText}))` parameter
        shape — multiple edits per call as ordered array; following
        Pi's both-shapes acceptance reduces migration friction;
    (2) The `edit` tool is a method on the *File* capability (not
        on the Dir) — consistent with `Dir.lookup(name) → File` +
        `File.edit(edits)` data-flow chain;
    (3) Four Pi-borrowed semantic invariants: *unique-match
        required* (multi-match returns error, agent must
        disambiguate); *no overlap between edits in one call*;
        *line-ending preservation* (normalize to LF for matching,
        restore on write, BOM preserved); *structured diff in
        tool result* (Chat UI renders; LLM sees as confirmation).

  Single most structurally interesting move: the §File-mutation
  queueing observation — Pi serializes edits/writes to the same
  file through a queue (`file-mutation-queue.ts`); Endo's
  eventual-send semantics *already serialize per capability if
  all writes go through one exo*. The §caveat is the
  *single-await-per-method discipline* against TOCTTOU — same
  concern cycle 118's exo-tools.js raised for context lookup
  (*Get the context after all waiting ... Avoid TOCTTOU!*).

  Three Open questions resolve per *follow Pi to reduce migration
  friction* discipline:
    (1) single vs array — Pi accepts both; follow.
    (2) diff in transcript as toolResult text block (Pi) vs
        structured value-message attachment — undecided.
    (3) regex support — *Pi declines; Endo should match Pi's
        choice (regex multiplies the prompt-injection surface)*.

  Two file-level Pi citations:
  packages/coding-agent/src/core/tools/edit.ts (Pi's edit tool
  wiring) + packages/coding-agent/src/core/tools/edit-diff.ts
  (`applyEditsToNormalizedContent`, `computeEditsDiff`).

  The §reuse-don't-import-Pi-TS-verbatim implementation note is
  the architectural-discipline echo of cycle 121's *adopt Pi's
  developer-velocity moves without giving up Endo's multi-agent-
  system shape*: algorithm migrates; code is re-implemented.

  Cycle 122 was nominally chat-lane (chat exhausted at 20/20);
  pivoted to designs-lane. Papers-lane has been blocked for 16+
  consecutive cycles. Endopi-* family now at 4/8 ingested
  (keystone + skills-markdown-format + jsonl-transcript-format +
  edit-tool); 4 spinouts remain (extension-package-manifest /
  iterative-compaction / prompt-templates / provider-registry-
  and-oauth / stdio-rpc-bridge — six initially named by the
  keystone, minus this cycle's edit-tool, minus prior cycles 112
  + 117).
---

> Abstract: `endopi-edit-tool.md` proposes adding an `edit` tool to
> Lal and Fae as a method on the `File` capability, modeled on Pi's
> `packages/coding-agent/src/core/tools/edit.ts`. The §Tool surface
> takes a file pet name / path plus an array of `{oldText, newText}`
> records and returns `{applied, diff, conflicts}`. *Unique-match
> required*: if `oldText` matches more than once, the tool returns
> an error and the agent must add disambiguating context. *No
> overlap between edits in one call*. *Line-ending preservation*
> via normalize-to-LF-for-matching + restore-on-write (BOM
> preserved). *Structured diff in tool result* — same diff rendered
> by Chat UI and seen by LLM as confirmation.
>
> The §File-mutation queueing observation is the most structurally
> interesting move: Pi's explicit `file-mutation-queue.ts` is
> *unnecessary in Endo* because *eventual-send semantics already
> serialize per capability if all writes go through one exo*. The
> caveat: the implementation must not split read-modify-write across
> multiple awaits without holding a lock (the TOCTTOU concern from
> cycle 118's exo-tools.js applied to a different surface).
>
> The §Open questions resolve per the *follow Pi to reduce migration
> friction* discipline: single-vs-array accepts both (Pi shape); diff
> placement undecided; regex support declined (Pi's choice; *regex
> multiplies the prompt-injection surface*).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation](../sections/endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation.md) | agent-conventions | current |

Tight 122-line design. The whole argument hangs off one structural
claim (*adopt Pi's edit-by-replacement primitive as a method on the
File capability, with unique-match required and line-ending
preservation*); the cohesion-honest count is one.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@f4a9dc6d` (the
  branch `origin/llm`) via the local bare-clone.
- Last touched 2026-05-15 by endolinbot in commit `f4a9dc6d`.
- Status: *Proposed*. Parent: `endopi.md` (cycle 121's family
  keystone).
- **Twenty-second-comment-style design ingest.** Pairs with cycles
  112 + 117 + 121 to advance the endopi-* family to 4/8 ingested.
- Cycle 122 was nominally **chat-lane** (cycle 121 was a designs-
  lane pivot). Chat-lane is **exhausted** (20/20 upstream designs
  ingested). Papers-lane has been blocked for **16+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 122
  continued the designs-lane work — picking a *short, focused
  follow-on* (122 lines) to balance the prior two heavyweights
  (cycle 119's 526-line capability-bus + cycle 121's 583-line
  endopi keystone).
- Cohesion-honest one-section count.
