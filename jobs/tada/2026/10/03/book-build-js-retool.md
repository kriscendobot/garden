Opened draft PR https://github.com/kriscendobot/garden-book/pull/6 against pinned base `main-cff5b57`.

- Replaced the Python builder/publisher with portable JavaScript modules using `markdown-it` and `markdown-it-anchor`.
- Isolated Node filesystem and subprocess access behind readable-tree and JSON-RPC adapters.
- Added unit tests and updated build/publish documentation.
- Verified `npm test`, all pre-push gates, and local verification pass.
- Compared current Python and JavaScript builds: `index.html` and `styles.css` are byte-identical. The JS build additionally copies `styles.css` automatically.
- Verified publisher request construction with tests; no live edition was published because publishing remains a separate explicit action.
- Affected package: root build tooling.
- Follow-up: gauntlet review, merge, then separately publish if requested.
- Library lookup: added readable-tree terminology shortcuts and notified the scholar.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-build-js-retool.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1096s

<!-- garden-usage-end -->
