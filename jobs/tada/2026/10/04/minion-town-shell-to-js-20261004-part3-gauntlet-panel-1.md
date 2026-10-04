Round 1 of the panel on kriscendobot/minion.town PR #154 came back **must-fix**, and I posted the verdict as a review on the PR.

**How the round ran:** I checked out the PR head (`chore/javascript-only-scripts-part-3` at `ec6a460`) in its own worktree. The base branch lives on the fork, so I passed the base commit `2ca6c15` to `panel.sh` directly. It ran single-round with 33 seats and exited 0 with must-fix. Locksmith and wire-watcher each timed out on their first attempt and finished on a retry.

**Tally:** 6 request-changes (stylist, prover, breaker, purist, wire-watcher, pruner), 14 comment-only and 13 approve. The phase-evidence pre-pass reported BLOCKED, which forces must-fix on its own. The integrator judged that a false positive: the diff only updates `.sh`→`.js` paths in the prose of two design docs and claims no phase of either.

**Main must-fix items:**
- **Restore rollback (breaker):** in `npm-registry-backup.js` `runRestore`, the rollback flag is set only after the second rename. If that rename fails, the live state directory is gone and nothing rolls it back.
- **Weak test (prover):** the header-stripping test in `deploy-script-helpers.test.mjs` doesn't check that the header is actually removed, so it passes even if that code is broken.
- **Naming (stylist):** a database handle named `db`, and a dead duplicate `UNIT_B64` key next to `UNIT_BASE64`.
- **Template renderer (`remote-template.js`, raised by six seats):**
  - Unsupported bash expansion forms like `${HOST:-default}` silently become the raw value.
  - A missing variable is left in the output as literal `${VAR}` text.
  - A crafted variable value can inject a literal `$` into the generated program.
- **Missing marker (purist):** `deploy-siwe-thunk.js` lacks the `prefer-endo-primitives-exempt` marker its sibling files carry.
- **PR description (pruner):** too long; drop the inline test counts and the per-script table.

There are also five should-fix items: the `endoCommit` pin regex lost its anchor, `sourceCommit` and `deployRunUrl` reach the remote program unvalidated, `MemoryMax=0` gets the wrong error message, two `→` arrows were changed to `->`, and the reaper test lost its "always exit 0" assertion.

**About the review:** GitHub won't let the bot request changes on its own PR, so I posted it as a COMMENT review (2026-10-04T19:40:49Z). It opens with "Panel round 1 — must-fix", ends with `<!-- garden-panel-verdict: must-fix round=1 -->`, and appends each seat's full review, trimmed to fit GitHub's size limit.

**Follow-ups:**
- The fix stage could also clear the phase-evidence block by stating in the PR body that this PR claims no phase of either design.
- The integrator suggested the phase-evidence pre-pass should require the PR body to name a design before treating it as governing, not just touching its file.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (982330 cached reads)
- Output: 7444 tokens
- Cost: $0.8805860000000001
- Wall-clock: 1921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
