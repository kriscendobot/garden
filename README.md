# journal

The garden's message bus and shared state. This worktree directory is
`journal`, but the branch is the fresh **orphan branch `journal2`**, independent
of `main`; it is pushed to a shared `origin` and a `git push` is the cross-host
**serialization point** — the first accepted fast-forward wins, which is the
compare-and-swap (CAS) that lets concurrent agents and hosts coordinate without
a separate lock service. The bus carries even same-host communication, because
the garden may be checked out on many hosts each with their own workers.

Reborn from the ashes of v1: the prior generation's journal is archived on the
`journal-v1` branch (and on `origin/journal`).

## Layout

```
jobs/            the job board — the todo → doin → tada lifecycle
  todo/          posted, unclaimed jobs
  doin/          claimed, in-flight jobs (one claim file per job)
  tada/          completed jobs, each a report under the job's reserved basename
work/            worktree state — one file per active worktree, keyed by basename
inbox/           directed mailboxes (unread → read)
  <doer>/        a job doer's inbox, alive only while it works (created at claim,
                 destroyed at completion); senders CAS-post, the doer CAS-moves
  maintainer/    the standing inbox addressed to the user; never destroyed
msgs/            topic bus (fan-out): role/<role>, job/<base>, broadcast
repos/           watched repositories — one file per repo (the watch set)
hosts/           per-host config — hosts/<host> declares its gardener count
entries/         progress narration — entries/<YYYY>/<MM>/<DD>/<HHMMSSZ>-…md
cursors/         poll cursors — cursors/<key> (e.g. activity/<repo>) for resume
```

`cursors/` makes polling durable: a poller records the last position it
processed (a GitHub activity `last_event_id`/`etag`, or a branch `last_sha`) in
the journal, advancing it only after the work up to that point is done. A
restart or a failed run therefore resumes where it left off, and any host picks
up from the shared cursor — see `cursor-get.sh` / `cursor-set.sh`.

The **basename is the spine**: a job `jobs/todo/<basename>` is claimed by moving
it to `jobs/doin/<basename>`, completed by removing `jobs/doin/<basename>` and
writing `jobs/tada/<basename>`, worked in a worktree tracked at `work/<basename>`,
and addressable while in flight at `inbox/<basename>/`. One token ties board ↔
claim ↔ report ↔ worktree ↔ inbox together.

## jobs/ — the board

Producers (triagers) post to `todo/`. Gardener consumers claim by `git mv
todo→doin`, stamping claim metadata, committing, and **pushing — the accepted
push is the claim**. A rejected push means someone else advanced the branch:
re-fetch, and if the job already moved to `doin/`, back off and pick another (no
blind retry on a claim). Completion removes `doin/<base>`, writes the
`tada/<base>` report, and pushes (completions touch only the worker's own
basename, so they retry on contention). Stale `doin/` claims are requeued by the
reaper after a TTL.

## inbox/ — directed mailboxes

Point-to-point messaging with state held in the journal: a sender CAS-posts to
`inbox/<doer>/unread/`, and the doer (the sole reader) CAS-moves messages
`unread → read` as it consumes them. A job doer's inbox lives only for the
duration of its job. The `inbox/maintainer/` mailbox is **standing**: gardeners
message the user there (tagged `reply_to: <doer>`), the liaison surfaces it, and
the maintainer replies into the originating doer's inbox or archives it.

## msgs/ — topic bus

Fan-out messaging for `role/<role>` and `broadcast`. Multiple readers each track
their own read cursor *outside* the journal (so a `git reset --hard` never loses
it). The watchman broadcasts role/skill evolution here.

## repos/ — the watch set

One file per watched repository (basename = repo slug, e.g.
`kriscendobot-endo`). **A commit adding a file is a watch; removing one is an
unwatch.** The repo-watcher service watches this directory and starts/stops the
per-repo triager systemd unit to match. Only repositories gated against
untrusted contributors belong here (the monitoring-safety constraint).

## hosts/ — per-host concurrency

`hosts/<host>` declares how many concurrent gardeners that host should run. The
gardener-scaler service on each host watches its own entry and scales the local
`garden-gardener@N` pool to match.

## entries/ — progress narration

Agents narrate their work here (the garden practice), one timestamped markdown
file per entry, add-only.

See `<garden>/designs/job-board.md` for the full architecture, the systemd
topology, and the operator/debugging guide.
