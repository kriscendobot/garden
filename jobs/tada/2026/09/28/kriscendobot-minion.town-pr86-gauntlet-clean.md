The clean stage is done for kriscendobot/minion.town PR #86: I pushed one follow-up commit, and CI is green on the new head `8689f79`.

**Coverage pass.** I checked coverage on `src/endo/git-remote/**` and removed one piece of dead code:
- Before: 87.7% of lines and 77.9% of branches covered.
- After: 92.7% of lines and 82.1% of branches covered. `capability.ts`, `config.ts`, `app.ts` and `projection.ts` now have every line covered.

**What the commit changes (`8689f79`, "test(git-remote): cover config, store edge cases; drop unused digestsEqual (#86)"):**
- **Removed `digestsEqual`** from `capability.ts`, along with its `timingSafeEqual` import. Nothing called it, because tokens are looked up by their hash in a map, never compared directly.
- **New `test/git-remote/config.test.ts`:** checks the production defaults (listen on localhost only, HTTPS required), every environment-variable override, and that HTTPS stays required for any value other than `"0"`.
- **More tests in `capability.test.ts`:**
  - Revoking an unknown token returns false and leaves existing tokens working.
  - A token minted by another store instance on the same directory is found even after this instance has built its lookup cache.
  - A store whose directory doesn't exist refuses every token.
  - Projecting a branch that has no commits yet returns `{fileCount: 0}`.

**Checks:**
- Typecheck is clean, and the full `npm test` run passed: 593 tests, 8 skipped.
- I pushed with `safe-push-pr-head.sh`, which moved the branch forward from `b002093` to `8689f79` without overwriting anyone else's commits.
- `ci-wait-merge.sh --no-merge` returned 0: all 3 checks passed.

**Follow-ups for later stages:**
- `main.ts` (the process entrypoint) is still untested, since that would mean starting the server.
- Some error paths in `git-backend.ts` and `git-http.ts` are still untested, such as the git subprocess failing to start or producing no headers.
- The PR is still a draft; un-drafting it is a later stage of the review sequence.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (940304 cached reads)
- Output: 6709 tokens
- Cost: $0.7748728
- Wall-clock: 348s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
