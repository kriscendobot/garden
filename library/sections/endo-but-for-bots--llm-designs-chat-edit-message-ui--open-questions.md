---
title: Open questions — slash-command collision and recipient-side history visibility
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Two open questions, both flagged as maintainer-decisions in the
  source. The first is a name collision with a sibling chat design;
  the second is a UX trade-off about whether to expose edits to
  recipients.
---

The design names two open questions whose resolutions are deferred to
the maintainer rather than embedded into the design.

## 1. Slash-command name collision with blob editing

[[endo-but-for-bots--llm-designs-chat-view-edit-commands]] reserves
`/edit` for opening a Monaco editor on a blob entry. The two designs
both want the same command name, and the focus-mode shortcut `e` would
similarly need to be disambiguated (the design's *Authority* section
covers the `e` case by gating on focus target; the slash command does
not have an obvious disambiguation in the command bar where there is
no focus target).

Three resolutions are listed in the source:

(a) **Rename one of the two.** Candidates for this design include
    `/revise`, `/amend`, `/edit-message`; for the blob editor, `/open`.
    Tradeoff: the rename has discoverability cost — users searching
    for "edit" find one of the two.

(b) **Overload `/edit` and dispatch on the type of the first
    argument** (a message number versus a pet name path). Tradeoff:
    the inline help text becomes context-dependent, which is in tension
    with the *inline-hints-complement-modeline* discipline from
    [[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]].

(c) **Ship this design first and rename the blob editor when that
    design lands.** Tradeoff: the rename is then forced on the
    blob-editor design rather than negotiated.

The maintainer should pick. The library captures the three options
without recommending one, since the trade-off is a matter of taste
about the chat client's command vocabulary.

## 2. Visibility of edit history to other participants

The daemon retains revision history per message and surfaces it through
`messageHistory`, but it is unclear whether the *recipient's* chat UI
should also display the "edited" annotation and offer the revision
panel.

Arguments for: transparency. Recipients deserve to know that the text
they see has changed.

Arguments against: an agent may make many small "thinking..."
revisions during a streaming response, and exposing all of them as a
clickable history clutters the inbox.

A middle ground noted in the source: *always show "edited" but only
expose the revision panel for messages that were ever settled (`done:
true`) and then re-edited*. The middle ground captures the cost of
each path: hiding edits entirely loses transparency; exposing every
streaming-tick edit floods the inbox; exposing only post-settle edits
discloses the user-visible writes (the ones a recipient might have
acted on) without surfacing every internal streaming tick.

The middle-ground proposal aligns with the design's own *not-done
messages are not editable from the UI* gate (decision 2 in the
sibling section): both rules treat *settled-then-edited* as the
recipient-significant event class, distinct from *still streaming* or
*never edited*.

## Implications for Endo

The two open questions illustrate two different *un-shipped* kinds.
The first (slash-command collision) is a vocabulary collision the
chat-client's command bar would have to negotiate as more designs
land; it points at the absence of a chat-client design that enumerates
the *current* command vocabulary as a single inventory. The second
(recipient-side visibility) is a UX trade-off between transparency and
inbox noise that depends on operational data the chat client does not
yet have (how often does an agent edit during streaming, how often
post-settle, what does the typical recipient want to see). Both kinds
are common: a design lands its load-bearing decisions and surfaces the
remaining trade-offs as named open questions for the maintainer to
resolve when operational signal accumulates.

## See also

- [[endo-but-for-bots--llm-designs-chat-view-edit-commands]] — the sibling design that competes for the `/edit` name and the `e` shortcut; the *Authority* section's focus-target disambiguation resolves the keyboard case but not the slash-command case.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]] — names the *inline-hints-complement-modeline* discipline that option (b) above would strain.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
