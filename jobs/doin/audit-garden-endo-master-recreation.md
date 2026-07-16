# Audit & de-fang: the garden must never recreate the mutable endo-but-for-bots `master`

**Goal (maintainer directive 2026-07-16):** stop the garden from recreating / hard-re-mirroring
the **mutable** `master` branch of `endojs/endo-but-for-bots`. That re-mirror silently drops
fork merge-commits and is the root cause of the "errantly-merged-to-master" cleanup — it has
already wiped PRs #67 and #84 from `master`, with more on borrowed time. Going forward the garden
should **only ever create a frozen `master-<hash>` anchor branch** (e.g. `master-eecc683`) to
anchor an upstream base — never push to, mirror, or recreate the mutable `master`.

This is a **garden-meta change to the garden's OWN repo** (`kriskowal/garden`, branch `main2`):
commit directly to `main2`, **no PR / no gauntlet** (garden convention — we do not open PRs
against ourselves). It deploys via the deliberate-deploy path.

## Part 1 — audit and remove the master-mirror behavior (garden scripts, main2)
- Start at **`scripts/jobs/clone-keeper.sh`** (see its §~L96-101 describing the `master`
  "passive upstream-mirror of endojs/endo"). Trace and enumerate **every** place the fleet
  fetches/pushes/creates/updates the mutable `master` of `endojs/endo-but-for-bots` (grep for
  `master`, `:master`, `refs/heads/master`, `HEAD:master`, `mirror`, `re-mirror`, fetch/push of
  upstream `endojs/endo` onto a fork `master`). Check `clone-keeper.sh`, `triager.sh`, and any
  clone/sync helper.
- **Remove** the behavior that maintains/recreates the mutable `master`. **Preserve** the ability
  to create a **frozen `master-<hash>` anchor branch** (the sanctioned artifact for anchoring an
  upstream base) — only the mutable-`master` mirror/recreate is excised. If anchor-branch creation
  and master-mirroring are entangled in one code path, split them so anchors still work.
- Verify by grep that no residual path pushes/recreates the mutable `master`, and reason through
  that anchor-branch creation is intact. Commit to `main2` with a message explaining the removal
  and citing this cleanup.

## Part 2 — branch protection on endo-but-for-bots `master` (block direct pushes)
- Add a branch-protection rule on **`endojs/endo-but-for-bots` `master`** that **blocks direct
  pushes** (require a pull request before merging, or lock the branch). Suggested:
  `gh api -X PUT repos/endojs/endo-but-for-bots/branches/master/protection` with
  `required_pull_request_reviews`, `enforce_admins` as appropriate, `restrictions: null`, or a
  branch lock — choose the minimal rule that blocks unmediated pushes to `master`.
- **If the bot identity lacks admin permission** on the repo, do NOT force it: surface to the
  maintainer via `scripts/jobs/message-user.sh <your-base>` with the exact API call / settings
  needed, and report it in the `tada`. This half may be maintainer-gated.

## Norms
- Garden-meta change: `main2`, no PR. Careful surgical removal — do not break anchor-branch
  creation or unrelated clone-keeper duties. ASCII prose; fully-qualified references.

## Done
`main2` no longer contains any behavior that recreates/mirrors the mutable
`endojs/endo-but-for-bots` `master` (only `master-<hash>` anchor creation remains), verified by
grep; branch protection blocks direct pushes to `endo-but-for-bots` `master` (or a precise
maintainer-action note if the bot lacks admin). The `tada` report lists every script changed, the
exact behavior removed, and the branch-protection state.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  worker_kind: cleric
  claimed_at: 2026-07-16T23:02:17Z
