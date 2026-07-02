# weaver (rebase stale base) on endojs/endo-but-for-bots PR #101

Escalated from the shepherd auto-job `endojs-endo-but-for-bots-pr101-shepherd`.

PR: https://github.com/endojs/endo-but-for-bots/pull/101
Head: feat/chat-voice-input (endojs/endo-but-for-bots, bot-pushable)
Base: llm

## Why weaver, not shepherd

CI is red on four checks — `cover (20.x)`, `cover (24.x)`, `lint`, `zizmor` —
but NONE are in this PR's own diff (PR touches only `packages/chat/*` and
`designs/*`):

- **lint** — 1 error: `makeClient not found in '../src/client/index.js'
  import/named` in `packages/ocapn/test/netlayer-tcp-syrup.test.js`. On the
  current `llm` tip that import is already `makeOcapn` (the export's real name);
  the PR head still carries the pre-rename `makeClient`.
- **cover (20.x/24.x)** — same file: `test/netlayer-tcp-syrup.test.js exited
  with a non-zero exit code: 1` in `@endo/ocapn`. Same stale-import root cause.
- **zizmor** — errors in `.github/workflows/familiar-release.yml` and `ci.yml`
  (overly-broad perms, template-expansion injection, cache-poisoning). Workflow
  files this PR never touches; fixed on current `llm`.

The PR is **966 commits behind** its `llm` base and `mergeable_state == "dirty"`
(`mergeable: CONFLICTING`), so `pull_request` workflows are not dispatching on
the synthetic merge ref and every red check is a stale-base artifact. The `llm`
base branch's own latest CI is **green**. Rebasing/merging the PR onto current
`llm` clears all four failures; it is not a shepherd task (per
roles/shepherd/AGENT.md § Conflicting PRs block CI dispatch).

## Task

Rebase/update PR #101 onto current `llm`, resolving conflicts (see
skills/conflict-resolution and skills/rebase-before-followup). The PR's own
substance is the chat voice-input feature (its own tests pass). After the
update, verify CI converges to green; if new in-scope failures surface, chain a
shepherd.

next: weaver

---
claim:
  host: endolinbot2
  gardener: 47
  claimed_at: 2026-07-02T00:57:16Z
