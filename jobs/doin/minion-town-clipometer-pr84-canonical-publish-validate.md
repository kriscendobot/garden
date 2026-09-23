---
role: fixer
priority: high
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# CLIPOMETER: canonical real-guest publish and final live validation

Repo (PRIVATE): `kriscendobot/minion.town`, DRAFT PR https://github.com/kriscendobot/minion.town/pull/84, branch `clip-clipometer-esbuild`, validated head `723631d2c34730e7a1934d14dcf46405570bd4b2`.

This is the credential-bound remainder of `minion-town-clipometer-pr84-rebase-revalidate`. The predecessor rebased the PR onto current `main`, resolved CI-workflow conflicts, kept the vendored reader, and pushed. It also used the disposable `minion-mcp-test-cc` identity strictly as a diagnostic after the 2 MB `/mcp` limit landed: publish succeeded, HTTP/bootstrap/counter/two-window `followNameChanges` all passed. The first run exposed an inline engine probe blocked by `script-src 'self'`; head `723631d` moves it to same-origin `engine-floor.js`, adds a regression test, and revalidates with zero browser console/page errors. CI is green and the PR remains draft.

The required canonical check is still outstanding because the predecessor's Codex handler exposes no `mcp__minion-town__*` tools, `claude mcp get minion-town` has no configured server, and credentials must never cross the journal. Use the REAL maintainer guest identity used by the earlier halted child (the guest holding `odometer-visit-count` / `rt58-designated-power`), never the disposable client-credentials guest. Publish the exact current PR head with a dedicated counter-only directory, then verify in an actual browser:

1. HTTP 200 + title/status prove bootstrap reaches `live` with zero console/page errors.
2. The first window increments the durable counter.
3. A second window increments it again and the first window updates without reload, proving `followNameChanges`.

Leave the PR DRAFT. If the canonical run passes, report that parked child `minion-town-clipometer-primer-esbuild-update` should be promoted next; the issue-report child follows only after the primer. Do not promote either.

Cleanup owned by this successor: unpublish the predecessor's two disposable diagnostic sites `zpzugyjldktj7dxwfiiguw2hqxfsv6ygwk4rb62juyhrggqjeezq` and `j3u43sdyjajwxpjf46k4pjoq3afmqthf44b3pvlicpywtx5hmlcq`, and remove test-guest pet name `clipometer-revalidate-count-20260923`, after preserving the cited evidence. Do not unpublish the canonical real-guest result.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T21:09:49Z
