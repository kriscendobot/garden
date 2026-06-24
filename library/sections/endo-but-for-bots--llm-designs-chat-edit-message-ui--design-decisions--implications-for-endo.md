---
title: Implications for Endo
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Four decisions the design names explicitly. Decision 4 (the chip
  carries the locator, not the stale pet name) surfaces an existing
  CLI/chat parity gap captured in the source's *Related: Chat parity
  gap for proposed names* section and folded into this section's
  *Implications for Endo*.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions
---

Decisions 3 and 4 collectively articulate a *model-not-surface* rule
for edit operations on typed content. Pulling pre-populated state from
the typed model (decision 3) and carrying typed locators through chips
(decision 4) both refuse to round-trip through the lossy rendered
surface. Future surfaces in the chat client that mutate typed content
(value-modal edits, inventory renames, eval-proposal counter-proposals)
inherit the same shape: the typed payload is what gets mutated; the
rendered surface is regenerated from the mutated payload, not used as
the input to the mutation.

Decision 4 also exposes an existing parity gap between chat and CLI:
chat has no affordance for proposing a name that is not the
addressee's pet name for the referent, whereas the CLI does. A
previously suggested resolution treats `:` as a special key inside the
`@`-completion to enter a different proposed name from the pet name;
pressing `:` again would escape, allowing a literal colon in the
petname. That suggestion warrants its own design document. The
chat-edit affordance is correct as specified above regardless of how
the parity-gap design resolves — the chip's locator-not-name discipline
is what makes that follow-up possible without re-litigating the edit
affordance.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
