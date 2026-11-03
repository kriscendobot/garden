**Undraft stage, endojs/endo-but-for-bots#1641:** the PR is now ready for review ("fix(exo-git): resolve diff and stash paths through the mount", base `llm-48d6f3e`).

**What I did**
1. **Appellate pass (advisory only, did not block the undraft):** ran a short `claude -p` review of the diff (351 lines). Its points weren't checked against the code and need a human look:
   - **Pathspec magic:** git may still read `:(top)`, `:!`, `:/` and names starting with `-` as pathspec syntax in the new `diff` and `stashPush` paths. If the mount root is a subdirectory of the repo, `:(top)` or `:/` could reach outside the mount. It's worth confirming the backend uses `--literal-pathspecs` and a `--` separator, and adding a test for it.
   - **Symlinks:** no test covers a symlink that points outside the worktree (e.g. `link/secret`).
   - **Deleted files:** a deleted tracked file is tested for `diff` but not for `stashPush`.
   - **Breaking change under a `minor` changeset:** `paths: ['.']` now throws. The changeset says so, but in-repo callers should be checked for it.
   - **Minor:** the schema is looser than the behaviour (it omits `entries`, and nothing requires `base` when `head` is given), and the `PATHS_PROP` → `PATHS_PROPERTY` rename is unrelated churn.
2. **Pre-mutation check:** the PR was OPEN and still a draft, with head exactly `c3baa8c6eaf631653f3a80befd41b2278a34a130`, the commit the panel passed.
3. **Undraft:** ran `gh pr ready`, which succeeded.
4. **Post-check:** the PR is no longer a draft and the head is still `c3baa8c6eaf631653f3a80befd41b2278a34a130`.

**What changed:** only the PR's draft status. Nothing was committed to the garden repo.

**Follow-up (optional):** if the maintainer wants the pathspec and symlink points fixed, that would be a separate fixer job.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1641-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178600 cached reads)
- Output: 1552 tokens
- Cost: $0.4216
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
