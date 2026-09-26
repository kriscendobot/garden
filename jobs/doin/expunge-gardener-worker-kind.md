---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (kriskowal, 2026-09-26): "gardener" is the legacy name for
the "monk" worker kind (Anthropic/Claude), and this ambiguity is causing real
confusion (it showed up as a misleading extra column in a fleet balance-status
table). Complete the "staged, reversible cutover" the codebase already
describes but never finished:

    scripts/jobs/common.sh:1129-1134 — "The Anthropic-backed gardener... `monk`
    is the CANONICAL Anthropic worker kind; the `gardener` row below is the
    LEGACY... so the staged, reversible cutover can flip a host from the
    garden-gardener@ pool to garden-monk@ one at a time"

Ground yourself in the current state first — `grep -rn "gardener" scripts/jobs/
scripts/systemd/` and read `common.sh` around lines 1111-1160, 1313-1340,
1470-1500, 8260-8360 (worker_kinds, worker_kind_field, native_anthropic_kind,
anthropic_active_kind, the default-kind arg-parsing fallback, gardener_*
wrapper functions) before changing anything.

## What "gardener" must mean going forward (the maintainer's framing)

- **"Gardener" is NEVER again a worker-kind name.** Not a declarable count key,
  not a systemd unit template, not a claim/event `worker_kind:` value.
- **"Gardener" is reserved for two things only:**
  1. The generic/umbrella term for "any variety of worker" (already how
     CLAUDE.md's prose uses it — "the gardener fleet", "a host runs a pool of
     gardeners (~20)" — that usage is CORRECT and should NOT change).
  2. The specific `gardener` ROLE (`roles/gardener/AGENT.md`) responsible for
     evolving the garden's own library — also already correct, don't touch.
- The worker-kind varietals are, and remain: monk, cleric, mystic, hermit,
  fireworker, openrouter, openrouter-promo, opencode-anthropic, friar — monk is
  the sole Anthropic/Claude one; there is no separate "gardener" varietal.

## Verified today, before this job was posted (do not re-derive, just confirm still true)

- No host currently runs live `garden-gardener@*.service` capacity — checked
  on endolin-garden-ece02cb4: the unit is `loaded inactive dead`, only
  `garden-monk@1.service` is `active running`. `anthropic_active_kind`'s
  "monks: wins, else legacy gardeners:" logic was already correctly
  preferring monk everywhere checked.
- All three live hosts (endolin-garden-ece02cb4, endolin-garden2-5bcdff64,
  oros-studio-garden-ce242c49) have already had `gardener` zeroed in their
  `hosts/<host>` record (`set-workers.sh gardener 0`, run directly on the
  first, dispatched via the sysop `set-workers` host-op to the other two) —
  so this is a **code/schema cleanup**, not a live-capacity migration. Verify
  this landed (the sysop-log acks) before assuming it; the two remote
  dispatches raced a push once but both eventually reported sent.

## What to do

1. Remove `gardener` from `worker_kinds()` and every place that special-cases
   it as a distinct declarable kind (`worker_kind_field`, `native_anthropic_kind`,
   `anthropic_active_kind`'s dual-read, the `hosts/<host>` schema comments).
2. Fix the default-kind arg-parsing fallback (`common.sh` ~line 8282, currently
   `*) kind="gardener"`) to default to `monk` instead.
3. Retire `garden-gardener@.service` (and its `.timer` if one exists) — confirm
   zero references to it remain live in install-units.sh/systemd templates
   before removing the file, and confirm via `systemctl --user list-unit-files`
   on whichever host you're building on that nothing still enables it.
4. Update every comment describing "gardener (legacy alias)" / "staged,
   reversible cutover" to past tense — the cutover is complete, not staged.
5. `hosts/<host>` records: confirm the `gardeners:` line is gone/zeroed on all
   three live hosts (verified above); if any drifted since, note it rather than
   silently re-writing another host's record (only the owning host may write
   it — use the sysop `set-workers` op again if needed, never a direct write).
6. Sweep for any other "gardener" worker-kind reference this job's own grep
   turns up that the list above didn't anticipate — the codebase is large;
   treat the grep as a checklist, not a ceiling.
7. Do NOT touch: `roles/gardener/AGENT.md`, the "Roles" list in CLAUDE.md, or
   any prose using "gardener"/"gardeners" in the generic-worker-pool sense
   (CLAUDE.md's Job system section, roles/liaison/AGENT.md, etc.) — those
   already match the reserved meaning and are correct as-is.
8. Regression coverage: there's almost certainly an existing test suite
   covering worker-kind resolution (`grep -rl gardener scripts/jobs/test/`) —
   update it to match, don't just delete gardener-kind test cases without
   understanding what they were protecting.

Land direct to `main2` per CLAUDE.md's garden's-own-repo convention (no PR)
unless you land it with open questions, in which case follow the PR carve-out.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-26T17:27:26Z
