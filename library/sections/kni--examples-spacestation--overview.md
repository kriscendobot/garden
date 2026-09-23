---
title: "Indentation as a nested outline"
source: examples/spacestation.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: A structure-only sketch — `bridge`, `stellar cartography`, `engine room`, `weapons`, and their sub-compartments, plus a `ship configurations` classification tree — written entirely as indented lines. It contains no options, variables, or flow directives, so it isolates one fact: kni's significant-whitespace columns already encode a nested tree.

Because deeper indentation columns start branches in kni's grammar, an outline like this parses as a hierarchy: each compartment owns the more-indented lines beneath it, exactly as an author would draw a containment tree. Here the tree is never walked interactively — it reads as a design note or scaffold for a larger navigable graph (compare `ship`, which turns a comparable compartment layout into an option-driven navigation state machine).

For authoring, `spacestation` is the reminder that indentation is the primary structural operator: before any options or state are added, the whitespace layout already commits to a shape the parser will flatten into the instruction graph.

Source: [examples/spacestation.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/spacestation.kni) at commit `435ec3cf`.
