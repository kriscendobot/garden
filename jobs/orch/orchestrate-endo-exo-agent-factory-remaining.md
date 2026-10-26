---
child-build-endo-exo-agent-factory-turn-ledger-host: endolin-garden-ece02cb4
child-build-endo-exo-agent-factory-turn-ledger-reap-count: 0
child-build-endo-exo-agent-factory-maker-adapters-host: endolin-garden-ece02cb4
child-build-endo-exo-agent-factory-maker-adapters-reap-count: 0
child-build-endo-exo-agent-factory-daemon-wiring-host: endolin-garden-ece02cb4
child-build-endo-exo-agent-factory-daemon-wiring-reap-count: 0
order: serial
children: build-endo-exo-agent-factory-daemon-wiring build-endo-exo-agent-factory-maker-adapters build-endo-exo-agent-factory-turn-ledger build-endo-exo-agent-factory-reply-collapse
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-10-26T02:09:51Z
---

Orchestrates the remaining implementation-plan steps of `designs/endo-child-agent-factory.md` (endojs/endo-but-for-bots#1558) after core slice #1560. The children are serial, and each stacks on the previous child's PR head.
