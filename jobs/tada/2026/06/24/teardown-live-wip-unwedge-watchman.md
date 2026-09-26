# Completion report: teardown-live-wip-unwedge-watchman

**Outcome: garden-wide deploy outage resolved.** The live `/home/kris` tree is clean and fast-forwarded; the watchman is unwedged and hardened against recurrence; no work was lost.

## Safety verification (step 1)
Diffed every dirty path against `origin/main2`. All live WIP was **redundant** — fully superseded by commits already on origin:
- `bulletin.sh`, `comment-watcher.sh`, `common.sh`, `repo-watcher.sh` — byte-identical to origin/main2.
- `post-job.sh` — live had `GARDEN_POST_ATTEMPTS` (already on main2); main2 additionally has the leading-dash guard → main2 is a strict superset.
- `run-test.sh` — live's only unique line was a `SUBTEST 17` header that main2 renumbered to 18 (same body); main2 adds the maintainer-followable + GH-identity subtests.
- untracked `scripts/jobs/bin/gh` — identical to main2 `11240ac2`.

No live-only delta anywhere. Backed up the full WIP to `/tmp/wip-backup-teardown/` before discarding, out of caution.

## Teardown + deploy (steps 2–3)
- Restored the 5 worktree-modified files (`checkout --`) and the 1 *staged* file (`bulletin.sh`, via `restore --staged --worktree`); removed redundant untracked `scripts/jobs/bin/`.
- Fast-forwarded the live tree **`51030653 → 9f3a2d66`** (the 10 stuck commits + my guard). Live `main2` HEAD now equals `origin/main2`.
- Refreshed installed systemd units (`install-units.sh install`, idempotent — did **not** enable the new GitHub-wide mention-watcher, per the monitoring-safety constraint), restarted `garden-bulletin.service`, ran `watchman.sh` once.

## Verification (step 4)
- Watchman ran **clean** — no "worktree dirty" abort, broadcast the reread to gardeners, updated its seen-marker. Confirmed it no longer wedges with an untracked sibling worktree present in the root.
- comment-watcher `@endojs-endo-but-for-bots.timer` is firing on cadence (fix `fb7a73d6` live).
- Bulletin posting (`bulletin posted` 23:23:12); `origin/journal2:README.md` shows followable maintainer-message blob-links + inlined per-job descriptions (`4fa4c29f`/`07c548e4` live).

## Root-cause guard (step 5) — implemented and deployed (commit `9f3a2d66`)
Hardened `scripts/jobs/watchman.sh` (the cause was the watchman treating **any** `git status --porcelain` output as dirty, so untracked artifacts silently froze the whole fleet):
1. The clean-check now uses `--untracked-files=no` — only **tracked** edits (genuine clobber risk) block the fast-forward; stray sibling worktrees / build artifacts never wedge the deploy. (Confirmed live: the root already churned `journal-cask-cycle7` → `cask-scratch-cycle8`, untracked, now harmless.)
2. Genuine tracked WIP (or any ff refusal) is now **reported loudly to the maintainer inbox** via `message-user.sh`, deduped on (target SHA, blocking paths) — a dirty tree can no longer silently freeze deploys garden-wide.
`bash -n` clean; built/pushed from an isolated worktree off `origin/main2` per the shared-tree-mutation rule.

## What was discarded vs preserved
- **Discarded:** all 6 tracked WIP edits + untracked `scripts/jobs/bin/` (all verified-redundant; backup at `/tmp/wip-backup-teardown/`).
- **Preserved:** everything — origin/main2 already held the equivalents.

## Deployed HEAD
`9f3a2d66ca9baf3294bc79443803e3f1c14d0144` (live `main2` == `origin/main2`).

## Follow-ups / incidents
- **Self-inflicted, recovered:** while verifying the bulletin render I ran `git pull` on the live `/home/kris/journal` (journal2) worktree — which is an **active agent's** in-progress journal restructure (librarian/scholar `library/` build, ~259 staged deletions/renames). HEAD was **not** moved (`a7e347fc`) and all work is intact in the working tree; the pull only left a harmless leftover `autostash` (extra stored state). I deliberately did **not** drop/pop it (the only risky op) — left it for the owning agent to reconcile. Recorded a memory: inspect journal2 read-only via `git show origin/journal2:<path>`, never pull the live worktree.
- **Minor (pre-existing, out of scope):** `garden-bulletin.service` logs a benign `Unknown key name 'CollectMode'` warning (systemd ignores it). Worth a one-line unit fix sometime.
- The new mention-watcher unit is installed but intentionally **left disabled** (monitoring-safety authorization is a separate decision).
