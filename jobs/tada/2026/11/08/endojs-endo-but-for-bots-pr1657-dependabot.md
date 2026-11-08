I reviewed PR #1657 and the verdict is **MERGE-NOW**, but I did not merge it. `test-xs` is red on the base branch for a reason unrelated to this PR, and the merge script won't merge with any red check, so the PR stays open as a non-terminal MERGE-NOW row (same as #1633).

**The bump:** `@earendil-works/pi-coding-agent` goes from 0.87.1 to 1.4.0, a major version. Only `packages/agentry` uses it.

**Base check:** the base branch `llm` (48d6f3e08b) still resolves ^0.87.1, so the PR is not superseded. The head is 1 commit ahead and 0 behind.

**Lockfile changes:**
- **Nested copies:** `pi-coding-agent` 1.4.0 pins exact 1.4.0 copies of `pi-agent-core`, `pi-ai` and `pi-telemetry`. Agentry itself stays on ^0.87.1, so both versions are now installed side by side.
- **New packages:** `pi-codemode` 1.4.0, `pi-mcp` 1.4.0 and `quickjs-wasi` 3.6.2.
- **Extra copies:** `@anthropic-ai/sdk` 0.129.0 and `openai` 7.19.0 now sit next to the newer versions already in the tree.
- **Publishing:** everything was published through npm trusted publishing with SLSA provenance. No package has install hooks, and the licenses are unchanged.

**Maturity:** the newest version in the diff is the headline itself, published 2026-10-21T22:48:58Z. The 7-day floor was 2026-10-28T22:48:58Z and has passed.

**Advisories:** OSV and GitHub's advisory database list nothing for any incoming or outgoing version.

**Install and source read:**
- The install ran with scripts disabled and was clean.
- I compared the URLs bundled in 0.87.1 and 1.4.0. The new ones are model-catalog entries, a doc-comment example and placeholders, not new default-on network calls.
- `pi-telemetry` 1.4.0 has no network code. `pi-mcp` only opens connections and spawns processes in its transports, which is expected for an MCP client.
- Every symbol agentry imports still exists in 1.4.0, and `endo-pi --version` prints 1.4.0.

**Local tests:** in `packages/agentry`, `tsc` is clean and 207 ava tests pass. One test, `eval/conflict-rebase`, fails here because this host has `rerere.enabled=true` in its global git config. With a clean git config its 13 tests pass, so it isn't caused by the PR.

**CI on head 306baa33a8:** 25 checks passed and 10 were skipped, including `lint` and `build`. Two were red:
- **`test-xs`:** the same `hardened262` test (`sesNode ThrowTypeError/intrinsic-metadata.js`) fails on `llm` itself. The cause is `.node-version: lts/*` now resolving to Node 26. The fix is draft PR #1646, which pins Node 24.
- **`test (22.x, macos-15)`:** the known `claude-sandbox` `restore-context.test.js` macOS flake; that package doesn't use pi. I asked GitHub to re-run job 128846679652. It hadn't finished when I stopped, so I don't know its result.

**What I posted:**
- **Verdict comment:** https://github.com/endojs/endo-but-for-bots/pull/1657#issuecomment-6727376011
- **Ledger entry:** `journal/entries/2026/11/08/212933Z-message-botanist-be838a.md`.
- **Recheck:** the daily heartbeat `dependabotany-recheck-endo-but-for-bots` already exists. I placed no one-shot recheck because the maturity floor has passed.
- **Prose read:** none. I read no changelog, release notes, README or PR body, so nothing needed classifying.

**Follow-ups:**
- **To merge:** once #1646 lands on `llm` and the macOS re-run is green, run `ci-wait-merge.sh endojs/endo-but-for-bots 1657 --dependabot-auto-merge`. #1646 is still a draft with no job driving it; #1633 and #1629 wait on it too.
- **Worktree script:** `ensure-project-worktree.sh` failed with a read-only filesystem error under the monk sandbox again (already reported). I cloned the repo into `$TMPDIR` instead.
- **Yarn cache:** the shared Yarn cache is also read-only in the sandbox. Install worked with `YARN_ENABLE_MIRROR=0 YARN_GLOBAL_FOLDER=$TMPDIR/... YARN_CACHE_FOLDER=$TMPDIR/...`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1657-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (5294294 cached reads)
- Output: 22758 tokens
- Cost: $2.4466908
- Wall-clock: 5092s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
