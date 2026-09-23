---
source_kind: web
source_url: https://erights.org/elib/equality/passing-rules.html
source_effective_url: https://erights.github.io/erights-org-website/elib/equality/passing-rules.html
source_fetched_via: mirror
source_content_sha256: 674e5229902870f36b8ac0a3ca4398a021591a529c4f4c54023be1e84d78b9fe
source_authors: [Mark S. Miller]
source_date: 2000-01-01
retrieved: 2026-06-27
ingested: 2026-06-27
ingested_by: scholar
section_count: 2
status: current
notes: "Mark Miller's *Argument Passing Rules* — the object-passing-taxonomy page of the equality chapter, sibling of [`web--miller-grant-matcher-puzzle`](web--miller-grant-matcher-puzzle.md). This is where E's pass-by-copy / pass-by-construction (PBC) / pass-by-proxy classification and the vat-relative leaving-home / going-home / travelling transforms live — the direct E-language ancestor of Endo's marshal pass-style. Also documents the historical Lost Resolution implementation bug. Fetched 2026-06-27 from the erights.github.io GitHub Pages mirror via scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses connections from the sandbox). The mirror bytes are byte-identical to the prior Internet-Archive `id_` capture (content SHA-256 unchanged), so this is a provenance refresh, not a re-ingest. Undated; source_date is the era approximation. Idempotency anchor is source_content_sha256."
---

Mark S. Miller's *Argument Passing Rules* is the equality-taxonomy page that classifies how a reference of a given kind, passed by an invocation of a given kind, is received. It is split into **vat-independent semantics** — the pass-invariance rules (Calls don't fork, Sends make Promises, Args stay Resolved/Settled, PassByCopy and PassByConstruction args stay Near, Once Broken always Broken) that define E's **PassByCopy / PassByConstruction (PBC) / PassByProxy** object-passing taxonomy — and **vat-based rules** — the leaving-home / going-home / travelling transforms a PassByProxy Near/Far reference undergoes across vat boundaries, plus the historical *Lost Resolution* bug. This page is the E-language ancestor of Endo's marshal **pass-style** classification ([[pass-by-construction]]), and its three-vat "travelling" case is the situation OCapN CapTP's [[three-party-handoff]] resolves.

| Section | Topics | Status |
|---------|--------|--------|
| [vat-independent-semantics](../sections/web--miller-equality-argument-passing-rules--vat-independent-semantics.md) | marshal, capability-theory, eventual-send | current |
| [vat-based-rules](../sections/web--miller-equality-argument-passing-rules--vat-based-rules.md) | marshal, eventual-send, captp | current |
