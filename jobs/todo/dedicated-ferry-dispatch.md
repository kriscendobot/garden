---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Dedicated ferry dispatch: a host-native boatman loop, off the generic job board

Maintainer directive (kriskowal, 2026-09-18). The boatman currently claims
`ferry` jobs off the ordinary job board (`jobs/todo/`) like any other role —
read `roles/boatman/AGENT.md` in full first; it is the source of truth for
every safety invariant this change must PRESERVE while relocating WHERE and
HOW a ferry gets dispatched. Nothing about the credential surface, host
preconditions, or per-action authorization changes here — only the dispatch
mechanism.

## 1. A dedicated board: `journal/jobs/ferry/`

A new sibling to `jobs/todo/doin/tada/plan/withdrawn/` — one file per ferry
directive, e.g. `journal/jobs/ferry/<name>.md`. Each file names a PAIR:
- **downstream** (the garden-side PR being ferried FROM): repo + PR number.
- **upstream** (the governance repo being ferried TO): repo + base branch
  (and PR number once opened — a fresh ferry may not have one yet).

Carry forward every field `roles/boatman/AGENT.md` § Job inputs already
requires (`human` name+email, `identity_switch_authorized: true`,
optional `convention`) — same fields, new home. `identity_switch_authorized`
is written ONLY by the maintainer, same as today; nothing about who may
originate it changes.

Design the file's own lifecycle (a claimed/in-progress marker, a
completed/archived bucket — mirror the existing todo→doin→tada shape in
spirit, e.g. `journal/jobs/ferry/done/` or similar, your call on the exact
shape) so a concurrent run of the loop (§ 2) can't double-dispatch the same
entry, and so a completed ferry leaves a durable record the way `tada/`
does today — don't lose that audit trail moving off the generic board.

## 2. `scripts/ferry.sh` — a HOST-NATIVE loop, Mac-compatible bash

Modeled explicitly on the repo-root `garden` launcher script (read it first
— same spirit: a script a maintainer runs directly on their own machine,
outside the container). `scripts/ferry.sh` is the loop that watches
`journal/jobs/ferry/` for new entries and, for each one, dispatches
`claude -p` in non-interactive/auto mode (grep the existing `claude -p`
invocation shape already used by `scripts/jobs/handlers/monk-claude.sh` for
the established flags rather than inventing new ones) running the boatman
role against that specific entry — **from outside the garden container,
on the host, using the operator's own ambient git/gh session** (no bot
identity pin, no `GARDEN_GH_IDENTITY` override — this path never touches
the fleet's `gh` wrapper at all, since it isn't running inside the
container's PATH).

**Bash dialect constraint, load-bearing**: this script must run under
macOS's stock bash (3.2, not bash 4+) and BSD coreutils, not GNU. Concretely
avoid: associative arrays, `mapfile`/`readarray`, `${var,,}`/`${var^^}` case
conversion, GNU-only `date -d` (BSD `date` needs `-j -f`), GNU-only
`sed -i` without a backup-suffix argument (BSD requires one), `readlink -f`
(not on BSD by default). Test your assumptions against what's actually
POSIX/BSD-portable, don't assume Linux GNU coreutils are present. This is
the same class of constraint `context/first-run/README.md` and the
container-guard design already grapple with for cross-platform hosts — read
those for precedent if useful, but this script specifically must work
UNMODIFIED on a maintainer's Mac.

Preserve every existing boatman safety step from `roles/boatman/AGENT.md`
inside what the dispatched `claude -p` actually does: host preconditions
(`gh auth status` shows kriskowal, push-permission check), human-author-
every-commit (strip bot trailers), the `git -c user.name=... commit`
per-commit override pattern, the garden-side cross-link comment + mirror
record, contribution-convention discovery. None of that logic should be
lost or weakened — it's being re-triggered by a different mechanism, not
rewritten from scratch.

## 3. Lock the boatman OUT of the normal job board — mechanically, not just by doc

"It is important that this is the ONLY kind of job dispatch the boatman can
receive and handle" (maintainer, verbatim). This must be an enforced
invariant, not a convention an agent might forget — per the garden's own
standing principle (move a responsibility off an agent into code, the same
reasoning `comment-provenance.sh`'s header cites). Concretely: add a
deterministic guard in the generic claim path (`claim-job.sh` and/or
`gardener.sh`) that REFUSES to claim any job whose frontmatter carries
`role: boatman` — fail loudly (a clear error/alert), never silently drop it.
Update `roles/boatman/AGENT.md` itself to state plainly that it is reached
only via `scripts/ferry.sh` / `journal/jobs/ferry/`, never the board.

## 4. The liaison recognizes "ferry" / "boatman" as an indirect duty

Update `roles/liaison/AGENT.md` (and the CLAUDE.md § Orchestrator vocabulary
table's `ferry #N` row, which currently describes posting a job to the
generic board — that description is now WRONG and must change) so that the
liaison's response to the verb "ferry" or a reference to the "boatman" role
is: write an entry into `journal/jobs/ferry/` (per § 1's shape), NEVER
`post-job.sh`, NEVER `Agent`/direct subagent dispatch. The liaison performs
this duty only indirectly — it stages the ferry entry; `scripts/ferry.sh`,
run by the maintainer on the credentialed host, is what actually executes
it. Make this distinction unambiguous in the doc: the liaison cannot cause
a ferry to run, only queue one for the maintainer's own script to pick up.

## Explicitly out of scope / do not do

- Do not grant the container or the bot identity any new credential access.
  The credential surface is unchanged — still the one host that already
  holds kriskowal's `gh`/git session, per the existing host-precondition.
  This change relocates DISPATCH, not CREDENTIALS.
- Do not weaken `identity_switch_authorized`'s maintainer-only origination.
- Do not silently migrate/withdraw any currently in-flight ferry job on the
  old board path — if one exists, flag it in your report rather than
  guessing how to carry it over.

## Report

What you built, the exact shape of a `journal/jobs/ferry/<name>.md` entry
(with a real example), confirmation `scripts/ferry.sh` was tested for
bash-3.2/BSD portability (how — a `bash --posix`/explicit-version check,
or actual access to a Mac to verify; say which), and confirmation the
claim-path guard actually refuses a stray `role: boatman` board post (a
real test, not just code review).
