---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Weave endojs/endo-but-for-bots PR #1116, then re-conduct

PR: https://github.com/endojs/endo-but-for-bots/pull/1116 (design: guest-native invitation and acceptance)

kriskowal APPROVED head e70a960422 (2026-10-01T23:24:54Z). The conductor
(job endojs-endo-but-for-bots-pr1116-conduct) marked it ready for review, but
`ci-wait-merge.sh` refused: safe-rebase hit a non-deterministic conflict in
`designs/README.md` replaying f7c1dfdae2 onto live llm afc72caff91 → needs weave.

Rebase the head onto current live `llm`, resolving the `designs/README.md`
(roadmap index) conflict by keeping both llm's entries and this PR's entry;
keep the net design content otherwise unchanged. Force-push with lease. Once
CI is green on the woven head, post a fresh conductor job to merge (the
maintainer approval remains effective unless dismissed).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T00:24:18Z
