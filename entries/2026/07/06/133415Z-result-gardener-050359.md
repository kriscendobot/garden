---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-06T13:34:17Z
---
role: scholar
job: scholar-ingest-dialog-db

# First-pass ingest of dialog-db/dialog-db into the library

Faithful first pass of `dialog-db/dialog-db` (Irakli Gozalishvili's embeddable
local-first database) as a high-signal aligned design reference. All five sources
at repo HEAD `f777fe7c` (default branch `main`, file-specific commit
`f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53`, 2026-07-05). No prior dialog sources
existed (fresh host); `dialog-db--` is a new, deliberate source-slug prefix.

## Sources ingested (5 sources, 22 sections)

- `dialog-db--readme` (README.md) — 1 section: overview.
- `dialog-db--notes-architecture-overview` (notes/architecture overview.md) — 9
  sections: overview/design-goals, facts-as-atomic-units, causal-temporal-model,
  schema-on-query, merkle-crdt-merge-semantics, probabilistic-btrees-and-segments,
  eav-aev-vae-indexing, blob-store-and-mutable-pointers, datalog-query-language.
- `dialog-db--notes-concept` (notes/concept.md) — 4 sections:
  claims-and-the-semantic-layer, attributes-and-concepts,
  bidirectional-mapping-assert-retract-query, schema-on-read-and-rules.
- `dialog-db--notes-capability-sysstem` (notes/capability-sysstem.md — upstream
  filename typo preserved for path-idempotency) — 4 sections: overview,
  subject-ability-policy, effects-and-providers, proposed-capabilities.
- `dialog-db--notes-privacy` (notes/privacy.md) — 4 sections: tiered-access-levels,
  ucan-authorization-model, tiered-encryption-implementation,
  privacy-efficiency-tradeoffs.

## Topics

New (genuinely new domains, not bent onto the endo taxonomy):
- `datalog-query` — Datalog over `{the, of, is, cause}` fact-triples + the
  attribute/concept schema-on-read semantic layer + EAV/AEV/VAE indexes (10 rows).
- `local-first-sync` — local-first ownership + replica sync: causal temporal
  model, Merkle-CRDT query-time merge, Prolly-tree deterministic layout,
  blob-store + DID:key CAS pointer decoupling (8 rows).
- `ucan-authorization` — UCAN/did:key `subject x command x policy` delegation
  tokens for effects and the L0-L3 privacy tiers (8 rows).

Reused (rows added, cross-referencing endo where concepts meet):
- `capability-security` (+5 rows) — the ocap/UCAN capability system + UCAN
  authorization model; cross-linked to endo's ocap practice.
- `content-addressed-storage` (+3 rows) — Prolly trees + segments, blob store +
  DID:key pointer, the Archive capability; cross-linked to kriskowal/cask as a
  peer content-addressed-Merkle store.
- `change-propagation` (+2 rows) — causal temporal model + Merkle-CRDT merge.

## Concepts / keywords

6 new concept pages: `dialog-db`, `fact-triple`, `prolly-tree`, `merkle-crdt`,
`schema-on-read`, `ucan-delegation`. Added to `concepts/README.md`; 24 keyword
lines added to `keywords.md`.

## Cross-references to endo (per the aligned-design framing)

Curated as a peer design worth reading closely, with explicit bridges: dialog's
UCAN capability model as the offline-token form of endo's object-capability
delegation (attenuated, unforgeable, environment-provided authority ~ endowments);
its content-addressed Prolly-tree + blob store beside kriskowal/cask and endo
`persistence` (content-hash vs formula-identity keying); its Archive/Memory
capability split as the capability form of the blob-store + mutable-pointer
decoupling. See-also links added across the new topic and concept pages.

## Integrity gate (step 8) — PASS

- `library-link-check.sh --source-slug` for all 5 dialog sources: OK.
- `library-link-check.sh --files` over the 3 new + 3 touched topic pages, 6
  concept pages, and the sources/topics/concepts README indexes: OK.
- `regenerate-topics-counts.sh --check`: stale by 6 rows pre-regeneration
  (my 6 touched topics), reconciled in step 9; no missing topic page.

## Regenerated projected indexes (step 9)

- `regenerate-sections-index.sh`: landed `sections/README.md` (projected the 22
  new section files).
- `regenerate-topics-counts.sh`: landed `topics/README.md` counts; re-check now
  reports counts current.

## Follow-on

Posted `scholar-ingest-dialog-db-remainder` to the board naming exactly what is
left: the ~26 remaining `notes/` design docs (notation.md flagged as its own full
cycle at ~1713 lines), the Rust crate READMEs (dialog-repository, dialog-storage,
dialog-remote-s3/ucan-s3, dialog-ucan, and siblings), the TypeScript packages
(dialog-experimental, dialog-artifacts-web-tests), and the `adr/` records.

Self-improvement: none warranting a structural change. The library's source-kind
schema, slug discipline, and the deterministic land/link-check/regenerate tooling
absorbed a brand-new external repo (new host, new topics, new concept cluster)
cleanly, which is the intended behavior. One tiny friction worth noting but not
escalating: the upstream filename `capability-sysstem.md` carries a double-`s`
typo; I preserved it in the slug for path-derivation idempotency and flagged it in
the source-index and section abstracts rather than silently "fixing" it.
