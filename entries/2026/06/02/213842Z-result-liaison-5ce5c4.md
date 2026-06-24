---
ts: 2026-06-02T21:38:42Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--5ce5c4
cycle: 126
---

# Cycle 126 — endopi-stdio-rpc-bridge.md (Kris Kowal, endo-but-for-bots) — sixth endopi-* spinout

Ingested `designs/endopi-stdio-rpc-bridge.md` (149 lines,
*Proposed* status, Parent: endopi.md) from
`endojs/endo-but-for-bots@f4a9dc6d` (branch `origin/llm`).
**Twenty-fourth-comment-style design ingest.** One cohesion-honest
section:

- **stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui**
  — closes the §Operating modes gap from cycle 121's family
  keystone (*Pi's RPC mode is the part Endo does not have*). The
  invocation surface is `endo agent rpc [--guest <name>]
  [--no-session]` with stdin/stdout LF-delimited JSON. Pi-byte-
  compatible framing (records separated by `\n` only — the §Node-
  readline-non-compliant warning matters). Six commands; six
  events.

## The single most structurally interesting move

*Stdio and WebSocket are two transports to the same underlying
daemon agent*. A guest with an open chat session in the browser
can also be reached over stdio; *the two transports interleave
through the same transcript*. The transport-agnostic-agent
discipline: agent identity, state, and transcript live in the
daemon; transports are *separate access surfaces to the same
identity*.

The §Capability shape paragraph reinforces: *the embedded agent
has the same capability grants as a chat-side guest of the same
name*; the daemon's capability boundaries enforce *what the agent
can do, independent of how it was invoked*. Cycle 119's
capability-bus design provides the broader frame.

## §endor-bus-tui horizon — *deprecation-in-place* lifecycle

The design names its own end state: *the stdio bridge becomes a
thin front-end for the bus once `endor` has Bus-TUI parity*. The
*deprecation-in-place* lifecycle pattern: design ships now to
close the gap, with explicit understanding it will become a
wrapper around the canonical transport rather than be removed.

## Adopt-existing-standard-with-endo-prefix — three endopi-*
designs now share

The §Pi-byte-compatible framing question proposes
`endo:`-namespaced event types for Endo-only features (capability
grants, formula references). Same posture as cycle 117's
endopi-jsonl-transcript-format and cycle 112's
endopi-skills-markdown-format. *Three endopi-* designs* (cycles
112 + 117 + 126) now share the *adopt-existing-standard-with-
endo-prefix* discipline.

## Endopi-* family arc progress

The endopi-* family is now at **6/9 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md`
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone)
- cycle 122 — `endopi-edit-tool.md`
- cycle 124 — `endopi-iterative-compaction.md`
- **cycle 126 (this cycle)** — `endopi-stdio-rpc-bridge.md`

Three spinouts remain: `endopi-extension-package-manifest` /
`endopi-prompt-templates` /
`endopi-provider-registry-and-oauth`.

## Rotation note

Cycle 126 was nominally **papers-lane** (cycle 125 was
comments). Papers-lane has been blocked for **20+ consecutive
cycles** (97/100/102/104/106/108/110/112/113/114/116/117/118/
119/120/121/122/123/124/125) due to lack of PDF-fetching
infrastructure.

## Counts

- 629 → **630** sections (+1).
- 170 → **171** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — sixth
  endopi-* row in this topic).
- Keywords index extended with ~28 stdio-rpc-bridge-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 127 wakes in 1500s. Rotation lands on **chat-lane**
nominally (still exhausted at 20/20). Expect a pivot.
