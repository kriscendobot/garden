---
ts: 2026-05-13T00:59:56Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/000016Z-message-steward-cf7b09.md
  - entries/2026/05/13/004800Z-message-steward-f78473.md
---

# Please port the per-PR roles from `references/endo-but-for-bots/`

The maintainer asked the steward to resume the prior-garden hand-off.
Sixteen open PRs on `endojs/endo-but-for-bots` are blocked on roles
that this garden's active library does not yet carry; the steward has
freshness-checked them (companion entry
`004800Z-message-steward-f78473.md`) but cannot move them further.
This entry is a focused request to land those roles.

## Recommended port order

Ranked by leverage against the 16 open PRs and the standing engagements.
For each role, the source file is at `references/endo-but-for-bots/roles/<name>.md`
and the destination is `roles/<name>/AGENT.md` on `main`. Skills cited
by each role will need to come along; the cited list is at the top of
each reference file.

| Rank | Role | Unblocks | Why first |
|---|---|---|---|
| 1 | `fixer` | #125 #128 #134 #151 #160 #165 #178 #179 #186 (9 PRs) | Most CHANGES_REQUESTED PRs need exactly this. Highest single-role leverage. |
| 2 | `weaver` | #121 #125 #165 #169 (4 PRs) | All four CONFLICTING PRs need a rebase pass; without `weaver`, even an approved fixer pass cannot land. |
| 3 | `shepherd` | every PR after a fixer push, plus #121's rerun watch | CI verification and "re-request review when green"; the bridge between fixer/weaver and conductor. |
| 4 | `conductor` | every APPROVED + green PR | Drains the merge queue. Cheap to port; pairs with shepherd. |
| 5 | `designer` | #203 (chat editMessage UI design) | One open issue today, but the design pipeline is upstream of every future feature PR. |
| 6 | `scout` | #205 (CI latency refresh, recurring) | The next scheduled refresh is 2026-05-20; without scout the steward will keep doing this inline (works, but a scout dispatch is cleaner and produces a comment-ready artifact). |
| 7 | `botanist` | future Dependabot PRs | The previous batch (#188-#196) is merged; new bumps will appear via the events Monitor. Per-PR maturity is low-volume; can wait until the next batch. |
| 8 | `major-general` | the 2026-05-17 weekly sweep + per-package rescouts | The scheduled-engagements row carries this; if the role does not land by 2026-05-17 the steward will surface it. |

The first three (`fixer`, `weaver`, `shepherd`) cover essentially all
the steward-actionable work the hand-off was waiting on. If
liaison-time is the bottleneck, that's the minimum viable port.

## Other roles in `references/endo-but-for-bots/roles/`

Listed for completeness; not on the critical path for the hand-off:

- `builder`, `cleaner`, `chronicler`, `scribe`, `triager`,
  `investigator`, `saboteur`, `juror`, `namer`, `stratego`,
  `director`, `marshal`, `groom`, `watchman-cadence`,
  `watchman-events`, `watchman-schedule`. Some of these are
  meaningful (`director` and `marshal` for orchestration; the
  `watchman-*` set for the cadence rules the steward still
  doesn't have ported); none are blocking the current resume.

## Porting checklist (per role)

1. Copy `references/endo-but-for-bots/roles/<name>.md` →
   `roles/<name>/AGENT.md` and rewrite the path conventions for
   this garden's layout (the `dispatches/<role>--<purpose>--<ts>--<id>/`
   triple from the new `CLAUDE.md` dispatch contract, not the
   prior `~/endo-wt/pr-<N>/` per-PR worktree pattern).
2. Pull in cited skills similarly. Several of the role files cite
   skills that already exist here under different names; reuse
   what's already in `skills/` rather than re-importing.
3. Update `CLAUDE.md` § Current inventory's *Roles* list.
4. Update `roles/steward/AGENT.md` § Subordinate roles dispatched
   to name the new role.
5. The steward role's external-repo etiquette already allows the
   `boatman` exception; add a per-role note in `roles/COMMON.md`
   § External-repo etiquette for any new role that legitimately
   needs to comment (shepherd's "re-request review", fixer's
   eventual push notification, conductor's merge-comment if any).
   These are per-action authorizations the steward forwards, not
   originates.

## Authority gap that pairs with this port

Even with the roles ported, the steward still cannot originate the
cross-repo authorizations the porting roles will need (re-request
review, post a status comment, leave a review). The cleanest fix is
a maintainer-or-liaison standing authorization, recorded in the
bulletin's *Pre-staged authorizations* section, of the shape:

> The `kriscendobot` identity is authorized to perform the
> following actions on `endojs/endo-but-for-bots` without further
> per-action approval: re-request a maintainer review on a PR
> after a successful CI run; post a comment whose body has been
> recorded verbatim in a journal `message` entry by the steward.

That single authorization unblocks most of the still-open PR
surface. Other actions (opening new PRs as the bot identity,
leaving review-as-comment, commenting on issues) can stay per-
action until they prove worth standing up.

## Self-improvement

This routing is the third entry in a row pointing at the same
gating port. If the liaison cannot tackle it in the next session,
that itself is a signal: either the garden's role-porting bar is
too high for the leverage the ports unlock, or the steward should
reduce dependence on the un-ported roles (acceptable, but means
accepting that ~16 open PRs sit indefinitely until kriskowal
moves them by hand). A meta-decision worth surfacing in the
liaison's next active session.

Self-improvement: nothing for the role file.
