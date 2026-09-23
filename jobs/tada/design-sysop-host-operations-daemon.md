The design is committed and pushed to `main2` (`d92dfa9f3b`).

## Completion report

**What I did.** Landed `designs/sysop.md` — a design-only doc for the **sysop**, a per-host systemd daemon that receives host-directed system operations off the journal bus and executes a closed set of them on the host it runs on. Grounded every reference in the actual codebase (verified `send-msg.sh`'s address grammar and single-segment guard, `set-workers.sh`'s cross-host refusal, `read-msgs.sh`'s out-of-journal cursor, `drain-fleet.sh`, `deploy-garden.sh`, `is-main-host.sh`, `install-units.sh` rendering, the `mention-watcher`/`issue-inbox` sender gates, and `common.sh` helpers/markers).

**What the doc decides** (all seven required decisions + gap analysis + preserved invariant + out-of-scope):
1. **Name** — `sysop`, chosen over `operator` (which collides with `orchestrator`); it's a script+unit, not a `roles/` role.
2. **Addressing** — a new `host/<GARDEN>` bus kind reusing the existing one-segment `[A-Za-z0-9._-]` guard unchanged; read via the topic mechanism (`read-msgs.sh sysop-<GARDEN> host/<GARDEN>`) with a reset-hard-proof host-local cursor.
3. **Op vocabulary** — a closed set (`set-workers`, `drain`, `reset-failed`, `restore`, `deploy`, `unit`) with exact key:value grammar, bounds, and per-op "may NOT"; each delegates to an existing hardened same-host tool. No `op: shell`/passthrough.
4. **Refusals** — six hard invariants (no arbitrary command, no LLM on content, no credentials, no ferry/identity switch, no git in `$GARDEN_ROOT`, deterministic parse-before-execute).
5. **Trust model** — honest about `from:` being unauthenticated; primary boundary is journal-push access (the maintainer's own bots). Consciously *departs* from the issue-inbox/fork-watch login-gate (wrong threat here — no external author, no downstream LLM) and instead uses **issuer-confinement** (`config/sysop-issuers`, default the leader) plus **maintainer-attestation** (`authorized_by` ∈ `maintainers/allowlist`) for the destructive tier; benign ops are reversible/self-healing. Three-layer idempotency.
6. **Unit shape** — `garden-sysop.{service,timer}`, non-templated, **no `is-main-host` gate** (the unattended follower is the whole point), timer/oneshot with self-heal wrapper, **runs even under drain** (else `drain off` is undeliverable → undrainable fleet), and acks-before-restart on `deploy`.
7. **Observability + ack** — journald logs + durable `sysop-log/<GARDEN>/<msgid>.md` audit trail + a bus ack distinguishing applied/refused/parse-error/failed, closing the "done vs never-arrived" gap.

The `set-workers.sh` cross-host refusal is explicitly preserved (the sysop runs on the target host, so writes are same-host by construction), plus §9 out-of-scope and §10 alternatives-considered.

**Follow-ups.** The build is the separate orchestrated child that follows this doc — it writes `scripts/jobs/sysop.sh`, `send-host-op.sh`, the `send-msg.sh` `host/` grammar extension, the units, and the test harness. Two design proposals introduce new per-instance journal config the build must wire and document as arming acts: `config/sysop-issuers` and reuse of `maintainers/allowlist` for destructive attestation.
