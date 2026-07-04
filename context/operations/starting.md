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

Before anything, the identity in `.garden` must be **unique across all running
instances** — it keys claims, per-host worker counts, journal index entries, and
the leader marker. This is the one question only the human can answer; the
mechanics and the rename move are [../first-run/identity.md](../first-run/identity.md).
Do not proceed on a default or a collision.

## The bring-up, in order

1. **Bootstrap the user manager** for headless `systemctl --user` (one-time):

   ```sh
   loginctl enable-linger "$USER"
   ```

2. **Install and enable the units:**

   ```sh
   scripts/jobs/install-units.sh install
   scripts/jobs/install-units.sh enable-services
   ```

3. **Size this host's worker pool** (journal state the gardener-scaler
   reconciles):

   ```sh
   scripts/jobs/set-gardeners.sh 100 "$(hostname -s)"
   ```

   ~100 is normal. Most workers are idle-blocked waiting on messages at any
   moment — sleeping is the cheapest thing an agent can do — so the count is
   sized for concurrency, not CPU. Sizing detail: [scaling.md](scaling.md).

4. **Designate the leader** on a first/only host (single host: itself):

   ```sh
   scripts/jobs/set-main-host.sh "$(hostname -s)"
   ```

   This CAS-writes the authoritative `leader` marker, which **raises** the named
   host via its standing marker-watch. On a single host, behavior is unchanged;
   the leader/follower gate only bites when a second host joins
   ([leader-follower.md](leader-follower.md)).

**Verify after:** `systemctl --user list-units 'garden-*' --state=failed` should
be **empty**. Show the one-line result.

## The liaison's three Monitors

The liaison arms these as Claude Code **Monitor** tools in its own session. Two
are singletons — leader-only, because two would double-act:

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

Singleton rule in general: on the leader host only — foreman, scheduler,
watchers, bulletin, and these Monitors. Followers run the gardener pool plus
per-host local infra. The full inventory and rationale are
[leader-follower.md](leader-follower.md) and
`designs/multibot-leader-follower.md`.

## Optional armings

- **Issue inbox** — drive the garden from its **own** GitHub issues. This is
  per-instance **journal** state, not `main2`, so each instance points at its
  own repo and tracks its own maintainers:

  ```sh
  scripts/jobs/set-garden-repo.sh <owner/name>   # e.g. kriskowal/garden
  scripts/jobs/add-maintainer.sh  <login>        # one per trusted maintainer
  ```

  The `garden-issue-inbox.timer` is auto-enabled by step 2 and is **inert** until
  both exist — writing them is the deliberate arming act. Gate is
  allowlist-only, no org fallback (`designs/issue-inbox.md`).

- **Bulletin PAT** — the GitHub Pages bulletin reads status without auth, but
  replying from the page needs a fine-grained Personal Access Token (Contents:
  Read and write, this repo only). The click-by-click is human-only:
  `docs/bulletin/SETUP.md`.

## The ask-before-acting contract

Every mutating step above is proposed in one sentence with the command shown,
run by the liaison on a yes, verified after. Read-only probes run freely. This
is the same contract that binds the first-run tour
([../first-run/README.md](../first-run/README.md) § Interaction norms).
