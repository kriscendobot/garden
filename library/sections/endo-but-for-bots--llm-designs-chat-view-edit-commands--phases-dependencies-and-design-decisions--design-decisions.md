---
title: Design decisions
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
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions
---

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

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
