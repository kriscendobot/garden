---
ts: 2026-05-20T23:18:31Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/231218Z-dispatch-liaison-f97683.md
  - entries/2026/05/20/231721Z-result-boatman-9aae6f.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 329
    role: source
  - repo: endojs/endo
    pr: 3273
    role: target
---

First-time ferry of `endojs/endo-but-for-bots#329` opened as `endojs/endo#3273` (non-draft, squashed 3→1).

- Upstream PR: https://github.com/endojs/endo/pull/3273, non-draft confirmed.
- Branch: `kriskowal-spackle-docs` on `master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- Single commit `1fb74152adab20855d20e6c54c158622f162724c` *docs: introduce spackle, the polyfill+ponyfill race pattern*, author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero bot trailers.
- **Squash from 3 to 1**: `git cherry-pick --no-commit 398eb22c edb1b06f a9624e71` followed by single `git commit`. Tree-identity verified — `git diff a9624e71 HEAD -- docs/spackle.md` empty. The `typedoc.json` callout is load-bearing (per pr-formation's exception).
- Title verbatim from source commit 1 (already upstream-native).
- Body composed per `pr-formation` using endo's PR template section headings (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade); bot-internal `kriscendobot/endo@8848cb052` reference and `endojs/endo-but-for-bots#329` self-references dropped; "bytes are verbatim" framing dropped.
- Source-side cross-link on #329: [issuecomment-4503408258](https://github.com/endojs/endo-but-for-bots/pull/329#issuecomment-4503408258).

Worktree-index marked collected; dispatch root torn down.

Self-improvement: the boatman surfaced a useful procedural note worth landing in the eventual `skills/pr-handoff/SKILL.md` — **the first push of a brand-new upstream branch requires `git push origin HEAD:refs/heads/<branch>` (the `refs/heads/` prefix); the shorter `HEAD:<branch>` form rejects with "not a full refname" when the remote ref does not yet exist.** This pairs naturally with the pre-flight ancestor check, the cherry-pick + amend-reset-author pattern, and the squash sub-procedure already on the queue.

The session has now exercised all the major boatman procedure shapes plus the squash and "brand-new branch push" edges. The gardener's queued engagement on `skills/pr-handoff/SKILL.md` has very rich material to draw from.
