---
ts: 2026-06-06T05:15:46Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/051150Z-dispatch-liaison-a1ec64.md
---

Shape-2 re-ferry of `endojs/endo-but-for-bots#75` onto `endojs/endo#3232` to clear CONFLICTING by refreshing the stale base. Force-pushed the recompute onto current master.

**Outcome.** `endojs/endo#3232` head `71055ef17` -> `46e330a2b` (force-with-lease confirmed: `+ 71055ef17...46e330a2b HEAD -> kriskowal-random-chacha20 (forced update)`, lease against the prior tip held). `mergeable` CONFLICTING -> MERGEABLE. `reviewDecision` REVIEW_REQUIRED (unchanged; gibson042 + kriskowal COMMENTED, no approval to dismiss). Title/body left unchanged. Pushed to the upstream branch name `kriskowal-random-chacha20` (source-side is `-chacha12`).

**Conflict handling.** All 9 feature commits (`208e4f725`..`effbf3bd6`) cherry-picked cleanly onto current master `4a04d078b` with zero conflicts. The bot's yarn.lock commit `cbab24e77` was NOT carried; regenerated via `corepack yarn install` (Yarn 4.13.0, node 24.16.0) producing a 61-insertion / 1-deletion delta to register the new workspaces, committed as a separate `chore: Update yarn.lock`. Final series is 10 commits.

**Attribution + trailers.** All 10 commits show `Kris Kowal <kriskowal@kriskowal.com>` as both author and committer (the source's 9 feature commits had Kris Kowal author but an endolinbot committer from the bot-side rebase; re-committed under the kriskowal identity override). TRAILER GATE: `git interpret-trailers --parse` is EMPTY on every commit in `origin/master..HEAD`. No `(#75)` suffixes, no Co-Authored-By / Generated-with / Refs trailers.

**Net-diff fidelity vs source bots#75.** Confirmed by direct blob comparison: all 62 non-yarn.lock files touched by `gh pr diff 75` have byte-identical resulting content at HEAD (matching `hash-object`; checked=62 mismatch=0 missing=0). The new packages `packages/random/**` and `packages/chacha12/**` (and `packages/chacha12-fast-check-test/**`) are present; the `_xorshift.js` helpers under `packages/hex/test/` and `packages/ocapn/test/` are correctly deleted. The earlier hunk-level diff differences were git rename-detection artifacts (my recompute renders the new package.json files as renames-with-modification from `packages/hex/package.json`; bots#75 renders them as full new files), not content differences.

**CI.** Running at report time (zizmor pass; build / cover / lint / test matrix / test262 / test-xs / test-hermes / ocapn-guile-interop / ocapn-python all pending). Not waited on; shepherd handles CI-driven follow-up.

**Cross-link (CREATE).** No prior `Mirror of ` comment existed on bots#75. Posted under the authenticated kriskowal identity on the garden repo: `Mirror of https://github.com/endojs/endo/pull/3232 (head 46e330a2b).` Comment id `4637494705`, https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4637494705. No upstream-side comment posted (retired per the 2026-05-29 directive); no `message: boatman → steward`.

Self-improvement: the net-diff fidelity check in `skills/pr-handoff/SKILL.md` § Verification implicitly assumes hunk-for-hunk diff comparison, but git rename detection makes that comparison produce spurious differences whenever a new file is most-similar to an existing one in the base (here the three new package.json files matched `packages/hex/package.json`). The blob-hash comparison (`git show HEAD:<f> | git hash-object --stdin` vs the same at the source ref, over the source diff's file list) is the robust check and sidesteps rename-heuristic noise. Below the threshold for a skill edit on its own (one ferry), but worth a row in pr-handoff's § Notes from the field if a second ferry hits the same rename-induced false-positive; flagging here so the next boatman recognizes the pattern.
