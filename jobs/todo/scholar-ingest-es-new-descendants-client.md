role: scholar

Ingest the Apple EndpointSecurity API doc and assess its relevance to the garden's
projects, per roles/scholar/AGENT.md.

Source (external web page — acquire with scripts/jobs/fetch-source.sh <url>, do not
hand-roll the fetch; record provenance per conventions):
  https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)
(`es_new_descendants_client(_:_:)` — creates an EndpointSecurity client that monitors
a process and its descendants.)

Two deliverables:
1. LIBRARY INGEST — curate the source into journal/library/ per conventions. This is a
   new domain (macOS EndpointSecurity / OS-level process + descendant monitoring):
   add new topic(s) for it rather than bending the existing endo-centric taxonomy.
   Keep it faithful; capture what the API does, its client/subscription model, and the
   descendant-monitoring semantics.
2. RELEVANCE ANALYSIS — assess whether this capability is relevant to any of the
   garden's PROJECTS (walk journal/projects/). Consider candidates like sandboxing /
   supervising agent-spawned processes, the endo-but-for-bots daemon and its
   agent-tools, process confinement, and the garden's own fleet/process supervision —
   i.e. anywhere the garden cares about observing or bounding a process and its
   children. Where there is a genuine fit, write or extend the relevant
   journal/projects/<slug>/<topic>.md note (abstract-first, cite the ingested source).
   Where the fit is weak or absent, say so plainly in the result — do NOT manufacture a
   connection. This is analysis, not advocacy.

Library/analysis curation only — no fork, no upstream, no external systems.
