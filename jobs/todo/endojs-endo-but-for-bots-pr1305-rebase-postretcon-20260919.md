---
role: weaver
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-19T03:11:12Z cleared=none -->

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# rebase endojs/endo-but-for-bots PR #1305 onto its retconned base

Blocked on `endojs-endo-but-for-bots-pr1306-retcon`. #1305 is the top of a
stacked PR (3/3 of #1125): its head is `bot/build/1125-guest-invitation-primitive`
and its base branch is `bot/build/1125-guest-provisioning`, which is #1306's head
(2/3). Both branches live on `endojs/endo-but-for-bots` directly (NOT the bot
fork), and the base is a sibling PR head, not a `<base>-<sha>` frozen snapshot —
so this is a stacked-PR rebase, not a frozen-base move.

The #1306 retcon rewrites `bot/build/1125-guest-provisioning` (net-diff invariant,
new SHAs). That leaves #1305's single commit parented on the pre-retcon base tip,
which makes GitHub recompute #1305's diff against a stale merge-base and balloon it
to include #1306's whole delta. Rebase to restore #1305 to its own 1-commit delta.

Procedure (in an isolated project worktree keyed by THIS job's base):
1. `git fetch origin bot/build/1125-guest-provisioning bot/build/1125-guest-invitation-primitive`
2. `git checkout -B bot/build/1125-guest-invitation-primitive origin/bot/build/1125-guest-invitation-primitive`
3. `git rebase origin/bot/build/1125-guest-provisioning`
   (the base tree is unchanged by the retcon, so the single commit should replay
   cleanly; resolve any conflict per conflict-resolution, never --ours/--theirs).
4. Verify `git diff --stat origin/bot/build/1125-guest-provisioning..HEAD` is
   ONLY #1305's own files (the guest-owned-invitation-primitive delta: ~17 files,
   .changeset/guest-owned-invitation-primitive.md, packages/daemon/src/manager.js,
   guest.js, test/endo.test.js, formula-record*, etc.). A balloon means the base
   moved under you — re-fetch and retry.
5. `git push --force-with-lease origin bot/build/1125-guest-invitation-primitive`
6. If the retcon turned out to be a no-op (base tip unchanged from 9e16e50b),
   this rebase is also a no-op; complete as already-current.

Do NOT comment on the PR (bot PAT lacks endojs PR-write on this host); the push is
the deliverable. Pre-retcon reference SHAs: base 9e16e50b, #1305 head 799b32e13,
llm dc05c16b8.

<!-- garden-transient-elapsed: kind=signature through=0 values=4 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-19T03:23:05Z -->
