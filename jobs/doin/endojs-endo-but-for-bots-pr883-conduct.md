---
role: conductor
---

# Conduct endojs/endo-but-for-bots PR #883

Maintainer directive (kriskowal, 2026-07-29, via the liaison on
`endolin-garden-ece02cb4`): conduct
https://github.com/endojs/endo-but-for-bots/pull/883.

Wear [conductor](../../roles/conductor/AGENT.md).

## State as observed at 2026-07-29 (verify live before acting)

- Title: `test(agentry): pin rerere off in the eval repository fixture`
- Head `fix-eval-fixture-rerere-hermeticity` into base `llm`
- Author `kriscendobot` (bot-authored), created 2026-07-28T17:44Z
- `mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`
- **All 22 checks SUCCESS** (lint, build, test matrix on 22.x/24.x across
  ubuntu/macos, test262, test-xs, test-hermes, cover, zizmor, browser-tests,
  familiar-bundle, sandbox-drivers, check-action-pins, viable-release,
  test-ocapn-python, build-wasm)
- **`reviewDecision` is empty: the PR carries ZERO reviews.**

That last point is the one to think about rather than skip. The maintainer's
instruction was framed as conducting an approved PR, but no approval exists on
this PR today. Re-check live. If conducting still requires a review or a panel
under the governance rules that apply to this repo and base branch, do **not**
improvise around them: run or request what is required, or report the gap and
stop. Do not merge merely because CI is green.

Refetch the live state before you act; the snapshot above is minutes old at best
and CI or reviews may have moved.

## Constraints

- Bot identity only. This is not a ferry, and no `identity_switch_authorized`
  flag is present, so nothing here runs under the maintainer's identity.
- Do not force-push, do not rewrite the head branch, and do not close or reopen
  the PR.
- If the merge is blocked (governance, a base that moved, a new red check),
  report precisely what blocks it rather than working around it.

## Done when

The PR is merged, or a `jobs/tada/` report names exactly what blocked it and what
the next action is.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-29T01:28:12Z
