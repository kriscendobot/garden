---
role: gardener
tier: mentor
posted_at: 2026-10-28T04:13:11Z
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-28T05:01:21Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Restage the ferry directive for endojs/endo-but-for-bots PR #1349 after the fresh
gauntlet `endojs-endo-but-for-bots-pr1349-gauntlet-20261028-fe74338e` finishes.

Context: the ferry directive `journal/jobs/ferry/endojs-endo-but-for-bots-pr1349.md`
pins head `b122ff91ef`, but the PR head moved to `fe74338e19` (review follow-up
for panel review 5675072198). The panel at fe74338e (review 5675257967) was decided
"pass", but its integrator seat raised two must-fix items that are still open:
(1) the PR body says `ci.yml` gets a `dorny/paths-filter` version comment, but the
diff doesn't touch `ci.yml`; (2) "Depends on: endojs/endo-but-for-bots#1425" (an
open draft) is unreconciled, because #1349 also carries the XS lockdown-shim change
that #1425 builds. The fresh gauntlet was staged to settle these.

Procedure:
1. Read the gauntlet's tada report (`tada_find`). Proceed only if it says
   `gauntlet-status: complete` and its last panel stage passed at the PR's
   CURRENT head (`gh pr view 1349 -R endojs/endo-but-for-bots --json headRefOid`),
   with no open in-scope must-fix, including the two integrator items above. CI
   must be green at that exact head.
2. If so, update the ferry directive in place (on journal2, with a CAS push).
   Set `downstream_head:` to the exact head and refresh the preconditions and
   provenance sections. Keep `identity_switch_authorized: true` exactly as the
   maintainer transcribed it, and do not originate a new authorization. If the
   directive is in `jobs/ferry/doing/` from a blocked ferry run, move it back to
   `jobs/ferry/`. Post a short PR comment saying the ferry is restaged at the new
   head.
3. If not (the gauntlet halted, hit its review budget, or the head moved again),
   do NOT restage. Report what blocks it and message the maintainer through
   message-user.sh.
