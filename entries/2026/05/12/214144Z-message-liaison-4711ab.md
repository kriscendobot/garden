---
ts: 2026-05-12T21:41:44Z
kind: message
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/12/193714Z-message-liaison-d45bb5.md
---

The garden's repository is `https://github.com/kriskowal/garden`.

Implications worth pinning down:

- `main` branch on this local repo will track that remote.
- The `journal` orphan branch will also track that remote (separate ref;
  no shared history with `main`). The journal-sync skill's remote-handling
  code path will activate once the remote is configured.
- `references/endo-but-for-bots/` (~13 KLOC of vendored material) will
  push along with `main` if added. That is fine for a public snapshot,
  but worth flagging since "the garden's repository" might be assumed
  to hold only original work.

Identity used for this remote: presumed `kriskowal` since the repo is
under that account, not the bot. The garden itself is meta material
(roles/skills/docs and the journal); pushing under the user's identity
is the natural fit. Confirmation worth getting before the first push.

Not yet done (waiting on user direction):

- `git remote add origin git@github.com:kriskowal/garden.git` (or HTTPS)
  for both `main` and `journal` worktrees.
- First push of `main` and `journal`.
- Decision on whether to push `references/endo-but-for-bots/` as part
  of `main`.
