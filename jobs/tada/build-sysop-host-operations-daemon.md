Still green (34/34) on the merged tree. The build is complete and landed on `main2`.

<<<REPORT>>>

## Completion report: build the sysop (per-host host-operations daemon)

Implemented `designs/sysop.md` in full and pushed directly to `main2` (commit `3f44c0c813`, no PR, per CLAUDE.md § Conventions), rebasing over a concurrent commit to land.

### What I built
- **`host/<GARDEN>` bus addressing** — added the fourth address kind to `send-msg.sh` (both the main grammar and the angle-bracket placeholder-unwrap path) and to `read-msgs.sh`. Both reuse the **existing single-segment guard unchanged**, so a `host/../../x` path-escape is rejected on the send *and* read paths.
- **`scripts/jobs/sysop.sh`** — deterministic, **no `claude`/LLM anywhere**. Reads `host/<GARDEN>`, applies the trust gate *before* execution, dispatches the closed vocabulary (`set-workers`, `drain`, `reset-failed`, `restore`, `unit`, `deploy`) by **delegating to the existing hardened same-host tools** (never reimplementing them), and acks + records `sysop-log/<GARDEN>/<msgid>.md`. Idempotent via an out-of-journal seen cursor plus a committed sysop-log belt; an unknown op is refused, never guessed.
- **`scripts/jobs/send-host-op.sh`** — the operator/liaison sender.
- **`garden-sysop.{service,timer}`** — enabled on **every host** by `install-units.sh` (no `is-main-host` gate), self-heal-wrapped, absolute `OnCalendar` schedule, and **ticks even under drain**.
- **`roles/sysop/AGENT.md`** + CLAUDE.md role index and § Job system every-host discussion.

### Trust model I implemented
- **Issuer confinement (all ops):** `from_host` must be on journal `config/sysop-issuers` (default: the leader). A stray op is inert *and visible* (logged + acked refused).
- **Maintainer attestation (destructive tier — `unit`, `deploy`):** message must carry `authorized_by:` on `maintainers/allowlist`. Attestation, not authentication (a compromised issuer could forge it) — its value is the irreversible tier can't fire by accident.
- Hard invariants preserved: no arbitrary shell, no credential touch, no ferry/identity-switch, no git in `$GARDEN_ROOT`, `set-workers.sh`'s cross-host refusal **satisfied by running on the target** (never bypassed).

### One deliberate deviation (flagged)
The job scope asked for `roles/sysop/AGENT.md` "per § Adding a role," but the design (§2, §9, §10) is emphatic and repeated that the sysop is **not a claimable role** — a role runs `claude -p` on a job body, exactly the LLM-on-host-ops surface the design forbids, and §10 explicitly *rejects* that alternative. I reconciled this the way `judge`/`monitor` are handled: a **non-postable redirect stub** that documents the daemon and points at the real artifacts, and updated the CLAUDE.md inventory to match. This honors the directive's documentation/inventory intent without contradicting the security design.

### Op deliberately narrowed
`deploy`'s optional `to_sha` pin is implemented as a best-effort advisory guard (validated 40-hex; compared to `origin/main2` via `ls-remote` when resolvable) rather than threaded into `deploy-garden.sh`, which takes no sha arg — deploy delegates to the sanctioned mover unchanged. Everything else in the §4 vocabulary is fully implemented.

### Verification (CI-equivalent, local)
- **`sysop-test.sh`: 34/34** — round-trip send→read, path-escape rejected, each op applied, unknown/parse refused, issuer gate, replay not double-applied, **drained host honors `drain off`**, destructive tier refused without attestation, unit self-preservation, follower-enabled + no leader gate + no drain guard, no-claude, and the **DoD end-to-end** (set host B's `gardeners:` from host A → `hosts/B` shows `gardeners: 2` written *by B itself*).
- **`enable-services-test.sh`: 37/37** (garden-sysop auto-integrated), **`producer-body-hang-test.sh`: 34/0**, `run-test.sh` **MESSAGE BUS** subtest fully green, `bash -n` clean on all scripts, `claude-md-inventory-drift` gate green.
- The only firing grep-gate (`maintainer-inbox-information-hiding`) and the unrelated `run-test.sh` FAILs (foreman fill-batch, gh-wrapper shellcheck, git-corruption classifier, declined-blocker) are **pre-existing at HEAD in files I never touched** — verified none reference my changes.

### Follow-ups (not blocking)
- The `maintainer-inbox-information-hiding` gate is red on `main2` independent of this change (leaks in `botanist`/`orchestrator`/`prosecutor`/`COMMON.md`/`restore`/…). Worth a separate scrub-or-allowlist pass.
- Real-host smoke: once deployed, confirm `garden-sysop.timer` enables fleet-wide and exercise a live `set-workers` from one host to another.
