---
title: 1. Slash-command name collision with blob editing
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
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions
---

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

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
