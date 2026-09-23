---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:34:23Z
---
# Dependabotany terminal technical verdict: endojs/endo-but-for-bots#558

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/558

Verdict: **MERGE-NOW** on `softprops/action-gh-release` 3.0.0 to 3.0.1, rendered
2026-07-28 by job `endojs-endo-but-for-bots-pr558-dependabot` (posted
automatically by the dependabot-PR watcher). Head reviewed
`b9d0683255bd287ead0cb9d9f7d42a6de6c6053a`, base `llm`.

**No embargo row and no recheck schedule.** Maturity is already satisfied
(v3.0.1 published 2026-06-19T14:42:32Z, 39 days), so this entry records a
terminal technical verdict rather than an open ledger row. The standing daily
backstop `dependabotany-recheck-endo-but-for-bots` is unaffected and stays as it
is for the genuinely embargoed set (currently PR #868).

## Gate legs

- **Pre-flight.** One line in `.github/workflows/familiar-release.yml`. No
  source file, no manifest, no lockfile. GitHub Actions ecosystem, so there is
  no project lockfile transitive set, no new npm package, no license change, and
  nothing to install. The scripts-disabled install step is not applicable and is
  recorded as such, not silently skipped.
- **Pin verified.** `refs/tags/v3.0.1` resolves to commit
  `718ea10b132b3b2eba29c1007bb80653f286566b`, exactly what the pull request
  pins. Descendant of v3.0.0 (`ahead=17 behind=0`), release not a draft and not
  a prerelease, tagged-commit date 14:41:38Z consistent with the 14:42:32Z
  publish instant. No yanked-then-republished signal.
- **Source read, byte-exact.** `action.yml` is blob `ee219b7b52` at both tags,
  still `runs: using node24, main dist/index.js`, no `pre` or `post`
  entrypoint. `dist/index.js` differs by 33 bytes in one place: the esbuild
  CommonJS lazy-require shim gained a `try`/`catch` that clears the cache slot
  (`t=0`) and rethrows. Applying that one substitution to the v3.0.0 bundle
  reproduces the v3.0.1 bundle byte for byte (788476 to 788509 bytes,
  `patched == new`), so every other byte of the shipped action is unchanged.
  The change is esbuild 0.28.0 to 0.28.1 codegen, not action logic. No new
  network call, filesystem write, `child_process` spawn, dynamic require of
  user input, or telemetry.
- **Advisories.** `softprops/action-gh-release` has no GitHub Security Advisory
  and no OSV record, unversioned or at 3.0.1.
- **CI.** 22 of 22 green, re-read against the head SHA by the spine
  (`rollup-terminal total=22 failed=0`). The runs are dated 2026-06-28 and the
  branch is 558 commits behind `llm`, so staleness was checked rather than
  waved off: `.github/workflows/familiar-release.yml` is blob `38a50aa635` at
  both the merge base `a1dcc7071fd5f6ab31e0834b1982bfabb2d58b24` and current
  `llm`, with no commit touching it since before the branch was cut. The
  post-merge content of the only file this pull request changes is exactly what
  `check-action-pins` and `zizmor` validated. `mergeStateStatus=CLEAN`.

## Disposition: executed, and stopped at the approval gate

The repo is bot-owned, so the spine was invoked rather than a recommendation
rendered:

```
rollup-terminal repo=endojs/endo-but-for-bots pr=558 total=22 failed=0 -> CI GREEN
merge blocked: no maintainer approval repo=endojs/endo-but-for-bots pr=558
```

`reviewDecision=none`; the pull request carries no review at all. The technical
verdict is terminal and only the approval is outstanding. Maintainer notified
through the maintainer inbox.

Verdict comment:
<https://github.com/endojs/endo-but-for-bots/pull/558#issuecomment-5101267372>

## Follow-up recorded, not acted on

Upstream published v3.0.2 on 2026-07-13 (commit
`3d0d9888cb7fd7b750713d6e236d1fcb99157228`), also mature. Dependabot has not
opened a pull request for it. Not a reason to hold #558: merging 3.0.1 advances
the pin and the 3.0.2 pull request will get its own botany review when it
appears. A deliberate `@dependabot rebase` was considered and declined, because
a rebase would likely re-target the branch to 3.0.2 and invalidate the review
just completed, while the staleness it would cure is already provably absent
for the single file this pull request touches.

Self-improvement: nothing this time. The peer botanist on #269 already
landed the lesson this run would have produced (record a terminal technical
MERGE-NOW separately from the conductor approval gate so a maturity ledger
never mistakes an approval blocker for an embargo), and job
`fu-endojs-endo-but-for-bots-pr868-dependabot-3` is already amending
`roles/botanist/AGENT.md`.
