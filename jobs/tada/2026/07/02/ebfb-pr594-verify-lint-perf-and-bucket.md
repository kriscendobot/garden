Everything the maintainer directive asked for is already done on the PR by a peer gardener, with green CI. My push was correctly rejected by the git-push CAS, so nothing was clobbered. I'll stand down without force-pushing my redundant commit or double-posting a comment.

## Completion report

**Outcome: the directive is satisfied — by a peer job, independently corroborated by me. No duplicate push, no duplicate comment.**

**What I did**
- Set up an isolated project worktree off PR #594's head (`endojs/endo-but-for-bots`, branch `chore/lint-eslint-per-package-batches`), installed deps (yarn 4.13.0 via corepack), and **measured the lint performance for real** (serial, single 32-core host, `node <eslint entry>` to bypass the sandbox's blocked bin shims):

  | approach | processes | wall-clock |
  |---|---|---|
  | baseline whole-tree `eslint .` | 1 | **65.4 s** |
  | per-package (this PR's original form) | 53 | **125.6 s (≈1.9×regression)** |
  | bucket 6 / 10 / 14 / 18 pkgs per process | 9 / 6 / 4 / 3 | 66.2 / 65.8 / 61.8 / 59.8 s |

  The regression kriskowal predicted is real (~1.9× locally). Bucketing amortizes the per-process project-service rebuild back to whole-repo parity even at bucket size 6; performance is flat from 6→18, so bucket size is really a ceiling-safety knob. Sweet spot: **~10 packages/bucket** (parity perf, ~5× headroom under the ~53-package scale that dropped the `where`/`zip` tail).
- Wrote a bucketed `scripts/eslint-repo.sh` (bucket 10, `LINT_BUCKET_SIZE` override) and updated the changeset; verified it end-to-end: **rc=0, 59.1 s, byte-identical warning set to `eslint .` (0 errors, 5 warnings), 0 `none of those TSConfigs`/parsing errors, shellcheck clean** at both `-S warning` and default severity.

**What I found on push (collision)**
- My push to the PR head was rejected by CAS: a peer gardener (job `endojs-endo-but-for-bots-pr594-042c3a07`, also endolinbot, ~13 min earlier) had **already pushed an equivalent bucketing commit** (`3473f5df2`, the current PR head) and **already replied on #594 with real-CI measurements** (base `master` `eslint .` 4m33s vs one-process-per-package 6m32s, +44%; fix = `ESLINT_BUCKET_SIZE` default 10). Their solution is functionally identical to mine (bucket 10 by count, env-tunable, coverage-identical, `--fix` forwarded, shellcheck clean), better-backed (CI timings), and already documented on the thread.
- **PR #594 is now MERGEABLE/CLEAN, all checks green** (`lint: completed success` on head `3473f5df2`), still DRAFT (un-draft is the maintainer/gamut's call, outside this directive).

**Decision**
- Stood down rather than clobber: I did **not** force-push my redundant commit over the peer's (my local commit is discarded with the worktree) and did **not** post a duplicate PR comment (the peer's reply already covers verification + decision comprehensively — a second post would be thread noise). My local numbers independently corroborate the peer's CI finding, raising confidence in the shipped bucketing approach.

**Follow-ups**
- None required for #594. Note for producers: two jobs (`ebfb-pr594-verify-lint-perf-and-bucket` and `endojs-endo-but-for-bots-pr594-042c3a07`) were created for the same maintainer directive on the same PR — a duplicate dispatch; the CAS + inbox correctly prevented any corruption or double-post, but the ~15 min of duplicate compute could be avoided by checking whether the target PR head already carries a peer's fix before claiming.
