---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Align the roadmap-design base-branch procedure so a designer has ONE explicit
path, not a documented exception that only works via an undocumented environment
override.

REPORTED (self-improvement finding from job `ironhorse-ocap-workload-optimization`,
role/liaison message 20260917T012207Z-0fa378, 2026-09-17):

  "the designer role requires bot-fork roadmap design PRs against floating `llm`,
  while `ensure-pr.sh` rejects every floating fork-side base unless
  `GARDEN_ALLOW_FLOATING_BASE=1` is supplied. The first create attempt for
  endojs/endo-but-for-bots#1300 failed at that contradiction; the documented
  roadmap-design exception then required an undocumented environment override."

So the role file mandates a thing the deterministic gate forbids, and the only way
through is a variable neither document mentions. Every designer hitting a roadmap
design PR pays this tax once, by failing first.

TASK: reconcile the three surfaces named in the report —
`roles/designer/AGENT.md`, `skills/frozen-base-branch/SKILL.md`, and the
deterministic base gate in `ensure-pr.sh` — so they state one consistent
procedure. Decide deliberately which way the reconciliation goes, and justify it:

(a) the gate learns the roadmap-design exception directly, so no override is
    needed and the documented procedure just works; or
(b) the override stays, but becomes a FIRST-CLASS, documented part of the
    roadmap-design procedure in both the role and the skill, with the gate's
    refusal message naming it explicitly so the failure is self-correcting; or
(c) the roadmap-design exception itself is wrong and those PRs should take a
    pinned base like everything else.

Prefer whichever keeps the deterministic gate meaningful. The gate exists because
a floating fork-side base makes a review diff unstable — a PR whose base moves
under it reviews the wrong divergence. That is the same failure class recorded in
the panel base-ref lesson (pass the PR's baseRefOid, never a stale
`origin/<baseRef>`), so do not weaken the gate merely to remove friction. If (a),
scope the exception narrowly enough that it cannot be reached by an ordinary
feature PR.

Whichever path: the refusal message must tell the operator what to do next, and
the role and skill must not contradict each other afterward. Include a regression
test pinning the chosen behavior.

Grounding case: endojs/endo-but-for-bots#1300.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T01:26:20Z
