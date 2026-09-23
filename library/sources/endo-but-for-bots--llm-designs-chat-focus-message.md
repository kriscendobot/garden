---
source: designs/chat-focus-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8fe17b1c61bf50fae8a97f97bc2aa7385a209f11
source_date: 2026-03-04
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
section_count: 5
status: current
notes: |
  Supersedes designs/chat-reply-chain-visualization.md (the MOI / message-of-interest layout). The supersession is the design's first content line. Focus mode is the deliberate-mode replacement for the earlier auto-inferred reply-chain visualization. The chat-edit-message-ui (`e` on a message envelope) and chat-view-edit-commands (`v` / `e` on a blob chip) designs both extend the focus-mode shortcut set ingested here.
---

> Abstract: Familiar Chat's focus message mode — a deliberate,
> user-initiated mode for selecting a message in the transcript and
> dispatching commands against it. Supersedes the earlier reply-chain-
> visualization (MOI) layout, which tried to automatically infer
> which message was interesting; focus mode replaces automatic
> inference with user-initiated selection. Entered via `⌘↑` from an
> empty `send`-mode input (or by clicking on a non-interactive part
> of a message); exited via `Escape`, by pressing any shortcut key
> (which transitions into a pre-filled command form), or by pressing
> `↓` on the last message (which mirrors the entry gesture
> symmetrically). Five command shortcuts: `r` reply, `d` dismiss, `a`
> adopt, `g` grant, `s` submit — exactly the commands in
> `command-registry.js` that have a `messageNumber` field and are
> common enough to warrant a one-key binding. Visualizes reply-chain
> structure around the focused message via a primary chain walk
> (backward via `replyTo`; forward via "last reply at each step")
> plus a secondary connections pass that classifies indented
> messages as gutter-connected (`chain-tee`),
> predecessor-connected (`sub-start` / `sub-end` / `sub-through`),
> or reply-indicator (`sub-indicator`). The pre-fill mechanism
> (`prefill?` on `setCommand`; `skipFilled` on `focus()`) is a
> generic primitive that sibling designs (the blob `/view` and
> `/edit` editor; the chat-message edit) compose with for their own
> pre-fill needs. Four key files:
> `packages/chat/chat-bar-component.js`,
> `packages/chat/inline-command-form.js`,
> `packages/chat/inbox-component.js`, and
> `packages/chat/index.css`. Out-of-scope: automatic MOI selection,
> multi-message selection, arrowheads on chain lines.

| Section | Topics | Status |
|---------|--------|--------|
| [motivation-entry-and-exit](../sections/endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit.md) | chat-ui | current |
| [navigation-and-shortcut-keys](../sections/endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys.md) | chat-ui | current |
| [indentation-algorithm-and-chain-lines](../sections/endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines.md) | chat-ui | current |
| [visual-design-and-data-model](../sections/endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model.md) | chat-ui | current |
| [prefill-mechanism-and-key-files](../sections/endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files.md) | chat-ui | current |

## See also

- [endo-but-for-bots--llm-designs-chat-edit-message-ui.md](endo-but-for-bots--llm-designs-chat-edit-message-ui.md) — sibling that extends focus mode with `e` to dispatch chat-message edit; the `/edit` slash-command-name collision with the blob-editor is the unresolved open question.
- [endo-but-for-bots--llm-designs-chat-view-edit-commands.md](endo-but-for-bots--llm-designs-chat-view-edit-commands.md) — sibling that extends focus mode with `v` and `e` to dispatch blob-editor commands; the `e` keystroke collision is resolved via focus-target (message envelope vs blob chip).
- [endo-but-for-bots--llm-designs-chat-command-bar.md](endo-but-for-bots--llm-designs-chat-command-bar.md) — the command-bar state machine; focus is one of its states.
- [endo-but-for-bots--llm-designs-chat-invariants.md](endo-but-for-bots--llm-designs-chat-invariants.md) — the six UI invariants the focus-mode design honors (modeline completeness, keyboard-manual parity, escape consistency).
- [endo-but-for-bots--llm-designs-chat-components.md](endo-but-for-bots--llm-designs-chat-components.md) — the broader file structure and component map; the four files focus-mode touches sit within that map.
