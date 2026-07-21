# Clean up test-context leak damage in the deployed garden root (endolin-garden2-5bcdff64)

A test context (a native-git scenario — fixture path `tmp/native-git-TdaKeS/`) leaked its cwd into the deployed garden root `/home/kris/garden2` on 2026-07-17T11:38Z (see `git -C /home/kris/garden2 reflog`): it committed fixture commits ("base commit" 4df32aff72, "feature commit" f048738ff2, "main commit" cd52bbfc08), left root HEAD on fixture branch `feature`, and clobbered the old v1 `main` branch tip. Separately, workers have been misusing the root as a project checkout (branch `xs2rust-endor` created in the root 2026-07-21T11:23Z; `remote.origin.url` found rewritten to `endojs/endo-but-for-bots` on 2026-07-21, which broke `journal_remote()` for every FRESH doer clone and poisoned `.garden-state/config/journal-remote`; both were restored to `git@github.com:kriskowal/garden.git` and verified by the git-integration press on 2026-07-21T15:35Z).

Remaining work, all in the DEPLOYED root (careful, live fleet):
1. Move root HEAD off fixture branch `feature` back onto `main2` (coordinate with the deliberate-deploy flow, context/operations/deploy.md — the root tree is also pinned at an older garden snapshot than origin/main2).
2. Delete fixture branches `feature` and the fixture tip of `main` (v1 branch; verify nothing needs it), and the fixture commits' `tmp/native-git-TdaKeS/` residue.
3. Sweep untracked junk left by root-misusing workers: `bin/pnpm`, `bin/pnpx`, `bin286/`, `pr661-bin/`, `tmp/aborted.txt`, `tmp/acc_full.log`, and similar.
4. Root-cause + guard: find which job/test harness runs with cwd = the deployed root (the native-git suite from the git-capability work, and the xs2rust press) and make it use an isolated worktree/tmpdir instead; consider a guard in common.sh refusing project-repo origin rewrites of the root checkout, in the spirit of the recent "refuse a production-journal push from a test context" fix.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  worker_kind: gardener
  claimed_at: 2026-07-21T15:28:32Z
