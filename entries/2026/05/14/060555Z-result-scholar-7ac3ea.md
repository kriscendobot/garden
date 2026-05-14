---
ts: 2026-05-14T06:05:55Z
kind: result
role: scholar
project: ocapn
refs:
  - entries/2026/05/14/055602Z-message-liaison-e60127.md
---

# Sixteenth scholar cycle — OCapN Model.md (the data-model overlap)

User-prioritized cycle. The maintainer flagged the upstream protocol's Model.md as having direct overlap with the in-Endo passable data model and asked the scholar to pick it up soon. This cycle does that.

## Cycle work

| Source | Decision | Sections |
|--------|----------|----------|
| `draft-specifications/Model.md` (kriscendobot/ocapn @ `971eadd1`) | INGEST | 11 |

11 sections cover: overview, value-and-atom-frame, atom-types (8 atoms consolidated), 3 container types (list/struct/tagged), 2 reference types (target/promise), error, pass-invariant, json-invariants.

## Consolidation: cross-references inline

Per the redirected loop task (each cycle does one consolidation action), this cycle's action is **eleven** cross-references — one per section — embedded as `notes:` fields in the section frontmatter. Each OCapN Model section's notes name the corresponding Endo realization. The full mapping:

| OCapN section | Endo realization (cross-referenced) |
|---------------|-------------------------------------|
| overview | library/topics/pass-style.md |
| atom-types | endo--pkg-pass-style-readme--pass-styles; endo--pkg-marshal-readme--beyond-json |
| container-list | endo--pkg-pass-style-doc-copyarray-guarantees |
| container-struct | endo--pkg-pass-style-doc-copyrecord-guarantees (with symbol-vs-string-key disagreement flagged) |
| container-tagged | endo--pkg-pass-style-readme--maketagged |
| reference-target | endo--pkg-marshal-readme--pass-by-presence-vs-copy; endo--pkg-marshal-readme--convert-val-slot |
| reference-promise | endo--pkg-eventual-send-readme--handled-promise; endo--pkg-eventual-send-readme--e-when |
| error | endo--docs-errors--hiding-revealing-distributed-diagnostic |
| pass-invariant | endo--pkg-pass-style-doc-copyarray-guarantees; copyrecord-guarantees; endo--pkg-marshal-readme--frozen-objects-only |
| json-invariants | endo--pkg-marshal-readme--beyond-json; endo--pkg-marshal-docs-smallcaps-cheatsheet |

The source-index page also lists three **disagreements worth maintainer attention**:
1. **Integer/Float64 split**: OCapN distinguishes; Endo merges into JS number+bigint.
2. **Struct key types**: OCapN uses Symbols; pass-style copyRecord uses strings.
3. **Promise resolution semantics**: OCapN spec includes wire-level fulfilled/rejected/resolved-to-remote; Endo's HandledPromise matches in shape but the wire-level details may not be 1:1.

These are not contradictions in the soft-flag sense (different shapes serving different audiences). They are real semantic differences between the spec and the implementation. Worth a separate `message` to liaison if the maintainer wants formal flagging.

## Files written

- 11 sections under `library/sections/ocapn--draft-specifications-model--*.md`
- 1 source-index at `library/sources/ocapn--draft-specifications-model.md` with the disagreement summary
- Topic-page updates: ocapn (+11, now 13), pass-style (+9, now 37), marshal (+10, now 25), captp (+2, now 14), capability-security (+2, now 22), eventual-send (+1, now 25), errors (+1, now 16)
- Master index updates
- This result entry

## Library state

- **162 sections** from **25 source documents**
- First non-endojs source ingested (kriscendobot/ocapn fork holding the upstream protocol spec)
- 5 OCapN spec docs remaining in the inbox: Notation, Locators, Netlayers, CapTP Specification, README
- Plus 6 endo asks from cycle 15 still queued

## Engagement-rule compliance

This cycle's writes use `source_repo: kriscendobot/ocapn` (the fork) per `journal/projects/ocapn/README.md` § Rules of engagement. Abstracts and bodies are specific (internal journal). The result-entry text uses "the upstream protocol" oblique phrasing in some places; per the project rules, this is a soft preference for outward-facing artifacts and the journal is internal.

## Inbox state

Remaining: 5 OCapN spec docs + 6 endo asks from cycle 15. Active mode continues.

## Self-improvement

The per-section inline cross-reference pattern (notes: pointing at matching sections in the other partition) is highly effective for cross-source-spec material like this. Worth promoting to a standing pattern in conventions.md: when ingesting material that mirrors or extends an already-ingested source's content, the per-section notes should explicitly cross-reference. The cycle 15 soft-flag convention update covers the general case; an additional note specifically about cross-source-mirror pairs would tighten it further. Routing as a passing observation.
