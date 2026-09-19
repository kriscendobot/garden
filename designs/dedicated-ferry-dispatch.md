# Dedicated ferry dispatch

| Created | 2026-09-18 |
| Author  | builder (job dedicated-ferry-dispatch) |
| Status  | Implemented |

## Summary

Move the boatman's **ferry** out of the ordinary journal job board and onto a
dedicated board (`jobs/ferry/`) driven by a host-native runner (`scripts/ferry.sh`)
that the maintainer runs on the credentialed host, outside the container. Lock the
boatman out of the generic board mechanically (not by convention) so a ferry can
never be race-claimed by an arbitrary gardener and pushed under the bot identity.
Nothing about the credential surface, the host preconditions, or the maintainer-only
origination of `identity_switch_authorized` changes — only **where** and **how** a
ferry is dispatched.

Maintainer directive (kriskowal, 2026-09-18): "It is important that this is the ONLY
kind of job dispatch the boatman can receive and handle."

## Why

A ferry crosses the identity boundary from the bot account (where gardening happens)
to the human account (which owns reputation upstream). That act must run on the one
host holding the maintainer's `kriskowal` git/gh credentials, and must use the
maintainer's own identity — never the fleet's bot-pinned `gh` wrapper. Dispatching it
as an ordinary board job made that a matter of the boatman role *remembering* to run
on the right host and blocking otherwise. The garden's standing principle is to move
such a responsibility off an agent and into code (the `comment-provenance.sh` /
container-guard reasoning). A ferry is also the highest-consequence, most
identity-sensitive act the garden performs; a generic-board mis-post or an accidental
bot-host claim is exactly the failure mode worth designing out.

## Design

### 1. The dedicated board — `jobs/ferry/`

A sibling to `jobs/{todo,doin,tada,plan,...}` on the journal branch, mirroring the
todo→doin→tada lifecycle in spirit so a completed ferry leaves a durable audit record
and a concurrent run cannot double-dispatch:

- `jobs/ferry/<name>.md` — a pending directive.
- `jobs/ferry/doing/<name>.md` — claimed/in-progress (a `ferry_claim:` stamp appended).
- `jobs/ferry/done/<name>.md` — completed (a `ferry_done:` stamp appended); the audit
  record. A directive that did not complete stays in `doing/` (a `ferry_failed:` note
  appended) for maintainer inspection — never silently retried, never lost.

Each directive names a PAIR — the **downstream** garden-side PR ferried FROM and the
**upstream** governance repo ferried TO — plus every field `roles/boatman/AGENT.md`
§ Job inputs already required, in their new home:

```
---
downstream: kriscendobot/endo-but-for-bots#387   # garden-side PR ferried FROM
downstream_branch: feat-frozen-abc1234           # its head branch
upstream: endojs/endo                            # governance repo ferried TO
upstream_base: master                            # upstream base branch
upstream_pr:                                     # set once opened; a fresh ferry has none
human: Kris Kowal <kris@example.com>             # commit attribution (name + email)
identity_switch_authorized: true                 # MAINTAINER-ONLY; no agent originates it
convention:                                      # optional contribution rules
---
Ferry endojs/endo-but-for-bots#387 upstream to endojs/endo (base master).
```

### 2. `scripts/ferry.sh` — a host-native loop

Modeled on the repo-root `garden` launcher: a script the maintainer runs directly on
their own machine, outside the container. Each pass it syncs its own throwaway clone
of the journal (never the deployed root or `journal/` worktree — it reads their remote
read-only), and for each pending `jobs/ferry/<name>.md`:

1. **Claims** it (move to `doing/`, append a claim stamp, commit + push with a CAS
   retry) — the accepted push is the double-dispatch guard, plus a host-local `mkdir`
   lock against two `ferry.sh` on one host.
2. **Dispatches** `claude -p --dangerously-skip-permissions "$prompt"` (the flag shape
   `scripts/jobs/handlers/monk-claude.sh` already uses) wearing the boatman role,
   from the garden root, **using the operator's ambient git/gh session** — no bot
   identity pin, no `GARDEN_GH_IDENTITY` override, no fleet `gh` wrapper on PATH.
3. On a genuine completion (exit 0 + the boatman emits the completion marker),
   **archives** to `done/`; otherwise records the failure in `doing/`.

The prompt does not re-inline the boatman's safety steps (that would drift); it tells
the dispatched agent to READ and WEAR `roles/boatman/AGENT.md` and states only the
host-native deltas. Every existing safety invariant — host preconditions, human-author-
every-commit + trailer strip, the per-commit `git -c user.name=... commit` override,
the garden-side cross-link comment + mirror record, contribution-convention discovery
— is preserved because it lives in the role brief and is re-triggered, not rewritten.

**Bash dialect (load-bearing): macOS stock bash 3.2 + BSD coreutils.** No associative
arrays, `mapfile`/`readarray`, `${var,,}`, GNU `date -d`, GNU in-place `sed -i`, or
`readlink -f`. Verified with `bash -n`, `bash --posix -n`, and an explicit-construct
grep; exercised end-to-end against a throwaway journal with a fake `claude`.

### 3. Mechanical lockout of the generic board

Three deterministic guards, so the invariant is enforced, not remembered:

- `post-job.sh` refuses a `role: boatman` post (checked after `--role`/template
  normalization) — the friendly early failure.
- `claim-job.sh` refuses to CLAIM a `role: boatman` job on the board (the enforced
  invariant for any path that reaches `todo/` — `post-plan`/`promote`/hand-written):
  it skips the candidate and alerts the maintainer (deduped per base), leaving the job
  visibly unclaimed rather than silently dropping it.
- `gardener.sh` refuses to RUN a claimed `role: boatman` job (defense in depth for a
  pre-guard leftover already in `doin/`): completes it blocked without a handler.

### 4. The liaison's indirect duty

The verb **ferry** / a reference to the **boatman** role means: write a
`journal/jobs/ferry/<name>.md` directive, never `post-job.sh`, never a subagent. The
liaison cannot cause a ferry to run — it only queues one for the maintainer's own
`scripts/ferry.sh` to pick up.

## Out of scope (unchanged)

- No new credential access for the container or the bot identity; the credential
  surface is still the one host that already holds `kriskowal`'s git/gh session.
- `identity_switch_authorized` stays maintainer-only to originate.
- No in-flight ferry job existed on the old board path at implementation time
  (`grep -rl 'role: boatman' journal/jobs/` and `ferry` across `todo/doin/plan`
  returned nothing), so no migration was needed.
