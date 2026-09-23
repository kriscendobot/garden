This job is already complete. The fix and tests described in the spec are fully present at HEAD (`7cc020469`, which is `origin/main2`), landed across four commits. All 29 triager tests pass, including the two new cases (E and F) covering exactly the scenario the job describes.

**Report:**

The self-heal fix requested by this job was already implemented and pushed to `main2` before this claim was worked. Verified current state rather than duplicating it:

**The fix (`scripts/jobs/triager.sh:55-64`):**
- Both `git rev-parse` invocations now use `--verify -q`, so a failed primary-ref resolution emits nothing on stdout — eliminating the `refs/remotes/origin/master\n<sha>` concatenation that broke bare-clone forks like `kriscendobot-endo.git` (commits `469cab011`, `4ceaff391`, the latter dropping the now-redundant `2>/dev/null`).
- The existing `|| die "cannot resolve ref '$ref' in $slug"` fallback is preserved.
- Added a belt-and-suspenders tripwire: `[[ "$new_sha" =~ ^[0-9a-f]{40}$ ]] || die ...` (commit `7cc020469`), which fails loudly at the source on any future regression that re-poisons `new_sha`, instead of surfacing as an "ambiguous argument" fatal deep in the handler.

**The tests (`scripts/jobs/test/triager-test.sh`, commit `8c25e2597` + `7cc020469`):**
- Case **E** — bare clone whose watched ref exists only under `refs/heads/*` (no `refs/remotes/origin/*`): asserts the fallback path resolves, the handler is invoked exactly once (single CALL_LOG line ⇒ no embedded newline), and `new_sha` is the clean 40-hex SHA.
- Case **F** — a poisoned multi-line `new_sha` trips the `^[0-9a-f]{40}$` guard, dying non-zero with the handler never invoked and the cursor unadvanced.

Ran the full suite: **29 passed, 0 failed**.

No code changes or commits were needed from this run; the worktree is clean and no push is required. No follow-ups.
