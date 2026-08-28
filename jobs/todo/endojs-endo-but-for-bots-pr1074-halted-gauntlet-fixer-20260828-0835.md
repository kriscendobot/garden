---
role: fixer
tier: mentor
fallback-tier: minion
handler-timeout: 10800
token-budget: 250000
dispatch: automatic
---

# Recover halted Ironhorse hardened262 gauntlet on endojs/endo-but-for-bots#1074

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1074. Work on the PR head branch using an isolated checkout keyed by this job base.

The staged gauntlet `endojs-endo-but-for-bots-pr1074-gauntlet-20260828` halted after its fix-4 child was reaped and parked as doomed for a deadline overrun. There is no live worker on it. Read the latest formal panel verdict (round 4, posted at head `ff77af168c749864f177688f1a5679526bdb92bc`) and address its remaining must-fix items:

- Make the detached-buffer test compatible with the supported Node 20.17 floor: do not unconditionally call `ArrayBuffer.prototype.transfer`; use a correct runtime guard or an equivalent portable detachment path. The `features` field does not cause the local hardened262 runner to skip.
- Post the required top-level PR completion summary covering the responding SHAs and verification. This repository has standing authorization for that comment.

Apply the fixes once, push safely to the PR head, run the relevant hardened262 test on the Node floor if available plus the ordinary targeted checks, and watch CI to terminal with a bounded wait. Reply to any actionable inline thread if applicable and post the required top-level summary. Do not merge or un-draft; a later press/gauntlet continuation owns the next panel round.
