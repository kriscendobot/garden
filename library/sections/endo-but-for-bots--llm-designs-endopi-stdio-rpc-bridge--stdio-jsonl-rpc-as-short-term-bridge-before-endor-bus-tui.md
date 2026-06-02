---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
---

# Stdio JSONL RPC as short-term bridge before endor-bus-tui

> *The maintainer's `endor-bus-tui` direction eventually subsumes
> some of this, but on a multi-quarter horizon. The short-term gap
> is real: a stdio JSONL surface that gives an embedding host the
> same affordances the WebSocket gateway gives the browser.*
>
> — `designs/endopi-stdio-rpc-bridge.md` §Motivation

`endopi-stdio-rpc-bridge.md` (149 lines, *Proposed* status, created
2026-05-15) is the sixth endopi-* design ingested and the fourth
spinout from cycle 121's family keystone. Parent: `endopi.md`. The
design closes the §Operating modes gap surfaced by cycle 121's
keystone: *Pi's RPC mode is the part Endo does not have — a strict
line-delimited JSON protocol for embedding the agent in another
process (an IDE, a CI harness, a Familiar pane) without WebSocket
overhead*.

## The *stdio vs WebSocket as two transports to the same daemon*
worldview

The §Relationship to the WebSocket gateway subsection is the
design's most structurally interesting claim:

> *The stdio surface and the WebSocket gateway are two transports
> to the same underlying daemon agent. A guest that has an open
> chat session in the browser can also be reached over stdio; the
> two transports interleave through the same transcript.*

This is the *transport-agnostic-agent* discipline. The agent's
identity, state, and transcript live in the daemon; transports
(WebSocket, stdio, future endor-bus) are *separate access surfaces
to the same identity*. The §Capability shape paragraph reinforces:

> *The embedded agent has the same capability grants as a chat-
> side guest of the same name. The host that spawns `endo agent
> rpc` chooses the guest; the daemon's capability boundaries
> enforce what the agent can do, independent of how it was
> invoked.*

The *capability-bounds-independent-of-transport* invariant means
the security model holds across all access surfaces — cycle 119's
capability-bus discipline applied at the transport layer.

## The §invocation surface

```sh
endo agent rpc [--guest <name>] [--no-session]
```

Standard input takes commands as LF-delimited JSON; standard
output emits responses and events as LF-delimited JSON. Standard
error carries logs separate from the protocol. *The host that
spawns `endo agent rpc` manages the child process.*

The §Out of scope paragraph names what's *not* in this transport:

- *MCP server compatibility.* Pi declines MCP; Endo declines too
  at the protocol level. *A user who wants MCP can write an Endo
  guest plugin that translates.* (Cycle 121's keystone's §Pi-
  specific moves Endo declines named this stance explicitly.)
- *Process-management features.* The host spawning `endo agent
  rpc` manages the child process; the Endo side does not
  implement parent management (no PTY, no resize, no bg).

The two declines are both *don't-duplicate-existing-host-
mechanisms* decisions: MCP is *separable as a guest plugin*;
process management is *the spawning host's responsibility*.

## The §Pi-byte-compatible framing — same adopt-existing-standard
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

## The §five commands + six events

The §Commands list:

```json
{"id": "1", "type": "prompt", "message": "Hello"}
{"type": "steer", "message": "Stop and do this instead"}
{"type": "abort"}
{"type": "list_models"}
{"type": "set_model", "provider": "anthropic", "model": "claude-sonnet-4-6"}
{"type": "get_status"}
```

The §Events list:

```json
{"type": "message_start", "message": {...}}
{"type": "message_update", "delta": "...partial text..."}
{"type": "message_end", "message": {...}}
{"type": "tool_execution_start", "toolCallId": "...", "toolName": "edit", "args": {...}}
{"type": "tool_execution_end", "toolCallId": "...", "result": {...}}
{"type": "agent_end"}
```

The §shape-at-the-event-level note: *the underlying agent is Lal
or Fae, and the events flow through the Lal transcript model*.
Pi's RPC mode emits events at the harness level; Endo's RPC mode
emits the *same events* but they're projected from Lal's
transcript graph. The wire compatibility is the *embedding-host-
gets-the-same-events* invariant; the internals are different.

## The §endor-bus-tui lifecycle horizon

The §Relationship to `endor-bus-tui` subsection names this
design's *short-term-bridge* lifecycle:

> *The Rust `endor` daemon will, in time, host its own protocol
> over a Unix-socket bus. That bus is the production-shape
> replacement for stdio. The stdio bridge in this design is the
> short-term shape that works on the Node daemon today; once
> `endor` has Bus-TUI parity, the stdio bridge becomes a thin
> front-end for the bus.*

The §thin-front-end-for-the-bus role is the *deprecation-in-place*
discipline: the design ships now to close the gap, with the
explicit understanding that it will *become a wrapper around the
canonical transport* rather than be removed. Cycle 119's
capability-bus design provides the broader frame: the endor binary
hosts *both* the daemon (the message router) and a Unix-socket-
based protocol — that bus is the production transport. This
design's stdio surface bridges the gap between the Node-daemon
present and the endor-bus future.

## Five-phase implementation plan

The §Phased implementation lists five phases:

1. **Protocol skeleton.** `endo agent rpc` accepts `prompt`,
   emits the message events. No tools, no streaming.
2. **Tool events.** Tool calls and results flow through.
3. **Steer + abort.** Mid-stream control.
4. **Model selection.** `set_model` switches the agent's
   provider/model mid-session.
5. **Multiplexing.** Multiple concurrent sessions over the same
   process (channel ID in each record).

The §multiplexing phase (5) is the *one-process-many-channels*
move — a single `endo agent rpc` invocation can host multiple
concurrent agent sessions, distinguished by channel ID per record.
This anticipates the *multi-guest-system* shape from cycle 121's
keystone (*Endo optimizes for a multi-agent system in which the
human is one of N participants*).

## Auth — *you can spawn the process, so you are authorized*

The §Open questions paragraph names the auth posture:

> *Where does auth live? Stdio's local: by default, "you can spawn
> the process, so you are authorized". For network-tunneled stdio
> (an `ssh` invocation of `endo agent rpc` on a remote host), the
> daemon's existing bearer-token mechanism applies.*

The §spawn-implies-authorization discipline is the *local-trust-
boundary* shape. The ssh-tunneled-stdio case falls back to the
existing `gateway-bearer-token-auth` design's mechanism — *same
auth surface as the WebSocket gateway, or none when stdio is local*.

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

## Related sections

- cycle 121 family keystone
  [[endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts]]
  — the §Operating modes table that names this design as the
  RPC mode gap-closer.
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the *daemon as message router* worldview that this
  short-term stdio bridge eventually fronts; the §Relationship to
  endor-bus-tui paragraph names this directly.
- cycle 117
  [[endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions]]
  — the §endo-namespaced-custom-entries discipline that this
  design's §Pi-byte-compatible framing question re-applies for
  wire-format extensions.
- cycle 122
  [[endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation]]
  — sibling endopi-* spinout from cycle 121's keystone.
- cycle 124
  [[endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking]]
  — sibling endopi-* spinout from cycle 121's keystone.
