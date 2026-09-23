---
title: Chat slash-command vocabulary and three-networking-backend enumeration
source: packages/lal/primer/chat-reference.md
source_kind: primer
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/chat-reference.md
source_line_range: 1-115
source_commit: 10594d09fa6efff9f7d4271adc2f2f19214fd756
source_date: 2026-03-26
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [chat-ui, daemon]
status: current
---

114-line `packages/lal/primer/chat-reference.md` — the Chat UI slash-command reference for Endo operators. The primer document enumerates all interactive commands available in the Chat message-input bar: inventory management, messaging, execution, worker/agent management, and networking. The networking section names three distinct peer-connection backends.

## Chat slash-command vocabulary and three-networking-backend enumeration

The Chat message-input bar doubles as both a conversational interface and a command line. Messages to a recipient are prefixed with `@recipient`; commands are prefixed with `/`. The full command vocabulary mirrors the CLI reference (`cli-reference.md`) but is scoped to the interactive Chat surface; most CLI commands have a `/`-prefixed equivalent, with the key exception that the CLI exposes `endo start`/`stop`/`restart` daemon management while Chat does not.

### Viewing and editing (Chat-specific, no CLI equivalent)

`/view <name>` and `/edit <name>` have no direct CLI equivalent. `/view` displays blob contents inline in the chat window; `/edit` opens an inline editor for a blob. This separation of concern — the Chat UI can surface and edit stored blobs in-place — is not available at the CLI layer.

### Three networking backends with distinct connection models

The Networking section names three peer-connection commands, each for a distinct transport:

1. **`/network [host] [port]`** — TCP peer network (defaults `127.0.0.1:8940`). Requires an open inbound port; suitable for LAN or port-forwarded deployments. The most direct connection model.

2. **`/network-libp2p`** — libp2p peer network. Annotated "no open ports needed." Uses libp2p's NAT traversal; suitable when a machine cannot accept inbound TCP connections (mobile, NAT, firewall). The key differentiator from the TCP backend.

3. **`/network-ws-relay <url>`** — WebSocket relay server. Connects to a relay at an explicit URL. Suitable when neither direct TCP nor libp2p traversal is viable; the relay mediates all traffic. Requires a relay server be operated somewhere.

The three backends form a capability ladder by connectivity model: direct TCP (requires open port) → libp2p (no open port, but NAT traversal) → WebSocket relay (arbitrary connectivity, relay required). Each addresses a strictly harder connectivity scenario than the one before it.

### Shareable locators and capability-sharing surface

`/share <name>` generates a shareable locator with connection hints for a named value. `/adopt-locator <locator> <name>` adopts a remote value from such a locator. Together these two commands form the user-facing surface for capability sharing across network boundaries — a capability reference serialized with transport hints so the recipient's daemon can establish connection without prior peering.

### Profile navigation with enter/exit

`/enter <host>` enters a named host as the current profile; `/exit` returns to the parent profile. The Chat UI models multiple Endo identity contexts as navigable spaces: a user can inhabit a different host's mailbox and storage as their active context, then return to their own. This mirrors the `--as` flag available on CLI commands, but as stateful navigation rather than per-command flagging.

### Messaging surface (Chat-specific extensions)

`/dm <to> <text>` — direct message, available only in channel context (not the home space). The home space is the user's primary mailbox; channels are multi-party spaces where `/dm` narrows to a specific recipient.

Source: [packages/lal/primer/chat-reference.md](https://github.com/endojs/endo-but-for-bots/blob/10594d09fa6efff9f7d4271adc2f2f19214fd756/packages/lal/primer/chat-reference.md) at commit `10594d0`.
