# Completion report: build-daemon-agent-tools-phase-five-contract-test

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1597 (head `bot/test/git-surface-contract`, pinned base `llm-9a14ddf`, which is current `llm`). It adds the contract test so the Git facet guards, the `types.ts` types and the generated code-mode declarations can no longer drift apart. The new test found one real drift, which the PR also fixes.

**What was missing.** On `llm`, three of the four places that describe the Git capability were already checked against each other:
- `makeGitKit`'s exo facets were checked against the method lists in `interfaces.js` (`kit-conformance.test.js`).
- `makeGit`'s return types were pinned to the `types.ts` posture types (`types.test-d.ts`).
- The generated declarations were kept fresh against `types.ts`.

Nothing tied each `types.ts` posture type, or each generated declaration, to the runtime facet guard that enforces it.

**Changes, all in `packages/agent-tools` unless noted:**
- **New test, `test/git-surface-contract.test.js`.** For each of reader, writer and rewriter, it requires the same method set in four places:
  - the method list;
  - the facet guard;
  - the `types.ts` posture type, including members it gets through intersection;
  - the checked-in generated declaration, read from the artifact text.

  It also checks that `GitInterface` matches the rewriter facet, that `gitHistory` holds exactly the rewriter-only verbs plus `commit`, and that `git` and `gitHistory` together cover the rewriter facet.
- **Drift fix.** The read-only declaration was filtered through a hand-kept `GIT_READONLY_MEMBERS` list written before the root followers were added. As a result it left out `help`, `followRootChanges` and `followLatestRoot`, even though the reader facet accepts all three. I removed the list, so the extractor now renders the whole `ReadOnlyEndoGit` type. `generated/code-mode-globals/git-declarations.js` is regenerated; only `gitReadOnly` changed. I also removed the one test assertion that used the list.
- **Changeset:** `.changeset/agent-tools-git-readonly-declaration-reader-facet.md` (patch).
- **Design (`designs/daemon-agent-tools.md`):** ticked the Phase 5 checkbox and corrected the file names it lists to `types.ts` and `types-index.types.d.ts`, the files that exist today. The pre-push typist fixer also replaced three `…`/`→` characters elsewhere in that file.

**Verification:**
- The new suite, `code-mode-types.test.js` and `code-mode-globals.test.js` pass (39 tests).
- `tsc` is clean for `@endo/agent-tools`, and the pre-push gates pass. The one advisory was about the test's header comment, which I kept because it explains which files the test ties together.
- Both drift directions fail the new test: restoring the old generated file fails the read-only check, and adding an unguarded member to `ReadOnlyEndoGit` fails the `types.ts` check.

**Notes and follow-ups:**
- The design points at commit `473b718b3` on branch `docs/agentry-git-rebase-evals`, but neither exists on the remote. The type-level assertions it describes are already on `llm` in `exo-git/test/types.test-d.ts`, so I built on those instead of restoring the commit. The PR body says this.
- `ensure-pr.sh` decides what to check from the directory you run it in (`$PWD`). Run from the garden worktree, it refused the PR body because it couldn't find the design file (`governing-design-unresolved`). Run from the project worktree, it opened the PR normally. Builders should call it from the project checkout.
- After this report, the gauntlet (clean → panel → fix-loop → un-draft) should stage automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-phase-five-contract-test.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4471289 cached reads)
- Output: 21668 tokens
- Cost: $2.311273799999999
- Wall-clock: 736s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
