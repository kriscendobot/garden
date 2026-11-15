I've added the hook, and both workflow pin comments for `peter-evans/create-pull-request` bumps on `endojs/endo-but-for-bots` now get fixed before CI runs. It's pushed to `main2` as `c4766a84510`.

**What it does.** `scripts/jobs/dependabot-migration.sh` has a new row in its hook table, `action-pin-comments`. Dependabot updates the SHA in `.github/workflows/update-action-pins.yml` and `update-action-pins-major.yml` but leaves the old `# v8` comment, which fails zizmor. The hook:
- **Checks it's a plain bump:** the PR may change only those two files, and every changed line must be a pin line for that action.
- **Requires one SHA:** both files must be pinned to the same SHA.
- **Finds the exact tag:** it asks the action's upstream (`git ls-remote`) which `vX.Y.Z` tag points at that SHA, and requires exactly one.
- **Rewrites only the trailing comment**, then checks that every pin reads `@<sha> # <tag>`.

The runner's existing checks still apply: only the two workflow files may be written, nothing is committed on failure, and a rerun on an already-fixed head reports `already-current`. Failures exit with code 2 when the PR isn't a plain bump (an extra line or two different SHAs) and code 4 when the tag can't be resolved.

**Runner change.** A hook step named `builtin:<fn>` now runs a function inside the script. Any other step name still runs as `npm run <script>`, so the existing `claude-harness-refresh` row behaves as before. The dependabot watcher needed no change, because the package name it reads from the PR title already matches the new row exactly.

**Docs.** `roles/botanist/AGENT.md` now cites this case next to the minion.town one.

**Tests**
- The migration suite passes 25/25. A new section J uses a local repo as a stand-in upstream and covers the lookup, the rewrite, a rerun, an extra changed line, two different SHAs and an untagged SHA.
- The watcher suite passes 89/89. I had to point `GARDEN_DEPW_TEST_DIR` at a temp directory because its default location is read-only in this sandbox.
- A live run against the real upstream, using PR #1662's SHA (`15733dbd…`), changed `# v8` to `# v8.1.2` in both files. That matches the hand repair commit `f5dfab4e`.

**Follow-up:** this fixes only these two files and this one action. If other actions with floating tags start failing zizmor, each needs its own row in the hook table.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-action-pin-comments.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1221049 cached reads)
- Output: 13188 tokens
- Cost: $1.1099618
- Wall-clock: 263s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
