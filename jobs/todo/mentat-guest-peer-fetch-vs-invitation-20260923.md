---
tier: mentat
dispatch: manual
---
role: designer

# Evaluate: does the guest-to-guest invitation workflow overtake guest peer-fetch?

Decide, don't just survey. Maintainer directive (kriskowal, 2026-09-23 muster): *evaluate whether the
guest-to-guest invitation workflow overtakes this older work, and decide whether to take its
requirements on or retire the old job.*

## The old work
Parked job `jobs/plan/minion-town-guest-peer-fetch-verify-await-auth.md` (gate
`awaiting-maintainer`). It would verify a PEER doing `enlivenSturdyRef` on a revealed minion.town guest
by FORMULA ID. It is blocked on a daemon-exposure question asked on
https://github.com/kriscendobot/garden/issues/58#issuecomment-5447765615 (2026-08-28, never
answered): expose the guest-substrate `endo-daemon.service` over a public OCapN-CBOR-Noise route, OR
run the app on the already-public pet daemon? The reveal half of garden#58's chain is done and verified
(see the job body).

## The newer work that may overtake it
- The capability-first invitation onboarding design for minion.town (design PR kriscendobot/minion.town#56).
- `EndoGuest.invite` / `EndoGuest.accept` merged upstream in endojs/endo-but-for-bots#1310
  (2026-09-21), and the minion.town endo pin was bumped to 89481580 in kriscendobot/minion.town#104
  (merged 2026-09-22; a daemon crash-loop followed and was fixed. See the journal tada for
  `minion-town-endo-daemon-deploy-fail-89481580`).
- Draft kriscendobot/minion.town#81, "Build: web bearer guest invite and accept workflow", plus
  the parked fallback-fix job whose inbox message
  `msg-minion-town-guest-web-invite-accept-fallback-fix-post104-0cc7bb5e48e6` said it was blocked on
  the stale pin that #104 has since refreshed.

## Deliver
1. **Verdict:** does invite/accept (guest-to-guest introduction by invitation) cover what formula-id
   peer fetch was for? Name the user-facing goal of garden#58's chain, then say whether invitation
   achieves it, partially achieves it, or leaves a gap that only a peer fetch covers. Also say
   whether the security question (a public route to the guest-substrate daemon) becomes MOOT under
   invitation, which is the capability-first posture.
2. **Act on it:**
   - **Retire:** `scripts/jobs/withdraw-plan.sh --by designer minion-town-guest-peer-fetch-verify-await-auth "<reason>"`,
     and post a short, courteous closing note on garden#58 recording the supersession, with fully
     qualified cross-repo references (e.g. `kriscendobot/minion.town#81`, not bare `#81`).
   - **Absorb:** fold the still-needed requirements into the invitation work, either as a design
     amendment on minion.town (a PR, per that repo's conventions) or as acceptance criteria added to the
     relevant build or fix job, then retire the old job the same way.
   - **Keep:** only if a genuine requirement remains that invitation cannot meet. Then restate the ONE
     remaining maintainer question crisply in the job and on garden#58, and leave it parked.
3. While you're there, check whether the parked guest-web invite/accept fallback-fix job is now
   unblocked by #104 and say so in your report (do not promote it; that is the maintainer's call in the
   muster).

Read-only on production; no deploys, no infrastructure changes. Complete the job via the normal
completion path when done.
