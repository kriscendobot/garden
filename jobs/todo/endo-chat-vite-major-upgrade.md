---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# build: upgrade Vite to the latest major in @endo/chat

Map: **build** → implement the upgrade and its migration, open a draft PR, auto-run the gauntlet.

Repo: `endojs/endo-but-for-bots` @ base branch `llm`.
Package: `packages/chat` (`@endo/chat`) — the only package that depends on Vite.

## Ask (from kriskowal, follow-up to PR #1094)

Upgrade Vite to the **latest major** and build out the corresponding
migration. Read through the Vite release notes / migration guides for the
**major breaking changes that require migrations** and implement them.

Source directive:
https://github.com/endojs/endo-but-for-bots/pull/1094#issuecomment-5473318493

## Why this exists

Dependabot PR #1094 (`@vitejs/plugin-react` 4.7.0 → 6.1.0) was REJECTED and
closed by the botanist: plugin-react 6.x requires peer `vite: ^8.0.0`
exclusively (v6 dropped Babel and imports `vite/internal`, a Vite-8-only
subpath), but `@endo/chat` currently pins `vite: ^6.0.0` (resolves 6.4.2).
The maintainer's fix is to move the project onto the current Vite major so
the plugin-react (and future) bumps can land. Closing this unblocks the
re-proposal of plugin-react 6.x.

## Current state (verified 2026-08-31)

- `packages/chat/package.json`: `"vite": "^6.0.0"`, `"@vitejs/plugin-react": "^4.0.0"`.
- Latest Vite dist-tag `latest` = **8.2.2** (major 8); `previous` = 7.3.6.
- So this crosses **two majors** (6 → 7 → 8). Read BOTH migration guides:
  - Vite 6 → 7: https://vite.dev/guide/migration (v7 section) — Node baseline
    change (drops Node 18), default browser target moved to "baseline-widely-available",
    Sass legacy API removal, etc.
  - Vite 7 → 8: https://vite.dev/guide/migration (v8 section) — read for the
    current breaking set at build time (Rolldown/rollup changes, config API,
    plugin hook signatures, `vite/internal` exports).

## Scope of the build

- Bump `vite` to `^8` (latest) in `packages/chat/package.json`; update
  `@vitejs/plugin-react` to the matching major (6.x, which now pairs with
  Vite 8) if that is the coherent pairing, per the release notes.
- Apply every migration the release notes require: `vite.config.js` changes,
  any changed plugin peer/dep set (e.g. `@rolldown/plugin-babel`,
  `babel-plugin-react-compiler` if plugin-react 6 needs them), build-target /
  Node-baseline implications, and any API renames.
- Update the yarn lockfile in a **separate** `chore: Update yarn.lock` commit
  per the garden's yarn-lock-separate-commit discipline.
- Verify locally: `yarn install`, the chat package's build (`vite build`) and
  its lint/test/cover legs must be green (the checks that #1094 turned red).
- Confirm the Node baseline change doesn't break the repo's supported Node
  window (Vite 7 dropped Node 18; check the repo's `engines` / CI matrix and
  reconcile — flag to the maintainer if it forces a Node-support decision
  rather than silently narrowing it).

## Deliverable

A draft PR against `llm` that upgrades Vite to the latest major with the
migration applied and CI green. The build auto-runs the gauntlet
(clean → panel → fix-loop → un-draft) per the gardening state machine.
If reading the release notes reveals the migration is larger than a
mechanical bump (a real design fork — e.g. the Node-support-window decision),
open a probe/gap report or escalate to the maintainer rather than guessing.
