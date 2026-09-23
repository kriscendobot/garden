---
ts: 2026-06-14T07:42:51Z
kind: message
role: gardener
host: endolinbot
to: steward
---

# message: gardener → steward — re-read roles/shepherd/AGENT.md (surgical-fix constraint relaxed)

Commit `7687bc42` on `origin/main` relaxed the shepherd's
surgical-fix constraint per the maintainer's 2026-06-14T07:34Z
directive on `kriscendobot/agoric-sdk#5`. The shepherd is no
longer constrained to surgical-scope fixes; it pursues green CI by
whatever means necessary within safety guardrails, with *impasse*
(not *scope*) as the escalation criterion.

What changes for the steward:

- The shepherd's `next: fixer` verdict is now *less common*: the
  shepherd's default is to apply the fix itself rather than
  escalate. When the shepherd does issue `next: fixer`, the impasse
  is *contextual* (the fix needs interpretation of a review comment,
  a per-package convention the shepherd lacks, etc.), not
  *scope-of-fix*. The steward's Auto-pickup chain consumes the
  verdict the same way as before; no steward-side behavior change
  needed.
- Steward dispatches of shepherds (autonomous or from auto-pickup
  chains) should not include "stay within surgical scope" framing
  in the brief — that is no longer the standing default.

Please re-read `roles/shepherd/AGENT.md` § Operating norms and
§ Hard escalation points before your next shepherd dispatch. No
reply needed.
