## Fix round 1 for kriscendobot/minion.town PR #154: done, CI green

I applied all six must-fix items from the round-1 panel review, plus the should-fix items. The changes are one follow-up commit, `e877678`, pushed to `chore/javascript-only-scripts-part-3` with `safe-push-pr-head.sh` (ec6a460 → e877678). `ci-wait-merge.sh --no-merge` returned 0: all 3 checks passed.

**Must-fix items**
1. **Restore rollback (breaker):** `npm-registry-backup.js` `runRestore` now arms the rollback before the first rename, as the shell `EXIT` trap did. A failure between the two renames now puts the previous generation back. A new test makes the second rename fail. It fails against the old `swapped` code and passes now.
2. **Header-strip test (prover):** the test now reads a synthetic file with a two-line header (one CRLF line) and asserts the exact body. `.slice(0)` or `.slice(1)` would now fail it.
3. **Stylist:**
   - The inline database handle `db` is now `database`. The test shim that matches on that text is updated to the new name.
   - The unused `UNIT_B64` key is gone from `deploy-npm-registry.js`.
4. **Template renderer (purist and others):** `renderRemoteProgram` now does one substitution pass. It throws if a template uses a variable the caller didn't supply, or any braced form other than `:start[:length]`. It also throws on NUL bytes in the template or in values. A value can no longer be expanded a second time or unescape the sentinels. Lower-case `$name` remote shell variables still pass through unchanged. The three real templates render byte-identical output to the old renderer. New tests cover each rejected operator (`#`, `:-`, `: -3`, `%`), unsupplied variables, and the injection attempts.
5. **Purist:** `deploy-siwe-thunk.js` now carries the `prefer-endo-primitives-exempt` marker with its reason.
6. **Pruner and phase-evidence:** in the PR body, I replaced the test tally and the ten-row table with a short coverage paragraph. I also added a sentence saying the PR claims no phase of `designs/claude-agents-capability.md` or `designs/endo-reminder-minion-town.md`.

**Should-fix items**
- **Pin regex:** the `endoCommit` regex is anchored on `^export const endoCommit` in both `tools/vendor-endo-claude.js` and `test/endo-pin-drift.test.ts`. Both now require exactly one match.
- **Receipt values:** `deploy-app.js` checks that `sourceCommit` is a 40-character hex SHA and that `deployRunUrl` is a strict URL or `local` before they reach the root receipt heredoc.
- **`MemoryMax=0`:** it is now reported as "at least 1G" instead of "invalid", with a test.
- **Arrows:** the two `->` arrows in `deploy/aws/README.md` and `designs/mcp-endo-guest.md` are back to `→`.
- **Reaper:** a new behavioral test checks the port-orphan reaper exits 0 both when `ss` fails and when the orphan can't be signalled.
- **`AGENTS.md`:** it now says the allowlist is empty.

**Local checks:** typecheck is clean. The full Vitest suite has one failure, `test/git-remote/capability.test.ts` ("propagates a git failure…"). It is a known host-environment failure that predates this branch and is unrelated to these changes.

**Follow-ups:** none. The gauntlet driver runs panel round 2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3708505 cached reads)
- Output: 22081 tokens
- Cost: $1.9860089999999995
- Wall-clock: 566s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
