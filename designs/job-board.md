# Design: the journal-backed job system

A git-backed, multi-host job board, message bus, and worker fleet for the
garden. Producers (triagers, the watchman) post work and messages onto the
`journal2` branch; consumers (gardeners) race to claim and complete jobs;
everything coordinates through one mechanism — the `git push` to the shared
`origin/journal2` — with no separate lock service.

Lineage: modeled on **pivoker** (`endojs/endo-but-for-bots:llm` `pivoker/`),
which contributed the `@`-template systemd idiom, the `todo`/`tada` +
reserved-basename lifecycle, the `run.sh` unit-installation plumbing, and the
pause/notify utilities (its killswitch became the garden's draining marker). What
pivoker does **not** have — and what this
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
jobs/plan/               parked proposals — NOT claimable until promoted (§2.5)
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
files, so it retries. Both use **exponential backoff with full jitter** (a fresh
uniform draw in `[0, min(cap, base·2^attempt)]`; `common.sh backoff()`, base 50ms
/ cap 2s) to break lockstep livelock under contention (per kriskowal #10). The
**idle poll** between claims uses the same recipe at second scale
(`common.sh idle_backoff()`, base `GARDEN_IDLE_SLEEP` / cap `GARDEN_IDLE_SLEEP_CAP`):
a ~100-gardener fleet started in lockstep would otherwise wake on one shared
boundary and hammer `journal2` with ~100 simultaneous fetches every interval, so
each gardener's idle tick is independently jittered and a persistently-empty board
backs the poll off toward the cap.

### The pre-claim health gate: a broken worker never takes work

Before step 1, the spine asks one question of itself: *can I actually run a job?*
If not, it **does not claim** (`common.sh worker_health_gate`, called from
`gardener.sh`'s poll loop). The invariant is **a worker that cannot run a job
never takes one**.

This is not politeness — it is a fleet-integrity property. The agent CLI used to
be probed *inside the handler*, i.e. **after** the claim had already removed the
job from `todo/`. A host whose CLI is unresolvable therefore fails every job in
about a second and returns to its poll loop far faster than a healthy worker
doing real work, so it **wins claim races disproportionately**: it drains the
shared board into `doin/`, fails everything, and the reaper requeues each job
until it dooms — while every healthy host sits idle. One misconfigured host
dooms the whole fleet's board (host `ps23`, 2026-07-27/28: 249 journal entries,
zero `tada` completions, all 52 `doin/` claims held by that one host).

Nor can a peer intervene: `set-gardeners.sh` refuses a cross-host write ("a host
may set only its own worker counts") and `drain-fleet.sh`'s marker is host-local.
Those guardrails are correct and stay. Their consequence is that **the only actor
that can take a broken worker out of rotation is that worker**, so the gate has to
live in the spine.

Shape:

- **Probe target from the worker-kind registry** (`agent_bin`: gardener→`claude`,
  cleric/hermit/fireworker→`codex`, mystic→`kimi`), so the one call site covers
  every kind. It uses the same resolver as the handlers (§ agent-CLI resolution:
  the `GARDEN_<NAME>_BIN` override, then PATH, then the known install locations),
  so the gate and the handler can never disagree about what "present" means.
- **Park, don't crash.** An unhealthy worker idle-polls on the shared exponential
  backoff rather than exiting into a systemd restart loop, and resumes claiming by
  itself the moment the binary reappears — e.g. an in-place `npm install -g`
  window closing. Under `GARDEN_ONESHOT` it exits *clean* instead (that deployment
  is timer-rearmed, and a failure rc would arm a self-heal responder against an
  environmental condition no code fix addresses).
- **One report per edge, not per tick.** The unhealthy episode is latched by an
  atomic `mkdir` of a host-local, kind-scoped marker, so exactly one worker of the
  ~20 in a pool emits the journal `error`, and exactly one emits the `progress` on
  recovery. `ps23` emitted one error entry *per failed job* for hours; that flood
  is the thing being fixed, not just the claiming.
- **Scoped to the kind's own handler.** The spine is backend-pluggable, so when
  `GARDEN_JOB_HANDLER` names a substituted handler its dependencies are unknown
  and the gate does not apply (`GARDEN_WORKER_HEALTH_GATE=0` disables it
  outright). A healthy host is bit-for-bit unchanged: one probe and one directory
  test per loop, no forks, no journal traffic.

The complementary half is the **resolver** (§ agent-CLI resolution in
`common.sh`), which makes the binary easier to *find*; the gate handles the case
where it still cannot be found. Both are needed — a resolver alone fails open on a
host where the CLI is genuinely absent. Covered by
`scripts/jobs/test/worker-health-gate-test.sh`.

### Divergences from pivoker / hazards (and how they're handled)

- **Local `mv` ≠ claim.** Only the accepted push is authoritative. No code path
  treats the local move as the claim.
- **Push contention.** Claims back off without retry; completions/posts retry.
  Index-offset candidate selection reduces head-of-line collisions.
- **Stale `doin` claims** (a gardener died mid-job): the **reaper** requeues
  claims older than `GARDEN_CLAIM_TTL` back to `todo/`, removes `work/<base>`,
  and best-effort removes the orphaned worktree. (vigil's "idle-but-pending"
  retargeted from systemd state to claim-file age.) A restart cycle can orphan
  dozens of claims within minutes of each other, so the requeue is **staggered**:
  one tick requeues at most `GARDEN_REAP_MAX_PER_TICK` (default 8) age-expired
  claims, **oldest first**, draining a large burst over successive ticks rather
  than dumping it into `todo/` at once (where the pool would re-claim it together
  and the herd would re-form). The cap only ever *delays* a reap — it sits on top
  of the age floor, so nothing is reaped earlier than `reap_age_threshold` already
  requires; reap-now-hinted claims (known-dead) bypass the cap.
- **Per-gardener worktrees.** Two same-host gardeners must not share one journal
  checkout (they'd stomp each other's working tree); each operates in its own
  clone under `GARDEN_STATE`. The push race serializes them.
- **Standing state outside reset-prone worktrees.** Triager/watchman last-seen
  markers and topic read-cursors live under `GARDEN_STATE`, never in a worktree
  that gets `reset --hard`.

---

## 2.5 The plan category: parked work, promoted on go-ahead or by priority

Not all work should auto-run the moment it is posted. Two kinds must wait:
**go-ahead** work that needs the maintainer's authorization (expensive/risky, or a
proposal a designer/scholar/foreman raised), and **deferred** work parked behind
higher-priority items. Posting these straight to `todo/` would flood the active
board and let the fleet pick them up prematurely. So they go to **`jobs/plan/`**, a
category that sits **alongside** the `todo/doin/tada` lifecycle but **outside** it.

**Gardeners never claim from `plan/`, and the reaper never reaps it** — by
construction, not by a new guard: `claim-job.sh` draws candidates only from
`JOBS_TODO`, and `reaper.sh` scans only `JOBS_DOIN`. A plan job is invisible to the
worker pool and, since it is never in flight, never goes stale. It becomes work
only when **promoted** into `todo/`.

A plan job carries leading YAML frontmatter — the **gate reason** plus a
**priority/urgency** and an optional **roadmap** item it serves:

```
---
gate: go-ahead | deferred
priority: urgent | high | normal | low      # urgency: accepted as a synonym
roadmap: <milestone/item>                    # optional
posted_by: <role>
posted_at: <iso8601>
---
<the work body — becomes the todo job verbatim on promotion>
```

**Producers** park work with `post-plan.sh [--go-ahead|--deferred] [--priority L]
[--roadmap I] <base> [body]` (default `--deferred`); like `post-job.sh` it is an
ADD, idempotent on the basename, retry-on-contention.

**Annotation** (`annotate-plan.sh [--note TEXT] [--key K] [--priority L]
[--roadmap I] [--role R] [--if-parked] <base> [body]`) is the counterpart the
idempotent post leaves out. `post-plan.sh` deliberately no-ops on a re-post, so a
producer that learns something new about an already-parked item (a follow-up review
comment, a narrowed scope, a priority bump) had no primitive and hand-rolled its own
sync -> edit -> commit -> push loop against the shared producer clone. The annotator is
that loop once: it appends the note under a
`<!-- garden-annotation: key=... -->` marker (a key already present is a no-op, so a
requeued producer never double-appends; the default key content-addresses the note),
rewrites `priority`/`roadmap`/`role` in place while passing every other frontmatter
key through (the `model:`/`handler-timeout:` execution pins survive), and refuses
once the job has left `plan/` (exit 3, or a quiet skip under `--if-parked`). Being
a third writer into a parked body, it runs the note through the same cycle-marker
strip as the park and the promotion (recorded as a `cleared=` token on the marker),
so producer-supplied text cannot smuggle a stale counter back into `plan/`. The
gate fields (`gate:`, `blocked_on:`, `orchestrated_by:`) are **not** settable
through it: re-gating a parked job is a different act, owned by `promote-plan.sh`,
`block-job.sh`, and `post-orchestration.sh`.

The **comment-watcher** is the annotator's first automated caller, and it shows why
the primitive was missing rather than merely convenient. A watcher-derived base is
not comment-unique — the mechanical verbs key on `(PR,verb)` and a review keys on
its review id — so several distinct comments legitimately fold onto one base. When
that base is **parked**, both producer primitives no-op on the basename, correctly:
re-minting into `todo/` would run a job the proxy parked as blocked and let
`promote-plan.sh` later clobber it with the stale plan body. But the follow-up
comment then had nowhere to rest. On the primary path the watcher misread the
deliberate no-op as a lost push and froze its cursor below that comment *forever*,
re-polling a directive that could never post and blocking nothing behind it only
because a later fix stopped it from `break`ing the batch; on the retrospective path
the new comment simply vanished from the prosecutor's brief. Both now annotate,
`--key`ed on the **directive identity** the watcher already computes for
cross-producer dedup (`<repo>#<pr>:comment:<id>`, or `…:review:<id>[:retro]`), which
makes the append idempotent for free: a re-poll of the same comment is a deduped
no-op success, a genuinely new comment appends once. An annotation counts as a
recorded job for the ack-implies-a-posted-job invariant, so the comment gets its 👀
and a reply naming the parked base, and the cursor slides. Exit **3** (the job left
`plan/` mid-write) is deliberately *not* swallowed with `--if-parked` there: the
watcher freezes the cursor and re-polls, so the next tick takes the ordinary
live-job dedup path instead of dropping the annotation on the floor.

`mention-watcher.sh` carries the identical branch for the identical reason: its
mechanical-verb base is keyed on `(repo,number,verb)`, it computes the *same*
`<repo>#<n>:comment:<id>` identity (that is how the two watchers already collapse
onto one job when both see a comment), and it had the same phantom-lost-push freeze.
The two are the whole of the comment-driven triage path, so the wedge is closed on
both sides rather than left to reappear from the other producer.

**Promotion** (`promote-plan.sh <base>`) moves `plan/<base>` → `todo/<base>`,
stripping the plan frontmatter so the todo body is the clean work spec the gardener
acts on (a one-line `garden-promoted-from-plan` marker records provenance). It also
**clears the reaper/gardener cycle markers** from the body — the `garden-reaped`
and `garden-deadline-overrun` counters and the per-cycle `garden-reap-now` /
`garden-productive-cycle` / `garden-outage-cycle` hints — and records the cleared set
in that same provenance marker (`cleared=deadline-overrun=1`, or `cleared=none`).
Without that reset a job the reaper DOOM-PARKED here carried its counter forward,
and at `GARDEN_REAP_OVERRUN_THRESHOLD=1` the next reap cycle re-read the stale count
and parked it straight back in `plan/` without ever granting it a requeue — promotion
was a no-op the job could not escape. Promotion is a deliberate "run this again" act,
so a clean counter is the right semantics; the reaper's protection is unchanged,
since a job that still fails deterministically re-accumulates and re-dooms on its
own. Like a completion it touches only its own basename, so it retries with backoff.

> **The doom rename (2026-08-04).** This state was renamed from *poison* to
> *doomed* — "doomed" states what the reaper actually detects (a job that will fail
> identically on every requeue, i.e. deterministic future failure), where "poison"
> did not; "wedged" was rejected because the garden already uses it for the wedged
> auto-gc. The rename is holistic (code, docs, the reaper's parked-plan frontmatter
> `doomed:` / `doom_signature:` / `doom_count:` / `doomed_at:` / `doomed_on:`, and
> the notice-filename prefix `doomed-<base>-<signature>.md`), and the operator env
> knobs `GARDEN_REAP_POISON_THRESHOLD` / `GARDEN_POISON_SPOOL` became
> `GARDEN_REAP_DOOM_THRESHOLD` / `GARDEN_DOOM_SPOOL`.
>
> Because hosts deploy independently, the rollout is **dual-read**: every reader
> accepts BOTH spellings (the readers of `doomed:`/`poisoned:` in `orchestrate.sh`
> and `cnf-backlog-triple.py`, the `doom_count`/`poison_count` re-doom accumulator
> in `reaper.sh`) while only writers switched to the new spelling; the two env knobs
> keep their old names as deprecated aliases (`common.sh`, logged once per process).
> The 38 jobs parked under the old field names were migrated to the new ones in one
> `journal2` commit. **Retire the compatibility shims** — the dual-read fallbacks and
> the env-knob aliases — once every host's deployed sha includes this change (no host
> can still write the old spelling). History (completed `tada/` reports, past
> notices, entries) is deliberately left in the old vocabulary.

Two paths:

1. **Maintainer go-ahead.** The **liaison** (and the **proxy** within its bounds)
   promotes a `go-ahead`-gated plan job when the maintainer authorizes it ("go
   ahead on X"). A `go-ahead` job is **only** ever promoted by maintainer
   authorization — never auto-selected. (For the proxy, promoting a `go-ahead` job
   is an authority grant it must refuse; it may promote a `deferred` one.)
2. **Priority/urgency selection.** The **foreman** idle-pump, on sustained idle,
   **prefers promoting the top `deferred` plan job** (highest priority, FIFO within
   a priority — `plan_deferred_ranked` in `common.sh`) over generating a brand-new
   step. This both honors the parked queue and skips a `claude -p` call, so deferred
   work is selected without flooding the active board. `go-ahead` jobs are excluded
   from this selection. Roadmap-aware ranking is a documented future input; the
   `priority` field is the current selection key.

The **bulletin** surfaces the plan queue in its own section: the go-ahead jobs
awaiting the maintainer's authorization, and the deferred queue (top by priority),
each with its gate reason — so the maintainer sees what needs a decision.

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

Primitives shared by the above: `post-job.sh`,
`post-plan.sh`/`annotate-plan.sh`/`promote-plan.sh` (the plan category, §2.5),
`claim-job.sh`,
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

#### Directive-identity dedup (one directive → at most one open job)

Basename idempotency only collapses re-posts of the **same** base. It does **not**
catch two **different producers** naming **different** jobs for the **one**
underlying directive: the comment-watcher's `<slug>-pr<N>-<hash>` and a
peer/liaison's hand-named `ebfb-pr-<N>-<slug>` both fired on a single PR #58
comment, so two concurrent jobs raced the same PR and one gardener clobbered the
other's working tree (fix `fu-endojs-endo-but-for-bots-pr58-4932647c-2`). Because
the two bases differ, neither `post-job.sh`'s basename check nor a watcher's
`verify_posted` could see they were the same work.

`post-job.sh` closes this with a second dedup keyed on a **directive identity** —
a producer-supplied, producer-independent key for the comment/review that
triggered the work: `<owner>/<repo>#<pr>:comment:<cid>` (or `…:review:<review_id>`).
It is passed via `--identity <key>` or `GARDEN_JOB_IDENTITY`, and maintained in a
`jobs/index/<hash>` map (alongside the lifecycle, never claimed or reaped) that
points each identity at the single base that owns it. On post: if the identity
already owns a **live** job (in `todo`/`doin`/`tada`), the post is a **no-op** —
so one directive maps to at most one open job regardless of what each producer
named it. The index entry is written **atomically with the job** (one commit) and
re-pointed once its owner **drains** out of the lifecycle, so a completed
directive never blocks a fresh recurrence. When no explicit identity is given,
one is best-effort **derived from the body** if it cites exactly one canonical
GitHub comment URL, so a hand-named peer job that merely quotes the comment dedups
too (`derive_job_identity_from_body`). The comment-watcher and mention-watcher
both compute the identical identity for the same comment, so a comment observed by
**both** (a repo-watched PR that also @-mentions the bot) collapses onto one job.
Producers hand-posting a PR/comment-directive job should pass `--identity` so their
job dedups against the watchers' deterministically.

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

**Draining:** `scripts/jobs/drain-fleet.sh on [reason]` writes the host-local
draining marker (`$GARDEN_STATE/draining`), which pauses every gardener cleanly —
they finish their in-flight claim, then exit 0 (not failed) rather than take new
work. The marker is a FILE whose EXISTENCE is the signal; the helper fills it with
a short prose note (what it means, who set it, how to clear it). `drain-fleet.sh
off` (or `rm` the marker) resumes the fleet. The predicate `fleet_draining` also
still honors the deprecated legacy marker `$GARDEN_STATE/NOPE` (the old
"killswitch") for backward compatibility; clear an old NOPE marker by hand.

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
