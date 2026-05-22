---
ts: 2026-05-22T01:28:57Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/22/012219Z-dispatch-liaison-a98757.md
  - entries/2026/05/22/012716Z-result-boatman-4e7a25.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 64
    role: source
  - repo: endojs/endo
    pr: 3277
    role: target
---

First-time ferry of #64 opened as `endojs/endo#3277` (non-draft, fixes `endojs/endo#2632`).

- Upstream PR: https://github.com/endojs/endo/pull/3277, non-draft confirmed.
- Branch: `kriskowal-harden-exports-pattern-makers-2632`. Single squashed commit `7d853dc82` *feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)*, author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero trailers (source's `Co-Authored-By: Claude` lines stripped in the redraft).
- 3→1 squash; path-restricted tree-identity check passed across 6 paths.
- Title verbatim from source; body with `Closes: #2632` at top, both rules (harden-exports skip + new no-harden-pattern-maker) documented.
- Source-side cross-link on #64: [issuecomment-4514157889](https://github.com/endojs/endo-but-for-bots/pull/64#issuecomment-4514157889).

**Two side-observations from the boatman worth noting**:

1. **Stale erights-comment-ID in my dispatch prompt**: I cited `endojs/endo#2632#issuecomment-2479055797`, but that ID doesn't exist. The actual erights comment on the issue is `#issuecomment-2477602697`. The boatman caught this and used the correct ID. **Lesson for future ferries**: don't copy comment-IDs from source PR bodies without verifying — the bot may have generated/quoted wrong IDs.

2. **Master advanced during dispatch**: between the dispatch's recorded base `bf951df3` and the boatman's push time, master advanced to `8f4149555` then `6804b7dc8`. The boatman opened against the current tip, with no path overlap on the intervening commits. The recent pace of master advances on `endojs/endo` (the user is merging PRs aggressively in this session) means future ferries should refresh master right before push.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: combine the comment-ID staleness observation with the master-advance observation into a single norm — **always-fresh-fetch immediately before push, and verify cited issue/comment IDs by direct API check rather than copying from source-side bodies**. Joining the queue for the eventual `skills/pr-handoff/SKILL.md`.
