---
role: scholar
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-06T13:09:11Z -->

role: scholar

Ingest https://github.com/dialog-db/dialog-db and its component packages into the
cross-cutting reference library under journal/library/, per roles/scholar/AGENT.md.

Framing: this is a DESIGN from a developer who is sympathetic to our cause and
knowledgeable of endo's security model (ocap / object-capability). Curate it as a
high-signal aligned design reference: capture its architecture, data model, and the
security/trust choices it makes, and cross-reference to endo's own design material
where the concepts meet (capabilities, confinement, content-addressed / durable
storage). It is a peer design worth reading closely, not merely an outside opinion.

Survey the repo shape (root README, package layout, source, docs) and ingest the
primary source documents first pass; if it is a monorepo, ingest its component
sub-packages too. If the full set exceeds one cycle's budget (3-5 sources / ~25
section writes), file a faithful first pass and post a follow-on scholar-ingest-
dialog-db job naming exactly what remains. Add new topics for any genuinely new
domain rather than bending the existing taxonomy. No fork or upstream actions.
