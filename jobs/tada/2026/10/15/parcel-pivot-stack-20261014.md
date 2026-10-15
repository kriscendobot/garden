Pivoted the full SturdyRef stack to Parcel and force-pushed each restacked PR in place, following [stacked-pr-build](/home/kris/garden/skills/stacked-pr-build/SKILL.md) and [rebase-before-followup](/home/kris/garden/skills/rebase-before-followup/SKILL.md).

Implemented the designed `InitialParcel`/`SharedParcel`, `isParcel`, location/open APIs, pass-style and marshal support, CapTP/OCapN transport, daemon formula Parcels, and updated design documentation. Preserved and test-pinned the `ocapn-sturdyref` wire tag. Lockfile updates remain separate commits.

| PR | New title | Head SHA | CI state |
|---|---|---|---|
| #774 | feat(parcel): add the first-wins Parcel shim and open API | `98a09fa5f6d8b5ef6b51f940bb6b9700734402b1` | Pending, 0 failures |
| #1391 | feat(ses): derive shared Parcel without location authority | `0f9d0cdb4eed6de98408f4bf671821132f43df50` | Pending, 0 failures |
| #1392 | feat(pass-style): recognize Parcel as passable | `283927ab62ce0a7085aadf645037b272497802af` | Pending, 0 failures |
| #1393 | feat(marshal): encode Parcel locations inline | `d4f9539f4d8076b7c52a890634b4cbdf30cdc8c4` | Pending, 0 failures |
| #1394 | feat(captp,ocapn): carry Parcel inline and preserve the OCapN wire tag | `6d089a6a31b3e1961ee2f4be36d66690f7a9eb85` | Pending, 0 failures |
| #1396 | feat(captp,ocapn): construct and forward Parcels from locations | `3202ecdd9e5596f842ea809b1f68a3d750fd300f` | Pending, 0 failures |
| #1397 | fix(ocapn): open returning Parcels through bootstrap and nonce | `9fda212be10fe5ee85964234f13fd8d52f0aab8a` | Pending, 0 failures |
| #1398 | feat(daemon): create dormant formula Parcels without incarnation | `35ccea8bd607a32f6c3a0cd5ac6cb35c243206f6` | Pending, 0 failures |
| #1399 | design(parcel): define the daemon Agent API | `bd6265772be801c3047a4e789afa95dd4e445694` | Pending, 0 failures |

All PRs retained their prior draft state; #1394 remains non-draft. Each PR has a design-linked summary comment and its normal gauntlet staged.

Validation passed: composite type build, formatting/diff checks, relevant lint and documentation generation, Patterns rank-cover tests, OCapN Parcel tests, and the complete Thixotrope suite across configured SES environments. The working tree is clean.

Follow-up: legacy design/bridge PRs #695, #697, and #698–#704 were intentionally left untouched; protocol-level historical SturdyRef terminology remains where required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/parcel-pivot-stack-20261014.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 6284s

<!-- garden-usage-end -->
