I applied the panel-2 must-fix items on PR #1594 in one commit, `3c20a5820a`, and pushed it with `safe-push-pr-head.sh`. CI is green on that head: 36 checks, 0 failed (`ci-wait-merge` rc 0).

**Code changes (commit `3c20a5820a`):**
- **Changeset** (`.changeset/daemon-rename-to-manager.md`): changed the bump from `minor` to **`major`**, because no deprecated aliases are kept. Added a migration paragraph covering the import-path move from `daemon-node-powers.js` to `manager-node-powers.js`, the renamed `interfaces.js` exports, and the facet tag that stops old and new managers and workers from working together. It also says `bus-xs-daemon-polyfills.js` keeps its name, and the text is now one sentence per line.
- **`interfaces.js`**: removed the stray `@deprecated` tag on the `WorkerFacetForManagerInterface` re-export.
- **Stale old names**: updated references to the renamed `manager-*` files in:
  - `docs/error-tracing-design.md`: the broken link and the prose.
  - `packages/daemon/DEBUGGING.md`: the `pgrep`/`pkill` patterns.
  - `mem-cas` (`README.md`, `store.js`, `store-web-powers.js`) and `platform` (`content-store-powers.js`, `search-powers.js`) comments.
  - The `fae` smoke test, which cited `daemon.js:2810`.
  - The re-export comments in `bus-manager-node-powers.js` and `manager-go-powers.js`.
  - The import in `manager-webextension.js`. That powers file has never existed, the import was already marked `no-unresolved`, and it still points at a file that doesn't exist; only the name changed.
- **Rename design**: the dangling `#open-questions` link now points to the "Question of renaming the package itself" section.
- **11 daemon test headers**: cut the exemption comment to one line without the "this rename-only change" history.

**PR body:**
- Removed the invented `### Repository-wide audit` heading and folded a shorter version into Description, which also drops the commit-hash lists, the grep regex and the test tally.
- Added the requested notes: the XS bootstrap only renames bindings and no CI workflow runs it, so wiring an XS run is a follow-up; `__daemonReady` and the `daemonHandle` bindings keep the old names on purpose.
- Updated the ledger's Phase 3 line to cite the new commit.

**Not done:**
- No local lint or tests: the worktree had no dependencies installed. The changes are comments, docs, one import specifier and a removed JSDoc block, and CI is green.
- I left older design docs such as `designs/daemon-capability-bus.md` alone, because the rename design says not to sweep older designs.
- I didn't squash the two earlier fixup commits; that suggestion was comment-only.

**Follow-ups:**
- Rust-side comment renames.
- Wiring an XS or `test:rust` CI run.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1594-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2336440 cached reads)
- Output: 13385 tokens
- Cost: $1.4806999999999997
- Wall-clock: 2702s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
