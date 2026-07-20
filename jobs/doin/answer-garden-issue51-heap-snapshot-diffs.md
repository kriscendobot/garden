# researcher — answer @kumavis on kriskowal/garden#51 (heap snapshot format + diffs)

Repo: kriskowal/garden (the garden's own repo; issue #51).
Maintainer @kumavis asked, via issue comment
https://github.com/kriskowal/garden/issues/51#issuecomment-5021711887 :

> What does the heap snapshot format look like? How structured is it? Is it practical and efficient to store diffs between snapshots of the same program?

Task: investigate the heap snapshot format used by the engine work (XS snapshot /
endor / the daemon-worker snapshot-mapper layer — see the relevant
endo-but-for-bots designs and the snapshot work). Ground in the ACTUAL format,
not generality: (1) what the snapshot format looks like and how structured it is
(layout, sections, linear image vs object graph, alignment/relocation);
(2) whether storing diffs between snapshots of the SAME program is practical and
efficient — address determinism/stability across runs, structural sharing,
content-addressing friendliness, expected diff density. Draft a concise,
technically-grounded reply and POST it as a comment on issue #51 (bot identity)
addressed to @kumavis, citing sources. If not yet knowable, say so and name what
would settle it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-20T15:28:10Z
