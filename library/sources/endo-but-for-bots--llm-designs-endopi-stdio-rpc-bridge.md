---
source: designs/endopi-stdio-rpc-bridge.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f4a9dc6d13234bc5a8b6c8642b3082d5d8a488d8
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Sixth endopi-* design ingest (after cycles 112 + 117 + 121 +
  122 + 124). 149-line *Proposed* design (Parent: endopi.md)
  closes the §Operating modes gap — *Pi's RPC mode is the part
  Endo does not have — a strict line-delimited JSON protocol for
  embedding the agent in another process without WebSocket
  overhead*.

  Single most structurally interesting move: **stdio and
  WebSocket are two transports to the same underlying daemon
  agent**. A guest with an open chat session in the browser can
  also be reached over stdio; *the two transports interleave
  through the same transcript*. The agent's identity, state, and
  transcript live in the daemon; transports are separate access
  surfaces to the same identity. The §Capability shape paragraph
  reinforces: *the embedded agent has the same capability grants
  as a chat-side guest of the same name*; the daemon's capability
  boundaries enforce *what the agent can do, independent of how
  it was invoked* — the transport-agnostic-agent discipline.

  §Pi-byte-compatible framing rules (from Pi's `docs/rpc.md`):
    - Records separated by `\n` only — *do not split on `\r`,
      U+2028, or U+2029* (Node `readline` is non-compliant; the
      embedding host must use a strict split).
    - Each record is one JSON object with a `type` field.
    - Optional `id` field on commands; matching response echoes
      the `id`.

  §Six commands: `prompt` / `steer` / `abort` / `list_models` /
  `set_model` / `get_status`.

  §Six events: `message_start` / `message_update` / `message_end`
  / `tool_execution_start` / `tool_execution_end` / `agent_end`.

  The §shape-at-the-event-level note: Pi's RPC mode emits events
  at the harness level; Endo's RPC mode emits the *same events*
  but they're projected from Lal's transcript graph. Wire
  compatibility is the *embedding-host-gets-the-same-events*
  invariant.

  §Five-phase implementation plan: (1) protocol skeleton (prompt
  + message events, no tools); (2) tool events; (3) steer +
  abort; (4) model selection; (5) **multiplexing** — multiple
  concurrent sessions over the same process via channel ID per
  record (anticipates the multi-guest-system shape).

  §Endor-bus-tui horizon: *the stdio bridge in this design is the
  short-term shape that works on the Node daemon today; once
  endor has Bus-TUI parity, the stdio bridge becomes a thin
  front-end for the bus* — the *deprecation-in-place* lifecycle
  pattern (design ships now with explicit understanding it will
  become a wrapper around the canonical transport rather than be
  removed). Cycle 119's capability-bus design provides the
  broader frame.

  §Pi-byte-compatible-with-endo-namespaced-extensions open
  question — same posture as cycle 117's
  endopi-jsonl-transcript-format. The *adopt-existing-standard-
  with-endo-prefix* discipline now visible across three endopi-*
  designs (cycle 112's skills format + cycle 117's jsonl
  transcript format + this cycle's RPC framing).

  §Auth posture: *Stdio's local: by default, "you can spawn the
  process, so you are authorized"*. The §spawn-implies-
  authorization discipline. For ssh-tunneled-stdio the
  `gateway-bearer-token-auth` mechanism applies.

  Two §Out of scope decisions: MCP server compatibility (Pi
  declines; Endo declines too at protocol level; *a user who
  wants MCP can write an Endo guest plugin that translates*) and
  process-management features (the spawning host's responsibility).

  Two file-level Pi citations: `coding-agent/docs/rpc.md` +
  `coding-agent/src/modes/rpc/` directory.

  Cycle 126 was nominally papers-lane (cycle 125 was comments).
  Papers-lane has been blocked for 20+ consecutive cycles. Cycle
  126 pivoted to designs-lane. Endopi-* family now at 6/9
  ingested (keystone + skills-markdown-format + jsonl-transcript-
  format + edit-tool + iterative-compaction + stdio-rpc-bridge).
  Three spinouts remain: extension-package-manifest /
  prompt-templates / provider-registry-and-oauth.
---

> Abstract: `endopi-stdio-rpc-bridge.md` (149 lines, *Proposed*
> status; Parent: endopi.md) closes the §Operating modes gap from
> cycle 121's family keystone. The invocation surface is `endo
> agent rpc [--guest <name>] [--no-session]`: stdin takes LF-
> delimited JSON commands; stdout emits LF-delimited JSON events;
> stderr carries logs.
>
> **The single most structurally interesting move**: *stdio and
> WebSocket are two transports to the same underlying daemon
> agent* — a guest with an open chat session in the browser can
> also be reached over stdio; *the two transports interleave
> through the same transcript*. The agent's capability grants are
> the same whether invoked from chat-side or rpc-side; the
> daemon's capability boundaries enforce what the agent can do
> *independent of how it was invoked*.
>
> §Pi-byte-compatible framing rules: records separated by `\n`
> only (the §Node-readline-non-compliant warning matters; strict
> split required). Six commands; six events. The §endor-bus-tui
> horizon: *once endor has Bus-TUI parity, the stdio bridge
> becomes a thin front-end for the bus* — the deprecation-in-
> place lifecycle pattern.
>
> Same *adopt-existing-standard-with-endo-prefix* discipline as
> cycles 112 + 117 + 122: the §Open question proposes Pi-byte-
> compatibility with `endo:`-namespaced event types for Endo-only
> features (capability grants, formula references).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui](../sections/endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui.md) | agent-conventions | current |

Tight 149-line design. The whole argument hangs off one
structural claim: *adopt Pi's stdio RPC bridge as a short-term
transport to the same underlying daemon agent, until endor-bus-
tui ships*. One cohesion-honest section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@f4a9dc6d` (the
  branch `origin/llm`) via the local bare-clone.
- Last touched 2026-05-15 by endolinbot in commit `f4a9dc6d`
  (same dispatch wave as cycle 122's endopi-edit-tool).
- Status: *Proposed*. Parent: `endopi.md` (cycle 121's family
  keystone).
- **Twenty-fourth-comment-style design ingest.** Pairs with
  cycles 112 + 117 + 121 + 122 + 124 to advance the endopi-*
  family to 6/9 ingested.
- Cycle 126 was nominally **papers-lane** (cycle 125 was
  comments). Papers-lane has been blocked for **20+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 126
  pivoted to designs-lane.
- Cohesion-honest one-section count.
