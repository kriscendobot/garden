---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr877-review-1eec395e
verdict: miss
category: style-convention
pr: 877
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
review_at: 2026-07-29T23:58:11Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/877#pullrequestreview-4813932381
identity: endojs/endo-but-for-bots#877:review:4813932381
missed_by: packager
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

Rust xsnap code reimplements base64 rather than reusing the existing @endo/base64 implementation (via bundling); a panel that knew the @endo utility catalog would flag the missed reuse.
