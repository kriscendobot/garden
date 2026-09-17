---
role: builder
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-17T03:31:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
role: builder
handler-timeout: 7200
---

Implement milestone 3 of the design in endojs/endo-but-for-bots#1300,
`designs/ironhorse-ocap-workload-optimization.md`: exploit proven ordinary-object
immutability in the Rust Ironhorse engine. This child runs after the closure-site
milestone has posted an accepted or not-pursuing result.

Use the landed benchmark corpus as the fixed contract. Work in an isolated
project checkout, use the correct frozen `llm-<sha>` implementation base, and
open one draft milestone PR through `ensure-pr.sh` if a change earns acceptance.
Do not un-draft it.

Implement and measure the ordinary, non-proxy fused freeze-and-referent walk,
the derived sealed/frozen/hardened state cache, and cached fast rejection of
writes while preserving strict throws, sloppy no-ops, receiver semantics, and
Proxy/exotic behavior. Measure the frozen property-index and hardened GC-edge
roster candidates independently; land either only if it clears the design's bar.
Do not infer deep immutability for mutable internal slots, omit specified write
behavior, merge object identities, or skip page-level dirty tracking. Derived
caches are not snapshot payloads and must be rebuilt on restore.

Run the exact path-keyed test262 and hardened262 parent/candidate manifest gate,
the Rust workspace and snapshot compatibility tests, the general benchmark
regression gate, and a real same-host before/after object-capability benchmark.
Post raw reports for every accepted and declined candidate. A correct candidate
that misses the speed bar is reverted and recorded as not pursuing; that is a
valid campaign result, not an orchestration failure.

If the core deliverable is finished but its required gated outcome is not met,
end the report with these exact lines in order:

<<<GARDEN-ORCHESTRATION-FAILED>>>
<<<GARDEN-JOB-COMPLETE>>>

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T03:31:23Z
