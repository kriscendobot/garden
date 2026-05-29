---
title: Motivation, entry, and exit
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
  Focus message mode supersedes the earlier `chat-reply-chain-visualization.md`
  (MOI / message-of-interest layout). The header of the source file names the
  supersession explicitly; this section captures the design's deliberate-mode
  framing and the entry/exit gestures that surround it.
---

> Abstract: Focus message mode is a deliberate, user-initiated mode for
> selecting one message in the transcript and dispatching commands against
> it. It supersedes the earlier reply-chain-visualization (MOI) layout,
> which tried to *automatically infer* which message was interesting and
> visualize reply trees around it. The new mode is deliberate by design:
> the focused message is **never implicitly the head of a reply chain**;
> it simply pre-populates the `messageNumber` field when the user invokes
> a command from focus mode. Entry: `⌘↑` from an empty `send`-mode input
> (or click on a non-interactive part of a message); the input blurs, the
> last message receives `.focused`, the modeline reveals the shortcut keys.
> Exit: `Escape` returns to `send` mode and refocuses the input; pressing
> any shortcut key also exits by transitioning into the inline command
> form with the message number pre-filled. The entry gesture is
> symmetric with the exit-by-arrow gesture (`↓` on the last message
> exits focus mode and returns to the command line) so the user can
> fluidly move between transcript and input.

## Motivation: deliberate over implicit

The earlier reply-chain visualization (the MOI layout, captured in the
now-superseded `chat-reply-chain-visualization.md`) tried to *automatically
infer* which message was interesting and visualize reply trees around it.
The design's first sentence frames the new mode by contrast:

> This was complex and implicit.

Focus message mode takes a different approach: it provides a deliberate,
user-initiated mode for selecting a message and dispatching commands
against it. The focused message is **never** implicitly the head of a
reply chain. It simply pre-populates the `messageNumber` field when the
user invokes a command from focus mode.

The three goals enumerated by the design:

1. Let users quickly act on messages without mouse interaction.
2. Pre-populate `messageNumber` fields for commands that need them.
3. Visualize reply-chain structure around the focused message.

Goal 3 is the visualization the MOI layout tried to do automatically;
focus mode subordinates it to the user-initiated mode rather than letting
the renderer infer it. The reply-chain visualization only happens when
the user has explicitly entered focus mode and pointed at a message.

## Entering focus mode

The user enters focus mode by pressing `⌘↑` (Cmd+ArrowUp on macOS,
Ctrl+ArrowUp elsewhere) when **both** of these hold:

- The chat bar is in `send` mode.
- The input is empty.

On entry:

- Mode changes to `'focus'`.
- The input is blurred.
- The last message in the inbox is highlighted (receives `.focused`
  class).
- Reply-chain-aware indentation is computed (see the *indentation
  algorithm* section).
- A focus modeline appears showing available shortcut keys.

Clicking a message also enters focus mode (or changes the focused
message if already in focus mode), **provided the click is not
intercepted by an interactive element within the message**. The
click-to-focus path is the mouse-side parallel of the keyboard `⌘↑`
gesture; both lead to the same focused-state machine.

The `⌘↑` entry gesture uses `stopPropagation()` on the input's keydown
to prevent the global handler from treating the same event as a
navigation action. This matters because navigation `↑` and `↓` inside
focus mode are global `keydown` events (the input is blurred); the
entry gesture has to suppress the same handler that will later be
listening for navigation.

## Exiting focus mode

Pressing `Escape` exits focus mode:

- Mode returns to `'send'`.
- The `.focused` class is removed from all messages.
- The `.focus-active` class is removed from the messages container.
- The input is re-focused.

Pressing a shortcut key (the per-command single-letter keys covered
in the *navigation and shortcut keys* section) **also** exits focus
mode, by transitioning to the inline command form with the message
number pre-filled. From the user's perspective the shortcut press is
not "exit then enter a command"; it is "act on the focused message",
and the mode change is incidental to the action.

There is also an arrow-edge exit: pressing `↓` on the last message
exits focus mode and returns to the command line. This **mirrors the
entry gesture** (`⌘↑` from the command line) so the user can fluidly
move between the transcript and input. The symmetry is deliberate:
the same arrow that navigates within focus mode (down moves focus to
the next message) carries past the last message into a mode-exit.

## Translation

| Design term | Library / chat-corpus term |
|---|---|
| `messageNumber` field | one of the eight typed field types in the chat command bar (see [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]]) |
| chat bar | the command-bar component covered in the [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] section; focus mode is one of its states |
| modeline | the per-state line of `<kbd>` hints; the *modeline completeness* UI invariant covers this surface (see [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]) |
| reply chain | a primary-chain walk through `replyTo` links; visualized only after focus is entered |
| MOI / message of interest | the superseded layout from `chat-reply-chain-visualization.md`; replaced by deliberate user-initiated focus |

## See also

- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — focus mode's modeline reveals shortcut keys, honoring the *modeline completeness* invariant; the entry gesture is one of the keyboard-manual parity surfaces.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — focus is a state in the command-bar state machine; entry from `send` mode is one of the documented transitions.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the inbox panel's message envelopes are the substrate focus mode highlights; the `.focused` class is applied to one envelope at a time.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]] — the chat-message edit feature's `e` focus-mode shortcut depends on focus mode being entered first; this section establishes the entry/exit gestures the shortcut composes with.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode]] — the blob-editor's `v` and `e` shortcuts extend the same focus-mode framework; this section establishes how the user gets into the mode where those shortcuts apply.

Source: [designs/chat-focus-message.md](https://github.com/endojs/endo-but-for-bots/blob/8fe17b1c61bf50fae8a97f97bc2aa7385a209f11/designs/chat-focus-message.md) at commit `8fe17b1c`.
