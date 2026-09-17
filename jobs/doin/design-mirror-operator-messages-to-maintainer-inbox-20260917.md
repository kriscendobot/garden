---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design a path that mirrors OPERATOR-directed messages into the MAINTAINER INBOX,
so a lightly-attended host can be operated remotely and the local operator and the
garden maintainers can RACE to address an issue rather than one waiting on the other.

MAINTAINER DIRECTIVE (kriskowal, 2026-09-17): "oros-studio is only lightly attended
and I expect that we will need to operate it remotely. Let's adjust so messages to
the operator also get sent to the maintainer inbox, so the local operator and
garden maintainers can race to address issues."

## The motivating incident — read this first, it defines the gap precisely

On 2026-09-17 oros-studio-garden-ce242c49 sat DRAINED for ~13.5 hours (06:16:38Z
onward) and fell 11 commits behind while the other two hosts stayed current. Its
`fleet/health` record said `operator-drained`, but NO `drain on` op had been sent
over the bus (last one was 2026-09-14, lifted 09-15). So the liaison could see THAT
the host was drained and could not see WHY.

The reason exists — `drain-fleet.sh` writes `set_by`, `reason`, and (since
`845b1895e2`) `source:` into the draining marker. But that marker is a HOST-LOCAL
file. From another host it is unreadable. And the two obvious ways to look are both
closed:
- The sysop vocabulary has no op that READS host state; it only mutates.
- A host-pinned job (`requires: host=...`) cannot help, because a DRAINED host
  claims nothing — the very condition you want to diagnose prevents diagnosis.

So "why is this host drained" was unanswerable remotely, and the liaison had to ask
the maintainer whether the drain was deliberate. That question should not need
asking: the host knows the answer and simply never published it.

Note the related sharpening from `845b1895e2`: a drain whose `source:` is absent or
unknown FAILS SAFE toward `operator`, which is correct for the operator guarantee
but means a pre-fix or unsourced marker reads as an operator drain indefinitely and
the roll skips that host forever. A stuck host that no longer self-heals is the
residual of that fix, and remote visibility is what would catch it.

## What to design

1. DEFINE "operator message". The scope decision is the substance of this design.
   Candidates, all currently host-local or journal-invisible:
   - drain set/lifted, WITH its reason, `set_by`, and `source` (operator vs
     roll-induced) — the motivating case, and the highest value.
   - deploy stalled / upgrade-ready accumulating unacted.
   - unit failures and `first_bad_unit` detail beyond the bare count.
   - root-repo-guard repairs and the invariants it restored.
   - worker starvation (a host-pinned job unclaimed past its dwell window).
   - a budget/claim-gate halt (now that fail-closed pools can refuse every claim).
   Recommend a principled boundary rather than an ad-hoc list: what makes a fact
   operator-facing, and what keeps it host-local?
2. MIRROR, DO NOT FLOOD. The garden has already learned this the hard way: one
   environmental condition (the provider's weekly quota refusing every `claude -p`)
   produced 94 unread maintainer messages in four days and buried a blocked build,
   two halted orchestrations, and an access request underneath them — the incident
   that produced `watchdog-notice.sh`. REUSE that coalescing mechanism (one keyed
   message per open condition, amended in place with `notice_count`/`first_seen`/
   `last_seen`, closed with `--recovered`) rather than inventing a second notice
   path. A mirrored operator message must be one entry per condition, not per tick.
3. RACE SEMANTICS. Both the local operator and a maintainer may now act on the same
   condition. Specify what happens when they do: remediations must be idempotent,
   the record should show who acted and when, and a condition resolved by EITHER
   party must close the notice for BOTH. Say explicitly how a maintainer learns the
   local operator already handled it, so the second responder stands down instead
   of duplicating or fighting the first.
4. PUBLISH THE DRAIN REASON as journal state, not only as a host-local marker. This
   is the concrete fix for the motivating incident and likely the first increment.
   `fleet/health` already carries `roll_status`; carrying the drain's reason and
   source alongside it would have answered the question with no new mechanism. Weigh
   that against any information-exposure concern — note `journal2` is PUBLIC, and
   the capability cache is deliberately host-local for exactly that reason
   (`common.sh`: publishing that a named host holds an AWS credential would be
   useful targeting metadata). A drain reason is free prose written by whoever set
   it, so say how it stays safe to publish.

## Relationship to work already in flight

`design-sysop-attested-exec-op-20260916` proposes an attested `exec` op, which
would let an operator READ a remote host's marker on demand. That is complementary
but strictly weaker for this purpose: pull-on-demand requires someone to already
suspect a problem, whereas mirroring PUSHES the fact to the inbox unprompted. Read
that design if it has landed and say how the two compose — do not duplicate it.

## Deliverable

A design under `designs/`. Include an `## Open questions` section if real decisions
remain for the maintainer — per the repo carve-out, a design carrying open
questions opens as a review PR rather than landing bare. Do NOT implement.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T20:01:07Z
