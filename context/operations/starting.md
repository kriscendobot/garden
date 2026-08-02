# Starting the garden

The command-level bring-up the liaison performs when the user says **start the
garden** — and the same procedure for any later re-start. This is agent-facing
detail the liaison **executes on demand**, asking before each consequential step
and verifying after; it is **not** a checklist a human is expected to type. It
covers linger, unit install/enable, sizing the pool, designating the leader on a
first host, the liaison's three Monitors and their singleton rules, and the
optional armings. Identity comes first and lives in its own page
([../first-run/identity.md](../first-run/identity.md)); multi-host leadership is
[leader-follower.md](leader-follower.md); pool sizing detail is
[scaling.md](scaling.md). If your question is "what commands bring up a fresh
instance," you are here.

## Precondition: a unique identity

Before anything, this instance's **location-derived `GARDEN` identity** must be
**unique across all running instances** — it keys claims, per-host worker counts,
journal index entries, and the leader marker. Same-host uniqueness is automatic
(distinct checkout paths yield distinct ids); the one thing only the human can
guarantee is **distinct short hostnames across hosts**. The mechanics and the
rename move are [../first-run/identity.md](../first-run/identity.md). Do not
proceed on a cross-host hostname collision.

## The bring-up, in order

1. **Bootstrap the user manager** for headless `systemctl --user` (one-time):

   ```sh
   loginctl enable-linger "$USER"
   ```

2. **Restore the bot git identity** (idempotent; auto-applied at container start,
   re-run here so a per-host override lands now that the journal is reachable):

   ```sh
   scripts/jobs/bootstrap-bot-identity.sh
   ```

   This rebuilds the garden repo's local `user.name`/`user.email` from a durable
   record a reset cannot lose — a per-host journal override (`identity/<host>`) if
   set, else the tracked canonical default (`kriscendobot` → `Kriscendo Bot`). It
   is a no-op when the config is already correct. It replaces the old manual
   `git config` step. To give this host a **non-canonical** identity first:
   `scripts/jobs/set-bot-identity.sh "<name>" "<email>"` (CLAUDE.md § Host
   environment).

3. **Install and enable the units:**

   ```sh
   scripts/jobs/install-units.sh install
   scripts/jobs/install-units.sh enable-services
   ```

4. **Size this host's worker pool** (journal state the gardener-scaler
   reconciles):

   ```sh
   scripts/jobs/set-gardeners.sh 20 "$(hostname -s)"
   ```

   ~20 is normal. Most workers are idle-blocked waiting on messages at any
   moment — sleeping is the cheapest thing an agent can do — so the count is
   sized for concurrency, not CPU. Sizing detail: [scaling.md](scaling.md).

   **Backend-verified provisioning (the auth auto-tune).** Declaring gardeners is
   always allowed — gardener is the baseline kind, so a fresh gnome should declare
   its target *before* the Claude device-login (step 2 of
   [auth.md](../first-run/auth.md)) even finishes. The gardener pool auto-ramps the
   instant Claude auth lands: the scaler probes each tick and holds the **effective**
   gardener count at 0 while `claude` is unauthenticated, ramping to the declared
   target on the first confirmed pass (and back to 0 if a human later logs out) —
   without ever rewriting the declared journal target. So a gnome installed ahead of
   its login sits idle-but-ready, not spinning uselessly.

   For each **additional** backend this host actually has, provision it first — then
   declare its kind:

   ```sh
   # only after: codex installed + `codex login` (cleric), MOONSHOT_API_KEY exported
   # (mystic), FIREWORKS_API_KEY exported (fireworker), ollama + a pulled model (hermit)
   scripts/jobs/set-workers.sh cleric 4 "$(hostname -s)"
   ```

   `set-workers.sh` **refuses** a non-gardener kind's count > 0 until that kind's
   backend probe passes on this host (credentials *and* software), naming the missing
   piece — so a Claude-only gnome (e.g. **ps23**) simply cannot declare
   `clerics`/`hermits`/`mystics`/`fireworkers` and stand up pools that fail every
   claim. Stage a declaration ahead of a credential with `GARDEN_FORCE_DECLARE=1`
   (the runtime effective cap still holds it at 0 until the probe passes, so the
   override is safe). `set-workers.sh <kind> 0` (withdraw a kind) is always allowed.
   Design: [gnome-backend-verified-autotune.md](../../designs/gnome-backend-verified-autotune.md).

5. **Designate the leader** on a first/only host (single host: itself):

   ```sh
   scripts/jobs/set-main-host.sh "$(hostname -s)"
   ```

   This CAS-writes the authoritative `leader` marker, which **raises** the named
   host via its standing marker-watch. On a single host, behavior is unchanged;
   the leader/follower gate only bites when a second host joins
   ([leader-follower.md](leader-follower.md)).

6. **Check for a stale drain and lift it.** A drain is a *moratorium* on taking
   new work, not a fixture — lifting it is what lets workers claim again
   ([scaling.md](scaling.md) § Pausing: drain). A re-start is very likely the
   aftermath of a deploy/upgrade: `deploy-garden.sh` ([deploy.md](deploy.md))
   drains the fleet, and although a *successful* deploy lifts its own drain, an
   **operator-engaged** drain (a prior `stand down` / `drain`) — or a deploy
   killed hard before its lift — leaves the **draining marker** in place, and
   the marker **outlives** the upgrade. A gardener that starts while the marker
   is present logs `fleet draining; exiting cleanly` and exits — so units are
   installed, linger is on, nothing is *failed*, yet **0 gardeners actually
   run**. Probe (read-only, run freely):

   ```sh
   scripts/jobs/drain-fleet.sh status
   ```

   If it reports `DRAINING`, propose and — on a yes — lift it, then nudge the
   scaler to reconcile the pool back up:

   ```sh
   scripts/jobs/drain-fleet.sh off
   systemctl --user start garden-gardener-scaler.service
   ```

   (An intentional pause you want to keep draining is the exception — leave the
   marker and say so.) After a deploy you also often want to reactivate any
   in-flight claims the drain/outage stranded: run [restore](../../skills/restore/SKILL.md)
   as the companion (it requeues orphaned `doin/` claims so the re-claiming
   gardener `--resume`s the interrupted session).

**Verify after — prove the pool is POSITIVELY live, not merely not-failed.** An
empty `--state=failed` list is **necessary but not sufficient**: a gardener that
exits cleanly under a drain marker is a *success*, so a fully-drained fleet shows
zero failed units while zero gardeners run. So check both:

```sh
systemctl --user list-units 'garden-*' --state=failed --no-legend                  # want: empty
systemctl --user list-units 'garden-gardener@*' --state=active --no-legend | wc -l  # want: > 0
```

Reconcile that active count against this host's declared target — the `gardeners:`
value in the journal `hosts/$GARDEN` file (set in step 4). **Signature to catch:
the scaler logged `scaled gardener pool to N` yet the active count is 0 ⇒ suspect
a stale drain marker** (step 6) — the units were created but each gardener
exited on the drain. Show the one-line counts.

## The liaison's four Monitors

The liaison arms these as Claude Code **Monitor** tools in its own session. Two
are singletons — leader-only, because two would double-act. Arm them on any
liaison bring-up that is not an explicitly interactive side session: a liaison
that is standing the instance up owns these watches for the life of the session.

- **Leader-marker watch** — **every host.** Watches the journal `leader` marker;
  when it comes to name this host's `GARDEN` identity, the liaison stands itself
  up as leader (arms the two Monitors below, lifts any drain). This is the
  follower's half of the leader/follower contract and must be armed on every
  host, leader and follower alike.
- **Maintainer-inbox watch** — **leader only** (singleton: two would
  double-answer). Runs `scripts/jobs/maintainer-watch.sh`; reply/dismiss with
  `scripts/jobs/maintainer-reply.sh <msgid>` / `maintainer-archive.sh <msgid>`.
  A follower stand-up brings up the gardener pool only and **skips** this.
- **Deploy-on-upgrade watch** — **leader only.** Command
  `cat "$GARDEN_STATE/deploy/upgrade-ready" 2>/dev/null` (silent when up to
  date); on a signal, invoke `scripts/jobs/deploy-garden.sh` ([deploy.md](deploy.md)).

- **Liaison-bus watch** — **every host**, leader and follower. A STANDING Monitor,
  not a one-shot drain at bring-up. Command:

  ```sh
  G="$(hostname -s)"; while true; do
    scripts/jobs/read-msgs.sh "liaison-$G" "role/liaison" "broadcast" "host/$G" 2>/dev/null || true
    sleep 120
  done
  ```

  Watch all three addresses, and **especially `host/<GARDEN>`** — notes addressed
  to *this host* have no other human-facing reader. (`host/<GARDEN>` is also the
  sysop's fan-out topic, but `read-msgs.sh` keys its cursor on the FIRST argument
  — `$GARDEN_STATE/seen/<seen-key>` — so a liaison reading with key
  `liaison-$G` has its own cursor and cannot consume the sysop's messages.)

  `read-msgs.sh` prints only *unseen* messages, so it is self-deduping: no
  seen-set wrapper is needed, unlike `maintainer-watch.sh`, which re-lists every
  unread message every tick and floods a short-interval Monitor.

  **Why standing and not a bring-up drain.** The former guidance ("drain it on
  bring-up, then again at natural checkpoints") failed in practice: on 2026-08-02
  a liaison that drained once at bring-up went ~36h without re-reading, missed
  four `deploy-garden` broadcasts, and did not see a peer liaison's direct request
  until the maintainer pasted the commit URL by hand. Gardeners read `broadcast`
  every loop (`gardener.sh`), but they exit before that read while the fleet is
  draining — so on a drained host the liaison is the ONLY reader on the bus.
  Surface anything unseen to the maintainer as a fleet notice; silence is normal.
  See [roles/liaison/AGENT.md](../../roles/liaison/AGENT.md) § the broadcast-bus drain.

Singleton rule in general: on the leader host only — foreman, scheduler,
watchers, bulletin, and the two leader-only Monitors above (maintainer-inbox and
deploy-on-upgrade). The **leader-marker** and **liaison-bus** watches are armed on
EVERY host: the first is the follower's half of the leader/follower contract, and
the second is the only human-facing reader of `host/<GARDEN>` and `broadcast` on a
follower or a drained host. Followers run the gardener pool plus
per-host local infra. The full inventory and rationale are
[leader-follower.md](leader-follower.md) and
`designs/multibot-leader-follower.md`.

## Optional armings

- **Issue inbox** — drive the garden from its **own** GitHub issues. This is
  per-instance **journal** state, not `main2`, so each instance points at its
  own repo and tracks its own maintainers:

  ```sh
  scripts/jobs/set-garden-repo.sh <owner/name>   # e.g. kriscendobot/garden
  scripts/jobs/add-maintainer.sh  <login>        # one per trusted maintainer
  ```

  The `garden-issue-inbox.timer` is auto-enabled by step 3 and is **inert** until
  both exist — writing them is the deliberate arming act. Gate is
  allowlist-only, no org fallback (`designs/issue-inbox.md`).

- **Transcript durability** — archive the fleet's session transcripts and keep
  Claude Code from deleting them. Deletion is disabled fleet-wide with **no
  arming** (on the moment this build deploys); the **archive** is **inert until
  you point it at a remote**, and until then every host still disables deletion
  and **spools** its finished transcripts locally — nothing is lost, only the push
  is gated. Arming publishes the fleet's raw working memory, so it is the
  maintainer's deliberate call: create a **private** repo to hold the branch
  (recommended: `kriscendobot/garden-transcripts`), grant the bot push, then

  ```sh
  scripts/jobs/set-transcripts-remote.sh git@github.com:kriscendobot/garden-transcripts.git
  ```

  and record it with a journal `message` entry. **Offer this; do not arm it
  yourself** — surface that capture is inert and say the word and I'll run
  `set-transcripts-remote.sh <url>`. Because local `~/.claude` no longer
  self-prunes once deletion is off, also note the disk-posture change. Full
  detail — arming, browsing a transcript, rotation: [transcripts.md](transcripts.md).

- **Bulletin PAT** — the GitHub Pages bulletin reads status without auth, but
  replying from the page needs a fine-grained Personal Access Token (Contents:
  Read and write, this repo only). The click-by-click is human-only:
  `docs/bulletin/SETUP.md`.

## The ask-before-acting contract

Every mutating step above is proposed in one sentence with the command shown,
run by the liaison on a yes, verified after. Read-only probes run freely. This
is the same contract that binds the first-run tour
([../first-run/README.md](../first-run/README.md) § Interaction norms).
