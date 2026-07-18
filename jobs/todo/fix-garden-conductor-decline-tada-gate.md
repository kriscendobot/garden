---
role: fixer
---
# Fix: a conductor that DECLINES to merge still satisfies blocked_on gates

Target: the garden repo itself (`main2`): the conductor completion path and/or the unblock watcher
(`scripts/jobs/unblock.sh`, `scripts/jobs/gardening/`, orchestrate substrate).

Evidence (2026-07-18): `merge-endo-but-for-bots-pr792-http-web-seed` reached `jobs/tada/` while
correctly declining to merge (CI was red on the live head). The gate `blocked_on` that parked
`design-endo-content-plane-git-http` keyed on the merge JOB reaching tada, not on the MERGE
happening, so the designer job promoted and ran against an unmerged #792 (harmless this time — the
designer flagged it — but the same gap would promote a build job onto a base that never landed).

Task: make "completed without achieving the gated outcome" expressible and respected. Options to
weigh (pick the least machinery that closes the gap):
- A conductor that declines marks its tada report `orchestration-failed: true` (the flag the
  orchestrate watcher already honors) so orchestrations halt; extend unblock.sh to honor the same
  flag for plain blocked_on edges (do not promote off a failed predecessor; surface to the
  maintainer instead).
- And/or: document that merge-gated follow-ups should verify the underlying PR state themselves as a
  precondition (several job bodies already do this defensively).
Add a hermetic test covering: declined-conductor tada does NOT promote its blocked dependents.
