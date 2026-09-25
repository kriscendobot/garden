---
id: xs-heap-snapshot-agent-persistence
aliases: ["heap snapshot agent", "resident agent", "agent brain is a file", "writeSnapshot", "init(snapshot:)", "agents on ice", "XS snapshot suspend resume", "orthogonal persistence for agents"]
topics: [xs-agent-runtimes, persistence]
---

# xs-heap-snapshot-agent-persistence

Persisting an agent by snapshotting the **whole XS heap** (every object, closure, pending timer, and promise queue) rather than serializing chosen state: the agent is paused by writing the snapshot and resumed by loading it into a fresh machine, possibly on another device. This is orthogonal persistence applied per agent. Its costs are the ones the sources name only loosely: a snapshot is only restorable against a compatible engine build and host-function table, and freezing mid-host-call leaves the outside world's half of the call behind. Endo's XS-worker design answers both explicitly (suspend only when idle; append-only callback table; named incompatibility axes); KaozKit relies on suspend/resume notifications and "a compatible version".

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [web--haruni-kaozkit-xs-agents--why-xs-not-javascriptcore](../sections/web--haruni-kaozkit-xs-agents--why-xs-not-javascriptcore.md) | Heap snapshots as the first of four reasons to prefer XS over JSC: the agent's brain is a file. |
| [web--haruni-kaozkit-xs-agents--what-the-snapshot-changes-in-practice](../sections/web--haruni-kaozkit-xs-agents--what-the-snapshot-changes-in-practice.md) | A resident agent and a whole actor system survive kill -9; a scheduled reminder fires after restart. |
| [web--moddable-kaozkit--agents-on-ice](../sections/web--moddable-kaozkit--agents-on-ice.md) | Snapshot to pause, load to resume, with suspend/resume notifications and device-independent snapshots. |

## See also

- [[formula-persistence-thesis]] — Endo's formula/CAS persistence, which rejects orthogonal whole-heap persistence as the durable-state model.
- endo-but-for-bots XS-worker snapshot design: [source page](../sources/endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot.md).
