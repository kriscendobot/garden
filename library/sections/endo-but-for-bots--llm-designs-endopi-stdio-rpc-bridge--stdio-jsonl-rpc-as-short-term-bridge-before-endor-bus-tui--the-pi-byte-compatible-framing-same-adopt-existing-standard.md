---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: The §Pi-byte-compatible framing — same adopt-existing-standard
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

posture

The §Framing section is *Pi's RPC mode rules verbatim*:

- *Records separated by `\n` only. Do not split on `\r`,
  `U+2028`, or `U+2029` (Node `readline` is non-compliant; the
  embedding host must use a strict split).*
- *Each record is one JSON object with a `type` field.*
- *Optional `id` field on commands; the matching response echoes
  the `id`.*

The §Node-readline-non-compliant-warning is the *strict-split-
required* discipline: `Node's readline` splits on additional Unicode
line separators that JSON-RPC implementations don't expect; an
embedding host must implement its own strict-`\n`-only split.

The §Open questions paragraph names the *Pi-byte-compatible*
direction:

> *Should the stdio framing be Pi-byte-compatible so a host
> already speaking Pi RPC works against Endo with only a binary
> swap? Probably yes, with `endo:`-namespaced event types for
> Endo-only features (capability grants, formula references).
> This is the same posture taken in
> [endopi-jsonl-transcript-format](endopi-jsonl-transcript-format.md).*

The *adopt-existing-standard-with-endo-prefix* discipline is now
visible across three endopi-* designs (cycle 112's skills format,
cycle 117's jsonl transcript format, this cycle's RPC framing).
The same *Pi-tooling-ignores-namespaced-extensions* trick lets
Endo extend without breaking Pi's wire compatibility.
