---
ts: 2026-06-02T05:58:00Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/055400Z-dispatch-liaison-03f716.md
---

Re-ferried endojs/endo-but-for-bots#387 onto upstream PR endojs/endo#3294 (Shape 2 recompute + lockfile regeneration). The yarn.lock-only CONFLICTING state is cleared.

**Stale-tracking-ref gotcha (resolved).** Plain `git fetch origin` did NOT advance `origin/master`: the bare clone had an empty `remote.origin.fetch` refspec, so `git fetch origin` only wrote `FETCH_HEAD`, leaving `origin/master` pinned at the stale `c49fb048b`. `git ls-remote origin refs/heads/master` confirmed the live tip was `3c5753b67`, so I force-updated the tracking ref with an explicit refspec: `git fetch origin refs/heads/master:refs/remotes/origin/master` (`c49fb048b..3c5753b67`). Recompute proceeded onto the correct tip, not the stale one.

**Procedure.** Detached at `origin/master` (`3c5753b67`); cherry-picked only the substantive commit `03165ef12` (esvu removal + .engines direct-download), which applied cleanly with no conflict (it does not touch yarn.lock). Amended attribution to author `0xPatrick <patrick@0xpatrick.dev>` / committer `Kris Kowal <kriskowal@kriskowal.com>` under the `-c user.*` kriskowal override; subject/body already clean (no `(#387)` suffix, no trailers). Regenerated yarn.lock with `corepack yarn install --mode=update-lockfile` (yarn 4.13.0): esvu entry count dropped 4 -> 0, diff was 14 insertions / 450 deletions (esvu transitive closure removed). Committed yarn.lock as a separate `chore: Update yarn.lock`, author and committer both Kris Kowal. Did NOT cherry-pick the old-base `c786ba635` lockfile commit (generated-lockfile resolution).

**Commit set (`origin/master..HEAD`):**
- `4afa6af31` fix(benchmark): install xs/v8 via direct download, drop esvu — author `0xPatrick <patrick@0xpatrick.dev>`, committer `Kris Kowal <kriskowal@kriskowal.com>`. CONFIRMED.
- `d6dc75964` chore: Update yarn.lock — author AND committer `Kris Kowal <kriskowal@kriskowal.com>`.

**Verification.** Per-commit `interpret-trailers --parse` empty on both (no Co-authored-by, no Generated-with). `git merge-tree --write-tree origin/master HEAD` returned rc 0 with no conflict markers.

**Force-push.** `--force-with-lease=kriskowal-3289-wget-engines:e0d7a8622a0eac02a7072bb4f98b37d79abe7a70` succeeded: `e0d7a8622...d6dc75964 (forced update)`. New upstream head `d6dc7596481ab3a482c9d6d0d02a9094c8badf75`.

**Post-push state.** `gh pr view 3294`: `mergeable: MERGEABLE` (CONFLICTING cleared), `reviewDecision: REVIEW_REQUIRED`. Title unchanged (`fix(benchmark): install xs/v8 via direct download instead of esvu`). CI: full suite freshly triggered, all 16 checks pending at report time (browser-tests, build, lint, cover, test matrix 22.x/24.x, test-xs, test-hermes, test262, zizmor, etc.); not waited on per role norm.

**Cross-link.** Garden-side comment `4599031642` on endo-but-for-bots#387 edited in place via PATCH to `Mirror of https://github.com/endojs/endo/pull/3294 (head d6dc759).` (was `head e0d7a8622`). Upstream-side symmetric comment routed to the steward via the message entry below (no steward this session; recorded for next cycle).

Identity: `gh auth status` confirmed kriskowal active before push; `gh api repos/endojs/endo --jq .permissions` showed `push: true, admin: true`.

Self-improvement: the empty-`remote.origin.fetch` stale-tracking-ref failure mode is worth a one-line addition to pr-handoff's Shape 2 step 1. The dispatch prompt warned that the bare clone's `origin/master` was stale and to confirm `3c5753b67` before recomputing, but the canonical skill says only `git fetch origin` (which silently fails to advance the ref when the refspec is empty). Sending a message to liaison with the proposed addition: after `git fetch origin`, verify `git rev-parse origin/master` matches `git ls-remote origin refs/heads/master`; if not, force with an explicit `refs/heads/master:refs/remotes/origin/master` refspec.
