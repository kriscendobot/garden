---
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
ingested: 2026-05-15
ingested_by: scholar
section_count: 4
status: current
notes: |
  **Status: Not Started** upstream. Closes a UI parity gap: the daemon
  shipped `editMessage` and `messageHistory` via the streaming-message
  work in [[endo-but-for-bots--llm-designs-daemon-message-streaming]]
  (implemented in `endojs/endo-but-for-bots#23`), but the chat client
  did not yet surface either. This design adds the chat side — three
  coordinated entry points (slash `/edit`, focus `e`, hover pencil) that
  all converge on one inline-command-form dispatch path, plus an
  `edited <timestamp>` caption that opens a read-only revision panel.
  Notable design properties: pre-populate from the typed payload (not
  the DOM); chip carries the locator (not the stale pet name);
  edit-while-streaming is hidden; edit is gated by sender-matches-profile.
  Two named open questions (slash-command name collision with the blob
  editor, and recipient-side history visibility) are deferred to the
  maintainer.
---

> Abstract: Chat UI affordances for editing one's own previously sent
> messages, mirroring the daemon's `editMessage` and `messageHistory`
> capabilities that landed in
> [[endo-but-for-bots--llm-designs-daemon-message-streaming]]. Three
> coordinated entry points — `/edit <referent>` slash command, `e`
> focus-mode shortcut, hover pencil button — converge on a single
> dispatch path that opens the inline command form's body editor,
> pre-populated from the typed Markdown payload (not the rendered
> DOM). Embedded token chips preserve the underlying capability
> locator even when the displayed pet name has drifted, applying the
> [[token-chip]] discipline to edit-mode. While an edit is in flight,
> the envelope renders the same indeterminate-progress affordance as
> not-done streaming messages. A message that has been edited carries
> an `edited <timestamp>` caption that opens a read-only revision
> panel rendering `messageHistory(number)` oldest-first, with each
> revision rendered through the same Markdown-and-tokens pipeline as
> the live envelope. Editing preserves `messageId`, `replyTo`, and
> message number; the focus-chain visualization is unaffected. Four
> load-bearing decisions: indefinite edit time-window, edit hidden
> until message settles, pre-populate from model not DOM, chip carries
> locator not pet name. Two open questions deferred to the maintainer:
> `/edit` slash-command name collision with the
> [[endo-but-for-bots--llm-designs-chat-view-edit-commands]] blob
> editor, and whether the recipient's chat UI should show the
> `edited` caption / revision panel for messages they received.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-authority](../sections/endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority.md) | chat-ui | current |
| [in-flight-and-revision-history](../sections/endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history.md) | chat-ui | current |
| [design-decisions](../sections/endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions.md) | chat-ui | current |
| [open-questions](../sections/endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions.md) | chat-ui | current |

## See also

- `chat-command-bar.md` — the inline-command-form `/edit` registers with.
- `chat-focus-message.md` — the focus-mode shortcut framework `e` joins (not yet ingested).
- `chat-components.md` — `send-form.js`, `message-picker.js`, `markdown-render.js` are reused by the edit form.
- `chat-markdown-render.md` — the rendering pipeline the revision panel reuses for each historical payload.
- `chat-view-edit-commands.md` — the sibling design competing for the `/edit` name and the `e` shortcut.
- `daemon-message-streaming.md` — provides `editMessage` and `messageHistory` (not yet ingested).

The [[token-chip]] concept page is the right entry point for an agent investigating *how does a chip behave inside an editable message?* — decision 4 of this source extends the concept's *identity is the chip, not the name* rule to the edit-mode form.
