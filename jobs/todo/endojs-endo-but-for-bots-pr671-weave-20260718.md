# Weave endojs/endo-but-for-bots PR #671 onto current `llm` (role: weaver)

PR #671 (`endo-registry-capability`, head `1eabe975cb`) is `mergeable_state: dirty`
against base `llm`, so GitHub dispatches no CI. Rebase the head branch onto current
`origin/llm` and force-push with `--force-with-lease`.

Context: this executes the first half of kriskowal's maintainer directive
"Shepherd." on PR #671 (issue comment id 4977246906, 2026-07-15T05:40Z — cited as
plain text deliberately; do not turn it into a URL identity). That directive was
silently dropped by the comment-watcher because the deterministic base
`endojs-endo-but-for-bots-pr671-shepherd` already sat in jobs/tada/ from 2026-07-10.
A chained shepherd job (`endojs-endo-but-for-bots-pr671-shepherd-20260718`) is
parked blocked on this weave and will drive CI to green once the conflict clears.

Known conflict shape (from the 2026-07-10 weave of this same PR): the `makers`
formula table in `packages/daemon/src/daemon.js` — keep base `llm`'s newer maker
signatures and retain the PR's added `registry` maker. Keep the tree prettier-clean
(`prettier --check` on touched daemon/registry sources) so the earlier lint fix is
preserved. The PR's review changes were already addressed at head `1eabe975cb`;
preserve those commits verbatim — this is a weave, not a rework.
