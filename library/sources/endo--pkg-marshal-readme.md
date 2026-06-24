---
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 7
status: current
---

> Abstract: The @endo/marshal package README. Covers the marshal API surface (makeMarshal, toCapData, fromCapData), the frozen-objects-only invariant, the smallcaps wire-format extensions beyond JSON, the pass-by-presence vs pass-by-copy distinction, the convertValToSlot/convertSlotToVal capability-bridging callbacks, and marshal's usefulness as a direct JSON replacement even outside capability contexts.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--pkg-marshal-readme--overview.md) | marshal, pass-style | current |
| [usage](../sections/endo--pkg-marshal-readme--usage.md) | marshal, pass-style | current |
| [frozen-objects-only](../sections/endo--pkg-marshal-readme--frozen-objects-only.md) | marshal, pass-style, hardened-javascript | current |
| [beyond-json](../sections/endo--pkg-marshal-readme--beyond-json.md) | marshal, pass-style | current |
| [pass-by-presence-vs-copy](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md) | marshal, pass-style, capability-security | current |
| [convert-val-slot](../sections/endo--pkg-marshal-readme--convert-val-slot.md) | marshal, pass-style, captp | current |
| [alternative-to-json](../sections/endo--pkg-marshal-readme--alternative-to-json.md) | marshal, pass-style | current |

## Provenance

- File last modified 2024-02-05 by Richard Gibson; substantive earlier edits by Kris Kowal.
- Captured at endo file-specific commit `70bcca3d`.
- The trailing "# As a direct alternative to JSON" H1 was kept as its own section (rather than folded into overview) because it is a substantive standalone use case for the package, not a frame.

Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md).
