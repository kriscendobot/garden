---
ts: 2026-06-03T00:21:21Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/001816Z-dispatch-liaison-e78c11.md
  - entries/2026/06/02/224400Z-result-boatman-87f5a9.md
---

Surgical tip-only amend of endojs/endo#3294 (branch `kriskowal-3289-wget-engines`), same shape as the prior amend (`224400Z-result-boatman-87f5a9.md`). Brought one file, `packages/benchmark/install-engines.sh`, to the live bot mirror's version (endo-but-for-bots#387 at `a179d5aa8dba604ba09b86325509091912fe0136`), which made the v8 launcher relocatable.

I detached at the prior tip `4150060dd`, ran `git checkout a179d5aa -- packages/benchmark/install-engines.sh` (status showed ONLY that file modified), and amended the tip only. The two parent commits were untouched.

Outcome:
- New #3294 head: `983551383044b9da6c2f8ae78d893e7235ac40d5` (was `4150060ddb0d09cbf30fdf85ed48314d30eb4982`).
- HEAD~1 unchanged: `d6dc7596481ab3a482c9d6d0d02a9094c8badf75` (chore: Update yarn.lock, Kris Kowal).
- HEAD~2 unchanged: `4afa6af31c393e04813a9571650eac1e1ee824c6` (fix(benchmark): install xs/v8..., author still `0xPatrick <patrick@0xpatrick.dev>`).
- Benchmark subtree now `98060f1ec122844e323a759864577e83eab4444a` (byte-matches the live mirror).
- `git diff 4150060dd HEAD --stat` shows ONLY `packages/benchmark/install-engines.sh`.
- The v8 launcher heredoc is now relocatable: quoted `<<'EOF'`, `engines_bin_dir="$(dirname "$0")"` + `engines_dir="$(dirname "$engines_bin_dir")"` relative traversal instead of baking in `$HOME`. `.engines` (not `.bench-engines`) throughout. gibson042's earlier improvements remain: `$tmp` + `trap` up front, `jq` for the V8 version, post-extract `xst -v` / `d8 -v` execution checks. Confirmed the more-evolved version, not a regression.
- Tip author AND committer both `Kris Kowal <kriskowal@kriskowal.com>`; per-commit `interpret-trailers --parse` empty on all three commits (no Co-Authored-By / Generated-with).

Push: `git push --force-with-lease=kriskowal-3289-wget-engines:4150060ddb0d09cbf30fdf85ed48314d30eb4982` landed `4150060dd...983551383 (forced update)`. Only the tip was rewritten; parents kept their SHAs.

Post-push (`gh pr view 3294 -R endojs/endo`): 3 commits (first two SHAs unchanged), `MERGEABLE`, **`reviewDecision: APPROVED`**. gibson042's `APPROVED` review (and its earlier `COMMENTED`) both still listed. The approval persisted: endo master is not branch-protected, so the tip force-with-lease did not dismiss it. CI re-triggered; all checks pending/in-progress at report time (not waited on; shepherd handles CI follow-up).

Identity precondition met: `gh auth status` showed `kriskowal` active; `gh api repos/endojs/endo --jq .permissions` showed `push: true, admin: true`.

Cross-link: garden-side comment on endo-but-for-bots#387 (id `4599031642`) PATCHed in place to `Mirror of https://github.com/endojs/endo/pull/3294 (head 983551383).`. No upstream-side mirror comment (retired per 2026-05-29 maintainer directive); the source-side cross-link is the only one and a `message: boatman → steward` records it per the dispatch.

Self-improvement: nothing this time.
