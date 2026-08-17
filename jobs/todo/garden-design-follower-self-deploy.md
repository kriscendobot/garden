---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
handler-timeout: 7200

Design follower self-deploy: let a NON-LEADER host advance its own deployed
version when it observes the upgrade signal, without waiting for a human.

MAINTAINER DECISION (kriskowal, 2026-08-17, liaison session). This is a
deliberate POSTURE CHANGE, chosen with the tradeoff stated: it means deployed
code advances on followers with no human in the loop. Your job is to design it
well, not to relitigate it. But you MUST record what it supersedes, because two
existing documents say the opposite:

- `designs/deliberate-deploy.md`: the root checkout is advanced only by the
  deliberate, drained `deploy-garden.sh`, "never by a continuous fast-forward".
- `roles/liaison/AGENT.md` § Deploy-on-upgrade Monitor: "advancing the deployed
  version is the one garden action deliberately kept on the human surface, never
  a fully autonomous background service."

Supersede those explicitly and narrowly (followers only, if that is what you
conclude) rather than leaving the library self-contradictory.

WHAT PROMPTED IT. The follower endolin-garden-ece02cb4 ran 30 commits behind for
NINE DAYS (root-repo-guard `first_seen: 2026-08-08T15:52:01Z`). Every mechanism
worked EXCEPT the human: the guard detected the stall and re-reported it, the
notice reached the maintainer inbox, and the sysop executed flawlessly once asked
(op sent 21:13:31Z, acked 21:13:48Z, deployed 21:14:07Z, 36 seconds end to end).
The failure was that the notice sat unread among 60+ inbox messages. The
deploy-on-upgrade Monitor is LEADER-ONLY, so an unattended follower accumulates
the signal with nobody to act on it.

THE RAILS THAT ALREADY EXIST, and which self-deploy inherits. `deploy-garden.sh`
is already hardened; observed on two real deploys today:
  - a candidate test gate (bash -n plus classifier suites) before anything moves
  - drain engaged, wait for the fleet to quiesce, refuse to proceed on mid-job workers
  - ABORT on a dirty tracked worktree ("never clobber") -- it aborted for me once
    today and that was the correct outcome
  - atomic per-file rename of the root tree
  - unit reconcile, drain lift, worker restart, broadcast
So self-deploy is not "unsupervised deploy"; it is the same hardened path with a
different trigger. Say so plainly, and design ONLY the trigger.

WORK OUT AT LEAST:

1. THE TRIGGER. What exactly fires it: the `$GARDEN_STATE/deploy/upgrade-ready`
   signal the deterministic `garden-upgrade-monitor` already writes. Should there
   be a settling delay (do not deploy a sha that is 30 seconds old), a minimum
   drift threshold, or a quiet-period requirement? Argue from risk, not taste.

2. LEADER VS FOLLOWER. The decision names followers. Recommend whether the leader
   should stay deliberate (a liaison is usually present there, and the leader runs
   the singletons) or adopt the same behavior. State the asymmetry's justification
   if you keep one.

3. THE DIRTY-TREE CASE, which is the one path that still genuinely needs a human.
   A self-deploying follower that aborts on a dirty tree must escalate in a way
   that does NOT reproduce the failure this design exists to fix, i.e. not merely
   another inbox message. Note that stray edits in deployed roots have now been
   observed on BOTH hosts, so this path will be exercised.

4. THE ATTESTATION BOUNDARY, and be careful here. The sysop `deploy` op requires
   maintainer attestation (`authorized_by:` on `maintainers/allowlist`) that no
   agent may originate. Self-deploy must be triggered by the host's own
   deterministic LOCAL observation of the upgrade signal, and must NOT become a
   path by which an agent-originated MESSAGE causes a deploy without attestation.
   Keep the two trigger paths separate and say how the separation is enforced.

5. INTERACTION with drain and the foreman brake. A drained host is drained for a
   reason; decide whether self-deploy respects it. Note `deploy-garden.sh` engages
   its own drain and lifts it, and that an operator-engaged drain must survive.

6. FAILURE AND OBSERVABILITY. A self-deploy that fails repeatedly must be visible
   without a human polling. Consider what a follower deploying itself on a broken
   candidate would do to the fleet, and whether the existing test gate is
   sufficient protection for an unattended path.

Deliverable: a design document as a DRAFT PR on the roadmap branch, including the
supersession notes for the two documents above. If the implementation turns out
to be genuinely small and clearly correct, you may follow with a contained change
on main2, but the design record comes first, because this reverses a written
invariant and the reasoning must be recoverable later.
