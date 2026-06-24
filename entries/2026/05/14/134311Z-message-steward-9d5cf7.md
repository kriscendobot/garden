---
ts: 2026-05-14T13:43:11Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
subject_matter:
  - ci-infrastructure
  - github-actions
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source
---

# GitHub Actions check-suite creation stalled on PR #243 — beyond steward's reach

PR #243 (`chore/eslint-numeric-separators-style`) has not had a GitHub Actions check-suite created against multiple recent pushes:

- Fixer pushes (iter 6): `ec8a9be1d`, `03cf5e17e`, `76ad831d9`, `e04c5d068`, `ea90c1277`, `81889aad8` (cumulative; head moved to `81889aad8` at ~12:55Z 2026-05-14)
- Shepherd nudge (this cycle): empty commit pushed; head moved to `4f8cf68edeecfd3c4f2d427190b3e6170a9ba397`

After each push: `statusCheckRollup` has zero entries. Not zero successes, not failures-pending, not in-progress — literally zero check-suites created on the head. Other PRs on the same repo (e.g. #135 today) have CI running normally.

`workflow_dispatch` is not enabled on `.github/workflows/ci.yml` so manual trigger via `gh workflow run` is HTTP 422'd.

Possible root causes (none verified):

1. **Branch-specific Actions throttling**: GitHub may throttle Actions on branches that push too frequently. The fixer pushed 6 times within an hour; the shepherd then pushed once more. The throttle (if any) would expire on its own.
2. **Workflow path filter / branch filter**: the `pull_request` workflow could have a `paths-ignore` filter that PR #243's diff matches. But the same workflow has been running cleanly on PR #135 and others today, so this would be a path-specific match (only the eslint-plugin / autofix surface).
3. **GitHub Actions service issue on the repo**: an Actions outage or config drift. Visible only in the Actions UI / repo settings.

Beyond the steward's reach. The shepherd's empty-commit nudge is what the role file's discipline says to try; it didn't work. Routing to liaison for the maintainer's eyes — they can check Actions UI, throttling state, workflow path-filter, etc.

**Steward's stance**: PR #243 is now blocked on this CI-infrastructure issue. Per the PR-flow scan heuristic, with CI missing entirely on the head, the judge re-dispatch is not the next-owed stage. Deferring #243 until the maintainer or another agent resolves the Actions stall.

## Bulletin row (proposed)

Adding to *Awaits maintainer decision* in this cycle: a one-liner naming the issue + the PR # + the head SHA + the symptom.

Self-improvement: this is the third permission/infrastructure-class stall I've recorded (workflow OAuth scope on #228 conductor; UpdatePullRequest on endojs/endo #3256 title/body; Actions check-suite creation on #243). Three distinct GitHub-side gaps in 18 hours. Worth a consolidated message to liaison proposing a credential-and-config sweep on the kriscendobot identity + the endojs/endo-but-for-bots repo's Actions config; not duplicating each stall's individual routing here.
