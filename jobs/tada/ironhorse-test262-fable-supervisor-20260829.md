# Completion report — ironhorse-test262-fable-supervisor-20260829

**Deliverable:** one draft PR, https://github.com/endojs/endo-but-for-bots/pull/1113 (head `feat/ironhorse-test262-compliance-ratchet` @ `be5eef82cc`, base `llm` @ `97d8de25da`), opened via ensure-pr.sh with the job marker. Four commits: three engine fix waves + the round-2 ratchet-floor snapshot.

**Baseline (step 2):** pinned `tc39/test262@be13516fb644` (unchanged, recorded in `TEST262_REVISION`), XS oracle `23b4d6b0a65f`. Fresh authoritative whole-corpus sweeps (`full-run.sh`, oracle on, 51,976 cases, 1,930 provenance-stamped batches, one run identity) at the branch point and at the finished head; hardened262 harness baseline exercised across all declared agents (xs, sesXs, sesNode, ironhorse, sesIronhorse).

**Before → after (whole corpus, same pin):** covered 30,006 → **30,232**; conformance failures 21 → **0**; unsupported 13,956 → 13,712; skipped 7,374 → 7,414; infrastructure 619 → 618. Every path of the merged 2026-08-29 floor (29,867) verified still covered — zero lost.

**Clusters found and fixed (steps 3–4, each with a dual-run regression suite):** (1) caught not-callable TypeError corrupted the continuation — `enter_call` returned the catch-handler pc as a callee body start, and `call_cross_segment` dispatched it as a nested body (14 failures + an abort class); (2) sixteen native validation sites threw uncatchable host `Halt::Throw` instead of the catchable raise chain — the dominant wrong-throw slice of the 5.6k `ironhorse-aborted` pool — plus the getOwnPropertyDescriptor ToObject arm; (3) three inherited floor regressions: payload-blind descriptor ToBoolean (`''` truthy), sparse-array walks permanently interning every probed absent index (16-bit id-space exhaustion), and TypedArray-from-array missing the IteratorToList snapshot. Also split the opaque `ironhorse-aborted` verdict by halt kind so report.json ranks the remaining backlog. Seven branch-point "hangs" (RegExp property-escapes) were proven contention flakes, passing in the refresh.

**Durability (step 5):** `baseline/refresh-20260901/` committed as the enforced superseding floor (covered.txt no-regress, empty permitted-failures list, provenance-pinned baseline.json). All Rust gates green (`cargo test --release -p ironhorse-vm -p ironhorse-compile -p ironhorse-262 -p ironhorse-snapshot`); hardened262 ironhorse agents show no baseline delta (a 7-entry xs/sesXs delta is a local-xst-version artifact, deliberately not blessed); the endo `ironhorse_store_worker` gate needs CI's generated xsnap bundles and is left to PR CI.

**Reporting & handoff:** terminal summary posted at https://github.com/kriscendobot/garden/issues/51#issuecomment-5504373629 (issue left open) with the ranked remaining queue (module evaluation, iterator-protocol reification, per-family wrong-throws, opcode gaps, oracle-host Temporal/Intl limits). The review chain is owned by posted job `gauntlet-endo-pr1113-20260902` (clean → panel → fix-loop → un-draft), per the spec's gauntlet requirement.

**Follow-ups:** next ratchet round should start from the refined `ironhorse-aborted:*` reason clusters; the run was reaped three times by the 2h handler limit (sweeps survived via detached resume-aware runs) — a raised or detached handler budget would keep future rounds in one session.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-fable-supervisor-20260829.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (1 unmetered)
- Input: 140 tokens (23167611 cached reads)
- Output: 52393 tokens
- Cost: $40.26798100000001 (1 engagement(s) unpriced)
- Wall-clock: 8240s
- Model(s): claude-fable-5 ×4

<!-- garden-usage-end -->
