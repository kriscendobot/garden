Everything is verified and complete. The `command-executor.test.js` is byte-identical to `llm` (the out-of-scope `openBlobViewer` view/cat/edit tests were correctly never brought in; the lone remaining `openBlobViewer` reference is a pre-existing base test in `blob-viewer.test.js`).

---

## Completion report — reconstruct PR #132 (per-message Md/Raw/Pre toggle) on current `llm`

**Outcome:** PR #132 now carries a faithful reconstruction of the per-message render-mode toggle, re-implemented in the confined `@endo/space-chat` `InboxRoot` Preact component on a fresh `llm` base. The PR is **ready for review** (un-drafted after verification), **MERGEABLE**, with 22/24 checks green.

### What I did
- Worked in an isolated project worktree off a fresh frozen `llm` snapshot (`cc41f42e24`).
- **Reconstructed the toggle as Preact vnodes/hooks** in `packages/space-chat/src/inbox.js`:
  - Added a `RenderModeToggle` component + `renderModeOptions` constant.
  - Per-message render state (`useState`) lives in `MessageEnvelope`, threaded to `Timestamp` (renders the toggle in the timestamp tooltip, package messages only) and to `PackageBody` via `MessageContent`.
  - `PackageBody` gained **literal** (plain interleaved `@name` text) and **preformatted** (`<pre class="md-preformatted">`) branches alongside the existing markdown path; the `useContext` hook is called unconditionally to respect the Rules of Hooks.
- **Re-homed the orphaned toggle CSS** (`.render-mode-toggle` / `.render-mode-btn` / `.md-preformatted`) into `packages/chat/index.css` (it did not exist on the fresh `llm` snapshot; the prior review's "auto-merged cleanly" was an artifact of its rebase attempt).
- **Dropped** the out-of-scope `openBlobViewer` view/cat/edit tests (never carried them into `command-executor.test.js`, which is byte-identical to `llm`).
- **Added a load-bearing component test** in `packages/chat/test/component/inbox-markdown.test.js` that drives the toggle through the real confined `InboxRoot` (md→raw→pre→md, asserting variant output and active-button state). Proved it is load-bearing: it fails when the raw/preformatted branch is disabled.

### Verification (real output)
- `yarn ava` — all 27 inbox-related component tests pass (inbox-markdown, inbox-shell, inbox-value, edit-message-inbox, form-request-inbox), including the new toggle test.
- `yarn lint` for `@endo/chat` (tsc + eslint) exit 0; `@endo/space-chat` eslint 0 errors; prettier clean on all three files (no private-package changeset needed).
- CI on the pushed PR: `lint`, `browser-tests` (playwright), `cover (22.x)`, `test (22.x/24.x ubuntu)` all **pass**. Only the two macOS `test` runners remain pending (same suite that already passed on Ubuntu).

### Landing
- Created frozen base `llm-cc41f42`; force-pushed the reconstructed `feat/chat-markdown` (single `feat(space-chat):` commit `583987b629`); retargeted PR base to the frozen snapshot; rewrote the stale PR body to describe the reconstruction (behavior-over-diff).
- Kept the PR draft during the work; un-drafted only after the change-relevant CI checks went green.
- Posted a brief bot-identity PR comment (issue-comment 4951765943) relaying @kriskowal's reconstruct decision and closing the "Please refresh" review loop.

### Follow-ups
- Two macOS `test` runners still finishing (unrelated to this change; Ubuntu equivalents passed) — no action expected.
- The superseded old head (`9e0378371f`) and any prior frozen bases will be swept at PR close per the frozen-base skill.
- Bounds honored: `endojs/endo-but-for-bots` only, bot identity, no ferry, no `agoric/agoric-sdk`.
