Completed `daemon-sqlite-pragma-simple` design and opened draft PR #933 against `llm`.

Changed:
- Specified default row-set and `{ simple: true }` scalar behavior.
- Reused existing prepare/query/column/finalize host bindings; no new Rust callback.
- Added roadmap, dependency graph, milestone, and estimate entries.

Validation: Prettier, git diff check, and both README Mermaid diagrams passed. `yarn docs` was blocked by a non-executable `typedoc` binary.

Follow-up: implement the shim and parity tests in a separate build.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-124-sqlite-pragma-simple.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 627s

<!-- garden-usage-end -->
