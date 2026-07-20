# researcher — answer @kumavis on kriskowal/garden#51 (test262 oracle OOM)

Repo: kriskowal/garden (the garden's own repo; issue #51).
Maintainer @kumavis asked, via issue comment
https://github.com/kriskowal/garden/issues/51#issuecomment-5021654884 :

> test262 enumeration; whole-tree OOMs the oracle
> Where's the OOM limitation coming from? How does this compare to other engine implementations?

Task: investigate the real source of the OOM ceiling in the whole-tree test262
enumeration against the oracle — this is the xs2rust-endor / test262-parity work
(see the xs2rust-endor design, the recent stageN reports, and the relevant
journal projects). Ground EVERY claim in the actual code/design/measurement
state; do not speculate. Cover: (1) where the memory limit comes from
(process/heap/GTT budget, oracle harness design, per-test vs whole-tree
accumulation, leak vs working-set); (2) how this compares to other engine
implementations the port measures against (XS/Moddable, V8/Node, SpiderMonkey,
etc.). Then draft a concise, technically-grounded reply and POST it as a comment
on issue #51 (bot identity) addressed to @kumavis, citing sources. If the answer
is not yet knowable from current state, say so plainly and name what would
settle it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: cleric
  claimed_at: 2026-07-20T15:27:59Z
