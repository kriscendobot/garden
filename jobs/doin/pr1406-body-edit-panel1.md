---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Edit the PR body of endojs/endo-but-for-bots#1406 (panel round-1 must-fix 5)

Host oros-studio's bot PAT gets 403 on PR body edits in endojs, so this is pinned
to endolin. Do ONLY this body edit; do not touch the branch.

On https://github.com/endojs/endo-but-for-bots/pull/1406 edit the body
(`gh pr view 1406 -R endojs/endo-but-for-bots --json body --jq .body`, then
`gh pr edit --body-file`), keeping everything else byte-for-byte, including the
`<!-- garden-job: ... -->` marker:

1. Under `### Documentation Considerations`, delete the sentence
   "The `pre-push-gates` typist fixer rewrote two pre-existing `…` to `...` in that design."
   (that autofix now lives in its own `chore(claude)` commit).
2. Under `### Testing Considerations`, replace "unit tests pass (80)" with
   "unit tests pass (81)", and replace
   "refusal when either is missing, altered, or repeated,"
   with
   "refusal when any of `--tools`, `--setting-sources`, `--permission-mode`, or `--permission-prompts` is missing, altered, or repeated (including a trailing `--tools Bash`),".

If the sentences are already gone/changed, it is a no-op; report done.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T14:46:40Z
