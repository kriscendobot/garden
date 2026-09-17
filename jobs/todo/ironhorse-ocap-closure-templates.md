---
role: builder
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T02:25:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
role: builder
handler-timeout: 7200
---

Implement milestone 2 of the design in endojs/endo-but-for-bots#1300,
`designs/ironhorse-ocap-workload-optimization.md`: benchmark-driven closure-site
templates in the Rust Ironhorse engine. This child runs only after the benchmark
corpus child completes.

Use the landed benchmark milestone as the fixed measurement contract. Work in an
isolated project checkout, use the correct frozen `llm-<sha>` implementation
base, and open one draft milestone PR through `ensure-pr.sh` if the optimization
earns acceptance. Do not un-draft it.

Derive an immutable `ClosureSiteTemplate` per code-segment/site/symbol variant,
bulk-copy the fixed allocation fragment in safe Rust, patch only dynamic
references, preserve the scalar allocator as a differential oracle and fallback,
keep templates derived and non-persistent, and preserve deterministic computron
charges. Cover free-list fallback, GC edges, function descriptors, snapshot
round-trips, restore/cache reconstruction, metering, and scalar/template result
equivalence with load-bearing tests.

Run the exact path-keyed test262 and hardened262 parent/candidate manifest gate,
the Rust workspace and snapshot compatibility tests, the general benchmark
regression gate, and a real same-host before/after object-capability benchmark.
Post the raw report and PR summary. Accept only if the design's thresholds hold.
If the change is correct but does not clear them, revert the production change,
preserve the measurement, and complete with an explicit not-pursuing rationale;
that is a valid campaign outcome, not an orchestration failure.

If the core deliverable is finished but its required gated outcome is not met,
end the report with these exact lines in order:

<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>
