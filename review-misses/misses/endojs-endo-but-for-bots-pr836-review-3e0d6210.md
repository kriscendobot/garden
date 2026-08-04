---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr836-review-3e0d6210
verdict: miss
category: style-convention
pr: 836
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
review_at: 2026-07-26T15:27:54Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/836#pullrequestreview-4782049359
identity: endojs/endo-but-for-bots#836:review:4782049359
missed_by: packager
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

sha256 XS test hand-rolls hex/ascii; maintainer: "Use @endo/hex", "Use @endo/ascii", and capture vectors in a shared cross-testing fixture. Reuse of existing @endo primitives not flagged.
