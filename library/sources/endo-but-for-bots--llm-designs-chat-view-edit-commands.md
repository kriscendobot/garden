---
source: designs/chat-view-edit-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2691e7d52d061c0a10b89864e879188f2d4e11d7
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-28
ingested_by: scholar
section_count: 5
status: current
notes: |
  **Status: Not Started** upstream. Closes the inventory's blob-leaf
  gap: the chat client today renders the inventory but cannot open
  the leaves; reads and edits force the user to escape to `endo cat`
  or the local filesystem. The design adds two slash commands
  (`/view`, `/edit`) plus focus-mode shortcuts (`v`, `e`) that each
  resolve a `petNamePath` to a blob and open a Monaco-backed modal.
  Five load-bearing design decisions: modal overlay (not embedded
  panel); Monaco reuse (not a new editor); Markdown split view phased
  to Phase 4; immutable blobs produce new formulas on save
  (content-addressed immutability); content type from extension (not
  MIME sniffing). The Markdown synchronized split view is the most
  complex sub-feature and is explicitly phased out of the critical
  path so Phases 1-3 can ship without it. Sibling design
  [chat-edit-message-ui](endo-but-for-bots--llm-designs-chat-edit-message-ui.md)
  surfaces a known name-collision over `/edit` and `e` — the chip
  carries blob identity (this design) versus message envelope
  identity (chat-edit-message-ui); the slash-command name itself is
  an unresolved open question deferred to the maintainer.
---

> Abstract: Two slash commands (`/view`, `/edit`) and two focus-mode
> shortcuts (`v`, `e`) that operate on the blob leaves of the chat
> inventory. Both commands accept a `petNamePath` (the chat's typed
> input vocabulary), resolve the path to a `ReadableBlob` /
> `SnapshotBlob` or a blob entry inside a `ReadableTree` / `Directory`,
> and open a wider-than-standard modal hosting Monaco. The viewer
> picks a renderer from the path's file extension (plain text, JSON,
> Markdown, future images). The editor's save flow is the load-bearing
> capability decision: a mutable blob's parent receives `write()`; an
> immutable blob produces a new `readable-blob` formula and prompts
> the user for a pet name to bind it under, preserving
> content-addressed immutability rather than papering over it. The
> Markdown synchronized split view (Monaco source on the left, live
> HTML preview on the right with cross-panel scroll synchronization)
> is acknowledged as the most complex sub-feature, reuses the same
> `@endo/markmdown` typed-AST pipeline as chat message rendering, and
> is phased to Phase 4 so the core commands ship in Phases 1-3
> without the synchronized-scroll mechanics. Five load-bearing
> decisions cover modal-vs-panel, Monaco reuse, Phase-4 separation,
> immutability-as-new-formula, and extension-as-content-type. Five
> upstream dependencies are named (chat-command-bar,
> chat-markdown-render, chat-focus-message, daemon-mount,
> daemon-checkin-checkout). Sibling design chat-edit-message-ui
> names an open question over the `/edit` slash command and `e` focus
> shortcut; this design's `e`/`v` operates on blob chips, the
> sibling's `e` operates on message envelopes, so focus-target
> discriminates the keyboard shortcut but the slash-command name
> requires maintainer resolution.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-blob-access-gap](../sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap.md) | chat-ui | current |
| [commands-viewer-editor-and-panel-layout](../sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout.md) | chat-ui | current |
| [markdown-synchronized-render-panel](../sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel.md) | chat-ui | current |
| [loading-blob-content-and-focus-mode](../sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode.md) | chat-ui | current |
| [phases-dependencies-and-design-decisions](../sections/endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions.md) | chat-ui | current |

## See also

- `chat-edit-message-ui.md` — the sibling design competing for the `/edit` slash command and `e` focus shortcut; resolves the keyboard collision via focus target (message envelope vs blob chip), defers the slash-name collision to the maintainer.
- `chat-markdown-render.md` — the typed-AST Markdown pipeline whose reuse makes the editor's preview consistent with chat-message rendering; the parallel four-phase rollout the maintainer's discipline favors.
- `chat-command-bar.md` — the command-registration and modal-dispatch infrastructure both new commands ride on; the `petNamePath` typed input field shared with eight others.
- `chat-components.md` — the file-structure and profile-system architecture the new commands compose with.
- `chat-color-schemes.md` / `chat-per-space-color-scheme.md` — the Monaco-iframe `set-theme` post-message bridge the editor's Monaco instance honors.
- `chat-invariants.md` — the six MUST-hold UI invariants the modal-overlay and extension-as-content-type decisions honor.

## Self-referential notes

This source was ingested on 2026-05-28 as scholar cycle 70's pick
from the chat lane in the three-lane rotation (chat / papers /
comments). The prior cycle (liaison orchestrator-direct-draft
2026-05-21) wrote three concept pages anchoring the Miller cluster;
the chat lane was the lighter-lift complement to either of the
heavier comment-fragment candidates (`packages/ses/src/lockdown.js`,
`packages/pass-style/src/passStyleOf.js`). Five sections is at the
upper end of a typical chat-design ingest; the source's 225 lines
across six H2 sub-sections produced a natural fivefold split
(Problem; Commands+Viewer+Editor+Layout merged; Markdown alone;
Loading+Focus merged; Phases+Dependencies+Decisions merged).
