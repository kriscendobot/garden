---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:41:41Z
---
# Dependabotany ledger row: endojs/endo-but-for-bots#268

Appended row for the `endojs/endo-but-for-bots` dependabotany ledger seeded at
`entries/2026/05/13/000050Z-message-steward-e08492.md`. Posted automatically by
the dependabot-PR watcher (job base `endojs-endo-but-for-bots-pr268-dependabot`),
no maintainer comment.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [268](https://github.com/endojs/endo-but-for-bots/pull/268) | `actions/setup-node` 6.2.0 to 6.4.0 (`github-actions` ecosystem, no lockfile) | REJECT (superseded by the base branch) | n/a (terminal) | CLOSED 2026-07-28 | Base branch `llm` already carries a newer pin. Census of `actions/setup-node` across `.github/workflows/` on `llm`: 22 call sites, 16 at `249970729cb0ef3589644e2896645e5dc5ba9c38` (v6.5.0), 6 at `6044e13b5dc448c55e2357c09f80417699197238` (v6.2.0). The 6 stale sites are exactly the 6 this PR touches, and it would set them to `48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e` (v6.4.0), the hash that commit `edd97f559caaaed8812903381e764467eaf55ae7` ("ci: repin setup-node to v6.5.0 with exact version comments", 2026-07-14) deliberately removed after zizmor flagged the floating `# v6` comment resolving to a different commit than the pin. Merging would partially revert that repin. Pre-flight clean: diff touches only `.github/workflows/{ci,ci-docs,familiar-release}.yml`, 2 lines each, no source files. No sibling open Dependabot PR targets setup-node, so supersession came from the base branch rather than from a paired PR. Version facts verified against the `actions/setup-node` tag and release APIs rather than the PR body: v6.2.0 `6044e13b` 2026-01-15, v6.4.0 `48b55a01` 2026-04-20, v6.5.0 `24997072` 2026-07-14, v7.0.0 `82076278` 2026-07-14. Advisory check: GitHub Security Advisory database (`actions` ecosystem) and OSV both return no advisory for `actions/setup-node` at any version, so no CVE is closed by the upgrade and none is left open by declining it; `npm audit` is not applicable to this ecosystem. CI green 23/23 against head `6c8a08481d525b9c6485c8b105634a3ce265d753`, cross-checked at the check-run level (the combined-status rollup read `pending`, so the rollup alone would have been misleading); green CI was not the basis of the verdict. Head was 1 ahead / 740 behind `llm`, with Dependabot automatic rebases disabled after 30 days open. ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/268#issuecomment-5101333677)) |

## Open follow-up this close does not resolve

6 `actions/setup-node` call sites remain on v6.2.0 (published 2026-01-15) while
the other 16 are on v6.5.0:

- `.github/workflows/ci.yml:140` (`familiar-bundle`)
- `.github/workflows/ci.yml:235` (`sandbox-drivers`)
- `.github/workflows/ci-docs.yml:50`
- `.github/workflows/ci-docs.yml:79`
- `.github/workflows/familiar-release.yml:46`
- `.github/workflows/familiar-release.yml:106`

Neither of the repo's own repin automations closes this, which is the part worth
remembering:

- `update-action-pins.yml` (weekly Monday 03:00 UTC, non-major) runs
  `scripts/update-action-pins.mjs`, whose tag selection is
  `commentIsVersion ? commentText : ...`. Since the 2026-07-14 repin switched the
  trailing comments from a floating `# v6` to an exact `# v6.2.0` / `# v6.5.0`,
  the non-major run now re-resolves each site to the tag already named in its own
  comment. That is a no-op for version advancement; it only repairs SHA drift
  when a tag moves.
- `update-action-pins-major.yml` runs the same script with `--major`, which uses
  `resolveLatestMajorTag` (the maximum tag overall). For setup-node that is
  v7.0.0, a major the repo has not taken at its other 16 sites.
- A fresh Dependabot PR would also target the latest release (v7.0.0), since
  `.github/dependabot.yml` sets no `ignore` rule for major updates on the
  `github-actions` ecosystem.

So the remaining work is a deliberate one-line-per-site repin of those 6 to
`249970729cb0ef3589644e2896645e5dc5ba9c38 # v6.5.0`, finishing commit
`edd97f559`. Left to a maintainer or a follow-up job; not folded into the
Dependabot branch.

Sibling stale PR noted in passing, not acted on by this job:
[269](https://github.com/endojs/endo-but-for-bots/pull/269)
(`actions/checkout` 4.3.1 to 6.0.2, opened the same day, also long past the
30-day auto-rebase cutoff) is worth the same base-branch census before review.

## Botanist self-notes for this PR

- **The supersession check has a second shape the role file does not name: the
  base branch itself.** Step 1 tells the botanist to look for a sibling open
  Dependabot PR bumping the same package. Here there was none, and the PR was
  still superseded, because the base branch had moved past the target by a
  hand-authored repin. For a `github-actions` PR the cheap decisive check is a
  census of the pin across all of `.github/workflows/` on the base ref, compared
  against the PR's target. Routed to the liaison as a role-file lesson.
- **A `github-actions` Dependabot PR has no lockfile, so steps 2 through 4 change
  shape.** There is no transitive set, no `npm audit`, and no install. The
  substitute for the lockfile diff is the pin census above; the substitute for
  the source read is resolving the target tag to its commit through the tag API
  and confirming it matches the hash in the diff (it did: v6.4.0 resolves to
  `48b55a01`).
- **The combined-status rollup disagreed with the check runs.**
  `commits/<sha>/status` read `pending` while all 23 check runs read `success`.
  The role's step-6 instruction to cross-check rather than trust the rollup paid
  off in the direction the role warns about.
- **Reading the repo's own automation is what turned a clean close into an
  honest one.** Without reading `scripts/update-action-pins.mjs`, the obvious
  assumption is that the weekly pin job will mop up the 6 stale sites. Its
  comment-driven tag selection means it will not, and saying so in the verdict is
  the difference between closing the PR and closing the loop.
