Everything is complete. Final state verified: PR #719 base is now `merge-adae30a`, head unchanged and MERGEABLE, the separate master-fix job is posted, and the summary comment is up. This was a project-repo job, so there are no garden `main2` changes to commit.

---

## Completion report

**Job:** rebase directive on endojs/endo-but-for-bots PR #719 (kriscendobot, `feat/hardened-url-vetted-shim`).

**What the directive asked:** set the merge base to a `merge-xxx` branch based on the current upstream master hash and rebase on it; if the problem persists, post a separate job to propose a fix for master.

**What I found:**
- The PR head (`fe0c40a`, 6 commits) was already sitting directly on the current master tip `adae30a` (6 ahead, **0 behind**, merge-base = master tip). So the rebase itself was a content no-op — this was really a base-freezing operation.
- master head `adae30a` is **itself red** with the exact failures PR #719 inherits: `lint` (Prettier formatting in `packages/ses/test/text-encoder-decoder.test.js`), `zizmor` (action hash-pin version-comment mismatches across many workflows, exit 13), the `test` matrix (22.x/24.x × ubuntu/macos), plus `build`/`Release`. The problem lives in master, not the PR.

**What I did:**
1. Created frozen base branch **`merge-adae30a`** on endojs/endo-but-for-bots at the current master hash `adae30a97445dfafe639c1e6e15132022d076b5a` and pushed it.
2. Rebased the head onto it — clean no-op, head OID unchanged (`fe0c40a`), same 6 commits, identical diff, so no force-push was needed.
3. Repointed PR #719's base from the moving `master` to `merge-adae30a` (`gh pr edit`); verified base=`merge-adae30a`, head=`fe0c40a`, mergeable=MERGEABLE.
4. Posted the separate master-fix job **`endojs-endo-but-for-bots-master-ci-fix`** to propose/implement a fix restoring green CI on master (the contingency the directive named, since the problem persists).
5. Posted a summary comment on PR #719 documenting the moved base, the no-op head, and the inherited-from-master CI diagnosis.

**Naming note / possible follow-up:** I honored the directive's literal `merge-<sha>` wording (`merge-adae30a`). The repo's automated frozen-base default elsewhere is `master-<sha>`; if the maintainer intended the standard prefix, it's a trivial rename + one `gh pr edit`. I flagged this in the PR comment.

**No garden `main2` changes** — this job only mutated the project repo (PR base + a new branch) and the job board.
