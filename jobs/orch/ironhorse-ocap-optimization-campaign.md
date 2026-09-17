---
child-ironhorse-ocap-frozen-objects-host: endolin-garden2-5bcdff64
child-ironhorse-ocap-frozen-objects-reap-count: 0
child-ironhorse-ocap-closure-templates-host: endolin-garden2-5bcdff64
child-ironhorse-ocap-closure-templates-reap-count: 0
child-ironhorse-ocap-benchmark-corpus-host: endolin-garden2-5bcdff64
child-ironhorse-ocap-benchmark-corpus-reap-count: 0
order: serial
children: ironhorse-ocap-benchmark-corpus ironhorse-ocap-closure-templates ironhorse-ocap-frozen-objects ironhorse-ocap-campaign-audit
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-09-17T01:21:15Z
---

Serial benchmark-driven implementation of
`designs/ironhorse-ocap-workload-optimization.md` from
endojs/endo-but-for-bots#1300. The benchmark contract lands first, closure and
frozen-object optimizations then receive independent benchmark/conformance
dispositions, and the final child audits their combined result. Halt on a real
child failure; an evidence-backed not-pursuing optimization disposition counts
as successful completion so the campaign can continue to its final audit.
