---
gate: blocked
blocked_on: weave-endojs-endo-but-for-bots-pr1575-onto-llm-after-pr1573
priority: normal
posted_by: gardener
posted_at: 2026-11-04T01:34:50Z
---

---
role: conductor
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Conduct endojs/endo-but-for-bots PR #1575

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1575 (draft; head `feature/api-key-provider-adapters`).
Directive: kriskowal's APPROVED review https://github.com/endojs/endo-but-for-bots/pull/1575#pullrequestreview-5761333416 ("respond, retcon, conduct").

Respond and retcon are done, and the parked weave job ahead of this one restacks the PR onto `llm`. Un-draft if needed and merge per roles/conductor/AGENT.md, absorbing the `fixup!` commits with the noninteractive autosquash.

Pinned to endolin because the oros-studio PAT gets a 403 on PR writes to endojs. If the base is still a non-trunk snapshot, stop and report; do not merge onto it.
