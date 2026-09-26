# Press report — npm-via-CAS registry proxy (tick 2026-07-27, 17:50Z)

## Assessment

`llm` HEAD unchanged at `7f8c08d74f` (#862). All five design phases remain merged; the five gap drafts from prior ticks (#857 peer/optional deps, #859 process shim, #860 npmrc auth, #873 workspace protocol, #875 imports field) are all still OPEN, MERGEABLE, draft, with **zero maintainer reviews** — nothing to land this tick. No live peer held any shared branch (inbox empty at all checkpoints; the only live npm-cas inbox is this job's).

## What I did — pressed the recorded-but-unpressed gap: new draft PR #876

The previous tick recorded the nanoid `node:crypto`/webcrypto failure class as "worth a design note before code." I probed it to ground truth and landed the conservative, non-default-changing half as **draft PR https://github.com/endojs/endo-but-for-bots/pull/876** (branch `feat/endor-npm-run-conditions-webcrypto`, commit `3140cfb985`):

- **Probe findings (cold isolated state, real registry):** archive compartments expose no `crypto`, `TextEncoder`, `Intl`, or `process`; the exports resolver activates only `import`/`require`/`default`. nanoid@5's `default` build needs `node:crypto` + `Buffer` (fails: `import webcrypto not found`), while its `browser` build needs only `crypto.getRandomValues`. Both halves had to move together.
- **The change:** (1) `endor run --conditions <a,b>` — extra export-map condition names (typically `browser`) active in every resolution pass beside the pass's module-flavor condition, bundler-style, threaded through all three run paths; opt-in on purpose, since flipping `browser` on by default could shadow a working pure-JS `default` build with a `window`-touching browser build — that policy question is surfaced for the maintainer in the PR and design doc. (2) A web-platform `crypto` endowment (`getRandomValues`/`randomUUID`) — a standard veneer over the already-endowed `randomHex256`, no new authority; the previously duplicated endowments blob factored into one shared `ARCHIVE_ENDOWMENTS_JS`.
- **Real-execution evidence:** `endor run --conditions browser entry.js` with `nanoid@^5.0.0` fetched `nanoid@5.1.16` into the CAS, selected `index.browser.js`, and printed `id: 2ZH89yp8AkQMI_-IV4jNB`; replayed green under `--offline`. Without the flag the failure is byte-identical to before (pinned by test). Finish-line probe `semver@^7.5.4` stays green with default flags, online and offline, and with `--conditions browser` active.
- **Tests:** `cargo test -p endo` 176/176, `-p xsnap` 120/120 (single-threaded); three new tests including one pinning the unchanged default condition set. Design doc Known gaps updated in the same commit (Updated → 2026-07-27).

## Follow-ups for the next tick

- **Six** gap drafts now held for maintainer promotion: #857, #859, #860, #873, #875, and new **#876**; land on the #862 pattern when approvals arrive. Note #875 and #876 both touch `EXPORTS_RESOLVER_JS` — whichever lands second takes a trivial rebase, and #875's `__resolveImports` passes then want the same one-line extra-conditions splice.
- Still-open web-global gaps recorded: `TextEncoder`/`TextDecoder` (very common in browser builds), `crypto.subtle`, `atob`/`btoa`/`URL`; `Intl` remains the engine arc's surface. The default-condition-set policy (browser-by-default vs opt-in vs node-shims) awaits maintainer word.
- Worktree note: the 11:35Z worktree's binary includes #875, so chalk probes green there but not on plain `llm` HEAD — don't misread that as a regression. My worktree carries a populated `c/moddable` copied from it (fresh checkouts still need the #600 generators plus that submodule).
