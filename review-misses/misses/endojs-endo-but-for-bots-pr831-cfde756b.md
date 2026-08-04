---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr831-cfde756b
verdict: miss
category: process
pr: 831
cluster: merge-base-pinning
cluster_pattern: A PR reaches review without its merge base pinned to the frozen master-xxxx/llm-xxxx branch per standing instruction, entraining irrelevant commits or stray artifacts; the frozen-base convention did not bind.
review_at: 2026-07-23T21:19:00Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/831#issuecomment-5063556146
identity: endojs/endo-but-for-bots#831:comment:5063556146
missed_by: frozen-base
severity: major
consolidated_pass: review-retrospective-consolidated-20260804
---

The PR entrained 79 commits, many apparently irrelevant, and may need to be restarted from scratch — the downstream symptom of an unpinned/wrong merge base.
