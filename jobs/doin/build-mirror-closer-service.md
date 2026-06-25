# Build a deterministic (no-claude) service: close our mirror PR when its upstream PR closes

Wear the **mentor** role. Build a `systemd --user` service that watches **upstream
repositories** for **pull requests being closed**, looks up the journal mapping of which
of **our mirror PRs** corresponds to that upstream PR, and **closes our mirror with a
comment**. Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`).

## Hard constraints (from the maintainer)

- **NO use of `claude`.** Pure shell + `gh` + `git` (+ `jq`, now installed). Deterministic
  end to end: read PR-closed state, map, close. **Document in the script header that this
  is WHY an upstream watcher is permissible** despite the monitoring-safety constraint —
  that constraint guards against prompt-injection into an LLM; with no `claude` in the
  loop, no untrusted text reaches any model, so watching upstreams for a mechanical
  state-change is injection-safe. Watch **specifically and ONLY for PRs being closed** —
  nothing else.

## 1. The journal mirror mapping + reinforcement at mirror creation

- Define a journal-backed mapping recording, per mirror, the **upstream PR ↔ our mirror
  PR**: e.g. `journal/pr-mirrors/<upstream-owner>-<upstream-repo>-<N>.md` with
  `upstream: <owner>/<repo>#<N>`, `mirror: <owner>/<repo>#<M>`, `created_at`, and how it
  was created. Pick a schema; document it.
- **Reinforce the mirror-creation point** to write this mapping. Find where the garden
  creates a mirror/ferried PR — the **boatman** ferry flow (`roles/boatman/AGENT.md`) and
  the cross-fork-block→endo-but-for-bots mirror path (see the garden's mirror handling;
  `skills/pr-handoff`/`pr-formation` and the boatman). At the moment a mirror/ferried PR
  is opened — when we know BOTH the upstream PR and our mirror PR — record the mapping on
  the journal. This is the data the service consults; without it the service can do nothing.

## 2. The watcher service (`garden-mirror-closer`, deterministic)

- `scripts/jobs/mirror-closer.sh` (+ `scripts/systemd/garden-mirror-closer.{service,timer}`),
  registered in `install-units.sh`. Timer-driven; honor `killswitch_engaged`; quiet on
  success.
- **Watch set = the upstream repos referenced by the mappings** (self-maintaining: only
  watch upstreams we actually mirror), or an explicit journal set — your call, documented.
- Each tick, per watched upstream repo: poll for PRs **closed since a durable journal
  cursor** (`gh api "repos/<up>/pulls?state=closed&sort=updated&direction=desc&per_page=…"`,
  or the issues/events stream filtered to `closed`; use a cursor like the comment-watcher's).
  For each newly-closed upstream PR with a mapping:
  - If our mapped mirror PR is still **OPEN**, `gh pr close` it **with a comment** stating
    the upstream PR was closed (note merged-vs-closed if cheaply available) and the mirror
    is closed to follow. Bot identity (use the kriscendobot token explicitly — the fleet's
    default gh must be the bot).
  - **Idempotent**: skip if the mirror is already closed; advance the cursor only after
    handling; never close anything without a recorded mapping.
- **Loud failure** (per today's hardening): if `gh`/`jq`/`git` is missing or a call fails,
  die loudly / surface — never silently no-op.

## 3. Test with a SYNTHETIC repository (required)

Do NOT exercise the close path against a real upstream. Create a throwaway test repo under
the bot account (e.g. `kriscendobot/mirror-closer-selftest`), and a self-test that:
- Creates a "mirror" PR on the synthetic repo and a "upstream" PR (a second synthetic PR or
  repo standing in for the upstream), records a mapping (synthetic-upstream#X → synthetic-
  mirror#Y) on a test journal area, **closes the synthetic upstream PR**, runs
  `mirror-closer.sh`, and asserts the synthetic mirror PR is now **closed with the expected
  comment**. Also assert idempotency (a second run is a no-op) and that a closed-upstream
  with no mapping closes nothing. Tear the synthetic repo/PRs down (or leave clearly-labelled
  for inspection) and report what it created.
- Make the GitHub I/O pluggable (env-overridable handlers) so the logic can ALSO be tested
  with deterministic stubs, but the maintainer specifically wants a real synthetic-repo
  end-to-end pass — do that too.

## Definition of done

`mirror-closer.sh` + units + `install-units.sh` registration (deterministic, no claude,
loud-failing, close-only-on-mapped-upstream-close), the journal mirror-mapping schema, the
reinforcement recording mappings at mirror/ferry creation, and a green synthetic-repo
end-to-end test — committed and pushed to `origin/main2` under the bot identity. Report the
SHA, the mapping schema, the mirror-creation point reinforced, and the synthetic-repo test
result (what it created, that the mirror closed with a comment, idempotency held). If you
cannot locate the mirror-creation point, report precisely rather than guessing.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 4
  claimed_at: 2026-06-25T17:00:40Z
