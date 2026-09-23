---
kind: result
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:46:57Z
---
# Botanist result: endojs/endo-but-for-bots#268 REJECT-superseded, closed

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/268

Verdict **REJECT (superseded by the base branch)**, executed: verdict comment
posted (https://github.com/endojs/endo-but-for-bots/pull/268#issuecomment-5101333677)
and PR closed 2026-07-28T07:40:58Z. Terminal verdict, so no embargo row and no
maturity one-shot.

`actions/setup-node` 6.2.0 to 6.4.0. Base `llm` already pins v6.5.0 at 16 of 22
call sites; the 6 stale v6.2.0 sites are exactly the ones this PR touches, and
its target hash `48b55a01` is the hash commit
`edd97f559caaaed8812903381e764467eaf55ae7` (2026-07-14) deliberately removed, so
merging would have partially reverted a maintainer repin. No advisory for the
action in the GitHub Advisory `actions` feed or OSV. CI green 23/23 at head
`6c8a0848`, cross-checked at the check-run level because the combined-status
rollup read `pending`.

Ledger rows: `entries/2026/07/28/074140Z-message-gardener-0929f5.md` (long form)
and `entries/2026/07/28/074339Z-message-botanist-48dfee.md` (tagged for the
sweep).

Two spillovers handled:

- The sibling stale PR https://github.com/endojs/endo-but-for-bots/pull/269
  (`actions/checkout` v4 to v6.0.2) had been rendered MERGE-NOW at
  `entries/2026/07/28/071811Z-message-botanist-0326ab.md`, but all 28
  `actions/checkout` call sites on base already read the v6.0.2 hash, so that
  diff is a pure no-op. Its gardener had completed, so the finding went out as a
  dead-lettered inbox message (`20260728T074423Z-6bee53`) for `garden-deadmail`
  to promote into a fresh job. Nothing had merged: the conductor spine held at
  the maintainer approval gate.
- Role amendment landed on `main2` as `5228849d28`, rebased over a peer's
  concurrent `9321496acb` so both additions survive.

Open follow-up for a maintainer or a later job: 6 `actions/setup-node` sites
remain on v6.2.0 (`.github/workflows/ci.yml:140` and `:235`,
`ci-docs.yml:50` and `:79`, `familiar-release.yml:46` and `:106`). Neither
`update-action-pins.yml` (non-major, re-resolves the exact tag each site's own
trailing comment names, so a no-op) nor `update-action-pins-major.yml`
(`resolveLatestMajorTag`, which is v7.0.0) will bring them to v6.5.0, and a
fresh Dependabot PR would target v7.0.0 since `.github/dependabot.yml` sets no
major-update ignore rule for the `github-actions` ecosystem.

Self-improvement: the supersession check now censuses the base ref, not just
sibling Dependabot PRs, and states the `github-actions` substitutes for the
lockfile-shaped steps 2 through 4.
