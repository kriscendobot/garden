---
title: "Attenuated random variables (the ~ operator)"
source: examples/distribution.kni
source_repo: kriskowal/kni
source_commit: e82da3ba428cb6cb5993c39163a40ba444ac910f
source_date: 2021-02-12
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: One line — `@start {(3~6)}/{+i}{(i < 100)||->start}` — emits 100 samples of the attenuated random variable `3~6`. kni's `X~Y` operator sums `X` independent uniform samples from `[0, Y)`, yielding a value in `[0, X*Y)` with mean `X*Y/2`; `3~6` therefore lands in `[0, 18)` with mean 9, a bell-ish distribution rather than a flat one. The counter-guard loop (`{+i}{(i < 100)||->start}`) is the `bottles` idiom; the example's point is the random-variable algebra, which composes better mathematically than dice rolls.

The `~` operator here is *arithmetic*, not selection: `X~Y` is a random variable, and summing samples attenuates it toward its mean (the central-limit intuition). The comment records the algebra explicitly — these variables "compose better mathematically than dice rolls, but dice rolls can be obtained by their means," giving `2d6 ≡ 1~6 + 1~6 + 2` (range `[2, 12]`, mean 7). Each loop iteration renders one sample with `{(3~6)}`, breaks the line with `/`, increments the counter with `{+i}`, and re-enters `@start` under the guard while `i < 100`. Piping the output through `sort -n | uniq -c` prints the histogram, per the file's own comment.

For authoring, `distribution` is the reference for kni's random-variable *arithmetic* (`X~Y` attenuation), distinct from the random *selection* face of `~` that `troll` uses (a shuffle block that splices one of several continuations) and from the random families documented in the MANUAL blocks-sequences-and-alternation section. Its loop is the pure counter-driven generator (`bottles`), here in service of sampling rather than a countdown.

Source: [examples/distribution.kni](https://github.com/kriskowal/kni/blob/e82da3ba428cb6cb5993c39163a40ba444ac910f/examples/distribution.kni) at commit `e82da3ba`.
