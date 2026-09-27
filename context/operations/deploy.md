---
created: 2026-07-04
updated: 2026-09-27
author: gardener
---

# The deliberate deploy

How a running instance takes up a new version of the garden library. The root
checkout is a **deployed version**, not a development tree, and it advances only
by the deliberate, drained `deploy-garden.sh` — now triggered **autonomously** by
each host's own host-local `upgrade-ready` fact, orchestrated fleet-wide by a
leader-run rolling deploy (`designs/follower-self-deploy.md`). This page is the
operator procedure and the mental model behind it; the rationale (why deliberate
and not continuous fast-forward) is `designs/deliberate-deploy.md`. If your
question is "an upgrade is ready — what do I do" or "why isn't the root checkout
tracking `main2`," you are here.

## What the root checkout is

`<garden-root>` is a **deployed version** of the garden, not a working tree.
Nothing fast-forwards it continuously.
Development happens in **per-job
worktrees** off `origin/main2`; the root is advanced only by the deliberate,
drained deploy below. The continuous fast-forward path is retired
(`garden-deploy-sync` is gone; the watchman's aggressive checkout defaults off,
keeping only its post-deploy reread broadcast).

## The upgrade-ready signal

The deterministic `garden-upgrade-monitor` service (per-host local infra) emits
an **"Upgrade ready"** signal when `origin/main2` is ahead of this host's
deployed sha. That signal is the host-local, cryptographic **deploy trigger** —
never a bus message — read by two autonomous daemons:

- **`garden-self-deploy`** (every host): the follower trigger. It deploys this
  host when its own `upgrade-ready` fact is joined by the leader's per-host
  **release token** (`deploy/roll/<GARDEN>`), with a headless leaderless-grace
  fallback if there is no live leader to orchestrate.
- **`garden-rolling-deploy`** (leader only): the conductor. It rolls followers
  first as canaries, validates each, and advances the leader **itself last**.

The liaison's **deploy-on-upgrade Monitor** is now an **observer/override** (a
human kill-switch on the leader), not the trigger — a host with no session still
advances on its own. Its command is unchanged:

```sh
cat "$GARDEN_STATE/deploy/upgrade-ready" 2>/dev/null   # silent when up to date
```

To deploy or halt **by hand** as an override, run `deploy-garden.sh` (below) or
`drain-fleet.sh on` on the host in question. A hand deploy on the leader skips the
canaries. Once the leader is current, the conductor releases any follower left
behind it to the leader's sha (catch-up). A follower that holds a release without
deploying it for 20 minutes raises a `rolling-deploy-canary-stuck-<host>` notice.
The conductor and the follower pin their deploys with `GARDEN_DEPLOY_TARGET=<sha>`,
so a roll lands the sha it validated, not whatever `main2` has become since
([design § Pinned deploys](../../designs/follower-self-deploy.md#pinned-deploys-and-a-moving-tip-2026-09-23-incident)).

## Candidate validation and manual override

Before draining, `deploy-garden.sh` unpacks the selected SHA into an isolated
candidate tree and runs its configured deterministic gate suites.
Failed suites
get one retry in a fresh tree within the gate deadline.
Persistent failure
rejects the candidate without advancing the root; diagnostics from both attempts
remain under `$GARDEN_STATE/deploy/candidate-gate-diagnostics/<sha>` (or the configured
`GARDEN_DEPLOY_GATE_DIAGNOSTICS_DIR`).
A moving `main2` does not replace a roll's
pinned target, which must be an ancestor of the fetched branch.

Canary unit health excludes `GARDEN_ADVISORY_UNITS` (currently the container
hardening probe).
This does not waive its security findings.
Offline peers are
skipped without consuming canary failures; resumed heartbeats clear the offline
notice, and lagging followers receive catch-up releases to the leader's SHA.
If followers exist but none is present and eligible to validate, the leader holds;
that is different from a genuinely leader-only fleet.

For an unattended host, the manual escape hatch is an **attested sysop `deploy`
op**, via `send-host-op.sh <host> op=deploy authorized_by=<maintainer>` only when
the maintainer supplied that authorization.
Release tokens and benign quiesce
drains do not confer this authority.
See [host-operations.md](host-operations.md).

## Deploying

```sh
scripts/jobs/deploy-garden.sh
```

The script runs the deliberate sequence: **candidate gate → drain → quiesce → advance → record the
deployed sha → lift the drain → restart the fleet.** It pauses the fleet
gracefully (the same drain as [scaling.md](scaling.md)), advances the root tree to the tested candidate, records the new deployed sha (which clears the
upgrade-ready signal), lifts the drain, and restarts so every unit picks up the
new code. A lesson you encode reaches a *running* agent mid-flight through the
watchman's broadcast; the deploy is how the *deployed root and its units* take
up the change.

### Busy fleet: pre-drain before deploying

The deploy's quiescence budget is 600 seconds, while legitimate jobs may declare
7,200- or 10,800-second handler budgets. An ordinary deploy therefore checks the
oldest live busy marker first: at 300 seconds it **defers without draining**, and
a worker that crosses that threshold during a self-engaged drain causes the
script to lift and defer. On a continuously busy pool, repeated attempts may
never find a quiet window.

In a **rolling deploy** the follower publishes each deferral (`roll_status:
deferred`), and the leader treats that canary as waiting rather than failed. After
30 minutes of continuous deferral the leader sends one targeted
`rolling-deploy-quiesce` drain so the long job becomes the host's last. A canary
still deferring 3 hours after its release fails normally. See
[designs/follower-self-deploy.md](../../designs/follower-self-deploy.md) § A deferring
canary is waiting, not failed.

The reliable operator sequence is to establish the quiet window first:

```sh
scripts/jobs/drain-fleet.sh on 'pre-drain for deliberate deploy'
find "$GARDEN_STATE" -mindepth 3 -maxdepth 3 -name busy -print
# wait until no live worker has a busy marker
scripts/jobs/deploy-garden.sh
```

Do not start the deploy until the second command is empty. Because the fleet is
already draining, `deploy-garden.sh` skips its pre-drain long-job defer check and
proceeds directly to its bounded quiescence check. A successful deploy lifts the
operator drain and restarts the fleet. If this pre-drained attempt aborts, the
script preserves the operator's marker; use the check below before deciding
whether to lift it.

## A Dockerfile-affecting deploy needs an image rebuild

`deploy-garden.sh` advances the root checkout to the tested candidate and restarts the
`--user` units, but it does **not** rebuild the container image — the fleet keeps
running inside the container it already created. So a deploy that advances the
**Dockerfile** (or a file it `COPY`s — the entrypoint, the api-key-handoff seed),
for example a change to its **browser-runtime dependency layer**, lands the source
without landing it in the running image: the units restart on new *library* code
but the same *image*, and the new apt/tooling contract is silently absent.

The `garden` launcher now tracks this. `./garden build` stamps a **build-contract
digest** (a hash of the Dockerfile and its copied inputs) into the image as a
label; a bare `./garden` **warns** when a pre-existing image no longer matches
that digest (it never auto-rebuilds — a minutes-long rebuild mid-bring-up would be
a surprise, and the running container is unaffected until recreated). To gate a
deploy on it:

```sh
./garden check   # exit 0 = fresh (or no/pre-tracking image); exit 1 = STALE
```

When `check` reports STALE after a Dockerfile-affecting deploy, rebuild and
recreate this host's container so the new image is actually in use:

```sh
./garden build && ./garden reset   # the next ./garden recreates from the fresh image
```

This is a per-host step (the image is per-host, `garden-<user>`), deliberate and
drained like the deploy itself. A deploy that did not touch the Dockerfile leaves
`check` fresh and needs none of this.

## The drain can outlive the deploy

A successful advancing deploy clears the drain, including an inherited operator
pre-drain, and restarts the fleet.
On abort it lifts only a drain it engaged;
an inherited operator drain remains.
A no-op deploy also lifts only its own
drain.
A hard kill can strand a marker before cleanup.
This is why restart
checks must inspect drain state and active worker counts, not just failed units
([starting.md](starting.md)).
Do not use a successful deploy to preserve an
intentional indefinite pause: re-establish that pause deliberately if needed.

Distinguish a live deploy from a stranded marker before recovering:

```sh
scripts/jobs/drain-fleet.sh status
pgrep -af '[d]eploy-garden.sh'
```

“DRAINING” with no deploy process is not evidence of a systemd outage; it means
the marker is controlling the otherwise healthy workers. Confirm that no
maintenance or intentional operator pause owns it, then recover with:

```sh
scripts/jobs/drain-fleet.sh off
scripts/jobs/gardener-scaler.sh
```

The August 2 failure mode in which a normal, self-engaged 600-second timeout
left its own drain behind is **not current behavior**: `lift_drain_if_we_engaged`
now clears that marker. The diagnostic still matters for a killed deploy and for
an aborted deploy that inherited an operator pre-drain.
