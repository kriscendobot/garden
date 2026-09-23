---
ts: 2026-06-02T22:44:00Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/02/224016Z-dispatch-liaison-bae5e2.md
---

Surgical tip-only amend of endojs/endo#3294 (branch `kriskowal-3289-wget-engines`) to realign the benchmark subtree with the live bot mirror.

The tip `Feedback responses` commit had been built from a stale mirror head; the live mirror endo-but-for-bots#387 (`e22369065`) renamed the engine cache `.bench-engines` -> `.engines` and carried gibson042's shell-review improvements. I detached at the prior tip `811f1ffd4`, brought the three PR-scope benchmark files (`packages/benchmark/{README.md,install-engines.sh,run-tests.sh}`) to the mirror's version via `git checkout e22369065 -- ...`, and amended only the tip. The two parent commits were untouched.

Outcome:
- New #3294 head: `4150060ddb0d09cbf30fdf85ed48314d30eb4982` (was `811f1ffd4`).
- HEAD~1 unchanged: `d6dc7596481ab3a482c9d6d0d02a9094c8badf75` (chore: Update yarn.lock, Kris Kowal).
- HEAD~2 unchanged: `4afa6af31c393e04813a9571650eac1e1ee824c6` (fix(benchmark): install xs/v8..., author still 0xPatrick <patrick@0xpatrick.dev>).
- Benchmark subtree now `40192d94edb5ec3934d717dbebc450e8ce3bbf06` (byte-matches the live mirror).
- `git diff 811f1ffd4 HEAD --stat` shows ONLY the three benchmark files.
- `install-engines.sh` now uses `$HOME/.engines` (no `bench-engines` anywhere) and retains gibson042's improvements: `$tmp` + `trap` up front, `jq` for the V8 version, post-extract `xst -v` / `d8 -v` execution checks. Confirmed the mirror version is the more-evolved one, not a regression.
- Tip author AND committer both `Kris Kowal <kriskowal@kriskowal.com>`; per-commit `interpret-trailers --parse` empty on all three commits (no Co-Authored-By / Generated-with).

Push: `git push --force-with-lease=kriskowal-3289-wget-engines:811f1ffd48dab4fee30fbcc67568c197d0d0b078` landed `811f1ffd4...4150060dd (forced update)`. Only the tip was rewritten; parents kept their SHAs.

Post-push (`gh pr view 3294 -R endojs/endo`): 3 commits (first two SHAs unchanged), `MERGEABLE`, `reviewDecision: REVIEW_REQUIRED`. gibson042's `COMMENTED` review is still listed (anchored to `d6dc75964`, which remains in history). CI re-triggered, all checks pending at report time (not waited on; shepherd handles CI follow-up).

Identity precondition met: `gh auth status` showed `kriskowal` active; `gh api repos/endojs/endo --jq .permissions` showed `push: true, admin: true`. Host `kmkmbp2026`.

Cross-link: garden-side comment on endo-but-for-bots#387 (id `4599031642`) PATCHed in place to `Mirror of https://github.com/endojs/endo/pull/3294 (head 4150060dd).`. No upstream-side mirror comment (retired per 2026-05-29 maintainer directive).

Self-improvement: nothing this time.
