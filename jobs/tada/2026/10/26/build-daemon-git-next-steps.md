## Completion report: build-daemon-git-next-steps

I opened draft PR **endojs/endo-but-for-bots#1565** (https://github.com/endojs/endo-but-for-bots/pull/1565) with one commit, `1cb4ade14e`. Its base is the frozen `llm-d5ac419` branch.

**Which slice.** In the roadmap's phased build plan (`designs/daemon-git-next-steps.md`), Phases 1–4 have shipped (#705, #706, #707, #645). Phase 5's two parts are covered: `conflict-rebase` is on `llm`, and `stack-surgery` is in draft #626. That left **Phase 6**, structured result shapes (Phase 7 in `daemon-git-capability.md`), as the next unbuilt work. This PR is its first slice: the `diff` family.

**What changed**
- **`@endo/exo-git`:**
  - `Git.diff(options?)` now returns a structured `GitDiff`: a list of changed files, each with status, old and new path, old and new mode, and hunks of added, removed, and context lines.
  - The old text output moves to a new `Git.diffText(options?)`, which takes the same options.
  - Guards, reader membership, `types.ts`, help, the backend contract and the stub backend are all updated, plus type tests.
- **`@endo/git`:**
  - New `src/parse-diff.js` combines two git outputs for the same comparison: `--raw -z` supplies exact paths, modes and statuses, and the patch output supplies the hunks.
  - Both calls pin rename detection; the patch call also forces no colour and short submodule output. This stops a repository's own diff settings from making the two outputs disagree.
  - It handles type changes (folded into one record), unmerged paths (status `unmerged`, no hunks) and blank context lines.
  - If the two outputs still disagree, or the output is bigger than 1 MiB, `diff()` throws an error instead of returning partial data.
- **Code that called `diff` was updated:**
  - The agent-tools `diff` tool returns the structured shape; I added no new JSON tool, per the #731 parking.
  - The code-mode type declarations were regenerated and now include `diffText`.
  - The floot system prompt describes the new shape.
  - The agentry conflict-rebase eval compares patches byte for byte, so it switched to `diffText`.
  - The daemon tests were rewritten against the structured shape.
- **Also added:** a changeset (major for exo-git and git, minor for agent-tools) and a note in the design's Implementation Progress section.

**Where it differs from the design sketch** (recorded in the design and the PR body):
- File paths are plain mount-relative strings rather than `EndoMountEntry` values, matching what `status()` already returns.
- I added an `unmerged` status, which the sketch doesn't have.
- The `binary` field is an empty record; file sizes aren't filled in yet.

**Testing**
- New parser unit tests, plus real-git tests run under hostile repository settings.
- Removing any one of the three pinned options (`--submodule=short`, `--no-color`, `--find-renames`) makes the hostile-settings test fail, so each one is needed.
- Test results:

| Package | Result |
|---|---|
| git | 23/23 |
| exo-git | 56/56, plus type tests |
| agent-tools | 255/255 |
| agentry (code-mode and conflict-rebase) | 33/33 |
| floot | 852/852 |
| daemon `test/git.test.js` | 132/132 |

- Type checks in each package and at the repo root are clean, and the garden pre-push gates and the related-design gate (#709, #807, #1367) pass.

**Unrelated failures on this host.** The merge, cherry-pick and rebase conflict tests fail on this host with or without my change. The cause is `rerere.enabled=true` in the host's global git config (the same kind of problem as #883). They pass with `GIT_CONFIG_GLOBAL=/dev/null`, and I noted this in the PR.

**Follow-ups**
- The rest of Phase 6 is not built: structured `show`, `merge`, `rebase`, `stashList` and `stashShow`, each with a `*Text` version, and removing mutation methods from the `readOnly()` type. A future run of this job can take the next slice. The PR body lists these.
- The breaking change (`diff()` no longer returns a string) is flagged in the changeset and the compatibility section of the PR.
- The gauntlet (panel review, fix loop, un-draft) is staged automatically when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-next-steps.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 188 tokens (14640829 cached reads)
- Output: 63296 tokens
- Cost: $5.888805800000002
- Wall-clock: 1513s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
