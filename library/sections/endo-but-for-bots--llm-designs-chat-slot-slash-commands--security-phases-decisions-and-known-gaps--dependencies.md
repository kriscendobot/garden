---
title: Dependencies
source: designs/chat-slot-slash-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: f3bf100cec6e0480536b3256ce0280de9487cd0c
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, daemon, capability-security, eventual-send]
status: current
notes: Fifth and final section for chat-slot-slash-commands. Consolidates four end-of-design sections (security considerations, dependencies, phased implementation, design decisions) plus the known-gaps and affected-packages footers. Four security claims: retained pins cannot escalate authority; no daemon-internal reference leakage via the release exo; bounded lifetime on Chat crash via captp partition; cross-peer eval exposure has same confinement posture as named pet-store values. Seven load-bearing design decisions, including *slot as the unit of transient retention not the command*, *transient pin over deferred formulation*, *real locator over opaque ephemeral identifier*, and *no new message type*. Five-phase implementation totaling ~1 developer-week.
parent: endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps
---

| Design | Relationship |
|--------|--------------|
| `daemon-form-request.md` | Forms with slots are the primary consumer; this design extends how slot values are supplied. |
| `chat-command-bar.md` | Slash syntax and modeline conventions reused inside slots, including the Cmd-Enter Monaco expansion. |
| `daemon-guest-eval-simplification.md` | `/js` inside a guest's slot relies on direct `formulateEval` without proposal review. |
| `chat-pending-commands.md` | Slot slash commands are *not* pending commands themselves; this design clarifies the boundary. |
| `daemon-commands-as-messages.md` | If commands become messages, the outer form's message can absorb retained inputs as its formula inputs. |
| `daemon-cross-peer-gc.md` | Retained pins interact with the cross-peer GC protocol only through ordinary retention edges; no new cross-peer concerns. |

Source: [designs/chat-slot-slash-commands.md](https://github.com/endojs/endo-but-for-bots/blob/f3bf100cec6e0480536b3256ce0280de9487cd0c/designs/chat-slot-slash-commands.md) at commit `f3bf100c`.
