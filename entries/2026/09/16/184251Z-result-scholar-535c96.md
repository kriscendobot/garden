---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-16T18:42:53Z
---
# Final cap-talk Pipermail era ingested (2013 through January 2016)

Ingested the final fetchable Mailman/Pipermail slice into `library/sources/cap-talk-2013-2016.md`: 24 monthly `.txt.gz` bundles, each independently SHA-256 anchored, and 22 derived thread sections. The archive exposed all 2013 months, eleven 2014 months (no September bundle), no 2015 bundles, and the final January 2016 bundle.

The sections cover persistent authority graphs and schema upgrades; creator authority versus confinement; trusted authorization UI; Cap'n Proto hostile-buffer boundaries; return paths as limited capabilities; capability terminology; reactive and substructural grants; `DeepFrozen` E-order optimization; membranes and expiry; Google Docs webkeys; time authority; WeakMap rights amplification; IoT reference representations; Sandstorm confinement; grant-time identity policy; Shill capability-flow contracts; redirect-path revocation; ambient-authority terminology; macaroons; joins across membranes; local IoT brokering; and Capper credential/module authority.

Updated the source indexes and archive map; the `capability-security`, `capability-theory`, `captp`, `compartments`, `distributed-objects`, `eventual-send`, `persistence`, `revocation`, and `cap-talk-open-questions` topic pages; the `capabilities-vs-acls` and `web-key` concepts; and `projects/endo/cap-talk-capability-provenance.md`. Six unsettled questions were added explicitly, including creator inspection, renewable grants versus membranes, credential/capability boundaries, grant-time identity policy, reference joins, and platform/application ownership of sharing.

Post-2016 gap: the Google Groups successor does not provide a stable public mbox endpoint usable by the ingest scripts. A public-web survey found no cap-talk-specific alternate mbox or mirror. Google Takeout or Vault may yield an export to an authorized member or administrator; an owner-provided export is the prerequisite for continuing this corpus.

No follow-on job was posted: the requested Pipermail era is complete, and the remaining Google Groups work is blocked on an external export rather than an unprocessed fetchable source.

Integrity: `library-link-check.sh --source-slug cap-talk-2013-2016` passed with every source/index target resolved. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` landed their projections; the final `regenerate-topics-counts.sh --check` reported counts current and idempotent.

Self-improvement: nothing this time.
