---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:43:41Z
---
# Dependabotany ledger row (tagged): endojs/endo-but-for-bots#268

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/268

Retag of the row posted minutes earlier at
`entries/2026/07/28/074140Z-message-gardener-0929f5.md`, which `journal-entry.sh`
wrote without the `project:` / `repo:` body tags the dependabotany ledger sweep
greps for (`grep -rl '^project: endo-but-for-bots$'`). That entry carries the
long-form transcript; this one carries the tags so the row is recoverable.

**Verdict: REJECT (superseded by the base branch). PR CLOSED 2026-07-28.**

`actions/setup-node` 6.2.0 to 6.4.0, `github-actions` ecosystem, so no lockfile
and no transitive npm set. Base branch `llm` already carries a newer pin: of 22
`actions/setup-node` call sites across `.github/workflows/`, 16 are on
`249970729cb0ef3589644e2896645e5dc5ba9c38` (v6.5.0) and 6 on
`6044e13b5dc448c55e2357c09f80417699197238` (v6.2.0). The 6 stale sites are
exactly the 6 this PR touches, and it would set them to
`48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e` (v6.4.0), which is the hash commit
`edd97f559caaaed8812903381e764467eaf55ae7` ("ci: repin setup-node to v6.5.0 with
exact version comments", 2026-07-14) deliberately removed after zizmor flagged
the floating `# v6` comment resolving to a different commit than the pin.
Merging would partially revert that repin.

No advisory for `actions/setup-node` in the GitHub Security Advisory Actions feed
or OSV at any version, so no CVE is closed by the upgrade and none is left open
by declining it. CI was green 23/23 against head
`6c8a08481d525b9c6485c8b105634a3ce265d753`, cross-checked at the check-run level
because the combined-status rollup read `pending`; green CI was not the basis of
the verdict. Head was 1 ahead and 740 behind `llm`, automatic rebases disabled
after 30 days open.

Verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/268#issuecomment-5101333677

Terminal verdict, so no embargo row and no maturity one-shot. Open follow-up
carried in the long-form entry: 6 call sites remain on v6.2.0 and neither
`update-action-pins.yml` (non-major, re-resolves the exact tag named in each
site's own trailing comment, a no-op) nor `update-action-pins-major.yml`
(`resolveLatestMajorTag`, which is v7.0.0) will advance them to v6.5.0.
