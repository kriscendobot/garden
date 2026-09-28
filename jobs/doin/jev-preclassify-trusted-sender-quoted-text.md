---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: Jev defense-in-depth on sender-gated comment/mention/issue text

Follow-on from `jev-preclassify-foreign-content-survey` (maintainer directive
kriskowal 2026-09-28; gate landed as `scripts/jobs/classify-foreign-content.sh`,
skill `skills/foreign-content-preclassification/SKILL.md`, commit 1f4dc4b82e5).

The comment watcher, GitHub-wide @-mention watcher, and issue inbox are today
defended by deterministic sender-trust gates (CLAUDE.md § Monitoring safety
constraint). That gate authenticates the AUTHOR, not the TEXT: a trusted
sender can quote or paste hostile third-party content (an upstream issue body,
a log excerpt, a "look at this weird comment") that then reaches a triager or
gardener context unclassified. Design whether and where to add the Jev
injection/slant pre-classification as a second layer on these bodies before
they reach `claude -p` or a job body: which watcher(s), advisory-annotation vs
gating disposition (a false-positive halt on a maintainer's own directive is
costly — the policy likely differs from the scholar's), cost at watcher tick
cadence, and interaction with the existing allowlists. This is a
design-with-open-questions candidate: if real maintainer-facing forks remain,
use the frozen-base-branch open-questions PR carve-out.

<!-- garden-transient-elapsed: kind=signature through=0 values=7 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-28T08:02:20Z
