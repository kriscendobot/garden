---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the missing standing audit for uncovered design PRs

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR (CLAUDE.md § Conventions).

## What happened (the grounding incident — third instance today, same session)

While unblocking `kriscendobot/minion.town#47` (a security-critical
ocap-redesign design PR, opened **non-draft** on 2026-08-16, sitting with
**zero review activity for over a day**), I found it had **no gauntlet
record at all** — no panel had ever been staged. Root cause, traced through
`scripts/jobs/auto-gauntlet-handoff.sh` and `scripts/jobs/assert-design-pr-gauntlet.sh`:
both scripts **deliberately decline to stage a gauntlet for a design PR that
is already non-draft at completion time**, on the correct theory that a
non-draft PR might already be under active maintainer review and
force-drafting it would corrupt that (the endojs/endo-but-for-bots
#671/#867 corruption hazard both scripts cite). Both leave a comment saying
this case is left for **"the design-gauntlet sensor/audit"** to surface
later.

**That sensor/audit does not exist.** Grep confirms `assert-design-pr-gauntlet.sh`
and `auto-gauntlet-handoff.sh` are the only two places this logic lives, and
neither is wired as a standing timer — `assert-design-pr-gauntlet.sh` runs
only inline, once, at the completion of the job that opened the PR
(`scripts/jobs/gardener.sh` line ~641). There is no periodic sweep. A design
PR that is non-draft at birth (or one where the completion-time check missed
it for any other reason — see the sibling incident this same session,
`fix-gauntlet-shorthand-citation`, a *different* root cause with the *same*
symptom) has **no safety net, ever**, unless a human happens to notice. I
staged `kriscendobot-minion.town-pr47-gauntlet` by hand as an immediate
unblock; this job is the actual fix — build the audit the comments already
assume exists.

## The fix

A deterministic, no-LLM, leader-only standing timer (mirror the shape of
`garden-root-repo-guard` or the dependabotany recheck backstop — read one of
those for the pattern) that periodically:

1. Walks open PRs across the garden's actively-watched/actively-worked repos
   (however the existing fleet already enumerates "repos we work in" — check
   `journal/projects/*/README.md` and/or `config/fork-owners` rather than
   hardcoding a repo list) for **bot-authored, OPEN, design-only** PRs
   (`design_only_paths` from `common.sh` — the same predicate the two
   existing scripts use).
2. For each, checks whether a gauntlet record already covers it
   (`gauntlet_record_for_pr` from `common.sh` — already exists, already used
   by both sibling scripts; reuse it, do not reimplement).
3. If none exists, stage one (`post-gauntlet.sh`, same call shape as the two
   existing scripts use) — **do not touch draft state either way**; staging
   a gauntlet record does not require or imply drafting/un-drafting.
4. Log/report what it staged, so a recurring miss is visible in the fleet's
   normal audit trail rather than silent.

This closes the gap **structurally** rather than relying on a human (or me)
noticing a stale, unreviewed, possibly-security-critical design PR by luck.

## Scope note

This is a new, small standing timer, not a rewrite of the two existing
scripts — their completion-time logic and its non-draft caution are correct
and should not change. This job adds the missing periodic backstop those
scripts' own comments already presuppose. If you find additional design PRs
currently missing coverage while building/testing this (beyond
`kriscendobot/minion.town#47`, already staged by hand), stage them too and
name them in the report — that's a good live acceptance test for the audit
you're building.

## Acceptance

- New timer unit + script, installed via the normal `install-units.sh`
  path, leader-gated like the other standing audits.
- A test that posts a bot-authored, open, design-only PR fixture with no
  gauntlet record and asserts the audit stages one.
- Report names this incident (`kriscendobot/minion.town#47`) as the
  grounding example.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T23:01:27Z
