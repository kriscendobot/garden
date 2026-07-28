# The deliberate deploy

How a running instance takes up a new version of the garden library. The root
checkout is a **deployed version**, not a development tree, and it advances only
by the deliberate, drained `deploy-garden.sh` — triggered by an upgrade-ready
signal the liaison acts on. This page is the operator procedure and the mental
model behind it; the rationale (why deliberate and not continuous
fast-forward) is `designs/deliberate-deploy.md`. If your question is "an upgrade
is ready — what do I do" or "why isn't the root checkout tracking `main2`," you
are here.

## What the root checkout is

`<garden-root>` is a **deployed version** of the garden, not a working tree.
Nothing fast-forwards it continuously. Development happens in **per-subagent
worktrees** off `origin/main2`; the root is advanced only by the deliberate,
drained deploy below. The continuous fast-forward path is retired
(`garden-deploy-sync` is gone; the watchman's aggressive checkout defaults off,
keeping only its post-deploy reread broadcast).

## The upgrade-ready signal

The deterministic `garden-upgrade-monitor` service (per-host local infra) emits
an **"Upgrade ready"** signal when `origin/main2` is ahead of this host's
deployed sha. The liaison arms a **deploy-on-upgrade Monitor** whose command is:

```sh
cat "$GARDEN_STATE/deploy/upgrade-ready" 2>/dev/null   # silent when up to date
```

On a signal, the liaison acts on it automatically (this Monitor is leader-facing;
arm it as part of leader stand-up, [starting.md](starting.md)).

## Deploying

```sh
scripts/jobs/deploy-garden.sh
```

The script runs the deliberate sequence: **drain → quiesce → merge → record the
deployed sha → lift the drain → restart the fleet.** It pauses the fleet
gracefully (the same drain as [scaling.md](scaling.md)), merges `origin/main2`
into the root checkout, records the new deployed sha (which clears the
upgrade-ready signal), lifts the drain, and restarts so every unit picks up the
new code. A lesson you encode reaches a *running* agent mid-flight through the
watchman's broadcast; the deploy is how the *deployed root and its units* take
up the change.

## The drain can outlive the deploy

A *successful* deploy lifts the drain it engaged (and its abort belt lifts a drain
it engaged on any failure), but a drain the deploy did **not** engage — an operator
`stand down` / `drain` it honored rather than lifted, or a hard kill before its
lift — leaves the **draining marker** behind, and that marker **outlives** the
deploy. A gardener that starts while the marker is present logs `fleet draining;
exiting cleanly` and exits: units installed, linger on, nothing *failed*, yet **0
gardeners running**. That is why a re-start ([starting.md](starting.md) step 5)
probes `drain-fleet.sh status`, **lifts** a stale drain (operator-confirmed), and
verifies gardeners are *positively* active — never trusting an empty
`--state=failed` list alone. The lift is kept deliberately on the re-start
surface, not force-lifted by the deploy, so a fleet an operator *intentionally*
paused is never silently resumed ([deliberate-deploy](../../designs/deliberate-deploy.md)).
