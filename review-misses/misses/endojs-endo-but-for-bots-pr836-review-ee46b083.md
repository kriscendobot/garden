---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr836-review-ee46b083
verdict: miss
category: process
pr: 836
cluster: merge-base-pinning
cluster_pattern: A PR reaches review without its merge base pinned to the frozen master-xxxx/llm-xxxx branch per standing instruction, entraining irrelevant commits or stray artifacts; the frozen-base convention did not bind.
review_at: 2026-07-29T01:54:10Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/836#pullrequestreview-4782068426
identity: endojs/endo-but-for-bots#836:review:4782068426
missed_by: frozen-base
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

Maintainer: pin the llm branch base to llm-xxxx by hash, rebasing on current llm, then run the gauntlet. The frozen-base pin was not applied before review.
