Inbox empty. Work is complete.

## Completion report

**Job:** Null-guard the gh-pages bulletin inbox loader (garden's own frontend; landed directly on `main2`, no PR per CLAUDE.md § Conventions).

**Root cause (confirmed):** In `docs/bulletin/app.js`, the maintainer-inbox render loop did `parseMessage(file.text)` on the result of `GH.getFile(...)`. `getFile` returns `null` on a 404 (`docs/bulletin/github.js:63`), which happens on a benign race — a file listed under `inbox/maintainer/unread/` is fetched a moment after a concurrent reply moved it `unread → read`, or the Contents API transiently 404s. `null.text` then threw and the outer `catch` surfaced the raw string *"Could not load inbox: can't access property text, file is null"* until the next load.

**Fix (`docs/bulletin/app.js`, one commit `37a6dfbeb`):**
- Wrapped the per-file `getFile` in try/catch and added `if (!file) continue;` — a null/failed fetch skips that one item instead of aborting the whole render. A genuinely unexpected failure logs a single non-fatal `console.warn` so it stays diagnosable.
- Replaced the pre-loop empty check with a `rendered` counter and an after-loop *"No unread messages to the maintainer."* — so the empty state also shows correctly when every listed file was skipped, rather than a blank pane. The existing *"loading messages…"* state is retained.
- Confirmed the only other `getFile(...).text` site (the README load, ~line 272) was already null-guarded via `if (readme)`; these were the sole two call sites.

**Verify:** Syntax-checked both files (`node --check`). Drove the exact loop logic with stubbed `GH`/DOM against three cases: (a) three listed files where the middle returns null and the last throws — the surviving message renders, the other two skip cleanly (one console.warn), no crash string; (b) empty inbox → "No unread messages"; (c) all-listed-files-vanished → still shows the empty state. All passed.

**Changed:** `docs/bulletin/app.js`. **Follow-ups:** none.
