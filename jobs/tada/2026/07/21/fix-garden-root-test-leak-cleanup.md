My work is complete. Here is my report.

---

## Completion report — fix-garden-root-test-leak-cleanup

**What I found.** The remaining work spans two very different kinds of task. Items 1–3 are *physical cleanup of the deployed root `/home/kris/garden2`*, which belongs to a **different instance** (`endolin-garden2-5bcdff64`). My gardener container (`endolin-garden-ece02cb4`) only bind-mounts `/home/kris/garden`, so `/home/kris/garden2` is genuinely unreachable from here — and editing any deployed root is forbidden to a worker regardless. Item 4 is *durable garden code* that lands on `main2` and deploys fleet-wide. I did item 4 and handed off 1–3.

**What I did (item 4 — landed on `main2`, commit `a0cd3eae13`).**
- Root-caused the poison mechanism precisely: because a linked worktree **shares repo config** with its root, the single root `remote.origin.url` rewrite to the fork poisoned *every* source `journal_remote()` reads — the journal-worktree origin, the `$GARDEN_ROOT` origin fallback, **and** (once resolved) the per-host cache — so `journal_remote()` handed a fork URL to every fresh doer clone.
- Added a structural refusal to `journal_remote()`, mirroring the existing `guard_no_production_push_in_test` shape: it refuses any resolved remote that is a **foreign github repo** (`_is_foreign_github_remote` — a github.com repo that isn't `kriskowal/garden`), skips it with a loud `REFUSED` log, falls through to a clean source, and from a non-shared clean source **re-asserts the correct root origin** (`_reheal_root_origin`) so the poison is repaired at the source. If every source is poisoned it dies loudly naming the exact repair, never returning a fork URL.
- Kept legitimate non-production remotes safe: a local test upstream / operator `JOURNAL_REMOTE` bare repo isn't github-shaped, so it flows through untouched.
- Added `journal-remote-origin-rewrite-guard-test.sh` (24 hermetic cases): the classifier unit table, refuse-then-self-heal-from-cache-and-repair-root-origin, die-when-all-sources-are-forks, and pass-through for both a clean garden origin and a local upstream.

**Verification.** New test 24/24; the existing `journal-worktree-relink-test` still 25/25; `identity-drift-guard`, `journal-worktree-keeper`, `clone-keeper`, `issue-inbox-journal-linkage` all green; `bash -n` clean. Rebase-CAS pushed to `main2` on the first attempt. I also caught and reverted an early slip where I'd edited the deployed root's checkout directly — the deployed `/home/kris/garden` is back to its prior state and my changes live only in the committed worktree.

**Handoff (items 1–3, plus a live finding).** Messaged the maintainer via the liaison. Items 1–3 must be run by a human/liaison on the `garden2` instance (drained, per `context/operations/deploy.md`): move HEAD off fixture branch `feature` back to `main2`, delete fixture branches `feature`/`main`-tip and the `tmp/native-git-*/` residue, sweep the `bin/pnpm bin/pnpx bin286/ pr661-bin/ tmp/aborted.txt tmp/acc_full.log` junk. **Live finding:** the *same leak is actively happening on this instance's own root* `/home/kris/garden` — ~150 `tmp/native-git-*/` fixture dirs, many `tmp/git-clone-daemon-*/`/`tmp/git-remote-*/`, xs2rust press logs, plus `bin/yarn`/`OCapN.md`/`scratch-shim-bin/`. Same cleanup applies here.

**Follow-up not in this repo.** The main2 guard stops the origin-rewrite *blast radius* but not the `tmp/` litter. The true source is the endo-but-for-bots **native-git suite** (and xs2rust press) writing fixtures under `./tmp` **relative to cwd**; a project-side fix in `endojs/endo-but-for-bots` (use `$TMPDIR`/`mktemp -d`, never `./tmp`, and run in an isolated worktree) is still needed to stop littering whatever cwd a worker runs it from. I flagged this to the maintainer.
