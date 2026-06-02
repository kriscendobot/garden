---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
---

# LLM-friendly edit-by-replacement with unique-match and line-ending preservation

> *LLM-driven coding agents perform most of their file mutations as
> "replace this exact string with this other string" rather than as
> whole-file writes. Whole-file `write` either truncates unintended
> content or forces the model to re-emit the entire file, which is
> token-expensive and error-prone for large files. The dominant
> solution across modern coding harnesses (Claude Code, Codex, Pi,
> Cursor) is an *edit* tool with two arguments: `oldText` (a unique
> snippet to replace) and `newText` (the replacement), with optional
> batching of multiple edits per call.*
>
> — `designs/endopi-edit-tool.md` §Motivation

`endopi-edit-tool.md` (122 lines, *Proposed* status, created
2026-05-15) is the *third endopi-* design ingested and the first of
the six unindexed endopi-* spinouts named by cycle 121's
family-keystone ingest. Parent: `endopi.md`. The design closes the
specific gap surfaced in §Feature-by-Feature Mapping §Built-in tool
core: *Endo's `daemon-agent-tools` design lists `readFile` and
`writeFile` but no edit-by-replacement primitive*, and
*[cli-edit-verb](cli-edit-verb.md) is the human-on-CLI shape
(hashline patches), not the shape LLMs use today*.

## The Pi-borrowed semantics, on the `File` capability rather than
`Dir`

The §Tool surface shows the `M.interface` guard:

```js
const editSchema = M.interface('EditTool', {
  edit: M.callWhen(
    M.string(),                     // file pet name / path within Dir
    M.arrayOf(
      M.splitRecord({
        oldText: M.string(),        // unique match
        newText: M.string(),
      }),
    ),
  ).returns(M.record()),            // { applied, diff, conflicts }
});
```

Two structurally interesting moves:

1. **`M.arrayOf(M.splitRecord({oldText, newText}))` over the
   parameter type.** Multiple edits per call, each a (oldText,
   newText) pair. The §Open questions section debates *single vs
   array* — *Pi accepts both shapes (`oldText`/`newText` for one,
   `edits[]` for many). Following Pi reduces friction for migrating
   prompts; the alternative is two separate tools (`edit`,
   `multi-edit`).*

2. **The `edit` tool is a method on `File` capability, not on
   `Dir`.** The §Capability shape rationale is consistent with the
   rest of `daemon-agent-tools` (cycle 107): `Dir.lookup(name) →
   File`, then `File.edit(edits)`. The granularity is per-file, not
   per-directory; the cap chain mirrors the data-flow chain.

## The four Pi-borrowed semantic invariants

The §Semantics borrowed from Pi lists four hard rules:

- **Unique-match required.** If `oldText` matches more than once in
  the file, the tool returns an error naming the conflict; *the
  agent must add disambiguating context*. Pi's
  `applyEditsToNormalizedContent` enforces this. The §canonical
  failure mode for ambiguous edit attempts is *not* silent first-
  match; it's an error that pushes the agent to refine.

- **No overlap between edits in one call.** Concurrent edits in a
  single call must not target overlapping byte ranges; conflicts
  are returned as a structured error. Together with the unique-
  match rule, this means *each edit in a multi-edit call is
  unambiguous on the post-prior-edit text*.

- **Line-ending preservation.** The tool *normalizes to LF for
  matching*, then *restores the file's original line endings*
  (`detectLineEnding`, `restoreLineEndings`) when writing. BOM is
  preserved if present. Match and write happen in different
  encodings; the algorithm never "fixes" the file's line endings
  as a side effect.

- **Structured diff in the tool result.** The tool returns a unified
  diff of the applied changes. *The Chat UI renders it inline; the
  LLM sees it as confirmation.* The diff is the same in both
  rendering channels.

## The unique-match-required failure mode is the most consequential
discipline

*Unique-match required* is the design's central capability-shape
choice. Modern LLM agents are good at finding *almost*-unique
snippets; the failure mode where an `oldText` matches twice and
the tool silently edits the first match is the source of most
LLM-edit bugs. Pi's approach (and now Endo's) is to *fail loudly*
and force the agent to add context. The contract is *contract not
heuristic* — the same discipline cycle 116's `daemon-form-request`
applied to fields: *patterns are a contract, not a hint*.

## File-mutation queueing — *eventual-send semantics already
serialize*

The §File-mutation queueing subsection is the most structurally
interesting *what-Pi-does-Endo-doesn't-need-to-do* observation:

> *Pi serializes edits/writes to the same file through a queue
> (`file-mutation-queue.ts`) so concurrent tool calls cannot
> interleave mid-write. Endo's eventual-send semantics already
> serialize per capability if all writes go through one exo;
> explicit queueing is unnecessary as long as the tool
> implementation does not split read-modify-write across multiple
> awaits without holding a lock.*

This is the *Endo-already-has-this-discipline-structurally* move
visible in cycle 121's family keystone: the comparative-mapping
mode keeps explicit Pi mechanisms only where Endo lacks an
equivalent structural property. Eventual-send + exo-per-File makes
the queue redundant — *one capability serializes its own writes by
construction*.

The §caveat is the *single-await-per-method discipline*: as long
as the implementation doesn't split read-modify-write across
multiple awaits without holding a lock, the per-capability
serialization holds. That's the same TOCTTOU concern cycle 118's
exo-tools.js raised for context lookup (*Get the context after all
waiting in case we ever do revocation by removing the context
entry. Avoid TOCTTOU!*).

## Three open questions, with Pi's choice as default

The §Open questions section names three:

1. *Single (`oldText`, `newText`) vs array of pairs?* Pi accepts
   both; follow Pi to reduce migration friction for prompts.

2. *Where does the diff land in the agent transcript? As a
   `toolResult` text block (consistent with Pi) vs. a structured
   value-message attachment?* The §value-message reference points
   back to cycle 103's `daemon-value-message` — the design hasn't
   chosen yet but the alternatives are well-defined.

3. *Does `oldText` need to support regex?* The §design answer:
   *Pi declines; Endo should match Pi's choice (regex multiplies
   the prompt-injection surface).* The same *minimal-surface-for-
   prompt-injection-resistance* discipline that cycle 107's
   daemon-agent-tools applied to shell-command argument arrays
   (no shell expansion).

## Two Pi-source citations, file-level

The §Citation section names two files in `badlogic/pi-mono`:

- `packages/coding-agent/src/core/tools/edit.ts` (Pi's edit tool
  wiring)
- `packages/coding-agent/src/core/tools/edit-diff.ts`
  (`applyEditsToNormalizedContent`, `computeEditsDiff`)

The file-level citation discipline (also visible in cycle 121's
endopi.md family keystone with 33 file-level citations) lets the
reader read Pi's reference implementation directly.

## Dependencies — Endo half of the equation

The §Dependencies table names three related Endo designs:

| Design | Relationship |
|--------|--------------|
| `daemon-capability-filesystem` | Provides `File` capability |
| `daemon-agent-tools` (cycle 107) | Sibling tool surface (read, write, exec) |
| `cli-edit-verb` | Different consumer (human, hashlines), shares helper code |

The implementation note adds:

- *Reuse the byte-level helpers from `packages/daemon` rather than
  importing Pi's TS verbatim; the algorithm is small and
  well-defined.*
- *Pi's edit tool exposes a render-side preview (`renderDiff`) in
  its TUI; Endo's equivalent lives in the Chat UI, on the existing
  diff-rendering path.*

The reuse-don't-import-Pi-TS choice is consistent with cycle 121's
*adopt Pi's developer-velocity moves without giving up Endo's
multi-agent-system shape*: the *algorithm* migrates, the *code* is
re-implemented for the Endo substrate.

## Related sections

- cycle 121
  [[endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts]]
  — the family keystone that names this design as the
  §Built-in tool core gap-closer.
- cycle 107
  [[endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-and-git-as-claw-like-agent-capabilities]]
  — *daemon-agent-tools* — sibling tool surface (read/write/exec)
  that this design extends with `edit`.
- cycle 116
  [[endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation]]
  — *patterns are a contract, not a hint* — the same
  *contract-not-heuristic* discipline that this design's
  unique-match rule embodies.
- cycle 118
  [[endo-but-for-bots--llm-designs-endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling]]
  — the *single-await-per-method discipline* TOCTTOU caveat that
  the §File-mutation queueing analysis depends on.
