Created `designs/daemon-retention-labels.md` and updated the roadmap. The design preserves stable path-derived keys, adds structured retention reasons and lifecycle states, host-only browse/CAS-prune APIs and CLI verbs, mint-time key validation, and defers a general durable Set primitive.

Opened draft PR endojs/endo-but-for-bots#1277 against `llm` at commit `cc214b211`. The PR contains only the design and roadmap changes.

Validation: Prettier passed; `git diff --check` was clean; both modified README Mermaid diagrams parsed successfully. Runtime tests were not run for this design-only change. GitHub checks were pending at final observation.

Library lookup writebacks added retention terminology shortcuts and notified the scholar for audit.

Follow-up: design review, then implementation after dependent PR #1125 settles.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-daemon-retention-labels.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 682s

<!-- garden-usage-end -->
