---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadmail.sh
Recognize dead letters addressed to an `issue-<owner>-<repo>-<number>` spine and promote them as explicitly typed issue-follow-up work, preserving the canonical issue URL and prohibiting PR-state assumptions in the scripted framing. The generic deadmail worker treated garden issue #58 as a pull request, hit a definitive GraphQL failure after carrying out live work, and was left to requeue.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-27T23:51:34Z
