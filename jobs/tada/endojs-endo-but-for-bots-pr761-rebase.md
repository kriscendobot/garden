Rebase complete. Here is the completion report:

## Completion report: endojs-endo-but-for-bots-pr761-rebase

**What was done:**

PR #761 ("fix(patterns): preserve literal inference in compound matchers") rebased onto current upstream `endojs/endo` master and prepared for ferry.

**Rebase details:**
- Old frozen base: `master-3f601bc` (upstream snapshot from PR open, 44 commits behind)
- New frozen base: `master-eda7b57` (upstream `endojs/endo` master at `eda7b576e`)
- Strategy: `git rebase --onto upstream/master origin/master-3f601bc` -- the branch carried fork-only commits between the common ancestor and old frozen base; plain `git rebase upstream/master` replayed all those fork commits; `--onto` correctly applied only the single PR commit
- No conflicts; the diff against the new base is byte-identical to the original (3 files, 105 insertions)

**PR updates:**
- Both frozen-base branch (`master-eda7b57`) and head (`128c0f11`) pushed to `endojs/endo-but-for-bots`
- PR base updated to `master-eda7b57` via `gh pr edit --base`
- Title cleaned: removed fork-specific `(reconstruct #720 on master)` suffix
- Description rewritten for upstream: Provenance section removed; upstream-facing change description leads; compact provenance note appended

**Verification:**
- `@endo/patterns` runtime tests: 610 passed
- `yarn build:types`: clean
- Only failure in full suite: `@endo/daemon` socket ENOENT (environment constraint, pre-existing, no daemon code touched by this PR)

**Completion comment:** https://github.com/endojs/endo-but-for-bots/pull/761#issuecomment-5111935513

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr761-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (3387694 cached reads)
- Output: 15236 tokens
- Cost: $1.7056422000000007
- Wall-clock: 505s
- Model(s): claude-sonnet-4-6 ×1

<!-- garden-usage-end -->
