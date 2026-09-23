Inbox empty. The build is complete: DRAFT PR #677 is open against `llm`, locally verified via a passing 7-case component test, lint and tsc clean.

## Completion report

**Job:** Build the Chat inventory `+` create menu and new-agent wizard (`endojs/endo-but-for-bots`, base `llm`, implementing the merged design PR #404).

**Result:** DRAFT PR **[#677](https://github.com/endojs/endo-but-for-bots/pull/677)** — `feat(chat): inventory + create menu and new-agent wizard`, base `llm`, confirmed `isDraft: true`.

### What I built (per the design's phasing)

New files in `packages/chat/`:
- `create-menu.js` — the `+`-button controller + keyboard-navigable pop-over menu (↑/↓/Enter/Esc) listing the five item types, dispatching to the right modal.
- `create-mount-modal.js` — the **working** filesystem-mount and scratch-space flows (`E(powers).provideMount` / `provideScratchMount`), with local pet-name validation and daemon-error field bubbles.
- `create-agent-wizard.js` — the **substantive three-pane new-agent wizard**: harness (Lal/Fae/Genie, discovered + annotated), inference source (provider-by-name with hidden URLs; Anthropic/OpenAI/Ollama/Ollama-Remote/OpenRouter; auth by `authShape`; model picker), and endowment pane. Submit routes to the chosen harness's outstanding manager form via `listMessages`→`reverseLocate`→`submit({name,host,model,authToken})`.
- `create-placeholder-modal.js` — documented placeholders for **passable value** and **structured value** (informational, not half-working).
- `provider-registry-client.js` — the static provider registry (Phase-4 hidden-URL table).

Edited: `chat.js` (top-of-inventory button + menu/modal containers + controller wiring + teardown), `index.css` (button/menu/modal/wizard styles).

### What's live vs placeholder (for UAT)
- **Ready to exercise:** the `+` button at the top, the pop-over menu, **filesystem-mount create**, **scratch-space create**, and the **new-agent wizard** end-to-end (its submit needs an outstanding manager form in the inbox, else it shows a clear "start the manager" error).
- **Placeholder (by design):** passable value, structured value, and pane-3 endowment controls (documentation-only this phase).

### Verification (real-execution evidence)
- New `test/component/create-menu.test.js` (happy-dom): **7/7 passing** — menu opens with five items; mount calls `provideMount(path, name)`; scratch calls `provideScratchMount(name)`; special-name rejection; passable placeholder renders (no form); wizard renders three panes and submits `{name,host,model,authToken}` to the outstanding form; and the no-form error path.
- `yarn eslint` clean on all new/changed files (0 errors; the 21 warnings are pre-existing in `chat.js`); `tsc` (`lint:types`) clean, exit 0.
- `yarn.lock` untouched (no dep changes).

### Design gaps / notes
- No gap in the cited primitives — `provideMount`/`provideScratchMount`/`listMessages`/`submit` are all landed on `llm`. The design's file list predates the inventory's refactor into `@endo/space-chat`, so I followed the design's **intent** (place at top of the inventory panel) rather than its literal filenames.
- Full workspace `yarn install` failed to build the native `better-sqlite3` (unrelated to chat); chat lint/tsc/tests ran fine regardless.

### Follow-ups (noted, in-scope phasing, not built)
`/create` slash command + modeline shortcut; host file picker; live Ollama model listing + one-click pull; OAuth providers; working endowment delivery; full passable/structured flows.
