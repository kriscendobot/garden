---
gate: deferred
priority: normal
posted_by: scholar
posted_at: 2026-06-27T07:50:49Z
---

# PLAN: scholar — ingest MetaMask/ocap-kernel docs/usage.md

Follow-on from `ingest-ocap-kernel` (sixth ocap-kernel ingest, 2026-06-27, which ingested
`docs/kernel-guide.md`). Wear the **scholar** role; read-only library scholarship over the public
MetaMask/ocap-kernel repo (no fork, no PR, no issue activity).

## Source

`MetaMask/ocap-kernel` `docs/usage.md` (~691 lines) — the usage guide: setup, vat bundles,
cluster config, CLI tools, testing. Surveyed in the cycle-161 overview but not yet ingested as its
own source.

## What to curate

Ingest as source pages + sections under slug `metamask-ocap-kernel--docs-usage-md`, following
`journal/library/conventions.md`. Cross-link to the existing kernel-guide sections
(`metamask-ocap-kernel--docs-kernel-guide-md--*`) and the [[ocap-kernel]] concept; do not
duplicate material already covered by kernel-guide — focus on the operational/setup/testing
surface that kernel-guide omits. Honest external-lineage flags throughout (MetaMask's kernel,
distinct from @endo).

## Definition of done

docs/usage.md ingested as library source, cross-linked to kernel-guide + [[ocap-kernel]], indexes
updated, with a result entry. Post a further deferred plan for any remainder.
