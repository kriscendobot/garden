---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr719-review-9fcf7da1
verdict: miss
category: process
pr: 719
cluster: merge-base-pinning
cluster_pattern: A PR reaches review without its merge base pinned to the frozen master-xxxx/llm-xxxx branch per standing instruction, entraining irrelevant commits or stray artifacts; the frozen-base convention did not bind.
review_at: 2026-07-22T05:28:23Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/719#pullrequestreview-4751242280
identity: endojs/endo-but-for-bots#719:review:4751242280
missed_by: frozen-base
severity: minor
consolidated_pass: review-retrospective-consolidated-20260804
---

A stray cbor package.json artifact appears because the PR predates the master-xxx pinned-base convention; maintainer asks to refresh. (Same review also asks to rename url-shim* test modules to url* and to make lockdown option names terse/consistent — naming nits secondary to the base-hygiene miss.)
