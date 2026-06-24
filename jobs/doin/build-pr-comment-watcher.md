# Build a PR-comment / @-mention watcher for safe-to-monitor repos

The v2 triager watches branch **commits** (`triager.sh` diffs `git log` over a ref
range); nothing in v2 polls **PR/issue comments**. So a maintainer directive left as
a PR comment (e.g. #57 "Please rebase on #475") is never noticed. Build the missing
watcher. Infrastructure on `main2` (bot identity). Templates: `scripts/jobs/triager.sh`
+ `handlers/triager-claude.sh` (per-repo watcher + claude-p handler + durable journal
cursor), `scripts/systemd/garden-triager@.{service,timer}`, `install-units.sh`.

The pipeline (maintainer's words): **watch PR comments → map the verb table →
reactji-acknowledge → post a job.**

## Scope & monitoring-safety (read first)

This watcher feeds PR/comment text into `claude -p`, so it is governed by the
**monitoring-safety constraint** (`CLAUDE.md` § Monitoring safety constraint): only
repos gated against untrusted contributors may be watched. **Arm it for
`endojs/endo-but-for-bots` only** (the one repo that meets the bar). The maintainer
authorized this build and this repo on 2026-06-24 — **record that authorization in a
journal `message` entry** as the constraint requires, then arm. Widening to any other
repo later requires the same maintainer-authorization-in-the-journal step; bake that
into the watcher's own norms so it is not bypassed.

## What to build

1. **A per-repo comment watcher** (model on `triager.sh`): `garden-comment-watcher@<slug>`
   (or extend the triager system with a comment path — your call, document it).
   Each tick, for the watched repo:
   - Poll PR/issue **comments, review bodies, and review-comments since a durable
     cursor** kept in the journal (like the triager's `activity/<slug>` cursor, so it
     resumes and never silently drops). Translate the v1 polling skills as needed:
     `v1/skills/github-activity-poll`, `v1/skills/activity-feed-watcher`,
     `v1/skills/at-mention-surveillance`.
   - Identify actionable items: **@-mentions of the bot**, the **verb table** from
     `roles/triager/AGENT.md` (**rebase / retcon / refresh / shepherd / run the
     gauntlet** → the corresponding job), and **review bodies with explicit asks**
     (CHANGES_REQUESTED or COMMENTED-with-asks). For a review event, **enumerate all
     inline comments tied to that review**, not just the latest. (These nuances are
     load-bearing — consult the maintainer-feedback the triager role references.)
   - **Map deterministically first** (the verb table is a fixed mapping per the
     triager role's "prefer a fixed mapping over open-ended reasoning"); fall back to
     `claude -p` wearing the **triager** role only for genuinely ambiguous directives.
2. **Reactji-acknowledge** each actioned comment so the human sees it was noticed
   promptly (translate `v1/skills/reactji-acknowledgment`; a 👀 / +1 on the comment).
   The endo-but-for-bots standing authorization permits the reaction.
3. **Post the job** (`post-job.sh`) with a **deterministic basename**
   (`<slug>-pr<N>-<verb>` or `<slug>-pr<N>-<shorthash>`) so re-polling the same
   comment is idempotent (a duplicate collides and is skipped). **Advance the cursor
   only after the post succeeds** — and verify the post actually landed (see the
   reliability note below), so a crash re-triages rather than dropping the directive.
4. **Arm it:** add `endojs/endo-but-for-bots` to this watcher's watch set and ensure
   the repo-watcher (or your unit) arms `garden-comment-watcher@endo-but-for-bots`.
   Reuse the bare clone under `$GARDEN_REPOS/<slug>.git` if present; clone if not.
5. Units + `install-units.sh` registration (install path + enable + summary line);
   `killswitch_engaged`, quiet on success, non-root `claude -p`.

## Reliability note (observed this session)

`post-job.sh` has been seen to print "posted" while the push did **not** land on
`origin/journal2` under contention — a silent directive loss. Since this watcher's
whole point is not dropping maintainer directives, **confirm each post actually
reached `origin/journal2`** (re-fetch and verify the job file exists) before advancing
the cursor; if the push was lost, retry rather than advancing. Flag this in your
report as a shared hazard for the producer path.

## Tests & verification

- Pluggable handler + deterministic stub. Assert: a "rebase #N" comment yields a
  rebase job + a reactji + cursor advance; a non-directive comment yields nothing; a
  re-poll of an already-actioned comment is idempotent (no duplicate job/reactji); the
  cursor does not advance if the post did not land. `shellcheck`/`bash -n` clean.

## Definition of done

The comment watcher built, armed for `endojs/endo-but-for-bots` (with the maintainer
authorization recorded in a journal `message`), tested, and registered in
`install-units.sh`. Report the SHA(s), the watcher shape chosen, the cursor
representation, and confirmation that the verb table + reactji + post pipeline works
end to end. If a write/push is blocked, report the diagnosis and ready-to-apply state
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 14
  claimed_at: 2026-06-24T20:28:32Z
