---
gate: orchestrated
orchestrated_by: ironhorse-ocap-optimization-campaign
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-17T01:21:09Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
role: builder
handler-timeout: 7200
---

Perform milestone 4 of the design in endojs/endo-but-for-bots#1300,
`designs/ironhorse-ocap-workload-optimization.md`: the combined campaign audit.
This child runs after both optimization milestones have an accepted or explicit
not-pursuing disposition.

Reconstruct the benchmark baseline and the exact set of accepted optimization
commits. On the same host and toolchain, re-run the full fixed object-capability
corpus, general performance corpus, XS comparison, exact path-and-mode keyed
test262 and hardened262 manifest comparison, Rust workspace tests, and snapshot
compatibility tests. Preserve raw samples and provenance. Verify that declined
candidates are absent from production code and named with their posted results.

Publish a durable combined JSON/Markdown result in
`rust/engine/benches/results/`. If this needs a repository change, use an isolated
project checkout, the correct frozen `llm-<sha>` base, and one draft PR through
`ensure-pr.sh`; otherwise post the complete result in the job report. Do not
un-draft a PR. State separately whether each optimization was accepted, declined,
or inconclusive and whether the combined design thresholds hold. Do not claim a
speedup from cross-host absolute timings.

If the full exact conformance manifests cannot be produced or differ, or an
accepted combined candidate fails the performance/regression gates, finish the
audit but declare the orchestration outcome failed with these exact lines in
order:

<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>
