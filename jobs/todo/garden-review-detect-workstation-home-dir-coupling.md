# Change-review automation: detect developer-workstation coupling (home dir) + a portability juror

Garden-infra feature, two reinforcing parts. The change-review system is
`scripts/jobs/gardening/` (`sense.sh` deterministic gates, `panel.sh` jury state
machine, `local-verify.sh`); the `claude -p` trigger pattern is the
`scripts/jobs/handlers/*-claude.sh` handlers; juror seats live in `roles/jurors/<seat>/AGENT.md`.

## Part 1 — Deterministic detector + conditional `claude -p` fixer

Add automation to the change-review pipeline that **searches the proposed change for
the current user's home directory** and, on a hit, **conditionally triggers a
`claude -p` agent to address it**:

- **Deterministic detector (no LLM), `sense.sh`-style.** Scan the proposed change's
  **added** diff lines (the new coupling, not pre-existing) for the **current user's
  home directory taken dynamically from `$HOME`** — NEVER hardcode `/home/kris`
  (that literal would be the exact coupling this is meant to catch; the detector and
  every file it adds must be clean under its own check). Exit 0 = coupling found.
- **Conditional fixer.** When the detector fires, trigger a `claude -p` agent (a new
  `scripts/jobs/handlers/portability-coupling-claude.sh`, mirroring the existing
  `*-claude.sh` handler shape) prompted with the offending lines to rewrite the
  coupling into portable forms — `$HOME`, `$GARDEN_ROOT`, a relative path, or an
  existing config var — and re-stage. The deterministic gate means the agent only
  runs when there's actually coupling, so it's cheap when clean (the `sense.sh`
  favors-false-positives discipline applies).
- Wire it into the gardener's change-review flow alongside the panel (pick the
  cleanest hook: a new gardening gate invoked before/with `panel.sh`, or a
  `local-verify.sh` step). Quiet on the clean path.

## Part 2 — A portability juror seat (semantic reinforcement)

Add a new juror `roles/jurors/<name>/AGENT.md` focused on **coupling to the
developer's workstation that will not port to another's**, and wire it into
`panel.sh`'s **code** panel seat list. Suggested name `transplanter` or `porter`
(spell out name components — no abbreviations — per the naming convention; pick what
fits the seat naming). Beyond the literal home dir the deterministic grep catches,
the juror flags the subtler, semantic cases:
- hardcoded home dirs of any user (`/home/<user>`, `/Users/<user>`),
- absolute machine paths that should be `$GARDEN_ROOT`/`$HOME`-relative,
- hardcoded hostnames (e.g. the GARDEN host name / `endolinbot`) where the logical
  `GARDEN`/`GARDEN_HOST` knob belongs,
- UID-specific paths (`/run/user/<uid>`), specific ports, single-OS assumptions,
- anything that would break on another contributor's checkout, host, or OS.
Keep it short, in the existing juror-file shape (purpose / what it flags / verdict).

## Definition of done

- Deterministic `$HOME`-dynamic detector + the conditional `claude -p` fixer handler,
  wired into the gardening change-review flow; clean path is quiet.
- The new portability juror seat, wired into the code panel.
- Tests under `scripts/jobs/test/` for the detector: hit / no-hit, added-lines-only,
  and that it keys off `$HOME` dynamically (passes for a different `$HOME`).
- Self-consistent: the new code is itself free of workstation coupling (it must pass
  its own detector and juror).
- Land on `main2` via an **isolated worktree off origin/main2** (commit explicit
  pathspecs, push `HEAD:main2`).
