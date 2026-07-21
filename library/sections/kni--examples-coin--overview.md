---
title: "Call-flip-compare toss"
source: examples/coin.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

> Abstract: A three-beat elicitation loop: a two-option prompt records the player's call into `called` via consequence assignments (`{=heads called}` / `{=tails called}`), the engine flips a random result into `flipped` (`{= ~2 flipped}`), and the outcome line renders win or lose purely from `{(called == flipped)|lose|win}`. It is the smallest example that elicits a choice, records it as durable state, and renders a verdict derived from that state against a fresh event.

The pattern separates the three roles cleanly: the menu is the elicitation surface (each option carries its own `{= ...}` consequence that writes the answer), the random flip is the automatic event the graph owns, and the final sentence is a deterministic function of the recorded call versus the recorded flip. No text infers the outcome after the fact — the guard reads the two variables directly.

For an agent-context loop this is the archetype in miniature: capture a bounded decision as typed state, let the deterministic side supply the event and the verdict, and render the result. Scaling it up (more options, more recorded fields, a real event source behind the flip) is how a routing-and-recording graph is built.

Source: [examples/coin.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/coin.kni) at commit `435ec3cf`.
