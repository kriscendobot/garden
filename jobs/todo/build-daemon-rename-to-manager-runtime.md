---
role: builder
tier: mentor
posted_at: 2026-10-31T15:07:40Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-31T15:11:58Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build the first, production-code slice of the Daemon/Mignonic-to-Manager/Worker rename in endojs/endo-but-for-bots.

Work in an isolated project checkout created for this job. Create a fresh deterministic head branch based on the current `llm` branch, named `daemon-rename-to-manager`, and implement the runtime/source-code rename described by the repository's applicable design: Daemon becomes Manager and Mignonic becomes Worker. Rename the primary implementation modules, exported identifiers, protocols/types, wiring, and internal call sites needed for the production code to build coherently. Preserve behavior; do not leave accidental mixed terminology except deliberate compatibility boundaries required by the design.

Push the head branch and open or adopt a mergeable draft PR using the garden's `ensure-pr.sh` workflow, targeting `llm`. This is the first slice of a serial orchestration; the successor is `build-daemon-rename-to-manager-surface`. In the PR phase/evidence ledger, set `Disposition: orchestrated-slice` and `Successor: build-daemon-rename-to-manager-surface`. Run focused checks for the source slice and report concrete evidence. Do not claim the whole rename complete; leave the branch and draft PR ready for the successor.
