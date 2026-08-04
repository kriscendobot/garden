---
slug: merge-base-pinning
category: process
status: improvement-dispatched
count: 4
members:
  - endojs-endo-but-for-bots-pr719-review-9fcf7da1
  - endojs-endo-but-for-bots-pr831-14cde530
  - endojs-endo-but-for-bots-pr831-cfde756b
  - endojs-endo-but-for-bots-pr836-review-ee46b083
prs: [719, 831, 836]
improvement_job: review-improve-merge-base-pinning
---





A PR reaches review without its merge base pinned to the frozen master-xxxx/llm-xxxx branch per standing instruction, entraining irrelevant commits or stray artifacts; the frozen-base convention did not bind.

**Threshold rationale:** # Dispatch rationale — cluster `merge-base-pinning`

**Floor met:** count=4, prs={719, 831, 836} — K≥3 misses across ≥3 distinct PRs.
Severity-bypass also applies to #831: the maintainer cited a standing instruction
("set the merge base to a master-xxxx branch per standing instructions") and said it
"may need to be reinforced" — a standing rule that did not bind.

**Dispatched, not landed inline:** unlike the two seat-tier clusters closed in the
same consolidated pass, this is a PROCESS fix spanning the builder AND weaver flows,
the `frozen-base-branch` / `rebase-before-followup` / `rebase-hygiene-audit` skills,
and a deterministic branch-hygiene check — larger than a single seat edit. Posted
`review-improve-merge-base-pinning` (identity `review-cluster:merge-base-pinning`,
role builder, deferred) with the two-part contract and the re-litigation test.
