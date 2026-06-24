---
title: Nine command categories
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps
---

| Category | Commands | What it covers |
|---|---|---|
| **Messaging** | request, dismiss, adopt, resolve, reject | Peer communication |
| **Execution** | js (eval) | JavaScript evaluation |
| **Storage** | list (ls), show, remove (rm), move (mv), copy (cp), mkdir | Inventory management |
| **Connections** | invite, accept | Peer connections |
| **Workers** | spawn | Worker management |
| **Agents** | mkhost (host), mkguest (guest) | Profile creation |
| **Profile** | enter, exit | Profile navigation |
| **Bundles** | mkbundle, mkplugin | Module instantiation |
| **System** | cancel, help | System operations |

Parentheses indicate aliases (`list` ≡ `ls`, `remove` ≡ `rm`, etc.) —
the design preserves both Unix-shell-familiar short forms and the
spelled-out long forms.

The **Profile** category (`/enter`, `/exit`) is the chat-bar
counterpart of the breadcrumb navigation discussed in
[[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]];
either surface gets the user to the same agent perspective.

The **Agents** and **Connections** categories together (`mkhost`,
`mkguest`, `invite`, `accept`) cover everything a user needs to do
to bring up a new identity and connect it to a peer — the user-
facing analogue of the daemon's per-agent keypair and per-agent
NETS work covered in
[[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]] and
[[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]].

The **Execution** category's single command (`js`) opens the
eval-proposal flow that
[[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]]'s
*Eval-proposal messages* describes — Grant / Counter-proposal /
Reject buttons appear in the recipient's inbox.
