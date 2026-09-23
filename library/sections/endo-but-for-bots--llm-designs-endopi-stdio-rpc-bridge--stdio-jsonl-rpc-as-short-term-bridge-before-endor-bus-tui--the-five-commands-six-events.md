---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: The §five commands + six events
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

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
