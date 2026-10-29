## Fix round 3 report: endojs/endo-but-for-bots#1565

Both must-fix items from the panel-3 review are fixed, along with most of the should-fix items. I pushed one follow-up commit, `aecab6dc2a`, to `build-daemon-git-next-steps-structured-diff` with `safe-push-pr-head.sh`. CI is green: 36 checks, 0 failed, `ci-wait-merge` rc 0.

**Must-fix items**
- **Archivist:** the "Essential backend contract" block in `designs/daemon-git-capability.md` now says `diff(...): Promise<GitDiff>` and adds `diffText(...): Promise<string>`.
- **Integrator:** the PR body now has the missing "Documentation considerations" section, and its sections follow the template order.

**Should-fix items applied**
- **Breaker #1, two-run race:** `Git.diff` now makes one `git diff --raw -z --no-abbrev --patch` call instead of two parallel ones.
  - The new `splitDiffOutput` and `parseDiffOutput` in `parse-diff.js` split that output into its raw and patch parts. A file that changes partway through can no longer get another file's hunks.
  - This also means only one copy of the output sits in memory.
  - In this combined mode, git reports a conflicted (unmerged) file as a single `::` record, so the parser now reads that as `unmerged`.
  - Tests cover the split, the conflicted-file case, and output that ends early.
- **Archivist #2–#7:**
  - The `diff` and `diffText` JSDoc now name the real difference: `diffText` is cut off at 50,000 characters with a truncation marker, while `diff` fails above 1 MiB.
  - That 50,000-character cap is now stated in `types.ts`, `help.md` and the regenerated `help-text-data.js`, and in the design note on the conflict-rebase eval.
  - The design's list of pinned git flags is complete.
  - `binary` is shown as `{}` with sizes "not yet reported".
  - The Phase 1 `diff` sketch is labelled as Phase 1.
  - `designs/agentry-git-eval-scenarios.md` now names `diffText()` and the 50,000-character cap instead of calling `diff()` "unbounded".
- **Purist #2:** the help text now describes the hunk shape correctly (`oldStart`, `oldLines`, `newStart`, `newLines`, `lines`).
- **Breaker #2:** the help now says what to do when `diff` fails on large output (use `diffText` or narrow by path).
- **Changeset auditor and integrator #2:** the changeset is rewritten one sentence per line. It now states that paths are mount-relative strings and why `@endo/agentry` is bumped. The PR body says `@endo/floot` is private, so it needs no changeset entry.
- **Pruner:** the Security, Scaling and Compatibility sections of the PR body are cut down to pointers to the changeset, and the "most critical to review" paragraph no longer lists the flags.

**Deliberately not done**
- **Purist #1 (use `Fail`/`makeError`):** the rest of `@endo/git` uses `throw new Error`, so I kept the package's own style.
- **Purist #3 (`binary: true` instead of `{}`):** this would change the API shape and is a design choice, so I left it for reviewers.
- **No test for output over the 1 MiB limit (breaker #2):** I only documented the fallback.
- The comment-only items need no change.

**Local checks:** `@endo/git` passes 28 tests and `@endo/exo-git` passes 58. ESLint shows no errors. The package `tsc` and the repo-root `tsc` report no errors in `git` or `exo-git`.

**CI:** `cover (24.x, ubuntu-latest)` failed twice, both times in `@endo/sandbox` bwrap tests:
- "process group survived bounded cleanup" on the first run.
- "stdin EOF refused" on the first rerun.

This PR doesn't touch that package, and the same workflow on `llm` alternates between red and green. Open PR #1566 ("make bwrap tests runner-portable") targets these bwrap tests. The second rerun passed; a CI wait run before that rerun had returned rc 3 (red), and the final wait came back rc 0, green.

**Follow-ups:** the panel-4 rerun is up to the driver. Once #1566 merges, it should stop these bwrap failures from hitting this PR's runs.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4880511 cached reads)
- Output: 24614 tokens
- Cost: $2.321742199999999
- Wall-clock: 3452s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
