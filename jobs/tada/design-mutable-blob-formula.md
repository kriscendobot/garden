Completed `design-mutable-blob-formula`.

- Added `designs/mutable-blob-formula.md`, covering the formula trio, shared read semantics during resize, persistence, lifecycle, attenuation, substitutability, recovery, and verification.
- Updated `designs/README.md` roadmap, dependency graph, milestone, and estimate entries.
- Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1296
- Verification: Prettier passed; both Mermaid diagrams parsed successfully. `yarn docs` was blocked by non-executable `typedoc`; CI lint remains pending.
- Open questions require maintainer decisions on operation-scoped reads and retaining `appendable-blob` as a distinct formula.
- Queued a scholar audit for stale library documentation about formula persistence.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-mutable-blob-formula.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 819s

<!-- garden-usage-end -->
