Both stray items are reaped and the root checkout is clean. Final report:

---

**Completion report — `fu-kriskowal-garden-pr9-d25b9529-3`**

Reaped the two stray untracked items flagged in PR #9's report on the deployed root checkout (`/home/kris`, branch `main2`):

**`wt-507/`** — a leftover endo worktree of `endojs/endo-but-for-bots` on branch `build/notifier-pubsub-daemon-migration`, linked to `worktrees/endojs-endo-but-for-bots.git`. It was **not** empty scratch: it held genuine uncommitted WIP (staged removal of `packages/daemon/src/{pubsub.js,test/pubsub.test.js}` + daemon adoption edits, unstaged `packages/pubsub/change-topic.js` + test edits, and an untracked changeset `.changeset/daemon-adopt-endo-pubsub.md`), and the branch was **not pushed to origin**. Per the lossless/preserve-WIP discipline I committed everything (`git add -A` + WIP commit) onto its branch first — preserved as `cbcf9ce00` in the bare repo's object store (recoverable) — then `git worktree remove`d the clean tree. The canonical `worktrees/endojs-endo-but-for-bots/pr507-fixer` worktree was left untouched.

**`bundle-ymax0.json`** — an 866 KB scratch bundle (Jun 26), genuine throwaway; removed.

**Result:** `git status` on `/home/kris` is now clean (no untracked entries), and `git worktree list` no longer shows `wt-507`. No ff-wedge risk remains for the next deliberate deploy.

**Follow-ups:** none required. The captured WIP commit (`cbcf9ce00` on `build/notifier-pubsub-daemon-migration` in the `endojs-endo-but-for-bots.git` bare repo) is local-only and recoverable if anyone needs to resume that daemon/pubsub migration work; it can be discarded with the branch when no longer wanted.
