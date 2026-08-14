---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-14T09:21:47Z
---
---
kind: result
role: purist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Panel seat `purist` on endojs/endo-but-for-bots#796 (hashline pure core), diff base `origin/llm`.

### purist

**Verdict:** request-changes

**Findings:**

- **must-fix** `packages/daemon/src/hashline.js:812-825` -- reapply relocates `anchor` and `anchorEnd` **independently**, and the only post-relocation guard is inversion. When one endpoint drifts and the other does not, the consumed span silently grows to cover lines the agent never anchored. Verified by execution: live `keep0\nfoo\nkeep1\nkeep2\nbar\n`, patch `replace-range 4#<foo>..5#<bar>` with `reapply: true` returns `success: true`, `newText: "keep0\nFOOBAR\n"` -- `keep1` and `keep2` destroyed, `relocations: [{line:4,relocatedTo:2}]` the only hint. The module's own contract (hashline.js:625) says only anchored lines are consumed. Relocate a range only when every anchor moves by the same delta; otherwise fail `ambiguous-reapply`/`hash-mismatch`. [proposed-rule: a bounded anchor-relocation search must never change the size of the span an operation consumes]

- **should-fix** `packages/daemon/src/hashline.js:94-108` -- the module's `EditResult` reuses the name of the design's boundary-crossing result (`designs/cli-edit-verb.md` § Result shape) and adds `newText`, the whole file, guarded only by the prose "must not forward it across the capability boundary". A comment is not a boundary. Return `{ result, newText }` (or name the internal type `EditOutcome`) so the shape that reaches the agent structurally cannot carry file content the agent may not be authorized to read. [rule: roles/jurors/purist/AGENT.md § Side-channel closure, § Type-vs-value namespace separation]

- **should-fix** `packages/daemon/src/hashline.js:200-205` -- the blank-line anchor **substitutes** the line number for the content rather than seeding the hash with it, so the seed shares a preimage space with real content: `lineAnchorHash('3', 3, 2) === lineAnchorHash('', 3, 2) === '9b'` (verified). Content `"N"` at line N is indistinguishable from a blank line N in the rendered view and, under reapply, in the candidate scan. Domain-separate the seed. Design (§ Hash algorithm specification) says "seed the hash with the line number", which the code does not do. [rule: designs/cli-edit-verb.md § Hash algorithm specification]

- **should-fix** `packages/daemon/src/hashline.js:638-655` -- inconsistent treatment of one options family: `reapplyWindow` is integer/range-validated and **throws**, while `reapply` is accepted as any truthy value (`reapply: 'false'` enables relocation). Both are caller-supplied across the eventual-send boundary per the design's `E(guest).edit(dir, path, patch, options)`. Validate `reapply` as a boolean, and return a `patch-syntax` failure rather than throwing, so the mount layer's error surface is uniform. [rule: AGENTS.md § Code style -- strong runtime safety at the Exo boundary and at a parser's input edge]

**Notes (out of scope but worth flagging):**

- `packages/daemon/src/hashline.js:969-971` -- two ops anchored on the same line that both relocate emit duplicate `AnchorRelocation` records (the map is keyed by anchor object identity), and the report sorts by `relocatedTo` rather than the authored `line` the caller knows. Dedupe and sort by `line`. [proposed-rule: a relocation report is keyed by what the caller authored, not by where it landed]
- Family asymmetry inherited from the design, not introduced here: `replace`/`replace-range` are separate discriminants while a ranged `delete` reuses `delete` with an optional `anchorEnd` (hashline.js:330). Either arity discriminates for both or neither; worth settling before the wire contract freezes. [rule: roles/jurors/purist/AGENT.md § Family-consistency across related symbols]
- Clean on the seat's other axes: `@endo/errors` (`makeError`/`q`/`X`) throughout with no hand-rolled `insist`, every named export hardened, module-level `EDIT_OP_KINDS` hardened at declaration, injected `sha256Hex` keeps the module pure, no `node:path` math.

Self-improvement: nothing this time.
