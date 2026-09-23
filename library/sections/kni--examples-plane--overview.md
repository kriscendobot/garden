---
title: "The consistent-hash coordinate field"
source: examples/plane.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: The same `@outer` / `@inner` grid sweep as `hilbert`, but each cell emits `{#(x-s/2)#(y-s/2)|A|…|Z}`: the **unary `#`** consistent-hash wraps the **binary `#`** Hilbert-curve value of the coordinate, so the alphabet index is a stable pseudo-random function of `(x, y)` with no symmetry about any axis. The same coordinate always hashes to the same letter (consistent), but neighbours are decorrelated — unlike `hilbert`, where the raw curve is visible. This is the reference for kni's "assign a deterministic random variable to every point in a space" procedural-generation primitive.

The `#` operator has two roles here, nested: as a *binary* operator (`(x-s/2)#(y-s/2)`) it produces the Hilbert-curve index of the point; as the *unary* prefix (`#(…)`) it maps that index through kni's consistent hash — a deterministic function whose output looks random but depends only on its input. Feeding the Hilbert value through the consistent hash is deliberate: the comment notes it "provides no symmetric axes," so the generated field does not repeat or mirror around the origin, which is what makes procedurally-generated places, people, and things feel non-repeating.

For authoring, `plane` is the reference for the consistent-hash operator as a coordinate-seeded random variable: same seed → same value forever, no storage required. It is the field-generator dual of `hilbert` (raw curve visible) and supplies the mechanism that `space` builds on (coordinate hashes seeding nested name-generator procedures) and that `forest` uses in miniature (a hash-derived local feature keyed on position).

Source: [examples/plane.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/plane.kni) at commit `435ec3cf`.
