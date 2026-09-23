---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr824-review-e4950d9b
verdict: miss
category: style-convention
pr: 824
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
review_at: 2026-07-22T09:03:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/824#pullrequestreview-4752746710
identity: endojs/endo-but-for-bots#824:review:4752746710
missed_by: packager
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

platform-neutral-hash design hand-rolls hex; maintainer: "Use endo/hex" (also a redundant filename extension nit). No panel job is recorded for this PR, so the reuse gap reached the maintainer un-reviewed.
