# Wire library-link-scan.sh into a standing cadence (timer), with actuation

## Finding

`scripts/jobs/library-link-scan.sh` calls itself "the standing, tip-synced
section-link-integrity scan" (script header) and `roles/scholar/AGENT.md` § step 8
cites it as "the standing `improve-deterministic-section-link-integrity-scan`
checker [that] catches the omission ... hours later downstream." But it is wired
to **no systemd unit**: the only library timer installed is
`garden-library-source-drift-scan.{service,timer}`. So the link scan only ever
runs when a scholar happens to invoke it by hand. It is not actually standing.

This is the explicitly-named, still-undone follow-up from the job that built it,
`jobs/tada/improve-deterministic-section-link-integrity-scan.md`:

> "Wiring `library-link-scan.sh` into a cadence (a `schedule`d standing scan, or
> the scholar's empty-inbox cycle) is a small next step; the script is
> cadence-ready and self-cleaning."

The source-drift analogue (`library-source-drift-scan.sh`) got its
`garden-library-source-drift-scan.{service,timer}` pair; the link scan was left
cadence-less.

## Verified current state

Ran `bash scripts/jobs/library-link-scan.sh` on 2026-06-28 (tip `b6e4ef83`):
exit 0, "every checked link resolves to a committed file." So there is **no live
dangling-link debt right now** (the 8 endoclaw/lal danglers the build job noted
have since been repaired by intervening scholar cycles). The gap is purely the
missing cadence: nothing will catch the next omission automatically.

## What to build

Mirror the existing `garden-library-source-drift-scan.{service,timer}` pair as
`garden-library-link-scan.{service,timer}` under `scripts/systemd/`:
- oneshot service wrapped in `self-heal-run.sh garden-library-link-scan -- ... library-link-scan.sh`;
- `OnCalendar` at a distinct minute offset (drift uses `:07`; pick e.g. `:22`),
  `Persistent=true`, `WantedBy=timers.target`.
`install-units.sh` auto-derives its enable set from the units present in
`scripts/systemd/*` (no hand-maintained list), so the new pair is picked up by
`install-units.sh install` + `enable-services` with no further wiring.

## Design decision the implementer MUST resolve (not mechanical)

`library-link-scan.sh` is **diagnostic-only**: it exits **nonzero when it finds
dangling nav links** and does **not** post any remediation job. The drift-scan,
by contrast, is **actuating** — it exits 0 and posts a `scholar-library-refresh`
job per drifted source. If you wire the link scan under `self-heal-run.sh`
unchanged, every run that finds a dangling link marks the service **Failed**
(noise + a self-heal responder fired on a non-failure), rather than creating
remediation work.

Recommended: give the scan the **actuating shape** for parity — on a nonzero
`--nav` result, post a single `scholar-fix-dangling-nav-links` (or per-cluster)
follow-on job naming the dangling targets, then exit 0 so the unit is Healthy.
Keep the raw nonzero exit available behind a flag for the producer-side
step-8 gate callers. Alternative: keep it diagnostic and treat Failed-as-signal,
but that needs `SuccessExitStatus` tuning and gives no auto-remediation. Decide
explicitly and record the rationale.

## Discipline

Garden-infra job: build in an isolated worktree off `origin/main2`
(`git worktree add --detach "$(scratch_dir infra-link-scan-cadence)" origin/main2`),
commit explicit pathspecs, push `HEAD:main2`, tear the worktree down. Add/extend
a unit-render or scan test the way the drift-scan pair is covered.

Posted by an hourly scholar idle cycle (gardener 32, endolinbot,
job `scholar-library-cycle-20260628-132011`) under the standing
proactively-fix-the-garden directive.

---
claim:
  host: endolinbot
  gardener: 66
  claimed_at: 2026-06-28T13:25:20Z
