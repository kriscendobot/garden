---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr755-review-a0778b2e
verdict: miss
category: style-convention
pr: 755
cluster: prefer-endo-primitives
cluster_pattern: Freshly-authored code hand-rolls or re-implements a primitive (hex, ascii, bytes, base64, sha256, error assertions) that an existing @endo/* package already provides; no juror seat or gate carries the @endo utility catalog, so the missed reuse reaches the maintainer.
review_at: 2026-07-27T23:31:08Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/755#pullrequestreview-4726236299
identity: endojs/endo-but-for-bots#755:review:4726236299
missed_by: packager
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

CBOR primitives PR hand-rolls bytes/errors: maintainer asks for @endo/bytes and @endo/errors (spell insist as assert), flags int53/floor smells and blank-line style. A full gauntlet ran (pr755-gauntlet) yet none of the prefer-@endo reuses were flagged.
