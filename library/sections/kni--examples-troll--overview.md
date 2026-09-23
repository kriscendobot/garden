---
title: "Inline random continuation"
source: examples/troll.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A two-line Monty-Python gag whose only mechanism is one inline shuffle block, `{~.|,…no, yellow! Aaaaaaah!}`, which randomly emits either a terminating period or the panicked second-guess — the minimal demonstration of splicing a random alternation into otherwise fixed narrative text.

There is no state, no option, and no loop: the entire decision the graph makes is which of two threads the shuffle operator (`~`) selects at that one point. It shows that the branch vocabulary is not limited to author-visible menus — a block can make a hidden, engine-chosen branch mid-sentence, drawn from the same seeded PRNG that makes transcripts reproducible.

For authoring, `troll` is the "one random word" primitive: the smallest place a non-deterministic choice enters an otherwise deterministic render, useful as the base case when reasoning about where randomness lives in a larger graph.

Source: [examples/troll.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/troll.kni) at commit `435ec3cf`.
