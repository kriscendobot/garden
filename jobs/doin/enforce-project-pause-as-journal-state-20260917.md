---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Make a project PAUSE enforceable by machinery, not only by deployed prose. A host
running a stale garden cannot honor a directive it has not deployed, and that gap
just produced a multi-day violation of an explicit maintainer pause.

## What happened (the grounding incident, 2026-09-16/17)

`roles/COMMON.md` § Project scope carries an unambiguous directive:

  "IronHorse work is PAUSED at zero priority (2026-09-09). ... this garden does not
  claim, post, promote, orchestrate, or run IronHorse implementation, review,
  test262, fuzz, optimization, or follow-up work. Leave every existing IronHorse
  plan item parked ... The continuous fuzz timer and service remain disabled."
  (kumavis, 2026-09-09, kriscendobot/garden#91)

Despite that, between 2026-09-16T23:53Z and 2026-09-17T02:23Z the fleet posted and
ran a storm of IronHorse fuzz repair jobs. Roughly SIXTY were quarantined with
`doom_signature=policy-refusal` and delivered sixty separate maintainer-inbox
messages. A gardener (`ironhorse-fuzz-repromote-quarantined`) diagnosed the cause
precisely: the LEADER host `endolin-garden-ece02cb4` was running an OLD deployed
garden (roughly 08-31..09-04) whose fuzz lane kept posting per-finding repair jobs.
Its deployed code PREDATED the 09-09 pause, so the pause did not exist as far as
that host's running code was concerned.

The storm stopped on its own only when the leader finally deployed. Nothing in the
system detected that a paused project was being actively worked for over a week.

Note the secondary harm: the policy refusals were themselves correct and
deterministic (the provider blocked fuzz-repair framing that reads as offensive
security), and the reaper correctly quarantined rather than requeued. The failure
was upstream of all that — the work should never have been posted.

## The design gap

A pause lives as PROSE in a file that reaches a host only via deploy. So:
- A stale host silently violates every directive newer than its deployed sha.
- The violation is invisible: no alert fires, because nothing is watching for
  "work is happening on a project that is paused."
- The blast radius scales with how far behind the host is, and the leader — the
  host running all the singleton producers — is the worst possible host to be stale.

## What to design and build

1. Represent an active pause as JOURNAL STATE, which every host reads live, rather
   than only as deployed prose. A paused-project record should name the project, the
   authorizing maintainer and directive, the date, and the scope of what is paused.
   COMMON.md keeps the human-readable statement; the journal record is what
   machinery consults. Keep the two from drifting — say how.
2. ENFORCE it at the chokepoints, so a stale producer cannot post and no worker can
   claim: the posting path (`post-job.sh`/`post-plan.sh`), the claim path, and the
   promote path (`promote-plan.sh`). Note that `promote-plan.sh` promoting a paused
   item is exactly what `ironhorse-fuzz-repromote-quarantined` did.
3. FAIL SAFE toward paused when the journal record is unreadable, consistent with
   how `foreman_braked` already fails safe toward braked and how the drain-source
   fix fails safe toward operator.
4. ALERT when a paused project shows activity, coalesced through
   `watchdog-notice.sh` — one keyed notice per project, never one per job. Sixty
   messages for one systemic cause is precisely the reporting defect that produced
   that helper.
5. Separately, consider a STALENESS alert on the LEADER specifically: a leader more
   than N commits or N days behind is disproportionately dangerous because it runs
   every singleton producer. The root-repo guard already watches for a stalled
   deploy; judge whether this belongs there or is its own signal.

## Explicitly out of scope

Do NOT lift the IronHorse pause, do NOT un-park any IronHorse plan item, and do NOT
run or re-scope any IronHorse work. 67 IronHorse items are correctly parked in
`plan/` and must stay there — that is what the directive requires. This job is about
the ENFORCEMENT MECHANISM only, and must itself honor the pause it is built to
enforce. Read-only inspection of the parked items to validate your enforcement is
allowed; acting on them is not.

Include regression tests pinning: a paused project's job cannot be posted, claimed,
or promoted; an unreadable pause record fails safe toward paused.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T21:18:10Z
