---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-08-06T06:33:03Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-06T06:33:03Z
---

<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-06T05:44:40Z cleared=none -->

# re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-for-bots #132)

PARKED (go-ahead). Escalated from the auto-minted shepherd job
`endojs-endo-but-for-bots-pr132-shepherd`. Needs a maintainer decision before any
work runs, because it is a substantial feature re-port whose value depends on
whether the feature is still wanted in this form.

## Situation

PR #132 (`feat/chat-markdown`, "per-message render mode toggle (Md/Raw/Pre)",
re-opened from #42 under the bot) has RED CI. The red is NOT the chat feature's
fault:

- The branch is **1282 commits behind base `llm`**. Base `llm` CI is fully green.
- All four failing checks are in code the PR does not touch:
  - `cover (20.x / 24.x)` — `packages/ocapn/test/netlayer-tcp-syrup.test.js`
    exits non-zero (`SyrupAnyCodec: read failed`) on the stale ocapn source.
  - `lint` — `packages/ocapn/test/netlayer-tcp-syrup.test.js:7` `makeClient not
    found in '../src/client/index.js'` (import/named), a stale-base import.
  - `zizmor` — `familiar-release.yml` / `ci.yml` / `release.yml` findings on the
    stale workflow files.
- The PR itself touches only `packages/chat/{inbox-component.js, index.css,
  test/unit/command-executor.test.js}`.

A plain rebase onto current `llm` would clear every failing check — but the
rebase **cannot complete mechanically**:

- On current `llm`, `packages/chat/inbox-component.js` is a **114-line thin host
  wrapper**: all message rendering was refactored into the confined
  `@endo/space-chat` `InboxRoot` Preact tree.
- The PR built its per-message render-mode toggle (Md / Raw / Pre) deep inside
  the **old 911-line inline rendering loop** that no longer exists.
- Rebase conflict in `inbox-component.js` is therefore architectural: the feature
  must be **re-implemented inside `@endo/space-chat`'s `InboxRoot`**, not merged.
- `command-executor.test.js` also conflicts, but only additively (two independent
  test blocks landing at the same spot — trivially both-kept).

## Task (once go-ahead is given)

Re-port the per-message render-mode toggle (Md / Raw / Pre) onto the current
`@endo/space-chat` `InboxRoot` architecture, rebased onto current `llm`; keep the
additive `command-executor.test.js` blocks; drive CI green. This is builder/fixer
work, not shepherd work.

Alternative the maintainer may prefer: **close #132 and rebuild the feature fresh**
against `@endo/space-chat` rather than re-port a 1282-commit-stale branch.

<!-- garden-deadline-overrun: 1 -->
