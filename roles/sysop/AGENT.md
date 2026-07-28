---
created: 2026-07-28
author: gardener
---

# Role: sysop (NOT a claimable role — a deterministic per-host daemon)

The **sysop** (system operator) is the fleet's host-operations attendant: it
receives **host-directed system operations** over the journal message bus and
executes a **closed set** of them on the host it runs on. Its whole point is to
drive an **unattended follower** — "do X to host Y" — by a message instead of a
human sitting at that host.

**The sysop is deliberately NOT a `roles/` posture you post to the board.** It runs
**no `claude`**, claims no jobs, and reads no free-form prose. It is a
deterministic script + systemd unit, sibling to the watchers under
`scripts/jobs/`, not an `AGENT.md` agent. This file exists only so a reference to
`roles/sysop/` resolves, and to point you at the real artifacts. Making the sysop a
claimable role was **considered and rejected** ([`designs/sysop.md`](../../designs/sysop.md)
§10): a role runs `claude -p` on a job body — exactly the LLM-on-host-ops surface
the design forbids — and the board cannot pin a job to a host, so a claimed sysop
job could run on the wrong host.

## The real artifacts

| artifact | what it is |
| --- | --- |
| [`scripts/jobs/sysop.sh`](../../scripts/jobs/sysop.sh) | the daemon: reads `host/<GARDEN>`, gates, dispatches the closed op set, acks. No LLM anywhere in the path. |
| [`scripts/jobs/send-host-op.sh`](../../scripts/jobs/send-host-op.sh) | the operator/liaison sender: `send-host-op.sh <GARDEN> op=… key=…`. |
| `scripts/systemd/garden-sysop.{service,timer}` | the per-host unit — enabled on **every** host by `install-units.sh` (NOT leader-gated). |
| [`designs/sysop.md`](../../designs/sysop.md) | the design of record: the gap, the invariants, the closed vocabulary, the trust model. |

## The closed operation vocabulary (the whole of what the sysop can do)

Each op delegates to an **existing, hardened, same-host tool** — the sysop adds
*addressing and a trust gate*, not new privileged mechanics. Two tiers:

- **Benign** (issuer gate only): `set-workers` (→ `set-workers.sh`), `drain`
  (→ `drain-fleet.sh`), `reset-failed` (→ `systemctl --user reset-failed 'garden-*'`),
  `restore` (reset-failed + `reaper.sh` + `deadmail.sh`).
- **Destructive** (issuer gate + maintainer attestation): `unit`
  (start/stop/restart an installed `garden-*` unit, never `garden-sysop.*` itself),
  `deploy` (→ `deploy-garden.sh`).

An unrecognized `op:` is **refused and logged, never guessed at**. There is no
`op: shell`/`op: run`/passthrough. Widening the set is a deliberate design act (a
new op row + grammar + tier), never an open-ended `exec`.

## Trust gate (deterministic, before execution — no LLM)

The honest boundary is journal-push access (the whole fleet); `from_host` is
self-asserted. On top of it the sysop adds defense-in-depth, in the shape of the
mention-watcher / issue-inbox gates:

1. **Issuer confinement** (all ops): `from_host` must be on the journal
   `config/sysop-issuers` (default: the **leader** identity). A stray op from an
   unexpected host is inert **and visible** (logged + acked refused).
2. **Maintainer attestation** (destructive tier): the message must carry
   `authorized_by: <login>` with `<login>` on `maintainers/allowlist`. Attestation,
   not authentication — its value is that the irreversible tier cannot be triggered
   by *accident*, only by a message that deliberately names a maintainer.

## Definition of done (for a change to the sysop)

- The op set stays closed; no op ever takes or runs a command string from a message.
- No `claude`/LLM is ever invoked on message content.
- Every accepted op, refusal, and parse failure is recorded to
  `sysop-log/<GARDEN>/<msgid>.md` (audit trail + idempotency belt) and acked to the
  sender, so "done" is distinguishable from "never arrived".
- Every op is idempotent; a replayed message never double-applies.
- The unit runs on **every** host (not leader-gated) and **still ticks under drain**
  (so a drained host can always receive `drain off`).
- Tests under `scripts/jobs/test/sysop-test.sh` stay green.
