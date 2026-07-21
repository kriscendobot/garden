---
title: "Show-once options and menu exhaustion"
source: examples/fish.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: Four `*` **optional-once** options (`* [One Fish]` … `* [Blue Fish]`) with empty bodies and one `+` **always-offered** `[End]` that exits with `<-`; `-> start` re-presents the menu. Because a `*` option is proposed only once, each fish disappears after it is chosen, so the menu shrinks toward just `[End]` — the minimal demonstration of the show-once bullet and a self-exhausting menu.

The example isolates the difference between the two option bullets. A `*` option is proposed *once* and then withheld on later visits; a `+` option is *always* proposed. Here the four fish are `*`, so re-entering via `-> start` presents a menu with fewer fish each time until only the always-offered `+ [End]` remains, whose `<-` exits the loop. The fish options carry no answer text or consequence — choosing one only consumes it — which is the sense in which they behave as "non-options": they mutate the menu's own state (their shown-once flag) and nothing else. This is the interactive dual of the sequence block in `liftoff`: there a `{a|b|c}` block advances one step per visit; here a `*` option is a menu entry that fires once.

For authoring, `fish` is the reference for the `*` optional-once bullet and menu exhaustion — the show-once affordance stripped of any body — paired with the `+`-always exit and the `<-` + `-> start` re-entry loop that `loop` isolates. The bullet trio (`*` optional-once, `+` always-offered, `-` organizational) is documented in the MANUAL indentation-and-threads section.

Source: [examples/fish.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/fish.kni) at commit `435ec3cf`.
