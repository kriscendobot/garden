---
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
section_count: 1
status: current
notes: |
  Cycle 445 designs-lane ingest. 114-line
  packages/lal/primer/chat-reference.md — the Chat UI
  slash-command reference for Endo operators. One-hundred-
  and-thirty-fifth consecutive non-garden source after
  the pivot (310-445). Ninety-third AUTHORED conformant
  single-body section doc in post-refactor era.

  Single most structurally interesting move: §the-named-
  three-networking-backends-as-distinct-connection-models
  — the Networking section names three peer-connection
  commands: /network [host] [port] (TCP, requires open
  port), /network-libp2p (no open ports needed; NAT
  traversal via libp2p), /network-ws-relay <url>
  (WebSocket relay; arbitrary connectivity, relay
  required). Three backends, each addressing a strictly
  harder connectivity scenario. The "no open ports
  needed" annotation on /network-libp2p is the key
  differentiator that names the exact problem each
  backend solves. §the-named-three-backends-as-
  connectivity-capability-ladder as tier-3 meta-pattern.

  §the-named-view-edit-as-chat-only-commands (no CLI
  equivalent; /view surfaces blob contents inline; /edit
  opens inline editor); §the-named-chat-view-edit-
  distinct-from-cli.

  §the-named-share-adopt-locator-as-capability-sharing-
  surface (/share generates locator with connection hints;
  /adopt-locator adopts remote value; user-facing bridge
  between pet naming and network-aware locators);
  §the-named-locator-with-hints-as-capability-transfer.

  §the-named-enter-exit-as-profile-navigation (/enter
  <host> switches active identity context to named host;
  /exit returns to parent profile; models multi-identity
  navigation as stateful context, vs CLI --as flag which
  is per-command); §the-named-stateful-vs-per-command-
  identity-switch.

  §the-named-dm-as-channel-only-command (/dm available
  in channel context only, not home space; home space
  IS the default mailbox; channels are multi-party
  spaces where /dm narrows to one recipient);
  §the-named-home-space-vs-channel-context.

  §the-named-cli-chat-surface-parity-with-exceptions
  (Chat mirrors CLI vocabulary except: no daemon
  management commands, add /view /edit /dm /network*
  /share /adopt-locator /enter /exit; the mapping is
  mostly symmetric with Chat-specific additions);
  §the-named-chat-as-operator-surface-with-extensions.

  §the-named-ninety-three-conformant-cycles-and-counting.

  Closes five citation arcs: cycle 444 (1, adjacent
  forward — extract-tool-calls.js contextualized by
  knowing the Chat UI it serves: operators use /network*
  to peer with other Endo nodes running Fae agents) +
  cycle 441 (3, howto-messaging.md's four-command-
  context-lifecycle-vocabulary confirmed at operator
  level: /reply, /dismiss, /clear, /adopt all present in
  chat-reference) + cycle 437 (3, granter perspective
  on request confirmed: /resolve and /reject in chat
  reference) + cycle 326 (75) + cycle 322 (75). Pushes
  citation-arc-closures-in-pivot to NINE-HUNDRED-AND-
  TWO (897 + 5 net new).
---

114-line `packages/lal/primer/chat-reference.md` — the Chat UI slash-command reference for Endo operators. The message-input bar doubles as conversational interface (`@recipient message`) and command line (`/command`). The vocabulary mirrors the CLI reference with key Chat-specific additions and omissions. Designs-lane after cycle 444 chat-lane fae/src/extract-tool-calls.js. **Single most structurally interesting move**: §the-named-three-networking-backends-as-distinct-connection-models — *the Networking section names three peer-connection commands: `/network [host] [port]` (TCP, requires open port), `/network-libp2p` (no open ports needed; NAT traversal via libp2p), `/network-ws-relay <url>` (WebSocket relay; arbitrary connectivity, relay required). Three backends, each addressing a strictly harder connectivity scenario: direct TCP → NAT-traversal → relay-mediated. The "no open ports needed" annotation on `/network-libp2p` names exactly the problem each backend solves.* §the-named-three-backends-as-connectivity-capability-ladder as tier-3 meta-pattern. §the-named-view-edit-as-chat-only-commands (`/view`/`/edit` have no CLI equivalent; view surfaces blob inline, edit opens inline editor); §the-named-chat-view-edit-distinct-from-cli. §the-named-share-adopt-locator-as-capability-sharing-surface (`/share <name>` generates locator with connection hints; `/adopt-locator <locator> <name>` adopts remote value; user-facing bridge between pet naming and network-aware locators); §the-named-locator-with-hints-as-capability-transfer. §the-named-enter-exit-as-profile-navigation (`/enter <host>` switches active identity context; `/exit` returns to parent; stateful profile navigation vs CLI `--as` per-command flag); §the-named-stateful-vs-per-command-identity-switch. §the-named-dm-as-channel-only-command (`/dm` available in channel context only; home space is the default mailbox; channels are multi-party); §the-named-home-space-vs-channel-context. §the-named-cli-chat-surface-parity-with-exceptions (Chat mirrors CLI except: no daemon management, adds `/view` `/edit` `/dm` `/network*` `/share` `/adopt-locator` `/enter` `/exit`); §the-named-chat-as-operator-surface-with-extensions. §the-named-ninety-three-conformant-cycles-and-counting. Five citation arcs closed; pushes citation-arc-closures-in-pivot to NINE-HUNDRED-AND-TWO (897 + 5 net new).

## Section list

- [endo-but-for-bots--packages-lal-primer-chat-reference-md--chat-slash-command-vocabulary-and-three-networking-backends](../sections/endo-but-for-bots--packages-lal-primer-chat-reference-md--chat-slash-command-vocabulary-and-three-networking-backends.md)
