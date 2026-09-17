---
role: builder
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T01:22:15Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
role: builder
handler-timeout: 7200
---

Implement milestone 1 of the design in endojs/endo-but-for-bots#1300,
`designs/ironhorse-ocap-workload-optimization.md`: the fixed object-capability
workload benchmark corpus and its fresh baseline. This is the first child of
orchestration `ironhorse-ocap-optimization-campaign`.

Work in an isolated project checkout. The Ironhorse engine is `llm`-only, so use
a frozen `llm-<sha>` implementation base and open one draft milestone PR through
`ensure-pr.sh`; do not combine it with the design PR or un-draft it.

Deliver the six-fixture roster, deterministic source generation and fixture
digest, parent/candidate same-host runner, result and allocation counters,
report-schema tests, and a checked-in initial JSON report under
`rust/engine/benches/results/`. Inventory representative Endo
`defineExoClassKit`, `makeExo`, promise-kit, revocable-forwarder, and `harden`
uses to choose the documented fixture parameters. The corpus must run against
Ironhorse and XS and must check every observable result.

This milestone changes no engine optimization. Run the relevant Rust workspace
tests, benchmark checker tests, and a real release-mode baseline measurement.
Report the exact command, output artifact, commits, toolchain, host provenance,
and draft PR number. A benchmark harness without an executed baseline is not
complete.

If the core deliverable is finished but its required gated outcome is not met,
end the report with these exact lines in order:

<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T01:29:57Z
