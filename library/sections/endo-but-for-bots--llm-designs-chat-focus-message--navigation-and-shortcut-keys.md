---
title: Navigation and shortcut keys
source: designs/chat-focus-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8fe17b1c61bf50fae8a97f97bc2aa7385a209f11
source_date: 2026-03-04
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  Both the per-message navigation gestures (arrow keys, PageUp/PageDown
  with viewport accumulation) and the per-command single-letter shortcuts
  that transition out of focus mode into the inline command form with
  `messageNumber` pre-filled. The five shortcut keys (`r`/`d`/`a`/`g`/`s`)
  are exactly the commands in `command-registry.js` that have a
  `messageNumber` field and are common enough to warrant a single-key
  dispatch.
---

> Abstract: While in focus mode, `↑` and `↓` move the focus highlight
> between messages; the focused message scrolls into view if needed.
> `PageUp` and `PageDown` jump by roughly half a viewport, computed by
> **accumulating actual rendered message heights** from the current
> position (not by a fixed `N`-message stride). At the edges the scroll
> container is scrolled to its limit directly (rather than relying on
> `scrollIntoView`) to ensure the first/last message aligns flush with
> the container boundary. These are handled as global `keydown` events
> because the input is blurred. Single-letter shortcut keys enter a
> command with the focused `messageNumber` pre-filled: `r` reply, `d`
> dismiss, `a` adopt, `g` grant, `s` submit; the modeline displays them
> as `<kbd>`-decorated abbreviations plus `Esc` back. Each shortcut
> emerges from a single registry rule: the command must have a
> `messageNumber` field and must be common enough to warrant a one-key
> binding. Pressing any shortcut exits focus mode by transitioning into
> the inline command form (the mode change is incidental; the user's
> intent is "act on the focused message"). Pressing `↓` on the last
> message exits focus mode entirely and returns to the command line.

## Per-message navigation

`↑` and `↓` arrow keys move the focus highlight between messages while
in focus mode. The focused message scrolls into view if needed via
`scrollIntoView`.

`PageUp` and `PageDown` jump by roughly half a viewport, **computed by
accumulating actual rendered message heights from the current
position** rather than by a fixed number of messages. The
heights-accumulation discipline matters because messages in the
transcript vary in height (single-line acknowledgments, multi-paragraph
markdown bodies, eval-proposal envelopes with code blocks) and a fixed
`N`-message stride would feel uneven; accumulating actual heights makes
the motion proportional to visible content.

At the **edges**, the scroll container is scrolled to its limit
directly rather than via `scrollIntoView`. The reason is alignment:
`scrollIntoView` brings a target into the viewport but does not
guarantee flush alignment with the container boundary. Scrolling the
container directly ensures the first / last message in the transcript
aligns flush with the container's top / bottom edge.

These navigation handlers are global `keydown` events. This is
necessary because the input is blurred during focus mode, so the input
cannot be the event target. The global listener checks the chat bar's
mode (`'focus'`) and dispatches accordingly.

## Edge-exit symmetry

Pressing `↓` on the **last** message exits focus mode entirely and
returns to the command line. This mirrors the entry gesture (`⌘↑` from
the command line; see the
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]]
section) so the user can fluidly move between the transcript and the
input. The same arrow that navigates within focus mode carries past the
last message into a mode-exit.

This is a small instance of the *escape consistency* UI invariant
([[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]):
every state has a path back to a safer ancestor, and the path is
discoverable from the same gestures the user already knows.

## Shortcut keys

Single-letter keys enter a command with the focused message number
pre-filled:

| Key | Command | Description |
|-----|---------|-------------|
| `r` | `/reply`   | Reply to the focused message |
| `d` | `/dismiss` | Dismiss the focused message |
| `a` | `/adopt`   | Adopt a value from the focused message |
| `g` | `/grant`   | Grant an eval-proposal |
| `s` | `/submit`  | Submit values for a form |

These are the commands from `command-registry.js` that:

1. Have a `messageNumber` field (so pre-fill is meaningful).
2. Are common enough to warrant a single-key shortcut.

When a shortcut key is pressed, the inline command form opens with the
`messageNumber` field pre-filled and focus advances to the next field
(typically the message body). The mode transition is one half of the
*pressing a shortcut also exits focus mode* contract from the
[[endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit]]
section; the pre-fill is the other half, and the pre-fill mechanism
itself is covered in
[[endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files]].

## Modeline

The modeline displays the shortcuts as `<kbd>`-decorated abbreviations:

```
<kbd>r</kbd> reply  <kbd>d</kbd> dismiss  <kbd>a</kbd> adopt  <kbd>g</kbd> grant  <kbd>s</kbd> submit  <kbd>Esc</kbd> back
```

The five action keys plus `Esc` form one line. Per the *modeline
completeness* UI invariant
([[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]),
the modeline must list every keyboard action available in the current
state; focus mode's modeline lists exactly the five command shortcuts
plus the back-out gesture.

## Extension by sibling designs

Two sibling designs extend the shortcut key list under their own kinds
of focused value, not by adding to the focus-message design itself:

- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]]
  adds `e` (edit) when the focused element is a **message envelope**
  the user sent (sender-only authority).
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]]
  adds `v` (view) and `e` (edit) when the focused element is a **blob
  chip** or a directory entry that resolves to a blob.

The `e` collision between chat-message edit and blob edit is
resolved by *focus target*: the same keystroke fires different
commands depending on whether the currently-focused element is a
message envelope or a blob chip. Both sibling designs name the
collision explicitly; the chat-edit-message-ui design also names the
`/edit` slash-command-name collision as an unresolved open question
(see its
[[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]]
section).

The base set in this section is *what focus mode itself ships with*;
the extensions ship with the respective sibling designs.

## See also

- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the *modeline completeness*, *keyboard-manual parity*, and *escape consistency* UI invariants the focus-mode navigation and shortcut surface honor.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps]] — the nine command categories; the five focus-mode shortcuts span Messaging (`r`), Storage / Cleanup (`d`, `a`), Execution (`g`), and Forms (`s`).
- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — the `messageNumber` typed field; one of the eight types focus-mode pre-fills.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]] — the `e` chat-message-edit shortcut extension to focus mode.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — the `v` and `e` blob-editor shortcut extensions to focus mode.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
