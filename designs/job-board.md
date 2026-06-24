# Design: the journal-backed job system

A git-backed, multi-host job board, message bus, and worker fleet for the
garden. Producers (triagers, the watchman) post work and messages onto the
`journal2` branch; consumers (gardeners) race to claim and complete jobs;
everything coordinates through one mechanism — the `git push` to the shared
`origin/journal2` — with no separate lock service.

Lineage: modeled on **pivoker** (`endojs/endo-but-for-bots:llm` `pivoker/`),
which contributed the `@`-template systemd idiom, the `todo`/`tada` +
reserved-basename lifecycle, the `run.sh` unit-installation plumbing, and the
killswitch/notify utilities. What pivoker does **not** have — and what this
system adds — is the concurrent-claim protocol: pivoker is strictly
one-worker-per-repo and avoids races by construction. Here, N gardeners across
M hosts compete, so the claim had to be made safe.

All code lives under `scripts/jobs/` (logic) and `scripts/systemd/` (units).
Everything is environment-overridable so the test harness points the same code
at a throwaway journal.

---

## 1. The journal as bus + board

The bus is the orphan branch `journal2` (checked out in the `journal/`
directory). Layout (see `journal/DESIGN.md`; the journal's `README.md` is now the
live maintainer dashboard written by `scripts/jobs/bulletin.sh`):

```
jobs/{todo,doin,tada}/   the board lifecycle
work/<base>              worktree state per in-flight job
inbox/<doer>/{unread,read}/   directed mailbox, alive for a job doer's lifetime
inbox/maintainer/{unread,read}/   standing inbox addressed to the user
msgs/{role/<r>,broadcast}/    topic (fan-out) bus
repos/<slug>             the watch set (add = watch, remove = unwatch)
hosts/<host>             per-host gardener count
entries/<Y>/<M>/<D>/…    progress narration
```

The **basename is the spine**: it ties `todo ↔ doin ↔ tada ↔ work ↔ inbox ↔
worktree` for a single unit of work.

---

## 2. The claim protocol (the core)

A local `git mv todo/X doin/X` is atomic on the local filesystem but invisible
to other hosts until pushed. **The real serialization point is the `git push`
to `origin/journal2`**, accepted only as a fast-forward — first pusher wins,
everyone else gets a non-fast-forward rejection. That rejection *is* the
compare-and-swap.

Claim (`claim-job.sh`):
1. `fetch` + `reset --hard origin/journal2` — start from the authoritative tip.
2. Pick a candidate (lexical order, offset by an id-derived index so N gardeners
   don't all grab the first file).
3. `git mv todo/<base> doin/<base>`, stamp claim metadata, create `work/<base>`
   and the doer's `inbox/<base>/`, commit.
4. **Push.** Accepted → the claim is yours. Rejected → re-sync; if `<base>` is no
   longer in `todo/`, someone beat you to it — **back off and try the next
   candidate (never blind-retry a claim)**.

Completion (`complete-job.sh`): `fetch`+`reset`, remove `doin/<base>`,
`work/<base>`, and `inbox/<base>/`, write `tada/<base>`, push. Completion touches
only the worker's own basename, so it **retries with backoff until it lands**.

Why the asymmetry: a claim that retries could steal a job another worker already
took, so it backs off; a completion/post/send only ever fast-forwards its own
files, so it retries. Both use randomized backoff (~50–300ms) to break lockstep
livelock under contention.

### Divergences from pivoker / hazards (and how they're handled)

- **Local `mv` ≠ claim.** Only the accepted push is authoritative. No code path
  treats the local move as the claim.
- **Push contention.** Claims back off without retry; completions/posts retry.
  Index-offset candidate selection reduces head-of-line collisions.
- **Stale `doin` claims** (a gardener died mid-job): the **reaper** requeues
  claims older than `GARDEN_CLAIM_TTL` back to `todo/`, removes `work/<base>`,
  and best-effort removes the orphaned worktree. (vigil's "idle-but-pending"
  retargeted from systemd state to claim-file age.)
- **Per-gardener worktrees.** Two same-host gardeners must not share one journal
  checkout (they'd stomp each other's working tree); each operates in its own
  clone under `GARDEN_STATE`. The push race serializes them.
- **Standing state outside reset-prone worktrees.** Triager/watchman last-seen
  markers and topic read-cursors live under `GARDEN_STATE`, never in a worktree
  that gets `reset --hard`.

---

## 3. Components

| Component | Script | Unit | Role |
|---|---|---|---|
| Gardener (consumer pool) | `gardener.sh <id>` | `garden-gardener@N.service` | claim→work→complete loop |
| Triager (per-repo producer) | `triager.sh <slug>` | `garden-triager@<slug>.{service,timer}` | watch a repo, post jobs |
| Repo-watcher | `repo-watcher.sh` | `garden-repo-watcher.{service,timer}` | reconcile triager units to `repos/` |
| Gardener-scaler | `gardener-scaler.sh` | `garden-gardener-scaler.{service,timer}` | reconcile local pool to `hosts/<host>` |
| Reaper | `reaper.sh` | `garden-reaper.{service,timer}` | requeue stale `doin/` claims |
| Watchman | `watchman.sh` | `garden-watchman.{service,timer}` | watch `main2`, broadcast role/skill evolution |

Primitives shared by the above: `post-job.sh`, `claim-job.sh`,
`complete-job.sh`, `send-msg.sh`/`read-msgs.sh` (topic), `inbox-send.sh`/
`inbox-read.sh` (directed), `journal-entry.sh` (narration), `set-gardeners.sh`,
plus the maintainer-channel scripts (§5). `common.sh` holds the shared git-CAS
helpers, the `systemd_user_env`/`unit_ctl` indirection, and `backoff`.

The actual work and triage decisions are **pluggable handlers** (so tests
substitute deterministic stubs): `GARDEN_JOB_HANDLER` (default
`handlers/gardener-claude.sh`), `GARDEN_TRIAGE_HANDLER`
(`handlers/triager-claude.sh`), `GARDEN_WATCH_HANDLER`
(`handlers/watchman-claude.sh`) — each dispatches `claude -p` wearing the
respective role.

---

## 4. Triager: less discretion, PR-comment driven

The triager dispatches jobs like the v1 garden but with **more automation and
less agent discretion** — it maps directives to jobs deterministically rather
than reasoning open-endedly. Its watch surface is **GitHub pull-request
comments**: direct @-mentions of the garden, and any message to a gardener
routed through a PR comment. (The `triager.sh` ref/SHA watch is the generic
form; the production `triager-claude.sh` handler watches PR-comment threads.)

It adopts the v1 vocabulary, mapping a comment directive on PR #N to a job:

| Directive (in a PR comment) | Job posted for gardeners |
|---|---|
| **rebase** #N | rebase the PR branch on its base |
| **retcon** #N | reset + restage per-package, separate `chore: Update yarn.lock` |
| **refresh** #N | re-sync the branch / regenerate derived artifacts |
| **shepherd** #N | drive CI to green |
| **run the gauntlet** #N | the full PR-creation chain end to end |

Note: **"gauntlet" is the correct idiom; v1's "gamut" was erroneous** and is not
carried forward. A directive deterministically becomes a job whose basename is
derived from the change identity (e.g. `<slug>-pr<N>-<shorthash>`), so a
re-triage across ticks is idempotent (the basename collides with an existing
`todo`/`doin`/`tada` entry and is skipped).

Monitoring-safety constraint: triagers feed PR/comment content into `claude -p`,
so the watch set (`journal/repos/`) is limited to repositories gated against
untrusted contributors — our own forks and `endojs/endo-but-for-bots`.

---

## 5. Messaging: topic, inbox, and the maintainer channel

Two complementary mechanisms, both CAS over the journal push:

- **Topic bus** (`msgs/`, fan-out): `send-msg.sh role/<r>|broadcast` and
  `read-msgs.sh <key> <addr>…`. Multiple readers, each tracking its own read
  cursor under `GARDEN_STATE`. Every working gardener polls `role/gardener` +
  `broadcast` each loop, so it notices messages while it works.
- **Directed inbox** (`inbox/<doer>/`, point-to-point): `inbox-send.sh <doer>`
  (sender CAS-appends to `unread/`) and `inbox-read.sh <doer>` (the doer
  CAS-moves `unread → read`). The inbox exists only for the doer's job lifetime.

Addressing frontmatter on every inbox message: `from_host`, `from`, optional
`reply_to`, `sent_at`, `to`. `reply_to` is what lets a reply be routed back to
the originating doer.

### Gardener ↔ user via the liaison

1. A gardener calls `message-user.sh <its-base>` → posts into the **standing**
   `inbox/maintainer/` tagged `reply_to: <base>`.
2. The **liaison** (the interactive role) runs `maintainer-watch.sh` through the
   Claude Code **Monitor** tool (a Monitor whose command is that script, on a
   short interval). It lists unread maintainer messages read-only, so they
   persist until handled.
3. The maintainer **replies** with `maintainer-reply.sh <msgid>` (routes the
   reply into the originating doer's inbox via `reply_to`, then archives the
   maintainer message) or **archives** with `maintainer-archive.sh <msgid>`
   (CAS-move `unread → read`).
4. The gardener — still working — receives the reply through its own
   `inbox-read.sh` poll. (Tested: subtest 6.)

---

## 6. systemd topology & scaling

Units are templates rendered by `install-units.sh install` (substituting
`@GARDEN_ROOT@`) into `~/.config/systemd/user/`. Then:

```sh
scripts/jobs/install-units.sh install            # render + daemon-reload
scripts/jobs/install-units.sh enable-services    # repo-watcher, reaper, watchman, scaler timers
scripts/jobs/install-units.sh scale 4            # run gardener@{1..4} (manual override)
scripts/jobs/set-gardeners.sh 4 <host>           # the standing way: declare in the journal;
                                                 # the scaler reconciles the pool to it
```

- **Gardeners** are a templated worker pool keyed by index (`@1..@N`),
  long-running (`Type=exec`, `Restart=on-failure`). The per-host count is journal
  state (`hosts/<host>`); the gardener-scaler reconciles the local pool to it.
- **Triagers** are templated by repo slug (`@<slug>`), timer-driven
  (`Type=oneshot` + `.timer`); the repo-watcher arms/disarms them from `repos/`.
- **Repo-watcher, reaper, watchman, scaler** are oneshot + timer.

---

## 7. Operator / debugging guide (systemd --user + journalctl)

> Drawn from how pivoker is operated. systemd is **not present in the build
> environment** (no `systemctl`/`journalctl`); this is the production reference.

**Environment bootstrap (do first).** `systemctl --user` silently fails from
cron/ssh/non-login shells without these (pivoker `common.sh` exports them;
`systemd_user_env` in our `common.sh` does the same):

```sh
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
loginctl enable-linger "$USER"     # so the user manager + /run/user/<uid> survive logout
```

**Lifecycle & scaling:**
```sh
systemctl --user daemon-reload                       # ALWAYS after editing a unit
systemctl --user enable --now garden-gardener@{1..4}.service   # scale up
systemctl --user disable --now garden-gardener@{3,4}.service   # scale down
systemctl --user reset-failed 'garden-gardener@*'    # unstick failed instances
systemctl --user list-units 'garden-*' --all
systemctl --user list-timers 'garden-*' --all        # NEXT/LEFT/LAST/PASSED/ACTIVATES
```

**Logs:**
```sh
journalctl --user -u garden-gardener@1.service -f               # tail one worker
journalctl --user -u 'garden-gardener@*' -n 200 --no-pager      # whole pool
journalctl --user -u 'garden-triager@kriscendobot-endo.*' -f    # .service + .timer
journalctl --user -u garden-watchman.service --since -1h
```
A `.timer` and its `.service` are separate journal sources: the timer logs *when*
it fired, the service logs *what the run did*.

**Common failure modes:**
- *Unit won't start / drop-in ignored* → forgot `daemon-reload`; verify with
  `systemctl --user show -P ExecStart <unit>`.
- *`Type=exec` start hangs/errors immediately* → bad/non-executable ExecStart
  path; `test -x` it.
- *Stuck transient timers* (`systemd-run --on-active`) → `systemctl --user
  list-timers --all`, `stop` the lingering `<unit>.timer`, `reset-failed`.
- *`CollectMode=inactive-or-failed`* auto-unloads dead instances (keeps
  `list-units` clean) — their history is still in the journal, but `status` may
  say "could not be found".

**Killswitch:** `touch "$GARDEN_STATE/NOPE"` pauses every gardener cleanly (they
exit 0, not failed); `rm` it to resume.

---

## 8. Testing & results

`scripts/jobs/test/run-test.sh [num-jobs] [num-gardeners]` runs six subtests on
throwaway fixtures (a bare journal as the shared origin, a stub job handler, and
a mocked `systemctl`). **systemd is not required**: gardeners run as concurrent
background processes executing the *identical* claim/complete code a
`garden-gardener@N.service` would run — the coordination under test lives in the
scripts, not in systemd.

Subtests:
1. **Concurrency** — N gardeners vs M jobs: every job completed exactly once
   (one accepted `claim()` commit per distinct basename — no double-claim),
   `doin`/`work` empty, multiple gardeners with **overlapping** processing
   windows (true concurrency).
2. **Topic bus** — `role/gardener` delivered once, not redelivered.
3. **Repo-watcher** — watch arms / unwatch disarms the triager unit.
4. **Gardener-scaler** — `hosts/<host>` count reconciles the `@N` pool up & down.
5. **Inbox** — per-doer `unread→read` CAS, lifecycle (created at claim, destroyed
   at completion), send-to-inactive-doer refused.
6. **Maintainer channel** — gardener→user message surfaced by the liaison watch;
   maintainer reply routed back into the *still-working* gardener's inbox;
   message archived.

Results: **24/24 pass** at 4×12; **clean at 8×30** under heavy contention. One
real bug was found and fixed by the stress run — a fixed 6-attempt completion
retry with no backoff stranded a job in `doin` under 8-way contention; the fix
is generous retry + randomized backoff on the always-safe operations
(completions, posts, sends, entries).

---

## 9. Production setup & open items

- **Shared remote.** The scripts derive `JOURNAL_REMOTE` from the `journal/`
  worktree's `origin`. For a live multi-host bus, `journal2` must be pushed to a
  shared origin all hosts can reach; this has **not** been pushed (outward
  action — left for the maintainer).
- **`claude -p` handlers** (`handlers/*.sh`) are the production agent
  invocations; they are not exercised by the tests (which stub them) and assume
  `claude` on `PATH`.
- **systemd** is absent in the build host; the units and operator guide are the
  production reference, validated structurally (rendering, scaling logic via the
  mock) but not run under a live `systemd --user`.
- **Roles/skills**: `roles/{gardener,triager,watchman,liaison}/AGENT.md` and
  `skills/{job-board,message-bus}/SKILL.md` carry the agent-facing briefs.
