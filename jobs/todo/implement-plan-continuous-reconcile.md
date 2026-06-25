# Plan-in-journal: fold continuous status reconcile into the bulletin/journalist loops

Follow-on to implement-plan-in-journal (garden#4). Phase 0 wired continuous plan
RENDERING into the bulletin loop (scripts/jobs/bulletin.sh render_plan, deterministic
+ change-gated). The gh merge-detection status auto-flip (scripts/jobs/plan/
reconcile.sh) was deliberately scoped to the WEEKLY Sunday job, not the per-tick
loop, to avoid running an unproven auto-mutator continuously over freshly imported
data across multiple hosts.

Once a weekly recalibration pass or two has proven the auto-flip correct on real
data, fold reconcile.sh into the bulletin (and/or journalist) loop with a TTL
throttle (mirror the parked_section gh-throttle pattern: a host-local stamp, once per
N minutes, degrade-safe). The design wants reconciliation continuous and not
maintainer-gated; this closes that gap. Verify multi-host idempotence (the reconcile
mutation must be CAS-safe and not churn). Report the throttle interval chosen.
