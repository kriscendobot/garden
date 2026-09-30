## Completion report: `retire-gardener-worker-kind-alias-verify-docs`

The gate passes, but the follower check is indirect evidence rather than a direct look. The docs are updated, and the commit is on `main2` as `d259a24e6f9`.

### 1. Gate re-verification on `endolin-garden2-5bcdff64`
- **Retirement is deployed there.** The follower's `fleet/deployed` record says it runs `c63c16cad57`, which contains `02513cd130f` (checked with `git merge-base --is-ancestor`). Every deploy runs `install-units.sh install` and `enable-services`, and those prune `RETIRED_UNITS`, so `garden-gardener@.service` is removed on deploy.
- **Unit health is clean.** `fleet/health` shows `unit_failures: 0` out of `unit_total: 270`. Its sysop applied `set-workers monk=1/2/3` against the monk pool today (`sysop-log` 19:50–20:20Z).
- **`journal/hosts/*`** have no `gardeners:` line on any of the three hosts.
- **What I could not check directly:** the follower's own `systemctl` unit list and its `$GARDEN_STATE/gardeners/`. The sysop has no read-only inventory op and that host's filesystem isn't mounted here. Nothing indicates a live legacy unit or marker. No current code writes or reads `state/gardeners/` any more, so any leftover there is inert. No attested `unit` op was needed, and I sent no message to the maintainer.
- **This host (`endolin-garden-ece02cb4`)** still had an inert `.garden-state/gardeners/`: 102 `N.garden` identity files and one empty dir, with no busy markers or clones. I looked through it and removed it.

### 2. Changes (commit `d259a24e6f9`)
- **`designs/anthropic-worker-kind-monk.md`:**
  - The Status row now reads "Implemented — stages 0–2 complete", citing `02513cd130f` and child 1's `70b6d1e3d42`.
  - There is a new *Implementation status (2026-09-30)* section. It records that v1 `worker_kind: gardener` records (no schema, or schema 1) still decode to `monk` through `canonical_worker_kind`, while a v2-schema `gardener` is rejected.
  - It also records that `reputation-reduce.sh` now writes only `reputation/arms/monk/…`. `reputation/arms/gardener/` is a snapshot frozen since 2026-09-27 that nothing reads, and it can be deleted.
  - The section includes the fleet verification above. The old 2026-08-16 text is kept, labelled as historical.
- **`scripts/jobs/state-clone-keeper.sh`:** `02513cd130f` had dropped `gardeners` from the kinds the keeper sweeps, which would have left any `$GARDEN_STATE/gardeners/<id>/journal` clones on hosts behind forever. I put it back as a retired kind that never counts as live, so the keeper's idle, process and lock checks clean up those clones on every host, including the follower once this deploys. A dry-run on this host was clean.
- **`skills/restore/SKILL.md`:** replaced the deleted `set-gardeners.sh` and the `garden-gardener@*` commands with `set-workers.sh monk|cleric` and `garden-monk@*` / `garden-cleric@*`.
- **`scripts/jobs/install-units.sh`:** fixed a code comment, not behaviour: `scale` defaults to monk, not gardener, and I repaired a garbled sentence.
- **Docs sweep:** `CLAUDE.md`, `README.md`, `context/operations/starting.md`, `context/first-run/auth.md` and `context/operations/scaling.md` had no stale alias mentions. Where they say "gardener", they mean the generic role, which is still correct. The `gardeners:` lines in `skills/model-selection` describe the past and are accurate, so I left them.

### Follow-ups (not done)
- Deleting the frozen `journal/reputation/arms/gardener/` tree (92 files) is optional.
- Several older `designs/*.md` still mention `set-gardeners.sh`, `garden-gardener@` and `gardener-claude.sh`. They are records of past designs, so I left them alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/retire-gardener-worker-kind-alias-verify-docs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2456857 cached reads)
- Output: 16099 tokens
- Cost: $1.5520393999999997
- Wall-clock: 241s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
