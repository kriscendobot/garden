# Health and recovery

Checking that an instance is healthy, and recovering it when it is not. The
garden is silent until an error and self-heals most failures on its own; this
page is the operator's window into that — the failed-unit check, the **restore**
engagement for recovering a fleet stuck after an outage, and the three
self-healing services (reaper, deadmail, poison) an operator should recognize.
The restore procedure itself is owned by `skills/restore/SKILL.md`, which this
page routes to. If your question is "is the fleet OK," "recover after an API or
quota outage," or "what happened to my dead job," you are here; pausing a
*healthy* fleet is [scaling.md](scaling.md).

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

## Recovering after an outage: restore

After an API or quota outage, workers may be hung, messages may be dead-lettered,
and poison jobs may be stuck. **Restore** is the engagement that recovers the
fleet: reactivate hung agents, forward dead letters, and acknowledge + redispatch
poison. The liaison runs it on the verb **restore** (or "recover the fleet"). The
full procedure is `skills/restore/SKILL.md` — read and follow it; this page only
tells you *when* to reach for it.

## The self-healing services (recognize these)

Each runs as a leader-only singleton; an operator should know what each does when
its name shows up:

- **Reaper** — requeues jobs whose claimant died. The **same job base resumes the
  same session**, so in-flight work survives its worker rather than restarting
  from scratch. A job that vanished from the board without a `tada/` report was
  reaper-poisoned.
- **Deadmail** — promotes a message sent to a **departed** agent into a fresh
  job, so intent is never dropped on the floor when its recipient has already
  finished.
- **Poison** — a job that keeps failing is quarantined rather than retried
  forever; restore acknowledges and redispatches it as part of outage recovery
  (above), so a poisoned job is not lost, just held until a human-triggered
  recovery clears it.

Related self-improvement machinery (the mentor's improvement jobs, the watchman's
mid-flight broadcast) is conceptual orientation in `README.md` § Self-healing,
self-improvement, reflection — not an operator control surface.
