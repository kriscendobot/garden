---
ts: 2026-06-03T00:39:40Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/003456Z-dispatch-liaison-847db6.md
---

Shape-2 recompute re-ferry of the retconned `endojs/endo-but-for-bots#387` onto `endojs/endo#3294` (branch `kriskowal-3289-wget-engines`). Force-push replaced the prior structure with the clean 3-commit series the maintainer approved as merge-ready.

**Preconditions.** `gh auth status` showed kriskowal active; `gh api repos/endojs/endo --jq .permissions` reported `push: true` (admin/maintain too). `git ls-remote origin refs/heads/master` == `3c5753b67`, and `origin/master` tracking ref matched (the 2026-06-02 tracking-ref fix held). Source head `57b9e8f8b` fetched directly from the bot fork.

**Procedure.** Detached at `origin/master` (`3c5753b67`). Cherry-picked the two code commits per-commit, both clean (no conflict): benchmark from `82f7aae17`, hex from `ebdcdff7b`. Did **not** carry the frozen-base yarn.lock commit `57b9e8f8b`. Regenerated yarn.lock on current master via `corepack yarn install --mode=update-lockfile` (yarn 4 / node 24); the diff removes esvu and its transitive deps (14 ins / 450 del). Pre-existing YN0060/YN0086 peer-dependency advisories on master are warnings, not errors. Committed as a separate `chore: Update yarn.lock`.

**Attribution (maintainer-verified standing decision).**
- benchmark `04083b87`: author `0xPatrick <patrick@0xpatrick.dev>`, committer `Kris Kowal <kriskowal@kriskowal.com>` (amended under the kriskowal `-c user.*` committer override, clean short body, no `(#387)` suffix, no trailers).
- hex `84a3f2a1`: author + committer `Kris Kowal <kriskowal@kriskowal.com>` (`--reset-author`).
- yarn.lock `8ff08496`: author + committer `Kris Kowal <kriskowal@kriskowal.com>`.

Per-commit `interpret-trailers --parse` empty on all three (no Co-Authored-By, no Generated-with).

**Verification.** `git rev-parse HEAD:packages/benchmark` == `98060f1ec122844e323a759864577e83eab4444a` (matches the live mirror). Recomputed net-diff file set equals the source PR's 6 files (`packages/benchmark/{README.md,install-engines.sh,package.json,run-tests.sh}`, `packages/hex/test/run-benches.sh`, `yarn.lock`). Per-file `git patch-id --stable` of all five non-lockfile diffs matched the source PR #387 byte-for-byte; only yarn.lock differs (regenerated on a newer base, as expected).

**Push.** `git push --force-with-lease=kriskowal-3289-wget-engines:983551383044b9da6c2f8ae78d893e7235ac40d5 origin HEAD:refs/heads/kriskowal-3289-wget-engines` succeeded: `+ 983551383...8ff084968 (forced update)`. New head **`8ff08496837cb9d659e5e218890e4e6f468eb246`**.

**Post-push.** `gh pr view 3294`: 3 commits (benchmark/0xPatrick, hex/Kris Kowal, yarn.lock/Kris Kowal), `mergeable: MERGEABLE`, `reviewDecision: APPROVED`. gibson042's APPROVED review **persisted** (master is not branch-protected, so the force-with-lease did not dismiss it). Title/body left unchanged. CI re-triggered, all 15 checks pending at report time (not waited on; shepherd handles CI-driven follow-up).

**Cross-link.** PATCHed the existing garden-side cross-link comment `4599031642` on `endo-but-for-bots#387` to `Mirror of https://github.com/endojs/endo/pull/3294 (head 8ff084968).`. No upstream-side comment (retired per the 2026-05-29 maintainer directive).

Self-improvement: nothing this time. The ferry exercised the standard Shape-2 path; the tracking-ref precondition and the multi-author-committer-override pattern both worked as documented.
