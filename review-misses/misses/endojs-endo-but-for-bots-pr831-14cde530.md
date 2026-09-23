---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr831-14cde530
verdict: miss
category: process
pr: 831
cluster: merge-base-pinning
cluster_pattern: A PR reaches review without its merge base pinned to the frozen master-xxxx/llm-xxxx branch per standing instruction, entraining irrelevant commits or stray artifacts; the frozen-base convention did not bind.
review_at: 2026-07-23T21:14:04Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/831#issuecomment-5063492506
identity: endojs/endo-but-for-bots#831:comment:5063492506
missed_by: frozen-base
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

Maintainer: set the merge base to a master-xxxx frozen branch per standing instructions — "These may need to be reinforced." A standing frozen-base convention that did not bind.
