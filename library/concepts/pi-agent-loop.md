---
id: pi-agent-loop
aliases: [pi-ai, pi-agent-core, runAgentLoopContinue, awaited agent event sink]
topics: [llm-agent-frameworks, agent-workspaces, persistence]
---

# pi agent loop

Cloudflare OS's pi migration uses `pi-agent-core`'s low-level awaited loop, translates existing persisted chat records into pi message types, adapts tools through TypeBox, and treats successful `turn_end` delivery as the persistence barrier while keeping provider failures and aborts out of durable chat history.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Migration decisions and provider routing](../sections/cloudflare-os--plans-pi-impl--migration-decisions-and-provider-routing.md) | Fixes the low-level pi loop and provider transport choices. |
| [Message replay and tool adaptation](../sections/cloudflare-os--plans-pi-impl--message-replay-and-tool-adaptation.md) | Translates persisted chat history and tools into pi types. |
| [Awaited agent loop and persistence barrier](../sections/cloudflare-os--plans-pi-impl--awaited-agent-loop-and-persistence-barrier.md) | Makes successful turn-end delivery the durable boundary. |
| [Verification and deferred bridges](../sections/cloudflare-os--plans-pi-impl--verification-and-deferred-bridges.md) | Defines automated, manual, and follow-up boundaries for the migration. |

## See also

- [[cloudflare-os-gadget]]
