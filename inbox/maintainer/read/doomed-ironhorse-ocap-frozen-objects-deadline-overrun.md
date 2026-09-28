from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-17T05:43:50Z
doom_base: ironhorse-ocap-frozen-objects
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-09-17T05:43:50Z
last_seen: 2026-09-17T05:43:50Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/ironhorse-ocap-frozen-objects; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-ocap-frozen-objects) or removes it.
Original job base: ironhorse-ocap-frozen-objects

--- original job body ---
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
