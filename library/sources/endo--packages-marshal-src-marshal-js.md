---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "47-409"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "makeMarshal constructor rationale clusters: error-diagnostic-priority (rather-send-it-anyway + no-stack + errorId-correlation + late-addition-tolerance), slot-typing-security-hazard (the under-typed remotable-vs-promise wire encoding and the implementation restriction that mitigates it per agoric-sdk#4334), and dual-format-body-discriminator (the `#` JSON-illegal sentinel + 'ontogeny recapitulates phylogeny' default-to-capdata backward-compat)"
source_authors: [Mark S. Miller, Turadg Aleahmad, Kris Kowal, Richard Gibson, Mathieu Hofman, Michael FIG]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  Fourth comment-fragment ingest (cycle 74), following the
  cycles 66 (`handled-promise.js`), 69 (`encodeToSmallcaps.js`),
  and 71 (`passStyleOf.js`) precedents. Three sections distilled
  from rationale comments scattered across the `makeMarshal`
  constructor that together address three cohesive arguments:
  (1) the diagnostic-priority rule for errors (send the salvage
  even when not Passable; deliberately omit the stack; allocate
  errorId for local-to-remote correlation; ratchet new error
  fields through decoder-first then encoder-second), (2) the
  slot-typing security hazard (the wire encoding cannot
  distinguish remotable from promise; the capdata implementation
  restriction routes both decoders to the same function while
  agoric-sdk#4334 stays open), and (3) the dual-format coexistence
  mechanism (`#` first-byte JSON-illegal sentinel discriminates
  smallcaps from capdata in a single `fromCapData` entry point;
  capdata remains the default per "ontogeny recapitulates
  phylogeny" backward-compat). The comments are short and
  scattered rather than long and clustered (cycle 71's cohesion-
  over-density lesson applied): each section pulls together
  multiple discrete comment blocks that together form one
  cohesive argument cluster.
---

## Abstract

`packages/marshal/src/marshal.js` is the home of `makeMarshal`,
the user-facing factory that returns the `{toCapData, fromCapData,
serialize, unserialize}` pair the rest of the Endo ecosystem
calls. Its 421 lines mix structural code (option destructuring,
slot encoding/decoding, format dispatch) with shorter rationale
comments at decision points. The comments do not form one
multi-paragraph cluster (as `handled-promise.js`'s do); they form
three cross-cutting *argument clusters*, each spanning several
discrete comment blocks at different points in the file. This
ingest distills those three clusters into three section files:

- **Error diagnostic priority** (sections of the
  `encodeErrorCommon`, `encodeErrorToCapData` and
  `decodeErrorCommon` functions): why marshal sends Errors even
  when the Error is not itself Passable, deliberately omits the
  stack to keep it Vat-local, allocates a per-send `errorId` to
  enable privileged correlation between a redacted summary and
  the local stacktrace via `marshalSaveError`, and how new error
  fields (`cause`, `errors`, `errorId`) ratchet through
  decoder-tolerance-first then encoder-emission-second.
- **Slot-typing security hazard** (the `TODO SECURITY HAZARD`
  comment on `decodeSlotCommon` and the matched
  `decodeRemotableOrPromiseFromCapData` implementation
  restriction): the wire encoding cannot distinguish a remotable
  slot from a promise slot (capdata produces identical shape;
  smallcaps prefixes diverge but the kind doesn't reach
  `convertSlotToVal`), so marshal routes both decoder slots to
  the same handler and trusts the application's slot-table to
  carry the kind, with agoric-sdk#4334 tracking the long-term
  fix.
- **Dual-format body discriminator** (the `#`-prefix encoder
  comment + the `#`-prefix decoder comment + the
  "ontogeny recapitulates phylogeny" capdata default): how the
  JSON-illegal `#` first-byte sentinel lets a single
  `fromCapData` entry point decode either wire format
  transparently while encoders pick one per call, and why the
  default `serializeBodyFormat` remains the historically-first
  `'capdata'` for backward compatibility.

The three clusters are *load-bearing* in different senses: error
diagnostic priority is the policy rule that downstream tooling
(audit sinks, distributed-tracing systems, panel reviewers) builds
on; the slot-typing hazard is the open work item that constrains
how peer-side validation gets written; and the dual-format
discriminator is the migration substrate that lets the smallcaps
rollout proceed peer-by-peer rather than fleet-wide.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [error-diagnostic-priority](../sections/endo--packages-marshal-src-marshal-js--error-diagnostic-priority.md) | marshal, errors, capability-security | current |
| [slot-typing-security-hazard](../sections/endo--packages-marshal-src-marshal-js--slot-typing-security-hazard.md) | marshal, capability-security, captp | current |
| [dual-format-body-discriminator](../sections/endo--packages-marshal-src-marshal-js--dual-format-body-discriminator.md) | marshal, captp, ocapn | current |

## Provenance

- File last modified 2026-04-06 by Turadg Aleahmad (`refactor(types): resolve exactOptionalPropertyTypes errors`).
- File-specific commit `da16a78e` (captured 2026-05-29).
- Comments authored across the file's history by Mark S. Miller (15 commits), Turadg Aleahmad (14), Kris Kowal (3), Richard Gibson (2), Mathieu Hofman (2), and Michael FIG (1). The `errorIdNum` "Temporary hack" TODO cites agoric-sdk#2780; the `decodeErrorCommon` capData-string-transform comment cites endojs/endo#2052; the `decodeRemotableOrPromiseFromCapData` implementation restriction cites agoric-sdk#4334; the post-`assertPassable` comment in `fromCapData` cites agoric-sdk#4337 ("which should be considered fixed once we've completed the switch to smallcaps").

## See also

- [`endo--packages-marshal-src-encodetosmallcaps-js`](endo--packages-marshal-src-encodetosmallcaps-js.md) — sibling source for the smallcaps encoder that `makeMarshal` calls into for the smallcaps branch. Both sources together cover marshal's wire-format rationale; this one covers the *constructor-level* decisions (defaults, dual-format dispatch, error policy, slot-table contract), the sibling covers the *encoding-internal* decisions (sigil scheme, canonicality, error root special case).
- [`endo--pkg-marshal-readme`](endo--pkg-marshal-readme.md) — the marshal README's user-facing framing; this source is the rationale layer below it.
- [`endo--pkg-marshal-docs-smallcaps-cheatsheet`](endo--pkg-marshal-docs-smallcaps-cheatsheet.md) — quick reference for the wire format.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js) at commit `da16a78e`.
