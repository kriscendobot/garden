---
title: Phases, dependencies, and design decisions
source: designs/chat-view-edit-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2691e7d52d061c0a10b89864e879188f2d4e11d7
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-28
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  Combines the design's *Phases*, *Dependencies*, and *Design
  Decisions* sections into one section. The four-phase rollout is the
  delivery shape; the dependency table is what the design assumes;
  the five design decisions are the load-bearing trade-offs the
  design names explicitly.
---

> Abstract: Four-phase rollout: Phase 1 ships `/view` with plain-text
> Monaco read-only; Phase 2 adds `/edit` with mutable-save (and
> immutable save-as-new); Phase 3 adds extension-based language-mode
> selection in Monaco; Phase 4 adds the Markdown split view with
> synchronized scroll. Five dependencies are listed: the command-bar
> infrastructure (command-bar), the Markdown pipeline reuse
> (chat-markdown-render), focus-mode (chat-focus-message), and two
> daemon-side prerequisites for writable directory entries
> (daemon-mount, daemon-checkin-checkout). Five load-bearing design
> decisions are recorded: modal overlay (not embedded panel); Monaco
> reuse (not a new editor); Markdown split view phased separately;
> immutable blobs produce new formulas on save (content-addressed
> immutability); content type from extension (not MIME sniffing).

## Phases

The design names a four-phase rollout that explicitly defers the
most complex sub-feature (Markdown split view) so the core commands
can ship first:

1. **Phase 1: `/view` with plain text.** Modal viewer, Monaco in
   read-only mode, content loaded via `text()`. No content-type
   inference beyond "text".

2. **Phase 2: `/edit` with mutable save.** Monaco editor with
   save-back to writable directories. Immutable blobs get "save as
   new" behavior.

3. **Phase 3: Content type inference.** Extension-based language
   mode selection for Monaco (`.js`, `.json`, `.ts`, `.py`, etc.).

4. **Phase 4: Markdown preview.** Synchronized two-panel layout for
   `.md` files, reusing the chat Markdown renderer. Scroll
   synchronization.

The shape is consistent with the maintainer's rollout discipline
across the chat corpus: ship the bones first (Phase 1 plain-text
view); add the next-largest affordance (Phase 2 mutable edit); add
the visible polish (Phase 3 language modes); add the complex
sub-feature last (Phase 4 synchronized split view). See the
[[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]]
section for the synchronized-scroll mechanics that justify Phase 4's
separation, and the
[[endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout]]
section for the parallel four-phase pattern in chat-markdown-render
itself.

## Dependencies

| Design                                                                                                            | Relationship                                                              |
|-------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| [chat-command-bar](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-command-bar.md)              | Command registration and modal dispatch                                   |
| [chat-markdown-render](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-markdown-render.md)      | Markdown rendering pipeline reused for preview                            |
| [chat-focus-message](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-focus-message.md)          | Focus mode shortcut integration                                           |
| [daemon-mount](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-mount.md)                      | Writable directory entries for `/edit` save                               |
| [daemon-checkin-checkout](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-checkin-checkout.md) | `ReadableTree` blob access patterns                                       |

The chat-command-bar dependency is unsurprising: every chat slash
command rides on the command-bar's registration and modal-dispatch
machinery. The chat-markdown-render dependency is the load-bearing
piece for Phase 4: without it, the Markdown preview would either
ship a second renderer (creating the styling and security drift the
design explicitly avoids) or omit the preview entirely. The
chat-focus-message dependency provides the framework the `v` and
`e` shortcuts join. The two daemon-side dependencies (daemon-mount
and daemon-checkin-checkout) provide the writable directory entries
the mutable-save path operates on; without them, only immutable
save-as-new would be available.

Of these five, the chat-command-bar and chat-markdown-render designs
are already ingested in the library; chat-focus-message,
daemon-mount, and daemon-checkin-checkout are not yet (and were not
in the cycle 70 ingestion lane). The cross-design dependency graph
the chat-design corpus is building up is its own structural
artifact: the chat client's bones are an explicit composition of
roughly a dozen named designs.

## Design decisions

The design names five load-bearing decisions explicitly. Each is
small in isolation; together they shape the surface and the
implementation strategy.

### 1. Modal overlay, not an embedded panel

Editing and viewing are focused tasks that benefit from maximum
screen space. A modal can be dismissed to return to the conversation,
whereas a persistent panel would compete with the transcript and
inventory for space.

The choice is consistent with the existing eval-form and help-modal
patterns: the chat client uses modal overlays for *focused tasks*
and persistent panels for *navigational tasks*. A blob viewer or
editor falls clearly on the focused-task side; the user is reading
or writing one specific blob, not browsing.

### 2. Reuse Monaco, not a new editor

The codebase already integrates Monaco for the eval form. Reusing it
avoids a second editor dependency and provides familiar keybindings.

The chat client already pays Monaco's costs (bundle size, iframe
isolation, the postMessage bridge for theme synchronization). A
second editor framework would double the cost without a
proportionate benefit; users would learn two slightly-different
keybinding regimes; the security posture would have to be
re-litigated. The reuse decision rolls forward the existing
investment.

### 3. Markdown split view is phased separately

Synchronized scroll between an editor and a rendered preview is
non-trivial (line-to-element mapping, variable-height rendered
blocks). Deferring it to Phase 4 lets the core `/view` and `/edit`
commands ship without this complexity.

This decision pairs with Phase 4 in the *Phases* table: the core
commands do not block on the most complex sub-feature; the
sub-feature lands when it is ready, and Phase 1-3 are fully usable
without it.

### 4. Immutable blobs produce new formulas on save

Content-addressed storage is append-only by design. Editing a
`ReadableBlob` creates a new blob rather than violating immutability.
The user is prompted to name the new blob.

This is the load-bearing capability decision. The chat client does
not paper over the daemon's content-addressed-immutability model; an
edit on an immutable blob *produces a new capability* (a new blob
formula) and the chat client surfaces that by asking the user where
to bind it. The discipline is the same one applied throughout the
formula-graph corpus: identity is the content hash, not the surface
name; mutation produces a new identity rather than rewriting an old
one. See the
[[endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout]]
section for the editor-panel surface that implements this fork.

### 5. Content type from extension, not MIME sniffing

Blobs in Endo do not carry MIME metadata. Extension-based inference
is simple, predictable, and matches how Monaco selects language
modes.

The decision honors the daemon's existing data model rather than
forcing a new metadata channel just for the chat client. It is also
predictable in a way MIME sniffing would not be: the user sees a
`.js` blob and knows it will get JavaScript syntax highlighting,
without having to know what the daemon happened to record about the
blob's bytes. Predictability is itself a chat-client value (see the
chat-invariants
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]
*modeline completeness* and *escape consistency* invariants for
adjacent rules that prize predictable, audit-able behavior).

## Prompt

The source document closes with the original prompt that produced
the design:

> Design Chat /view and /edit commands that operate on directory
> entries that correspond to blobs. These would open a viewer or
> Monaco editor. Allow for the possibility this could be complicated
> for Markdown in particular, which would enjoy a synchronized
> render panel.

The Markdown synchronized render panel reappears as the design's
most complex sub-feature and is phased to Phase 4 for that reason.

## See also

- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout]] — the surface the design decisions justify.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]] — Phase 4 and the synchronized-scroll mechanics that justify its separation.
- [[endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout]] — the parallel four-phase rollout in chat-markdown-render; same maintainer discipline of phased complexity.
- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the six MUST-hold UI invariants the modal-overlay and predictable-content-type decisions honor.
- [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]] — the Monaco bridge the editor's Monaco instance honors for theming.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]] — the named collision over the `/edit` slash command between this design and the chat-edit-message-ui sibling.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
