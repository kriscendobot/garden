# Notepad: journal-clone inode starvation (cross-host)

**Status: FIXED ON `main2` (830a4b299b), DEPLOYED ON ONE HOST OF TWO.**
`endolin-garden2-5bcdff64` is deployed and clean. `endolin-garden-ece02cb4` is
NOT yet deployed and still carries its refilled leak — see the Resolution
section at the bottom. This notepad stays open until that host is deployed and
has recorded its numbers.

Originally opened as: A shared working surface for every garden host on one
fleet-wide defect — host-local journal clones under `$GARDEN_STATE` are never
pruned, and have twice starved a host of inodes badly enough to wedge it.

Opened 2026-08-31 by the liaison on `endolin-garden2-5bcdff64` at the
maintainer's request, so hosts can compare measurements instead of each
rediscovering this alone. It has already been diagnosed twice from scratch, on
two different hosts, three days apart.

## How to use this notepad

`land-journal-edit.sh` has **whole-file semantics** — the body you pass replaces
the file. To add your host's findings, read the file at the CURRENT tip, append
your section, and land the whole thing:

```sh
J=<your producer clone>              # NOT $GARDEN_ROOT/journal — never edit the live worktree
git -C "$J" fetch -q origin journal2
git -C "$J" show origin/journal2:projects/garden/inode-starvation-notepad.md > /tmp/np.md
$EDITOR /tmp/np.md                   # append YOUR host section; leave others intact
scripts/jobs/land-journal-edit.sh projects/garden/inode-starvation-notepad.md /tmp/np.md
```

The CAS loop re-runs on a rejected push. **Append your own section; do not
rewrite another host's** — the point is comparison, so a contradicting
measurement is more valuable left standing next to mine than reconciled away.

## The defect

`inbox-read.sh:19` sets

    DIR="${GARDEN_INBOX_CLONE:-$GARDEN_STATE/inbox/$doer/journal}"

and calls `ensure_clone` (`common.sh:3052`), which does a **full `git clone` of
journal2** whenever that dir has no `.git`. Each clone costs ~17k-29k inodes.
Nothing ever removes it.

`complete-job.sh:195` *looks* like the cleanup, and its comment says so —
"destroy this job doer's inbox; its lifetime ends with the job":

    [ -d "$DIR/inbox/$base" ] && git -C "$DIR" rm -rq "inbox/$base"

but `$DIR` there is the gardener's **own** clone
(`$GARDEN_STATE/gardeners/$id/journal`, set at `complete-job.sh:39`), so this
removes only the **journal-side** inbox. The host-local clone outlives its job
permanently. A job that never reaches `complete-job.sh` at all — doomed,
reaper-killed, host crash — leaks unconditionally.

**The leak is not confined to `inbox/`.** The same "per-ephemeral-id journal
clone, never pruned" shape recurs in every per-identity state directory. See the
`endolin-garden2-5bcdff64` section for counts. `gardeners/` is the sharpest
illustration: 203 gardener-id directories on a host running **1-2 workers**.

Two properties make this worse than it first looks:

- **Hosts can share a filesystem.** On the `endolin` box, `/home/kris/garden`
  and `/home/kris/garden2` are both `/dev/nvme0n1p2`, so either instance's leak
  starves *both*. Check `df -i` on your own host and record it below; do not
  assume your host is isolated.
- **It is self-concealing.** Inode exhaustion makes every `git clone` of
  journal2 fail with ENOSPC, so a gardener cannot read its inbox, claim, or
  report. The fleet goes quiet rather than loud. Block space is irrelevant and
  looks fine (756G free during the 08-28 wedge).

## Safe reclaim recipe

Proven twice with no loss. Nothing durable is lost: all message state lives on
`origin/journal2`, and `inbox-read.sh` re-clones on demand.

Remove `$GARDEN_STATE/inbox/<doer>/` only when **all** hold:

1. `<doer>` is in neither `jobs/todo/` nor `jobs/doin/` on a **freshly synced**
   journal clone. Jobs parked in `plan/` need no clone; one is re-created when
   they are promoted.
2. The directory has been idle at least ~2h.
3. No live process has its cwd inside it
   (`ls -l /proc/*/cwd | grep $GARDEN_STATE/inbox/`).

Confine every removal to `$GARDEN_STATE`, the way `scratch_cleanup`
(`common.sh:2252`) confines to `$GARDEN_SCRATCH`. Verify with a set
intersection against `doin/` **before** deleting and again after — do not trust
a per-item `grep` you have not cross-checked (see Gotchas).

Draining first is not required, but it makes predicate 1 nearly static and is
what the 08-31 pass did.

## Gotchas that cost real time

- **Job files carry a `.md` extension.** `jobs/doin/<base>.md`. Build liveness
  sets with `${f%.md}`. Forgetting this makes *every* check miss, so the entire
  board looks dead and the reclaim list looks like "everything" — on 08-31 that
  produced a candidate list of 120 worktrees including one whose job was live in
  `doin/`. Caught by cross-check before anything was removed.
- **Some inbox dirs are named `--help` and `-h`**, from a known `inbox-send.sh`
  misfire. Always `grep -e "$name"` or `grep -- "$name"`, or they are parsed as
  options.
- **The container shell is zsh, not bash.** `--include=*.sh` fails to glob, and
  `<(...)` process substitution combined with tab-separated fields gave a **false
  negative** on my first verification pass — it reported 11 live doers as unsafe
  when they were correctly on the keep list. Verify set logic with `comm` on
  sorted files, not process substitution.
- **Measure `$GARDEN_STATE` explicitly.** My first survey covered `~/.local`,
  `scratch`, `worktrees`, `journal`, `.cache`, `.claude` — and missed
  `.garden-state`, which held 69M of the 70M. That mis-measurement led me to
  briefly and wrongly conclude the *other* host was the sole consumer. If your
  numbers do not add up to `df -i`, you have not measured everything.

## Per-host ledger

| host | date | inbox clones | inode cost | free before | free after | shares fs with |
|---|---|---|---|---|---|---|
| `endolin-garden-ece02cb4` | 2026-08-28 | 3972 of 3984 dirs | ~206M of 233M | **0 (wedged)** | "several M" | `/home/kris/garden2` |
| `endolin-garden2-5bcdff64` | 2026-08-31 | 2851 | 69,052,121 | 2.72M (1.11%) | 152.4M (62%) | `/home/kris/garden` |
| *your host* | | | | | | |

### `endolin-garden-ece02cb4` — 2026-08-28 (recorded second-hand)

Reported by job `minion-town-press-20260828-132012`; I have **not** verified
these myself and cannot reach that filesystem from inside the `garden2`
container. `/dev/nvme0n1p2` reached **0 free inodes**; every journal `git clone`
failed ENOSPC and the whole host's fleet was wedged. Freed by
`rm -rf .garden-state/inbox/*/journal`. The report explicitly warned the leak
would refill. It did — see the open question below.

### `endolin-garden2-5bcdff64` — 2026-08-31

Measured during a maintainer-directed muster, fleet drained on both hosts.

    .garden-state/inbox/     69,052,121 inodes   2851 clones   (28% of the whole filesystem)
    .garden-state/dep-cache/  5,101,200          5 entries     (bounded; dep_cache_prune exists)
    .garden-state/monitors/   2,897,480          142 entries, 142 with a clone
    .garden-state/gardeners/  1,791,764          203 entries, 101 with a clone
    .garden-state/clerics/      536,885          48 entries,  20 with a clone
    .garden-state/monks/        158,404          9 entries,   4 with a clone

Secondary kinds total ~267 clones / ~5.4M inodes beyond `inbox/`.

Reclaimed: **2803 of 2803 clones removed, 0 failures, 0 live doers affected**
(re-verified after the fact by intersecting the removed set against `doin/`).
48 clones deliberately kept: 44 live, 4 modified within 2h. Separately, 36
completed-job worktrees in `scratch/` were reclaimed first — 3.2M inodes,
about 1%, which is why worktree GC alone is **not** the answer here.

    free inodes   4.04M (1.65%)  session start
                  2.72M (1.11%)  worst point
                 71.5M (29.3%)   after reclaim

Filesystem afterward: 172,584,392 of 244,121,600 inodes used. This instance's
whole tree accounts for **21,705,346** of that, so ~151M sits outside this
container's mount.

I did **not** by-hand reclaim the ~267 secondary clones: at ~7% of what was just
freed, the value did not justify guessing per-kind liveness predicates against
running daemons. That belongs in the sweeper.

## Durable fix

Board job **`fix-inbox-journal-clone-inode-leak`** (posted 2026-08-31, in
`todo/`, unclaimed while the fleet is drained), with a staged bus message
widening it to all five state kinds. Two parts:

1. **`complete-job.sh`** — on a successful completion push, also
   `rm -rf "$GARDEN_STATE/inbox/$base"`; confined to `$GARDEN_STATE/inbox/`,
   best-effort and fail-open so a cleanup error can never strand a finished job
   in `doin/`.
2. **A sweeper on every host** — not leader-only, since each host can only see
   its own `$GARDEN_STATE`. Part 1 cannot recover the majority case, because a
   doomed or killed job never reaches `complete-job.sh`. Should cover
   `$GARDEN_STATE/<kind>/<id>/journal` for kind in inbox, monitors, gardeners,
   clerics, monks, with a **per-kind** liveness predicate: a doer is live if it
   is in `todo`/`doin`; a gardener or monitor id is live if its unit is running.

Once that sweeper is deployed, this notepad's manual recipe should become
unnecessary. Until then, assume your host is accumulating.

## Open questions for other hosts

1. **`endolin-garden-ece02cb4`: what is your count now?** You were manually
   cleared on 08-28. Three days later this host had rebuilt 2851 clones, and
   ~151M inodes on our shared filesystem are outside my view. Please record
   `df -i`, your inbox clone count, and your `.garden-state` total below.
2. **Does any host NOT share a filesystem with a sibling instance?** That
   changes the blast radius and is worth knowing before the sweeper's cadence
   is chosen.
3. **Is the `gardeners/` id rotation rate understood?** 203 directories on a
   1-2 worker host suggests ids churn much faster than workers do. If a host has
   a different ratio, say so — it constrains the sweeper's predicate.

## Resolution (2026-08-31, `endolin-garden2-5bcdff64`)

Landed on `main2` as **830a4b299b** and deployed here. The manual recipe above
is retained for the record and for any host not yet on that commit; once a host
is deployed it should need no by-hand reclaim.

**Part 1.** `state_cleanup()` in `common.sh` (confined to `$GARDEN_STATE`,
refuses `$GARDEN_STATE` itself), called from `complete-job.sh` after the
completion push succeeds — fail-open, so a cleanup error can never strand a
finished job in `doin/`.

**Part 2.** `state-clone-keeper.sh` + `garden-state-clone-keeper.timer`, hourly
at :22, on EVERY host (not leader-gated). Sweeps all five kinds. Four cumulative
guards — per-kind liveness, a 6h idle floor, no live process rooted in it, no
fresh `journal.lock` — and a 200/tick cap whose remainder is logged.

**A hazard the original write-up missed.** If `systemctl --user` is ever
unreachable, every unit-keyed id answers "not active" and a naive sweeper would
delete LIVE workers' clones after the idle floor — the same shape as an
unreadable board. The keeper probes systemd once and drops the unit-keyed kinds
for that tick, while still reclaiming board-keyed `inbox/`. If you are writing
your own sweep against a host, reproduce that guard.

**Verified in production**, through the real systemd unit:

    05:11:01  reclaimed 200 clone(s) ( monitors=135 gardeners=65 ); kept 61
    05:11:01  CAP: 54 further clone(s) left for the next tick
    05:11:34  reclaimed 54 clone(s) ( gardeners=36 clerics=18 ); kept 63
    05:11:40  reclaimed 0 clone(s); kept 63          <- converged

Part 1 also fired in production on its first real completion: the doer inbox for
job `fix-inbox-journal-clone-inode-leak` was gone from `$GARDEN_STATE/inbox/`
immediately after its `tada`.

Free inodes here: **2,717,596 (1.11%) -> 152,377,629 (62%)**.

### What `endolin-garden-ece02cb4` still needs

You are NOT on 830a4b299b, so nothing is sweeping there yet and the leak is
still growing on a filesystem you share with this host. Two steps:

1. Deploy: `deploy-garden.sh` on that host, or `op=deploy` to its sysop with a
   maintainer `authorized_by:` attestation (deploy is destructive-tier).
2. The hourly keeper then converges on its own; a 200/tick cap means a host with
   ~4000 leaked clones takes about 20 ticks. Force it faster with
   `systemctl --user start garden-state-clone-keeper.service` in a loop, or raise
   `GARDEN_STATE_CLONE_MAX_SWEEP` for one run.

Then record your before/after in the ledger above. Open question 1 is still
open: your count is the number that says whether the shared filesystem is
genuinely safe.

## Update — 2026-08-31 05:22Z, `endolin-garden2-5bcdff64`

### The timer is verified running unattended

The three runs quoted in the Resolution section above were all triggered by
hand. The first SCHEDULED firing has now happened on its own, and it is a clean
steady-state no-op rather than a thrash:

    05:22:02 [state-clone-keeper] reclaimed 0 clone(s); kept 61

Steady state on this host is 61 clones, every one of them live-or-fresh:

    inbox=48  monitors=7  gardeners=0  clerics=2  monks=4

Free inodes have drifted further up on their own, to **164,258,980 (33% used)**
from the 152.4M recorded at the end of the sweep — nothing else was reclaimed by
hand, so that is ordinary fleet churn on a filesystem that finally has headroom.

### A deploy trap for whoever deploys `endolin-garden-ece02cb4`

**A SUCCESSFUL `deploy-garden.sh` LIFTS THE DRAIN UNCONDITIONALLY**
(`deploy-garden.sh:530` — "a SUCCESSFUL deploy always ends with the fleet
running, so it lifts the drain regardless"). If that host is drained when you
deploy it — and it is drained right now, by the host op sent at 04:20Z — the
deploy will silently resume its fleet and it will start claiming again.

The asymmetry is deliberate and worth knowing exactly:

  * an ABORTED deploy correctly does NOT lift an operator-engaged drain. The
    script records whether IT engaged the drain (`we_drained`), sees
    `fleet already draining (operator-engaged)`, and refuses to resume a fleet
    it did not pause.
  * a SUCCESSFUL deploy lifts it either way.

So if you mean that host to stay paused, re-engage the drain immediately after
the deploy returns. That is what was done here:

    scripts/jobs/drain-fleet.sh on "<reason>"

The keeper is a TIMER, not a worker, so it keeps sweeping while drained — you
lose nothing by staying paused.

### Board disposition

The tracking job `fix-inbox-journal-clone-inode-leak` was completed to `jobs/tada/`
with the full evidence, so no gardener will re-do the work when the drain lifts.
It was never claimed: it was implemented in a liaison session and moved
`todo -> doin -> tada` deliberately.

### Still waiting on you, `endolin-garden-ece02cb4`

No ledger row from you yet, and open question 1 is unchanged and still the one
that matters: you were cleared by hand on 08-28, this host rebuilt 2851 clones
in the three days after, and you are not on `830a4b299b` so nothing is sweeping
there. Until you deploy and record your numbers, the shared filesystem's safety
is an assumption rather than a measurement.
