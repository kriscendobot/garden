Revise the garden **startup / re-start procedure** so it detects and recovers a fleet that was left **fully drained** — the very likely state after a deliberate deploy/upgrade, where `deploy-garden.sh` drains the fleet and the drain marker can outlive the upgrade.

## The gap (observed 2026-07-10 on endolin-garden-ece02cb4)

On a leader re-start (`start the garden`), every startup probe looked healthy — units installed, linger on, no failed units, leader marker correct, `hosts/<host>` declared `gardeners: 20`, and the scaler even logged "scaled gardener pool to 20" — yet **0 gardeners were actually running**. Root cause: the fleet **draining marker** (`$GARDEN_DRAINING_MARKER`, written by `drain-fleet.sh on`) was still present, so each gardener started and immediately logged `fleet draining; exiting cleanly`. The current `context/operations/starting.md` bring-up (§ "The bring-up, in order") never checks the drain marker, and its only post-check is `list-units --state=failed` — which is empty in this case because a cleanly-exiting drained gardener is *success*, not failure. The liaison only found it by manually inspecting a gardener's journal.

## What to change

1. **`context/operations/starting.md`** — add an explicit **drain check + uncork** step to the bring-up sequence (naturally near the end, after sizing the pool / designating the leader):
   - Probe with `scripts/jobs/drain-fleet.sh status`.
   - If draining, propose and (on yes) run `scripts/jobs/drain-fleet.sh off`, then trigger reconciliation with `systemctl --user start garden-gardener-scaler.service`.
   - Strengthen the **verify-after**: an empty `--state=failed` list is NOT sufficient proof the pool is live. Add a positive check that active gardeners > 0 (e.g. `systemctl --user list-units 'garden-gardener@*' --state=active --no-legend | wc -l`) and reconcile the count against the declared `hosts/<host>` `gardeners:` value. Note the "scaler logged scaled-to-N but 0 active ⇒ suspect drain" signature explicitly.
   - Cross-reference: this is the deploy/upgrade aftermath — after `deploy-garden.sh` ([context/operations/deploy.md](../../context/operations/deploy.md)) the fleet is deliberately drained, and a re-start must **un-drain** to restore the flow of jobs. Point at the [restore](../../skills/restore/SKILL.md) skill as the companion for reactivating orphaned in-flight claims.

2. **`roles/liaison/AGENT.md`** — reflect the same in the stand-up contract (§ "Stand up / stand down the garden" and/or the Deploy-on-upgrade Monitor section): standing the garden back up after a deploy is not complete until the drain is lifted and the pool is verified *positively* live. Keep it terse; the command-level detail belongs in `starting.md`.

3. Consider whether the **deploy path itself** should leave a breadcrumb (e.g. a note that the fleet is intentionally drained post-deploy and needs an explicit un-drain), or whether the deploy should auto-lift the drain on completion. Recommend, but don't silently change deploy semantics — call out the trade-off in the change so the maintainer can decide. Do NOT couple an automatic un-drain into a fully-autonomous path if it would undermine the deliberate-deploy design ([designs/deliberate-deploy.md](../../designs/deliberate-deploy.md)); an operator-confirmed un-drain at re-start is the safe default.

## Scope / definition of done

Documentation + role-brief edit in `main2` (garden's own repo — direct push, no PR, per CLAUDE.md § Conventions). Net effect: a future `start the garden` on a drained-post-upgrade instance deterministically detects the drain, uncorks it (with the ask-before-acting contract), reconciles the pool, and verifies gardeners are positively running before declaring the garden up. Keep edits tight and consistent with the surrounding prose; no executable changes required unless you judge a positive-liveness helper worth adding under `scripts/jobs/`.
