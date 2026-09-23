---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:51:57Z
---
# Dependabotany ledger row (tagged): endojs/endo-but-for-bots#269

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/269

**Verdict: REJECT (superseded by the base branch). PR CLOSED 2026-07-28.**
This REPLACES the MERGE-NOW verdict recorded earlier the same day at
`entries/2026/07/28/071811Z-message-botanist-0326ab.md` and posted as
https://github.com/endojs/endo-but-for-bots/pull/269#issuecomment-5101129776.
That review was correct about `actions/checkout` v6.0.2 itself and never
compared the target against the base-branch pin; the conductor spine then
stopped at the maintainer-approval gate, so nothing landed and no approval was
spent.

`actions/checkout` v4 (`34e114876b0b11c390a56381ad16ebd13914f8d5`, v4.3.1,
published 2025-11-17) to `de0fac2e4500dabe0009e67214ff5f5447ce83dd` (v6.0.2,
published 2026-01-09); `github-actions` ecosystem, so no lockfile and no
transitive npm set. Base branch `llm` at `7f8c08d74f` already carries
`de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2` at **all 28**
`actions/checkout` call sites across `.github/workflows/`. The 3 sites this PR
touches (`ci-docs.yml:42`, `ci-docs.yml:71`, `ci.yml:132`) all reached v6.0.2 in
`1ff3e0d3d7` ("fix(ci): repin stale actions/checkout hashes flagged by zizmor",
2026-07-20).

The no-op was verified rather than inferred: merge base
`6da436b676e3bb846befdaebef65961e6450ee99`;
`git merge-tree --write-tree llm pr/269` yields tree
`1daf774f06d7606b5f6c5d41392e32a80ec54a7d`, and `git diff llm 1daf774f06` is
empty. Both sides made the identical v4 -> v6.0.2 edit from the common ancestor,
so the merge result is byte-identical to `llm`.

No advisory for `actions/checkout` in the GitHub Security Advisory Actions feed
or OSV at any version, so no CVE is closed by the upgrade and none is left open
by declining it. CI was 23/23 green against head
`9c96ebd589e9a5c53af3b831b896e9a4c2c3cf71`, cross-checked at the check-run level;
green CI was not the basis of the verdict. Head was 2 ahead and 740 behind `llm`,
automatic rebases disabled after 30 days open (opened 2026-05-17).

Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/269#issuecomment-5101428385

Terminal verdict, so no embargo row and no maturity one-shot. Unlike #268 this
close strands nothing — every call site is already on v6.0.2. Standing follow-up
(not this PR's): upstream now has v6.1.0 and v7.0.1 (both 2026-07-20), and
neither `update-action-pins.yml` (re-resolves the exact tag in each site's own
trailing comment, a no-op at `# v6.0.2`) nor `update-action-pins-major.yml`
(jumps to the newest major, v7) advances the repo deliberately; a fresh
Dependabot PR against the current latest is the expected mechanism.

Provenance: this disposition was carried by the dead-lettered-message job
`deadmail-20260728T074423Z-6bee53`, picking up the intent of a message the
`endojs-endo-but-for-bots-pr268-dependabot` botanist sent to the already-completed
`endojs-endo-but-for-bots-pr269-dependabot` job. The base-ref census clause that
would have caught this at step 1 landed on `main2` as `5228849d28`.
