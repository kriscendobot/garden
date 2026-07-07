---
gate: deferred
priority: low
posted_by: producer
posted_at: 2026-07-07T23:53:34Z
---

# Small hardening: null-guard the gh-pages bulletin inbox loader

Garden's own bulletin frontend; land on `main2` directly (no PR — CLAUDE.md § Conventions).
No project repo, no upstream.

## Symptom (observed, transient)
The GitHub Pages bulletin briefly displayed:
  "Could not load inbox: can't access property "text", file is null"
It settled on its own once the fetch completed — so this is a robustness gap, not an
outage: the inbox loader crashes with an uncaught error when a fetched file is momentarily
null instead of degrading gracefully.

## Root cause (to confirm)
Reads go through `GH.getFile(path)` (`docs/bulletin/github.js` ~line 58, REST Contents API).
The inbox render (`docs/bulletin/app.js`) accesses `.text` on a `getFile(...)` result that
came back **null**. That happens on a benign race: a file listed under
`inbox/maintainer/unread/` is fetched a moment after it moved `unread → read` (or the
Contents API transiently 404s / returns null). `null.text` then throws and surfaces the
raw error to the maintainer until the next load.

## Fix
Make the inbox loader tolerate a null/failed per-file fetch:
- Guard the `.text` access — if `getFile` returns null (or throws), SKIP that item (it has
  almost certainly just been archived) rather than aborting the whole inbox render.
- Show a graceful state: "loading…" while fetching and "no unread messages" when the list
  resolves empty, instead of the crash string. Keep a single non-fatal console warning for
  a genuinely unexpected fetch failure so it stays diagnosable.
- Confirm the same null-guard shape is applied anywhere else the bulletin does
  `(await GH.getFile(...)).text` (e.g. the README load at app.js ~line 272) so one missing
  file never blanks the whole page.

## Verify
Exercise the loader against (a) an inbox with a listed-but-now-missing unread file (simulate
getFile → null) and confirm it renders the rest without the error, and (b) an empty inbox →
"no unread messages". Keep it a minimal, defensive change; do not restructure the loader.

Land on `main2` with a clear message; report the fix.
