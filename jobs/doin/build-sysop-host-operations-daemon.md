---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T07:37:12Z -->

role: builder
# Build the sysop: per-host daemon + host/<GARDEN> bus addressing, per designs/sysop.md

Maintainer directive (kriskowal, 2026-07-28). Implement the design landed by the
predecessor child `design-sysop-host-operations-daemon` — **read
`designs/sysop.md` first and follow it**; it is the contract for this build. If the
design is missing or contradicts this body, STOP and report rather than improvising a
security-sensitive daemon.

Garden repo, `main2`, **DIRECT push, NO PR** per CLAUDE.md § Conventions.

## Scope

1. **`host/<GARDEN>` bus addressing** — extend `scripts/jobs/send-msg.sh` and
   `scripts/jobs/read-msgs.sh` to accept it alongside `role/`, `job/`, `broadcast`.
   Preserve the existing single-path-segment validation exactly: a relpath must not
   be able to escape `msgs/`. Keep the angle-bracket placeholder-unwrapping path
   working for the new kind too.
2. **`scripts/jobs/sysop.sh`** — deterministic, plain code, **no `claude -p`, no LLM
   anywhere in the path**. Reads this host's `host/<GARDEN>` address, parses each
   message against the CLOSED operation vocabulary from the design, applies the trust
   gate BEFORE execution, executes via the existing scripts (`set-workers.sh`,
   `drain-fleet.sh`, …) rather than reimplementing their logic, acks per the design.
   An unrecognized op is refused and logged, never guessed at.
3. **`scripts/systemd/garden-sysop.{service,timer}`** — installed and enabled by
   `install-units.sh` on EVERY host. **Not** gated by `is-main-host.sh`: an
   unattended follower is the whole point. Wrap with `self-heal-run.sh` like its
   siblings.
4. **`roles/sysop/AGENT.md`** — purpose, skills, operating norms, definition of done,
   per CLAUDE.md § Adding a role. Update the CLAUDE.md role index and the § Job system
   singleton/every-host discussion so the leader/follower inventory stays accurate.

## Hard constraints (from the design; restate, do not relax)

- **Never** execute arbitrary shell or a command string taken from a message.
- **Never** run an LLM on message content — the gate is deterministic code, before
  execution, in the shape of the mention-watcher / issue-inbox gates.
- **Never** touch credentials, perform a ferry, or originate `identity_switch_authorized`.
- **Never** run git with `$GARDEN_ROOT` as the enclosing repo (root-repo-guard class
  of corruption); honor `GIT_CEILING_DIRECTORIES`.
- **Preserve** `set-workers.sh`'s cross-host refusal. The sysop satisfies that guard
  by running ON the target host — it must not bypass it.
- **A drained host must still accept `drain off`**, or the fleet becomes wedged
  undrainable. Regression-test this specifically.
- Ops are **idempotent**: a replayed or duplicated message must not double-apply.

## Tests + verification

Tests under `scripts/jobs/test/` covering at minimum: `host/<GARDEN>` round-trip
send→read; path-escape attempt rejected; each vocabulary op applied correctly;
unknown op refused; untrusted sender refused; replayed message not double-applied;
drained host still honors `drain off`; the unit is enabled on a follower host.

Run the CI-equivalent checks LOCALLY before pushing — a CI failure is a defect in our
automation, not something to discover in CI.

## Definition of done

A maintainer on host A can direct an operation at host B and have it execute on B
with no attended liaison on B, with an ack that distinguishes "done" from "never
arrived". Demonstrate with the motivating case end to end: set another host's
`gardeners:` count from a different host, and show the target's `hosts/<GARDEN>`
updated and its pool reconciled. Report the trust model you implemented and any op
you deliberately left out of the first vocabulary.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-28T07:39:23Z
