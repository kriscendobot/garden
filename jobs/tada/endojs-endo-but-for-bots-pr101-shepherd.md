Weaver job posted successfully. My worktree is clean (no garden dev changes needed — this was a diagnosis-and-escalate shepherd run). No PR comment posted, as the job body carries no external-repo comment authorization.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #101 ("feat(chat): voice input via Web Speech API").

**Diagnosis (re-fetched live CI, head `2f017c04`):** four red checks — `cover (20.x)`, `cover (24.x)`, `lint`, `zizmor`. None are in the PR's own diff (it touches only `packages/chat/*` and `designs/*`):
- **lint** — 1 error: `makeClient not found in '../src/client/index.js'` in `packages/ocapn/test/netlayer-tcp-syrup.test.js`. Current `llm` base already renamed that import to `makeOcapn`; the stale PR head still carries `makeClient`.
- **cover (20.x/24.x)** — same file, same stale-import root cause (`@endo/ocapn` exit 1).
- **zizmor** — errors in `.github/workflows/familiar-release.yml` and `ci.yml`, workflow files this PR never touches, already fixed on `llm`.

**Root cause:** the PR is **966 commits behind** its `llm` base and `mergeable_state == "dirty"` (CONFLICTING). Every red check is a stale-base artifact; the `llm` base's own latest CI is green. Per `roles/shepherd/AGENT.md` § *Conflicting PRs block CI dispatch*, this is out of shepherd scope — I did not push nudge commits.

**Action:** escalated `next: weaver`. Posted job `endojs-endo-but-for-bots-pr101-weaver` (identity `endojs/endo-but-for-bots#101:shepherd-escalation:weaver`) with the full failure inventory and the rebase-onto-current-`llm` task.

**Changes:** none to garden main2 or the project repo. No PR comment (no external-repo comment authorization in the job body).

**Follow-up:** the weaver job will rebase PR #101 onto current `llm`, resolve conflicts, and re-run CI; a shepherd should re-chain only if new in-scope failures surface post-rebase.
