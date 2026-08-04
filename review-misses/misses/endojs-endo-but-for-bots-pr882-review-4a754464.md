---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr882-review-4a754464
verdict: miss
category: style-convention
pr: 882
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
review_at: 2026-07-28T18:06:45Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/882#pullrequestreview-4800433644
identity: endojs/endo-but-for-bots#882:review:4800433644
missed_by: packager
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

bus-worker XS bundling hand-rolls bytes; maintainer: "Use endo/bytes" and flags an excluded-packages list as a smell. A panel ran (pr882-panel) yet the @endo/bytes reuse was missed.
