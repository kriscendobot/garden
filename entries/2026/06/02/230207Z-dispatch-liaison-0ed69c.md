---
ts: 2026-06-02T23:02:07Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriskowal/garden
project: garden
to: builder
dispatch_root: /home/kris/dispatches/builder--0ed69c
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
---

# dispatch: builder — garden #3 implement top-level scripts/ layout pivot (design Phase 1)

User explicit ask:

> Please dispatch a subagent to respond to
> https://github.com/kriskowal/garden/pull/3 which should have a
> top-level scripts implemented, not just designed.

PR kriskowal/garden#3 carries the driver design at
`designs/driver.md` (head `b6a1318a`). The design's Phase 1 plan
calls for the file-layout move to land the new top-level `scripts/`
directory and a small set of new skills. Three kriskowal reviews
(2026-06-02 04:08Z, 04:19Z, 21:41Z) escalate from "please add
systemd + top-level scripts" → "reorganize into top-level
scripts/" → "Please implement the pivot as documented."

The design (lines 41-150 especially) is now the authoritative spec
for what the builder lands. This dispatch is the implementation
follow-up the design names ("a follow-up implementation dispatch
lands the moves").

## Critical reading order

1. `garden/designs/driver.md` — full design (638 lines). Pay
   special attention to:
   - § Layout pivot (lines 41-78) for the new directory tree.
   - § systemd-managed daemons (lines 79-170) for the unit files
     and helper scripts.
   - § What changes in the existing library → New artifacts (lines
     ~458-490) for the canonical list of files to create.
   - § Migration plan → Phase 1 (line ~552) for the explicit Phase-
     1 scope ("Lands the file-layout move ... the templated
     systemd unit files; `skills/driver-pr-creation-state-machine/
     SKILL.md`; `skills/prompt-on-failure-capture/SKILL.md`;
     `skills/activity-feed-watcher/SKILL.md`. No live drivers or
     watchers yet.").
   - § Non-goals (lines ~624-636) for what to NOT change.
2. `garden/CLAUDE.md` — garden's standing layout + dispatch
   contract (you'll add a brief mention of `scripts/` to §
   Current inventory).

## Scope (Phase 1 only)

### Create

**Top-level `scripts/` tree:**

- `scripts/driver/driver.sh` — moved from `roles/driver/driver.sh`.
  Update the script's internal path references (state-file path
  formatting, etc.) per any conventions implied by the design's
  "lane number argument" disposition. The script's behavior is
  unchanged from the current `roles/driver/driver.sh`; only its
  home (and any path constants embedded in it) change.
- `scripts/driver/README.md` — human-oriented overview per design §
  New artifacts. Cover: what it does, how to launch a lane manually
  (`scripts/driver/driver.sh <lane>`), how systemd integrates,
  per-lane state files, where transcripts land on failure.

- `scripts/watcher/.gitkeep` plus a README at
  `scripts/watcher/README.md` (parent-directory README explaining
  the per-feed-subdirectory convention). The design names initial
  feed slugs (`endo-but-for-bots`, `endo-but-for-bots-poll`,
  `review-queue`, `assigned-issues`); Phase 1 does NOT require
  implementing each watcher. A single stub feed directory is OK:
  - `scripts/watcher/endo-but-for-bots/watcher.sh` (a minimal
    placeholder that documents the contract via comments + exits
    cleanly with a "not yet implemented" message; this is enough
    to validate the directory shape).
  - `scripts/watcher/endo-but-for-bots/README.md` (per-feed
    README).
  - Other feed directories can be deferred to Phase 2-5; do NOT
    invent watchers for feeds whose implementation isn't yet
    designed.

- `scripts/daemons/start.sh`, `stop.sh`, `status.sh`, `logs.sh` —
  human-invocable wrappers over `systemctl --user`. The design's §
  Start, stop, status, and log review (lines ~127-145) names the
  contract. `start.sh` reads a host-local config (see next item)
  and enables/starts the configured lanes + watchers; `stop.sh`
  stops cleanly; `status.sh` reports unit state; `logs.sh` tails
  `journalctl --user-unit garden-driver@*.service` and
  `journalctl --user-unit garden-watcher@*.service` with `--lane`
  / `--feed` filters.
- `scripts/daemons/config.sh.example` — example config sourceable
  shell file declaring `GARDEN_DRIVER_LANES=(1 2)` and
  `GARDEN_WATCHER_FEEDS=(endo-but-for-bots)`. The actual
  `config.sh` is host-local (gitignored); the `.example` is the
  template. Add an entry to `.gitignore` for `scripts/daemons/
  config.sh`.
- `scripts/daemons/README.md` — human-oriented start/stop guide;
  systemd integration; troubleshooting recipes.

- `scripts/systemd/garden-driver@.service` — templated unit per
  design § Driver pool (lines ~84-106).
- `scripts/systemd/garden-watcher@.service` — templated unit per
  design § Per-activity-feed watcher daemons (lines ~95-110).
- `scripts/systemd/README.md` — drop-in locations
  (`~/.config/systemd/user/`), `daemon-reload` cadence, `enable` /
  `start` lifecycle.

**New skill files (`skills/`):**

The design's Phase 1 names three:

- `skills/driver-pr-creation-state-machine/SKILL.md` — formalize
  the PR-creation state machine + transition predicates. The
  existing `skills/driver-state-machine/SKILL.md` covers similar
  ground; you can either rename + extend it, or create the new
  file and delete the old. Pick whichever produces a cleaner diff;
  document the choice in the result entry.
- `skills/prompt-on-failure-capture/SKILL.md` — the `git
  hash-object` / `git cat-file blob` capture pattern, prompt
  template, claude invocation, and known-SHA short-circuit. Design
  § Prompt-on-failure capture pattern is the source (lines
  ~340-380).
- `skills/activity-feed-watcher/SKILL.md` — contract every
  per-feed watcher implements (event classification, subscription
  union, reactji policy, error escalation). Design § Watcher
  subscription model and event routing is the source.

### Move / delete (per design § Retired / superseded)

- `roles/driver/driver.sh` → `scripts/driver/driver.sh` (move via
  `git mv`).
- `roles/driver/AGENT.md` → DELETE. The design explicitly retires
  the driver-as-role; it is a script now. Subagents invoked by
  the driver still read other roles' AGENT.md, but no AGENT.md
  exists for the driver itself.
- `roles/driver/` directory: empty after the above; `git rm -rf
  roles/driver/` to remove cleanly.

### Update path references

These currently reference `roles/driver/driver.sh` and need updating
to `scripts/driver/driver.sh`:

- `tests/driver/test_loop_capture_and_self_improve.sh`
- `tests/driver/test_trap_fires_on_error.sh`
- `tests/driver/test_design_only_happy_path.sh`
- `tests/driver/lib/mock-garden.sh`
- `tests/driver/test_skeleton.sh`
- `.github/workflows/driver-tests.yml`

Run the test suite locally after the moves to confirm. The
existing `tests/driver/run.sh` should still pass end-to-end.

### Update `CLAUDE.md`

Add a brief mention of the new top-level `scripts/` directory
under § Layout (right after the entry for `worktrees/` is
fine), referencing `designs/driver.md` for the rationale. Per
design § Modified artifacts: `CLAUDE.md` § Current inventory gets
a mention of the `scripts/` directory but **no `driver` row is
added to the roles inventory** (since the driver is a script,
not a role).

## Out of scope (Phase 1 explicitly excludes)

- Implementing watchers beyond the single stub feed directory.
  The four feed slugs (`endo-but-for-bots`, `endo-but-for-bots-
  poll`, `review-queue`, `assigned-issues`) are named in the
  design but implementation is Phase 2-5.
- Implementing the additional six workflow-kind state-machine
  skills (`observed-error`, `issue-response`, `build-request`,
  `design-request`, `retcon-rebase`, `ci-recovery`). Phase 1 only
  requires `driver-pr-creation-state-machine`.
- Implementing `skills/gardener-inbox-error-reporting/SKILL.md`
  and `skills/driver-pre-ci-validation/SKILL.md` (named in the
  design but not Phase 1).
- Enabling any systemd units. The unit files land in `scripts/
  systemd/` but no `systemctl --user enable` runs.
- Retiring any existing scan-based system (steward's PR-creation-
  flow scan, contractor's slot machinery, standing-monitor
  daemons). All preserved per migration plan.
- Touching `roles/steward/`, `roles/general-contractor/`,
  `roles/monitor/`, or any per-project monitor skill.
- Moving `skills/cleaner/cleaner.sh` (if it exists) — design names
  it but Phase 1 can leave it where it is; mark it as a known
  follow-up if you encounter it. (Looking at the current tree:
  `skills/cleaner/` may already exist; verify before moving.)

## Procedure

1. From `project/`, read `designs/driver.md` end-to-end. Make
   sure the layout sketch and the new-artifacts list are clear.
2. Create the `scripts/` tree per the spec above. Use `git mv` for
   the move of `roles/driver/driver.sh`.
3. Write the new skill files (`driver-pr-creation-state-machine`,
   `prompt-on-failure-capture`, `activity-feed-watcher`).
4. Update path references in `tests/driver/` and
   `.github/workflows/driver-tests.yml`.
5. Update `CLAUDE.md` § Layout (and Current inventory note).
6. Run the test suite locally: `tests/driver/run.sh`. Iterate
   until passing.
7. Verify `shellcheck` clean on new scripts (the design's
   self-improvement notes name this as a discipline).
8. Commit using conventional-commits style. Suggested shape (use
   judgment):
   - `feat(scripts): top-level scripts/ layout — driver, daemons, systemd units`
   - `feat(skills): driver state machine, prompt-on-failure capture, activity-feed watcher`
   - `chore(driver): retire roles/driver/ in favor of scripts/driver/`
   - `test(driver): update path references for scripts/driver/`
   - `docs(claude): mention top-level scripts/ in Layout`
   One or several commits; aim for review-friendly granularity.
9. Push regular-append: `git push origin HEAD:design/driver`.
10. Post a top-level PR comment on #3 acknowledging the
    implementation, naming the commit SHAs, summarizing what
    landed and what's deferred to Phase 2-5.

## Per-action authorizations

- All file creations, moves, and deletions under `scripts/`,
  `roles/driver/`, `skills/`, `tests/driver/`, `.github/workflows/`,
  and `CLAUDE.md`. Authorized.
- Edits to `.gitignore` for `scripts/daemons/config.sh`.
  Authorized.
- Run `tests/driver/run.sh` locally and any `shellcheck`
  invocations. Authorized.
- One or more commits + regular-append push to
  `kriskowal/garden:design/driver`. Authorized.
- Top-level PR comment on garden #3. Authorized.

## Not authorized

- Touching `roles/` or `skills/` paths beyond what's explicitly
  listed (no scope creep into other roles).
- Enabling or starting any systemd unit (`systemctl` runs are
  for the maintainer at Phase 4).
- Modifying `roles/steward/`, `roles/general-contractor/`,
  `roles/monitor/`, `roles/liaison/`, or any per-project monitor
  skill (all preserved through the migration).
- Un-drafting or re-drafting the PR.
- Force-pushing.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/builder--0ed69c/garden/roles/COMMON.md`
2. `/home/kris/dispatches/builder--0ed69c/garden/roles/builder/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md` (optional;
   the top-level PR comment can use `gh pr comment` directly).
4. Any other skills your role names just-in-time.

Project worktree at `project/` on `design/driver` (head
`b6a1318a`). Base is `main`.

**Important: this PR is on the garden itself.** Garden has no PR
workflow for its own repo as a rule (CLAUDE.md § Conventions);
garden designs are the named exception. The journal-side daemon
resets `/home/kris/journal/` every 30s — do journal writes via
your own `dispatches/builder--0ed69c/journal/` sub-worktree (safe
per memory `feedback_journal_poll_daemon_race.md`).

## Report

A `result` journal entry. Include:

- New head SHA after push.
- Per-commit subject + file change count.
- Local `tests/driver/run.sh` exit code + summary.
- `shellcheck` results on new scripts.
- Top-level PR comment ID.
- Notes on any judgment calls (e.g., rename vs replace for the
  state-machine skill; how you handled `skills/cleaner/` if it
  exists).
- What's deferred to Phase 2-5 (the watchers, the additional
  state-machine skills, gardener-inbox-error-reporting,
  pre-ci-validation).
