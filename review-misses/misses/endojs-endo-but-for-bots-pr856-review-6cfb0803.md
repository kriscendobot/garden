---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr856-review-6cfb0803
verdict: miss
category: missed-edge-case
pr: 856
cluster: cjs-lexer-edge-cases
cluster_pattern: The lexer misclassifies a valid module form (e.g. a solitary dynamic import in CJS); edge-case coverage the panel did not probe.
review_at: 2026-07-25T05:48:43Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/856#pullrequestreview-4778593042
identity: endojs/endo-but-for-bots#856:review:4778593042
missed_by: corner-prober
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

The Rust CJS lexer misclassifies a module: a solitary dynamic import() is also valid CJS. A corner case the panel's edge-case lens did not probe.
