---
ts: 2026-05-20T21:34:31Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
---

# Dispatch: builder c08d56 — port spackle docs article to endo-but-for-bots, open PR

Dispatch root: `dispatches/builder--c08d56/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

Maintainer directive (2026-05-20T21:30Z): *"Please create a PR in endo-but-for-bots for spackle.md with ref 8848cb052"*. The ref is on `kriscendobot/endo@docs-spackle`, head of the previously-authored docs-spackle branch where `docs/spackle.md` (139 lines, 5,900 bytes) was authored 2026-05-20 — the cross-fork PR-create to `endojs/endo` was blocked at that time for permission reasons. The bot identity has direct `push` permission on `endojs/endo-but-for-bots`, so we can land this PR directly upstream rather than going through a fork.

## Source content

- Source: `kriscendobot/endo@8848cb052ed38a1dd1ccd8f04ff9e25a6a08a131:docs/spackle.md` (sha `8ece62eeca1aab6c32ff5f79257722be7fbed1d6`, 5,900 bytes).
- Companion: that same commit also inserted `docs/spackle.md` as one line in `typedoc.json`'s `projectDocuments` array, between `docs/message-passing.md` and `docs/reference.md`. Do the same here — `endo-but-for-bots/typedoc.json` has the same `projectDocuments` shape with the same neighboring entries (verified before dispatch).

## Task

One commit on a new branch `docs/spackle` off `endojs/endo-but-for-bots@llm`:

1. Fetch the source content (the file's bytes) from `kriscendobot/endo@8848cb052:docs/spackle.md`. Two ways: `gh api repos/kriscendobot/endo/contents/docs/spackle.md?ref=8848cb052 --jq .content | base64 -d` or `curl` + base64. Write the **exact same bytes** to `docs/spackle.md` in the project worktree.
2. Add `"docs/spackle.md"` to `typedoc.json`'s `projectDocuments` array, inserted between `"docs/message-passing.md"` and `"docs/reference.md"` (the canonical ordering used on the endo-side commit). One-line insertion.
3. Verify shape: `git diff --stat` should show two files changed (`docs/spackle.md` ADDED, `typedoc.json` modified +1/-0).
4. If `yarn docs` (or whatever the docs build is here — check `package.json` scripts) runs in a few seconds and is feasible, exercise it as a smoke test; if it takes long or fails for unrelated reasons, skip and note in the report.

## Commit shape

- Subject: `docs: introduce spackle, the polyfill+ponyfill race pattern` (matches the source commit's subject; well-formed for this repo's style).
- Body: 1-2 short paragraphs naming what spackle is and citing `kriscendobot/endo@8848cb052` as the origin. Plus the standard footer:
  ```
  Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
  ```
- One-sentence-per-line markdown discipline (check `CONTRIBUTING.md` in the repo for the convention — the source file already follows it).
- Use the bot's git identity already pinned in the dispatch sub-worktree's local config; do NOT re-pin or override.

## PR shape

- Push branch: `git push origin HEAD:docs/spackle`
- Open PR: `gh pr create --repo endojs/endo-but-for-bots --base llm --head docs/spackle --title "docs: introduce spackle, the polyfill+ponyfill race pattern" --body <see below>`
- PR body: 1-2 short paragraphs naming what spackle is, why it's worth documenting (the polyfill+ponyfill race pattern via registered symbols, with `@endo/harden` as the canonical instance), and noting that this is a direct port from the endo-side draft at `kriscendobot/endo@8848cb052`. **Not** a draft — the maintainer wants a regular PR.
- No `Co-Authored-By` footer in the PR body itself (only on the commit).

## Per-action authorization

- Standing on `endojs/endo-but-for-bots`: push to `docs/spackle`, create the PR on `llm` as the base.
- READ-ONLY on `endojs/endo` and elsewhere. No comments anywhere except the PR's own body at create time.
- No identity switch — the bot identity is the correct author for this PR (this repo is the bot's home turf).

## Out of scope

- Don't edit any file other than `docs/spackle.md` and `typedoc.json`.
- Don't rewrite the article's prose — the upstream maintainer-editorial calls (Remy Sharp attribution without citation, prototype.js history removed, harden section delegating to `packages/harden/README.md`) are intentional. The bytes go verbatim.
- Don't open it as draft.
- Don't merge.

## Report

≤ 250 words: PR URL, branch+head SHA, the two files in the diff with their sizes, whether the docs build was exercised (and if so, the result), and one-line `Self-improvement: ...`. If anything blocks (auth, PR-create perms, the source file 404s, etc.), surface the blocker rather than working around it.
