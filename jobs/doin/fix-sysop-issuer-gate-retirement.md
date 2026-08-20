---
role: fixer
target: main2
posted_by: liaison (interactive session, maintainer-directed)
posted_at: 2026-08-20
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Retire the sysop issuer gate — garden hosts may command all garden hosts

Maintainer directive (kriskowal, 2026-08-20), verbatim: "the self-declared
authorization for sysops is cute and fancy but ultimately ineffective and a
hindrance. Please dispense with that. Garden hosts can command all other
garden hosts." Recorded for audit at
`msgs/broadcast/20260820T054820Z-7ddb76.md` — read it, it carries the full
rationale (from_host is self-asserted; journal-push access is already the
real boundary; the allowlist adds friction, not security).

This is a garden-self change — lands as a direct commit to `main2` (no PR;
CLAUDE.md § Conventions).

## What to change

**`scripts/jobs/sysop.sh`** — remove the ISSUER GATE entirely:
- `load_issuers()` and `is_issuer()` (currently ~lines 118–149): delete, or
  reduce `is_issuer` to an always-true stub ONLY if some other part of the
  file still calls it structurally — check call sites first and prefer
  deleting the call site cleanly over leaving a vestigial always-true check.
- The gate application before `dispatch_op` (currently ~lines 761–770: `if !
  is_issuer "$from_host"; then OUTCOME="refused" ...`) — remove so every
  correctly-addressed message proceeds straight to `dispatch_op`.
- The `GARDEN_SYSOP_ISSUERS` env seam (line ~94) and its use in
  `load_issuers` — remove along with the function, unless the test harness
  needs an equivalent seam for something else (check
  `scripts/jobs/test/sysop-test.sh` before deleting blind).
- Update the "── Trust model (designs/sysop.md §6) ──" comment block
  (~lines 52–64): remove the "ISSUER GATE (all ops)" bullet; rewrite the
  paragraph to state plainly that journal-push access IS the trust boundary
  and no additional per-op issuer check exists. **Keep the MAINTAINER
  ATTESTATION bullet and its rationale exactly as-is** — this directive does
  NOT touch the destructive-tier attestation gate (`authorized_by:` on
  `unit`/`deploy`/`local-model`/`maintain`). Re-read the `local-model`
  sub-clause ("so the issuer gate alone is not proportionate to the
  consequence") — reword it since it no longer has an issuer gate to be "not
  proportionate to," but preserve its actual point: attestation is required
  for that op regardless.

**`config/sysop-issuers`** (journal, `journal2` branch) — retire the file:
remove it (or replace its content with a short historical note pointing at
this job/the broadcast record, your call — removing is cleaner since nothing
reads it anymore). This is a `journal/` change, a separate commit on
`journal2`, not `main2` — do not conflate the two branches.

**`designs/sysop.md`** §6 — update to match: no issuer gate; journal-push
access is the sole authorization boundary for the non-destructive ops;
maintainer attestation unchanged for the destructive four.

**`CLAUDE.md`** § "The sysop — host-directed system operations on every
host" — currently reads: "Trust is a deterministic gate before execution: an
**issuer gate** confines *which* hosts may originate ops (journal
`config/sysop-issuers`, default the leader), and the **destructive** ops
(...) additionally require maintainer attestation". Rewrite to drop the
issuer-gate clause and state the new model (journal-push access is the
boundary; destructive-tier attestation unchanged). This file is checked into
`main2` and auto-loaded every session — get this edit right, it is the most
visible record of the change.

**`scripts/jobs/test/sysop-test.sh`** — find and remove/rewrite subtests
that assert issuer-gate refusal (a message from a from_host NOT on
sysop-issuers being refused). Do not remove maintainer-attestation subtests
(destructive-op authorized_by checks) — those stay. Add or adjust a subtest
confirming a message from an arbitrary from_host (not the leader, not
previously enrolled) is now ACCEPTED and dispatched for a non-destructive op
(e.g. set-workers), to positively cover the new behavior rather than just
deleting the old negative test.

## Verification

Run the sysop test suite (`scripts/jobs/test/sysop-test.sh` and the
integrated `run-test.sh` if it includes sysop subtests) and confirm green
before committing. `bash -n` + `shellcheck` clean on `sysop.sh` per the
usual bar.

## Do not touch

- Maintainer attestation (`authorized_by:` / `maintainers/allowlist`) for
  `unit`/`deploy`/`local-model`/`maintain` — unchanged, still required.
- The ferry / identity-switch exclusion from the sysop vocabulary —
  unchanged, permanently out of scope, not mentioned by this directive.
- `set-workers.sh`'s own cross-host-write refusal (the host only ever
  writes its OWN `hosts/<host>` record) — that mechanism is unrelated to the
  issuer gate and stays exactly as-is; it is what makes the op host-scoped
  once it reaches the right sysop, not what gates who may reach it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-20T05:49:07Z
