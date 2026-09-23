---
ts: 2026-05-18T06:26:15Z
kind: message
role: builder
to: liaison
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# Builder impasse: `chat-view-edit-commands.md` Phase 1 is already shipped on `llm`

## What I was asked to do

Dispatch `dispatches/builder--9e20d2/`: implement Phase 1 of
`designs/chat-view-edit-commands.md` on the `llm` branch of
`endojs/endo-but-for-bots`. Phase 1 was scoped narrowly to the
`/view` read-only blob viewer; `/edit` (Monaco editor) was to be
deferred to a follow-up phase and recorded in the design's Status
section.

## What I found at pre-flight gate 3 (existing-symbol check)

The full feature (both `/view` and `/edit`, plus Monaco editor,
markdown rendering, syntax-highlighted read-only mode, save-back,
and a 301-line unit test file) is **already implemented on `llm`**
and has been for eight weeks. The implementation commit is
`ae2b074ac "Blob view and edit"` (Kris Kowal, direct on `llm`,
~2026-03-22 by file date), followed by three follow-up commits
(`0e52003c4`, `db3739ef5`, `9faaddb92`) that reconciled tests,
types, and lint.

The shipped surface covers Phase 1 through Phase 4 of the design:

| Design phase                                  | Shipped artifact                                                                                                                                                |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Phase 1: `/view` plain text                   | `packages/chat/blob-viewer.js` § `open(path, readOnly=true)`; non-markdown read-only branch renders a syntax-highlighted `<pre>` via `colorize`.                |
| Phase 2: `/edit` with mutable save            | Same component, `open(path, readOnly=false)`; save calls `E(powers).writeText(currentPath, content)`. Daemon-side wiring is in `packages/daemon/src/directory.js` (`readText` / `writeText`). |
| Phase 3: Content-type inference               | `packages/chat/language-detect.js` § `inferLanguage(filename)`, called from `blob-viewer.js`. Language badge rendered in the header.                             |
| Phase 4: Markdown synchronized preview        | `packages/chat/markdown-preview.js` § `renderMarkdownToHtml`, `isMarkdown`; the `/edit` markdown branch in `blob-viewer.js` shows side-by-side editor + live preview with scroll-fraction synchronization. The `/view` markdown branch shows rendered HTML with a Preview/Source toggle. |

Command registration:

- `packages/chat/command-registry.js` registers both `view` (alias
  `cat`) and `edit` commands with `petNamePath` argument and the
  `storage` category.
- `packages/chat/command-executor.js` `case 'view'` calls
  `openBlobViewer(petName, /*readOnly*/ true)`; `case 'edit'` calls
  it with `false`.
- `packages/chat/chat-bar-component.js` instantiates the viewer
  via `createBlobViewer({$container, $backdrop, powers, onClose})`
  using the dedicated `#blob-viewer-container` / `#blob-viewer-backdrop`
  DOM hooks declared in `packages/chat/chat.js`.

Tests: `packages/chat/test/unit/blob-viewer.test.js` (301 lines)
covers the cases the dispatch prompt asked for (command parsing,
rendering modes for text / non-text, error paths) and more.

## Pre-flight gates: results

1. **Open-PR slug check (gate 1)**: `gh pr list ... "chat-view OR
   view-edit OR view-command OR chat-blob-viewer"` returned matches
   for adjacent designs (chat-markdown, chat-edit-message) but **no
   open or closed PR** with a `chat-view-edit`-shaped title or branch
   slug. The feature did not ship through a PR; it was committed
   directly to `llm` by the maintainer.
2. **Design-status drift check (gate 2)**: **Failed.** The design
   file still says `Status: Not Started` (line 7 of
   `designs/chat-view-edit-commands.md`), but the implementation
   covers all four phases. This is design-status drift: the file
   under-reports reality.
3. **Existing-symbol check (gate 3)**: **Failed.** `grep -rn
   "/view\|ViewerModal\|BlobViewer\|view-command" packages/chat/`
   surfaces full implementations in `blob-viewer.js`,
   `chat-bar-component.js`, `chat.js`, `command-executor.js`, and
   the test file. Nothing about the `/view` command can be added.
4. **Substrate audit (gate 4)**: passes; the substrate exists and
   is already wired to a working viewer.

## Cross-reference: the sibling builder dispatch flagged this

`journal/entries/2026/05/18/043505Z-message-builder-88a725.md`
(earlier today, dispatch `builder--ab96fc`, working on
`chat-edit-message-ui.md`) names the `/edit` collision explicitly:

> The design body uses `/edit` and lists three resolutions ((a) rename
> one of the two to `/revise` / `/amend` / `/edit-message` or `/open`
> for the blob editor; (b) overload on argument type; (c) ship this
> design first and rename the blob editor later). The existing `/edit`
> is already shipped, so resolution (c) is no longer available

That message treats this design's `/edit` as a fact-on-the-ground
that the chat-edit-message-ui builder must work around. It is the
same fact-on-the-ground I am hitting now: the work for
`chat-view-edit-commands.md` was done out-of-band.

## Options I considered

1. **Skip implementation; only bump the design Status to Complete
   and write the post-hoc Status prose section.** Lowest-cost,
   accurate, but requires liaison authorization because the
   dispatch's framing assumes Phase 1 implementation work is
   pending; rewriting the design without writing any code is
   outside `build #N` scope and is more of an editorial or
   `journalist`-shaped task. The maintainer should also pick
   whether `/edit` is partial-Phase-2 (mutable save only;
   immutable-blob "save as new" is not shipped) or fully
   Complete.

2. **Open a no-op PR documenting Phase 1 as already shipped.** A
   builder-shaped artifact for the gamut to chew on; produces an
   appropriate audit trail. But the diff would be zero code lines
   plus a design-status edit, which the cleaner/judge chain has no
   real work on. Wasteful.

3. **Build the deferred `/edit` immutable-blob "save as new"
   path** (the one phase that I read as not yet shipped). The
   dispatch prompt explicitly defers `/edit` to a follow-up phase,
   so this is out of scope without re-authorization.

I did not pick. Per the dispatch's pre-flight gates ("if any of
these is missing, surface to liaison"), gates 2 and 3 are exactly
the "stop and surface" trigger.

## Specifically what the maintainer should pick

- (a) Editorial-only follow-up: dispatch a `journalist` (or any
      role with design-doc authority) to (i) bump
      `designs/chat-view-edit-commands.md`'s Status to `Complete`
      (or `In Progress` if option (c) holds), (ii) add the post-hoc
      Status section pointing at the shipped files
      (`blob-viewer.js`, `language-detect.js`, `markdown-preview.js`,
      `command-registry.js` § `view`/`edit`, the daemon
      `readText`/`writeText` wiring, and the test file), and (iii)
      update `designs/README.md`'s summary row + dependency graph
      accordingly. No code change.
- (b) If audit-trail matters more than minimality: dispatch a
      builder against a thin "status-update PR" framing where the
      diff is the design-status sync plus a small README touch-up,
      open as a normal draft PR through the gamut.
- (c) If `/edit`'s immutable-blob "save as new" branch is
      considered still-open Phase 2 work: re-dispatch with a
      narrower brief that asks specifically for the
      `ReadableBlob` / `SnapshotBlob` → new-pet-name save path
      (the design § Editor panel item 2), since that branch is
      not in `blob-viewer.js` today. The current implementation
      calls `writeText` on `currentPath` regardless of
      mutability, which works for entries in writable
      directories and silently fails (via daemon-side
      `disallowedFn`) for immutable blobs.

## Adjacent open question (carry-over from sibling impasse)

The `/edit` command-name collision noted in the
`builder--ab96fc` message is still unresolved. If the maintainer
later wants `chat-edit-message-ui.md`'s `/edit-message` (or
whatever name lands) and the existing blob editor to coexist,
that decision touches this design's Status section too: the
"shipped /edit" claim is what makes resolution (c) of the
sibling design's three-way pick unavailable. Worth threading
both editorial passes (this design's Status sync + that design's
Dependencies fix) into a single liaison decision.

## Repo state at impasse

- `project/` worktree on `llm` HEAD `68246ad92`. No commits made;
  no branch created; no pushes.
- Journal: this message entry plus the matching `result` entry.
  No upstream PR; no upstream interaction at all.

Self-improvement: nothing this time. The pre-flight gates worked
as designed; the dispatch prompt explicitly listed gates 1-4 and
told me to stop at any failure. The shape of the impasse (design
file lags reality; full feature shipped direct-to-roadmap-branch
by maintainer) is the same shape `builder--ab96fc` surfaced two
hours earlier, which suggests a one-off audit of design-status
fields against `llm` HEAD might be worthwhile (cheap pass: `grep
-l "Status.*Not Started" designs/*.md` cross-checked against
recent direct-to-`llm` commits). Routing that observation to the
liaison rather than the steward because the editorial scope is
maintainer-judgement, not autonomous.
