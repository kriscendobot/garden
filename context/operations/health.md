# Health and recovery

Checking that an instance is healthy, and recovering it when it is not. The
garden is silent until an error and self-heals most failures on its own; this
page is the operator's window into that — the failed-unit check, the **restore**
engagement for recovering a fleet stuck after an outage, and the three
self-healing services (reaper, deadmail, doom) an operator should recognize.
The restore procedure itself is owned by `skills/restore/SKILL.md`, which this
page routes to. If your question is "is the fleet OK," "why can't this host's
workers find `claude`," "recover after an API or quota outage," or "what
happened to my dead job," you are here; pausing a *healthy* fleet is
[scaling.md](scaling.md).

## The health check

```sh
systemctl --user list-units 'garden-*' --state=failed   # should be empty
```

An empty list is health. A failed unit is the first thing to look at after any
bring-up or deploy. The fleet's `self-heal-run.sh` wrapper already captures
evidence on an unexpected failure and posts a diagnosing fix job (throttled, so
a crash loop can't burn tokens) — systemd restarts, the wrapper diagnoses — so a
transient failure often clears itself. A unit that stays failed is the operator's
cue.

## A worker cannot find its agent CLI

`FATAL: claude not on PATH`, from every worker on one host, means the spine
cannot resolve the agent CLI that host's jobs run on. Two facts settle most of
these:

**Where the CLI actually lives.** The image takes node from the nodejs.org
tarball unpacked into `/usr/local` (NodeSource's apt repo and setup script both
403 as of 2026-07 and are no longer used), so npm's global prefix is
`/usr/local` and the CLI lands at **`/usr/local/bin/claude`** — *not*
`/usr/bin/claude`, which is where a NodeSource apt node would have put it.
`codex` and `kimi` sit alongside it. A host running the fleet outside the
container has no such guarantee: its CLI lands wherever that operator's npm
prefix points, commonly `~/.local/bin`, `~/.claude/local`, or an nvm bin.

**A `systemd --user` unit carries no `Environment=PATH`.** The fleet runs on
whatever PATH the user manager inherited at login, so `command -v claude` in a
login shell proves nothing about what the units see. `systemctl --user
show-environment` is the comparison that does.

The spine absorbs most of the rest. `agent_bin_probe` (`scripts/jobs/common.sh`)
resolves in order: a `GARDEN_<NAME>_BIN` override → PATH → the known install
locations (`/usr/local/bin`, `/usr/bin`, `~/.local/bin`, `~/.claude/local`,
`$NVM_BIN`, `~/.npm-global/bin`, `~/.node/bin`, `~/bin`), with a bounded retry
over the seconds-long window an in-place `npm install -g` unlinks the global
bin. A genuine absence exits `GARDEN_ENV_RC` (75) as an *environmental* failure,
never as a defect in whatever job happened to be claimed. The **pre-claim health
gate** then keeps an unhealthy worker from claiming at all: it parks and
re-polls, reporting once per health transition, so a host that cannot run jobs
can no longer win claim races and drain the shared board into doom (the ps23
outage, kriscendobot/garden#68).

The operator's remaining lever, for a CLI the candidate list does not cover, is
`GARDEN_CLAUDE_BIN` set to an absolute path in the worker unit's environment —
fail-closed, so a typo surfaces loudly instead of quietly running some other
binary. Both mechanisms live in the *deployed* checkout: a host still running an
older deploy has neither, so check [deploy.md](deploy.md) before diagnosing
further.

## Recovering after an outage: restore

After an API or quota outage, workers may be hung, messages may be dead-lettered,
and doom jobs may be stuck. **Restore** is the engagement that recovers the
fleet: reactivate hung agents, forward dead letters, and acknowledge + redispatch
doom. The liaison runs it on the verb **restore** (or "recover the fleet"). The
full procedure is `skills/restore/SKILL.md` — read and follow it; this page only
tells you *when* to reach for it.

## The self-healing services (recognize these)

Each runs as a leader-only singleton; an operator should know what each does when
its name shows up:

- **Reaper** — requeues jobs whose claimant died. The **same job base resumes the
  same session**, so in-flight work survives its worker rather than restarting
  from scratch. A job that vanished from the board without a `tada/` report was
  reaper-doomed.
- **Deadmail** — promotes a message sent to a **departed** agent into a fresh
  job, so intent is never dropped on the floor when its recipient has already
  finished.
- **Doom** — a job that keeps failing is quarantined rather than retried
  forever; restore acknowledges and redispatches it as part of outage recovery
  (above), so a doomed job is not lost, just held until a human-triggered
  recovery clears it.

Related self-improvement machinery (the mentor's improvement jobs, the watchman's
mid-flight broadcast) is conceptual orientation in `README.md` § Self-healing,
self-improvement, reflection — not an operator control surface.
