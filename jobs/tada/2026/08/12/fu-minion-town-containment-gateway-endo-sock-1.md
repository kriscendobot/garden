I have everything I need to resolve this job correctly. Here is my report.

---

**Job `fu-minion-town-containment-gateway-endo-sock-1` — disposition: triaged and the safe, non-colliding part executed.**

**What this job actually is.** Its body as dispatched was the empty placeholder "No autonomous job — see the SCHEDULE and MAINTAINER blocks below" with no such blocks. Tracing it: `garden-follow-up` on the leader (garden2) converted a containment-job follow-up into a matched pair — an immediate `JOB fu-…-1` (commit `cc61886b`) **and** a daily `SCHEDULE fu-…-1` (commit `8154064846`). The real intent landed only in the SCHEDULE body; the immediate JOB companion's body was left empty (a handler quirk — body attached to the SCHEDULE block, not the JOB block), which is why I was handed a content-free job.

The intended task (from the intact schedule) is a **read-only containment drift-check for kriscendobot/minion.town**: confirm dckc's two de-registered `@agent` gateway vhost records are still absent and that the `zz-containment-20260812.conf` drop-in disarming the weblet powers plane is still in place; re-run the de-registration (already authorized by the parent containment) only if a CD redeploy restored them.

**What I did.** I ran the one part that is safe, credential-free, and cannot collide with the still-in-progress containment job (`minion-town-containment-gateway-endo-sock`, gardener 2 on garden2): the external unauthenticated reproduction — the "test that matters." From this host, no credential:
- `https://6hlvj…ocap.site/.well-known/ocapn-bootstrap` → **404 "no such weblet"** (fail-closed)
- `…/.well-known/endo-captp` WS upgrade → **426 upgrade required, refused** — no CapTP host obtainable
- `https://minion.town/` → **302** (up)

Containment is **holding** ~20 minutes after it was applied; the powers plane is still failing closed and non-weblet surfaces are up. This matches gardener 2's verified AFTER state exactly.

**What I deliberately did NOT do, and why.** I did not run the on-host portions of the drift check (enumerate/confirm the two vhost records absent, stat the drop-in file). They depend on the parent containment job's **report, which does not yet exist** (that job is still in `jobs/doin/`), they would collide with gardener 2's active incident response on the same production host, and the maintainer's standing directive for this incident is no unauthorized motion. Those portions are correctly owned by the **daily schedule**, which will fire against the finished containment report on future ticks — exactly when drift (a post-redeploy record restoration) can actually occur. I made no production changes, altered no schedule, and did not page the maintainer mid-incident.

**Changed:** nothing in the garden repo or in production. No commit/push needed (this was a triage + read-only verification job).

**Follow-ups:**
- Minor automation defect worth a garden-dev pass: `handlers/follow-up-claude.sh` emitted an immediate `JOB fu-…-1` companion with an empty body alongside the daily `SCHEDULE`, yielding a placeholder "No autonomous job" job. Either the immediate companion should carry the same body as the schedule, or the handler should not emit a bodyless immediate JOB when the intent is purely recurring.
- The daily schedule `schedules/fu-minion-town-containment-gateway-endo-sock-1.md` is well-formed and left in place; its first meaningful tick should run once the containment report is written so it can follow "the de-registration exactly as recorded in that job's report."
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1038635 cached reads)
- Output: 15167 tokens
- Cost: $1.4095375000000003
- Wall-clock: 242s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
