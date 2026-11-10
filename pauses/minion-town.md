project: minion-town
maintainer: 'kriskowal'
directive: 'liaison session, 2026-11-10: ''Please pause development on minion.town.'''
scope: 'all minion.town development: builds, designs, fixes, presses, gauntlets, deploys, and jobs posted by the screener or CI watcher'
paused_at: 2026-11-10T17:46:55Z
paused_by_host: endolin-garden-ece02cb4
match: minion\.town
---

Project **minion-town** is PAUSED.

While this record exists on journal2, the garden does NOT post, park,
claim, or promote work for this project. Every host reads it LIVE at the
post/claim/promote chokepoints (scripts/jobs/common.sh project_pause_hit),
so the pause is honored even by a host whose DEPLOYED roles/COMMON.md
predates it — the gap that produced the 2026-09-16/17 fuzz storm.

Authorizing maintainer: kriskowal
Directive: liaison session, 2026-11-10: 'Please pause development on minion.town.'
Scope: all minion.town development: builds, designs, fixes, presses, gauntlets, deploys, and jobs posted by the screener or CI watcher

The human-readable statement of this pause lives in roles/COMMON.md
§ Project scope; keep the two in sync.

To LIFT this pause (the only authorized way to run the work again):
    scripts/jobs/pause-project.sh minion-town off
and update roles/COMMON.md to match.
