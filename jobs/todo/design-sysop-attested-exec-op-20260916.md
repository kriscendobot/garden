---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design an attested `exec` op for the sysop: deterministic, no-inference execution
of arbitrary shell commands on a target host, driven from another host inside the
garden perimeter. MAINTAINER DIRECTIVE (kriskowal, 2026-09-16).

## The motivating critique (the maintainer's, and it is correct)

The sysop's closed vocabulary is more elaborate in its refusal to do general work
than the threat model justifies, because it is **trivially bypassed by a job
posting**. Worked example from the same session: the liaison wanted a gh token
checked on `endolin-garden-ece02cb4`, the sysop had no op for it, so the liaison
posted `verify-gh-token-endolin-garden-ece02cb4-20260916` carrying
`requires: host=endolin-garden-ece02cb4` — the same host-pin the rolling deploy
uses for canary probes — and got a full-tool gardener on that host. The closed
list constrains one daemon; it does not contain the capability.

What IS genuinely valuable and must be preserved is the sysop's **no-inference**
property: it runs no `claude`, so a host-directed operation is plain bash from
end to end, auditable and reproducible. That property is ORTHOGONAL to the
vocabulary being a short enumerated list. The design should keep the determinism
and drop the pretense that enumeration is the security boundary.

## Decisions already made (do not relitigate)

1. **Keep the named ops, add `exec`.** `set-workers`, `drain`, `reset-failed`,
   `restore` stay as they are, un-attested and benign — they are safe precisely
   because they are narrow, and `drain off` MUST remain reachable on a drained
   host or the fleet is wedged undrainable from the bus. `exec` is added at the
   **destructive tier**, alongside `unit`/`deploy`/`local-model`/`maintain`:
   it requires `authorized_by: <login>` with `<login>` on `maintainers/allowlist`,
   checked BEFORE any parse or execution (the existing gate at sysop.sh:465-470).

2. **The ferry is out of reach by ARCHITECTURE, not by policy.** The maintainer's
   correction, which the design must record and preserve: *the sysop cannot reach
   the boatman. The boatman does not run in a full garden and does not read an
   inbox on the message bus.* `roles/boatman/AGENT.md` puts the human (kriskowal)
   credentials on ONE host, and the boatman's environment sits outside the
   container perimeter the sysop executes in. So an `exec` command cannot perform
   an identity switch or an upstream ferry: the credentials are not present where
   it runs.

   TREAT THIS AS A LOAD-BEARING INVARIANT TO VERIFY AND STATE, NOT AN ASSUMPTION
   TO INHERIT. Confirm concretely that the sysop's execution environment has no
   path to the kriskowal credentials, and write down what would have to change for
   that to stop being true (e.g. landing those credentials on a bot host — already
   flagged in CLAUDE.md as "a separate, security-weighted decision"). The design's
   safety rests on this, so it deserves an explicit paragraph rather than a
   footnote.

## What the design must reckon with

- **Drain asymmetry — the sharpest remaining edge.** `gardener.sh:296` exits
  cleanly while draining; `sysop.sh:77` DELIBERATELY has no such guard, so a
  drained host still ticks. This means the job route cannot reach a drained host
  but `exec` always can. That is not a bypass of an existing capability — it is a
  capability that exists nowhere else: a host the operator deliberately paused can
  be made to run an arbitrary attested command. Decide deliberately whether `exec`
  honors the drain, and justify either answer. (Note the tension: the sysop ticks
  under drain SO THAT `drain off` is always deliverable; that rationale does not
  obviously extend to arbitrary commands.)
- **Issuer.** `from_host` is self-asserted and there is no issuer gate — any
  garden host may originate an op for any other. Attestation is what bounds
  `exec`; say plainly that the attestation, not the origin, is the gate, and that
  journal-push access remains the outer perimeter.
- **Auditing.** Every op is already recorded to `sysop-log/<GARDEN>/<msgid>.md`
  and acked. An `exec` op must record the COMMAND, its exit status, and its output
  (bounded), so the log is sufficient to reconstruct what ran.
- **Idempotency.** Every existing op is idempotent; arbitrary commands are not.
  Say how a redelivered or retried `exec` message is prevented from running twice
  (the msgid is the natural dedup key — confirm the existing machinery suffices).
- **Bounding.** Timeout, output size cap, working directory, environment, and what
  happens to a command that outlives the tick. `maintain` and `local-model`
  already run async outside the tick — see whether `exec` should reuse that shape.
- **The root-repo invariant.** Running git in `$GARDEN_ROOT` corrupts the shared
  journal repo (two incidents, 2026-07-17 and 07-21; the `garden-root-repo-guard`
  timer exists because of them). An `exec` op is an obvious new way to do it by
  accident. Decide whether exec sets `GIT_CEILING_DIRECTORIES` / refuses a cwd of
  `$GARDEN_ROOT`, as the worker spine already does.

## Deliverable

A design under `designs/`, plus the `## Open questions` section if any decisions
genuinely remain for the maintainer — per the repo's carve-out, a design carrying
open questions is opened as a review PR rather than landed bare. Do NOT implement.

Reference: designs/sysop.md (§ Trust model), scripts/jobs/sysop.sh,
scripts/jobs/send-host-op.sh, roles/boatman/AGENT.md (§ Host preconditions),
CLAUDE.md § The sysop.
