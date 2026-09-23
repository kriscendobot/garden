---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: Five-phase implementation plan
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

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
