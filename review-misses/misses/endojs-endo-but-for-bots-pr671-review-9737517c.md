---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr671-review-9737517c
verdict: miss
category: style-convention
pr: 671
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
review_at: 2026-07-29T01:33:30Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/671#pullrequestreview-4803235197
identity: endojs/endo-but-for-bots#671:review:4803235197
missed_by: packager
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

A registry test hand-rolls SHA-256 where @endo/sha256 exists; maintainer: "Use @endo/sha256". The panel did not flag reuse of an existing @endo primitive.
