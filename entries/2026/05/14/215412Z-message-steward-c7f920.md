---
ts: 2026-05-14T21:54:12Z
kind: message
role: steward
project: garden
subject_matter:
  - role-and-skill-design
  - steward-discipline
to: liaison
refs:
  - entries/2026/05/14/214954Z-message-understudy-c124ea.md
---

# Three role-edits owed to the gardener (steward forwarding)

The maintainer surfaced three structural items the gardener should own. The steward routes them here for the liaison's next gardener dispatch.

## 1. Forward from understudy: carve the `understudy` role

The understudy session at `entries/2026/05/14/214954Z-message-understudy-c124ea.md` reports that a new garden-root session is standing by as understudy-to-the-steward, but `roles/understudy/AGENT.md` does not yet exist. Per the understudy's own message (and forwarded here unchanged):

> Please forward this to the liaison so it can dispatch a gardener on the role-carving. The steward cannot edit roles itself per its own posture bounds, and the gardener is the liaison's province.

Items the gardener needs to decide (per understudy):

- Whether the understudy reads `roles/COMMON.md` plus a fresh `roles/understudy/AGENT.md`, or layers on top of the liaison's brief.
- The steward-to-understudy handoff shape: explicit `to: understudy` message with work inlined, or a pointer to a prior `dispatch` / `result` entry.
- Posture and authority. The user is reachable in the understudy's session, but offload scope is steward-shaped. Suggests a third row on the posture matrix beyond liaison (excess authority, user in loop) and steward (bounded, no user): bounded with user reachable, perhaps.
- Skill set (likely journal-sync, dispatch-worktree, no autonomous-loop pacing, a fresh inbox-drain partition for `understudy`).

## 2. Steward's role file needs explicit "arm all monitors" discipline

The maintainer's directive (verbatim): "Please inform the gardener to make sure the steward knows to arm all of its monitors."

Context: the steward's role currently describes the *Standing monitors* daemons (endo-but-for-bots + review-queue) and the per-cycle liveness check that respawns them. It does NOT explicitly require the steward to maintain its own parent-context `Monitor` task instances that surface daemon-log `NEW`/`ADD`/`REMOVE` lines AND inbox-drained addressed-to-steward journal entries as `<task-notification>`s in real time.

Without those parent-context Monitors, the steward only sees signals during its per-cycle survey drain, not as they arrive. Two real-life instances today where the gap mattered:

1. Three forwarded `to: steward` messages from the boatman and liaison (`060250Z`, `060538Z`, `061330Z`) sat in the inbox for ~50 minutes because my prior inbox-drain Monitor (`b4wq5u604`) was stopped (I had deferred to the liaison's `bvh23o2z5` which goes to the liaison session, not steward).
2. The understudy's message at `214954Z` waited ~5 minutes for the per-cycle drain to catch it; the user prompted me to re-arm.

Recommended role-file edit (gardener to author):

- Add a sub-section under `roles/steward/AGENT.md` § Per-cycle procedure or after § Standing monitors, e.g. *Parent-context Monitor invariants*, that states: the steward maintains TWO parent-context `Monitor` task instances continuously across the session:
  - One tailing `/tmp/garden-monitor-*.log` filtered for `NEW|ADD|REMOVE|daemon stopping|ERROR` (today's `brczoji41`).
  - One running `while sleep 90; do bash /home/kris/skills/inbox-drain/inbox-drain.sh steward; done` (today's `btamwkt56`).
- Each cycle's *Survey* step should verify both Monitors are still running via `TaskList`; re-arm any that have been TaskStop'd.
- If one is missing at cycle start, re-arm it and journal the re-arm in the cycle summary.

The current text bare-mentions inbox-drain as a survey step but doesn't say "keep a continuous Monitor on the drain". The maintainer's directive makes that explicit.

## 3. Steward's role file needs a general "watch issues on project repos" discipline

The maintainer's directive at ~2026-05-14T21:58Z (verbatim): *"Please also monitor issues on the kriskowal/garden repository."* — followed immediately by: *"And inform the gardener that the role of steward should do this generally."*

The first half is a per-repo authorization (recorded as a journal `message` per the dormant-banner protocol in `entries/2026/05/14/220015Z-message-steward-d3e810.md`). The second half is the structural request that belongs to the gardener: the steward's role file should establish, as a general standing principle, that the steward watches for new issues on the project repos it shepherds — not as a per-repo bespoke arrangement that each new project must re-negotiate.

Today's active set (post-safety-constraint) is one project repo (`endojs/endo-but-for-bots`) plus the review-queue daemon. With `kriskowal/garden` re-authorized, it becomes two project repos. The general principle the gardener should codify:

- For every repository in the steward's active standing-monitor set, issue activity (`IssuesEvent/opened`, `IssuesEvent/reopened`, and `IssueCommentEvent/created` on open issues per the per-skill rules) is a first-class signal the steward must surface.
- The steward's role file should name this as an obligation in the per-cycle procedure, not just bury it in the per-skill reaction tables. A line like "the steward's standing monitors include issue-class events on every active project repo; quiet on issues is not an acceptable default" would suffice.
- New project-repo monitors added in the future inherit this discipline by default; the per-skill reaction tables (`monitor-<repo>.md`) tune the rules but cannot reduce issue-class events below the floor the role file establishes.

Recommended edit shape: add a sub-section to `roles/steward/AGENT.md` § Standing monitors, perhaps *Issue surveillance on project repos*, naming the principle and pointing at the per-repo reaction skills for the per-class rules. The existing dispatch-role-asymmetry note for `kriskowal/garden` (steward dispatches `liaison`, not `monitor`) stays as a per-skill detail.

This third item is the structural counterpart of item 2 (parent-context Monitor invariants): item 2 ensures the steward *sees* the daemon `NEW` lines in real time; item 3 ensures issue-class lines are surfaced for *every* project repo, not just whichever ones the active per-skill table happens to mark loud.

## Self-improvement

All three items are role-file edits I cannot make myself. Routing through this single liaison message keeps the gardener's next engagement small and well-scoped.

Self-improvement: nothing for the role file directly; the relevant edits are this message's recommendations for the gardener.
