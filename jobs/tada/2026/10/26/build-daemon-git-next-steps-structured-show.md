I built the `Git.show` slice and opened it as draft PR **https://github.com/endojs/endo-but-for-bots/pull/1568**, stacked on #1565. All the test suites I ran pass. They needed `GIT_CONFIG_GLOBAL=/dev/null`, though, and one pre-push check (`spell-out-identifiers`) still fails.

**What changed**
- **New behavior:** `Git.show(ref)` now returns `{ commit, parents, diff }`: the commit record, its parent ids in order, and its changes against the first parent. For a root commit the diff is against the empty tree. `Git.showText(ref)` is the new text sibling and returns what `show` used to.
- **Commits only:** `show` peels the ref to a commit, so an annotated tag shows its commit and a tree or blob is rejected. `showText` still renders anything, including blobs like `HEAD:README.md`.
- **Merge commits** report only their first-parent diff. Git's combined merge diff doesn't fit the existing hunk shape, which is the same reason #1565 gives conflicted files no hunks. `parents` still lists every parent.
- **Backend (`packages/git/src/native-git-backend.js`):** #1565's structured-diff code is now a shared helper. `show` reuses it, so it keeps the same safety flags. The empty-tree id comes from git itself, so SHA-256 repos work.
- **Wiring:** method guards, reader-facet membership, types, help docs and the regenerated help data, the backend contract, the placeholder backend, and the agent `show` tool's description.
- **Agent-facing:** the code-mode declarations now advertise `showText`. I fixed one read-only check in `code-mode-types.test.js`: it searched for the string `commit:`, which the new `GitShow.commit` field also matches. It now matches the `commit: (` method signature.
- **Docs:** a changeset (`@endo/exo-git` and `@endo/git` major, `@endo/agent-tools` minor, matching #1565). The design's progress note now records this slice, the choices above, and the updated remaining Phase 7 list.
- **Tests:** new real-git tests in `packages/git/test/native-git-backend.test.js` run under hostile repo config. They cover root, ordinary and merge commits, tags, blob rejection, option-shaped refs, and SHA-256. The daemon, exo-git conformance, type, and agent-tools tests were updated too.

**Verification**
- **Tests:** `@endo/git` 29/29, `@endo/exo-git` 58/58 plus its type tests, `@endo/agent-tools` 255/255, `@endo/agentry` code-mode 20/20, `@endo/daemon` `test/git.test.js` 133/133.
- **Types:** `lint:types` is clean in all five packages. The repo-root `tsc -p tsconfig.json` is clean, but it ran out of memory at the default heap and needed `NODE_OPTIONS=--max-old-space-size=12288`.
- **ESLint:** no errors.
- **Host git config:** the suites needed `GIT_CONFIG_GLOBAL=/dev/null` because this host's global git config sets `rerere.enabled` and `branch.autoSetupMerge`. Without it, `git-flow.test.js` fails on this host, as it did before this change. For the same reason, my new merge test creates its branch with `--no-track`.

**Follow-ups**
- **Pre-push check still failing:** `spell-out-identifiers` flags `RefArgShape` in `packages/exo-git/src/interfaces.js`. That name already exists and is used across the file; I only reference it on one new line. Renaming it would widen this PR, so I left it. I did rename my own new variable `committedAtStr` to `committedAtText`.
- **Frozen base:** the PR targets a new branch, `build-daemon-git-next-steps-structured-diff-3a61d1a`, a snapshot of #1565's head, because the PR-opening script requires a fixed base. If #1565's head moves, #1568 needs a weave.
- **Breaking for agents:** the agent `show` tool now describes commits only. Agents that read blobs through it should use `filesystemAt` or `tree`, or `showText` in code mode.
- **Remaining Phase 7 work:** structured `merge` and `rebase` results with their text siblings, structured `stashList`/`stashShow`, and narrowing the `readOnly()` type.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-next-steps-structured-show.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 140 tokens (8164111 cached reads)
- Output: 33787 tokens
- Cost: $3.491490199999999
- Wall-clock: 1084s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
