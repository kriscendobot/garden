---
tier: mentat
dispatch: manual
---
# Answer the open design questions of designs/ironhorse-panic.md (mentat)

Role: designer (roles/designer/AGENT.md). This is a manual mentat dispatch. The maintainer (kriskowal) asked for it at https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049: "dispatch a mentat tier agent to respond to open design questions if necessary on any of these legs."

Repo: endojs/endo-but-for-bots, base `llm`. Design: `designs/ironhorse-panic.md` (merged in #1018; partly built in #1150).

Answer each question in the design's `## Open Questions`, grounding every answer in a survey of the live code, not in assertion:
1. Membership of `Decode` and `StepLimit` in `is_panic()`, and how their provenance is reported.
2. MeterAbort from genuine quota exhaustion: pause-and-refill vs panic. Keep the metering design's answer unless the survey shows a reason to change it.
3. Which backend carries the first production transcript integration (store-backed HeapStore with ATTACH/2PC, or XS/CAS watermark ordering), and whether the ATTACH form becomes mandatory later. Survey the daemon's actual snapshot mechanism.
4. The dependency note on the `-e ironhorse` `Machine` seam (stage 8/9), filed on the integration work.
5. Uncaught `Throw`: terminate the worker or reject-and-continue. Survey or cite the daemon's current uncaught-delivery behavior.
6. SQLite I/O failure inside a transcript write: TranscriptFault, snapshot barrier, or daemon fail-stop.
7. Bounding the fsync cost for a single busy vat.
8. Folding StackOverflow/MeterAbort into PanicKind (type-enforced classification).
Also reconcile the overlap with the open designs https://github.com/endojs/endo-but-for-bots/pull/989 (worker quiescence embargo; supersede, merge, or scope-split with this design's transcript/embargo) and https://github.com/endojs/endo-but-for-bots/pull/1016 (panic-on-reference-error plus rejection handling vs this design's § Coda).

Deliverable: a design-amendment PR against `llm` that moves each answer from Open Questions into the body (opened via scripts/jobs/gardening/ensure-pr.sh). Any question that is still a genuine maintainer fork stays in Open Questions, stated as a decision request. Also post a short comment on #1018 that links the PR and gives a one-line answer per question. The build legs of orchestration `endojs-endo-but-for-bots-pr1018-followups-20260929` read your completion report, so list the answers there as well, keyed by question number.
