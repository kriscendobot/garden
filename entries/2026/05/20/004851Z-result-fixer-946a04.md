---
ts: 2026-05-20T00:48:51Z
kind: result
role: fixer
worktree: dispatches/fixer--ee758d/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/20/003609Z-dispatch-steward-ee758d.md
  - jobs/claimed/endolinbot--20260520T003411Z--0dc9e0--sf-305-chat-edit-message-ui.md
---

# Summary-fix for endojs/endo-but-for-bots#305: five items, three commits

Claimed dispatch `ee758d` for job `0dc9e0` (judge `7a11c8`'s code-panel verdict at PR head `8682264d2`). All five items landed cleanly in three logically grouped commits.

## Per-item disposition

1. **Narrow `editMessage` history-shape cast (line 769)** — DONE. Replaced `Array<{ envelope: any }>` with `MessageRevision[]`. The job spec named `'@endo/daemon/src/types.js'` as the import path, but the daemon's `package.json` exports map only permits `.`, `./ref-reader.js`, `./reader-ref.js`, `./locator.js`, `./pet-name.js`, `./src/interfaces.js`, `./package.json` — `./src/types.js` is not exposed, and `NodeNext` moduleResolution refuses to traverse outside the exports map. The 19+ other `chat/` files all use `@endo/daemon` as the @import root. I took the path-of-least-disruption: added `MessageRevision` to the top-level `packages/daemon/types.d.ts` re-export list (alongside the existing `Message`, `EndoHost`, etc.) and used `@import { MessageRevision } from '@endo/daemon'`. Same outcome, consistent with the chat package's idiom, narrower-scoped surface change.

2. **Drop `edgeNames` fallback (lines 773-776)** — DONE. The daemon publishes `names` on `MessageRevision.envelope` (Package type, line 465 of `daemon/src/types.d.ts`) and the inbox-edit-affordances test mock already uses `names`. Folded into commit 1.

   *Type-narrowing side-effect worth noting:* narrowing to `MessageRevision` exposed that `Message = Request | Package | DefineRequest | Form | ValueMessage`, and only `Package` has `strings`/`names`. The original `{ envelope: any }` cast was hiding this. I added a runtime narrow (`if (latest.envelope.type !== 'package') return;`) at the boundary so the downstream `{ strings, names }` destructure is check-free. Held the chat-bar-component.js TS error count stable at the baseline of 9 (every error pre-existed). Boundary-narrowing matches the spec's stated intent and the project CLAUDE.md's type-assertion discipline.

3. **Eliminate `no-use-before-define` on `editMessage` at line 1733** — DONE (cargo-cult removal). Investigated: `editMessage` is declared at line 759, well *before* the focus-shortcut block's use at line 1733 — so the rule would not fire even if active. Confirmed: the project's `eslint-plugin/lib/configs/internal.js` line 50 sets `'no-use-before-define': 'off'`. The `// eslint-disable-line no-use-before-define` comment was never doing anything. Action: removed the comment. The 27 other identical disable comments throughout the file are preexisting (cargo-cult) and not in scope per the spec. `handleEditMessageEvent` mentioned in the spec is at line 1836 (after the focus block) and is only referenced from lines 1843 and 1856, immediately after declaration — no forward reference. No restructuring needed. Folded into commit 2.

4. **Narrow or remove public `editMessage` field at line 1854** — DONE (dropped). Verified no consumer reads `chatBarAPI.editMessage`: the only `.editMessage` references in the chat package are `E(powers).editMessage(...)` in command-executor.js (daemon power) and the mock's `editMessage:` key in the test (also the daemon mock). The CustomEvent `chat:edit-message` is the documented dispatch surface, already wired in `handleEditMessageEvent`. Dropped the field. Folded into commit 2.

5. **Coerce test `messageNumber` to string and add bigint-type assertion (test line 1051)** — DONE. Changed `messageNumber: 7` → `messageNumber: '7'` (the registry's `'messageNumber'` field is a text input, so production receives a string from the form). Added a `t.is(typeof ctx.calls[0].args[0], 'bigint')` assertion alongside the existing `t.is(..., 7n)`. Regression-evidence verified: temporarily removed the `BigInt(...)` call in `command-executor.js`'s `edit-message` case and re-ran — test failed with `'7' !== 7n` as expected. Restored. Commit 3.

## Commits (in push order on `feat/chat-edit-message-ui`)

- `3c501154e` `chore(chat): narrow editMessage history-shape cast to MessageRevision` — items 1+2 (chat-bar-component.js + daemon/types.d.ts).
- `b5815e39b` `chore(chat): trim chat-bar editMessage public surface` — items 3+4 (chat-bar-component.js).
- `94f4d28dc` `test(chat): exercise edit-message string-input coercion path` — item 5 (test/unit/command-executor.test.js).

Each commit body references PR #305. No yarn.lock change (no dependency edits), so no separate `chore: Update yarn.lock` commit needed.

## Push and post-fix status

Push: `8682264d2..94f4d28dc  HEAD -> feat/chat-edit-message-ui` (clean fast-forward; no rebase needed).

Post-fix local status:

- `yarn lint:prettier`: clean (`All matched files use Prettier code style!`).
- `yarn lint:eslint` (chat package): 0 errors, 196 warnings (down 1 from the 197 baseline; the removed `no-use-before-define` disable comment dropped one suppression slot but ESLint's warning count was driven by other rules).
- `yarn lint:types` (chat package, chat-bar-component.js): 9 errors, identical to the pre-fix baseline. All 9 are preexisting (the file has long-standing TS-strictness debt: untyped `EMethods<Required<{}>>` returns, sendForm API drift, `root0.skipFocus` JSDoc shape, etc.). My changes neither introduce nor resolve any of these.
- `yarn ava` (chat package): all **435 tests pass** including the modified `execute edit-message coerces messageNumber to bigint and forwards body` test.

CI on PR #305 should auto-trigger from the push; I have not yet sampled the matrix (steward will see the next per-cycle scan).

## Cross-cutting observations

- **The job's recommended import path (`@endo/daemon/src/types.js`) doesn't work in this repo's TS resolution.** The CLAUDE.md example mentions it abstractly (`FarEndoGuest`) but no source file actually uses that subpath, and `grep` confirms it. If the maintainer wants subpath imports for daemon types, the right move is to add `./src/types.js` to the daemon's exports map; my chosen alternative (re-export from the package root) keeps the daemon's public surface conservative and matches the chat package's existing idiom of importing `EndoHost` from `@endo/daemon`. Either lens lands a `MessageRevision` that downstream consumers can name.

- **Three commits felt right for five items.** Items 1+2 are a single conceptual change (replace the loose-typed `{ envelope: any }` cast with a properly-typed `MessageRevision` chain, which incidentally drops the `edgeNames` fallback because the typed shape only has `names`). Items 3+4 are both public-surface cleanup on the same return record. Item 5 is a test-only change with regression evidence, deserving its own commit. Splitting further (e.g., items 1 and 2 separately) would have been artificial; bundling all five into one commit would have made the commit body unreadable for the reviewer.

- **Cargo-cult `// eslint-disable-line no-use-before-define` everywhere.** I counted 27 of these in `chat-bar-component.js` alone, all unnecessary since the rule is off in the project's eslint config. Removing them would be a one-shot sweep but is out of scope for this dispatch (the spec named only the one at line 1733 in connection with editMessage and explicitly carved out line 1175). Worth a future janitorial PR if cleanliness merits the diff churn; not surfacing as a followup ledger entry yet because the comments are pure noise, not behavioral.

- **The `// Per Design Decision 4 (...)` comment block (lines 778-784) survived the edgeNames removal.** Its language still mentions "fall back to the edge name" but the surrounding code now reads `names` only. The semantic intent is unchanged (the daemon's `names` array carries the same edge-name content that was previously in `edgeNames`); the comment continues to motivate the `@${name}` interleaving below. I left the comment alone to keep this dispatch tightly scoped. A more aggressive editor could update "edge name" → "name", but that risks drift from the design doc's vocabulary.

Self-improvement: nothing this time. The job spec was thorough enough that the only deviation was the import-path question (whose answer required reading the daemon's exports map and tracing TS NodeNext behavior), and the deviation surfaced cleanly during type-check rather than at push time.
