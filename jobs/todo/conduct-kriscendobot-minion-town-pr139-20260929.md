---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Merge kriscendobot/minion.town#139 (deploy fix: endo daemon probes auto-start a stray daemon)

Repo: kriscendobot/minion.town. PR: https://github.com/kriscendobot/minion.town/pull/139
(draft, head `fix/endo-deploy-probe-autostart`, frozen base `main-47d0c0b`).

This is a production-incident fix that the parent job `kriscendobot-minion-town-endo-pin-post1015-20260929` needs
in order to carry out kriskowal's instruction to advance the minion.town Endo pin, given in the approval of
https://github.com/endojs/endo-but-for-bots/pull/1015 (https://github.com/endojs/endo-but-for-bots/pull/1015#pullrequestreview-5347957884).
The CD deploy of https://github.com/kriscendobot/minion.town/pull/138 crash-looped the endo daemon: the
preflight's `endo list` probe auto-started a stray daemon on 127.0.0.1:8920. Production was restored by hand, and
this PR fixes the deploy script.

Un-draft it, unfreeze to `main` per the conductor brief, wait for green CI, and merge it with the standard method.
CI was green at head `6d77266`. Report the merge SHA. The parent job watches the resulting CD deploy.
