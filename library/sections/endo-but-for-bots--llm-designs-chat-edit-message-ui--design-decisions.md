---
title: Four load-bearing design decisions
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
---

The design names four load-bearing decisions. Each is small in
isolation; together they shape the user-visible behavior of the edit
affordance.

## 1. Edit time-window is indefinite

`/edit` is available whenever the daemon accepts the call. The
daemon imposes no window, and the UI imposes none either. A UI-only
window (for example, "edit only the most recent message" or "within 5
minutes") would simplify the affordance but limits correction of
long-tail typos, and the maintainer chose unbounded editability.

The trade-off: unbounded editability means the *latest body* of a
message may diverge arbitrarily from what the recipient first saw, and
recipients who acted on the original body bear the cost of re-checking
the latest. The revision-history surface (see the sibling section)
exists precisely so a recipient can audit what they read against what
the sender now claims to have written.

## 2. Edit is hidden until the message settles

When the focused message is a not-done message produced by the local
user (rare but possible if the user is driving an agent that streams),
`/edit` is not offered. The streaming sender owns the message during
a streaming session, and manual edits during a stream race the agent's
own edits. The button and shortcut are hidden until the message
settles (`done: true`).

This is the same authority gate as the cross-sender check (the
affordance is only shown when the current profile is the sender), but
gated on a different field: the daemon's `done: true` flag. The two
gates compose into a single visibility predicate: *show edit iff
sender == current profile AND message.done*.

## 3. Pre-populate from the model, not the DOM

The edit form pre-populates the body field from the original `strings`
payload (the last entry in `messageHistory`), not from the rendered
DOM. The model is the source of truth, so a round-trip no-op edit is
byte-equivalent. Markdown that did not survive a render round-trip
(raw HTML escapes, non-canonical whitespace) is preserved.

This is an instance of the broader *typed shape vs rendered surface*
discipline (see [[producer-typed-shape-consumer-rendering]]): the
typed Markdown payload is the producer's truth; the rendered HTML is a
lossy consumer view. An edit affordance that round-tripped through the
DOM would silently re-canonicalize the source on every edit. Pulling
from the model preserves authorial intent.

## 4. Embedded-token resolution: chip carries the locator, not the stale pet name

If an embedded token in the original body refers to a pet name that
has since been renamed or removed in the sender's namespace, the edit
form renders the token as a chip carrying the underlying
locator/identifier, not the (possibly stale) pet name. The
locator/identifier is the source of truth for the reference; the
inventory's pet name is orthogonal. The user can replace the chip with
a fresh `@`-completion if the reference is wrong.

This is the [[token-chip]] discipline applied to the edit-mode form:
*identity is the chip, not the name*. The chip's visual identity (the
name shown to the user) and its capability identity (the underlying
locator) are deliberately separable; an edit operation that re-rendered
chips from pet names alone would silently rewrite the *capability* the
message references when the sender renamed the pet name. The
locator-bearing chip preserves the capability across the edit even
when the displayed name has drifted.

## Implications for Endo

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

## See also

- [[token-chip]] — the chip mechanism the locator-bearing rule extends; chips already separate visual name from capability identity, and edit-mode preserves that separation under rename / removal.
- [[producer-typed-shape-consumer-rendering]] — decisions 3 and 4 are two applications of the typed-shape-vs-rendered-surface rule.
- [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]] — the profile system that authorizes `sender == current profile`, which decisions 1 and 2 build on.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
