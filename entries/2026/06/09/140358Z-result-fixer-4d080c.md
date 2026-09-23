---
ts: 2026-06-09T14:03:58Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: steward
dispatch_root: /home/kris/dispatches/fixer--4d080c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
refs:
  - entries/2026/06/09/140100Z-dispatch-fixer-4d080c.md
  - https://github.com/endojs/endo-but-for-bots/pull/75
  - https://github.com/endojs/endo-but-for-bots/commit/4a879634ecbc22497d63d903ce53b25717e0b0d3
  - https://github.com/endojs/endo-but-for-bots/commit/4a879634ecbc22497d63d903ce53b25717e0b0d3#commitcomment-188148534
---

# result: fixer (4d080c) — reverted package.json exports collapse on PR #75 per kriskowal commit-comment

Surgical revert of one file in `e627f7b13` per kriskowal's commit-comment on `r188148024`: "Please revert this. Some tools need to be able to import the `package.json`." Single append commit on `kriskowal-random-chacha12`; no other file touched; gibson042 substance changes in `e627f7b13` stay applied.

## Pre/post branch tip

- Pre: `e627f7b13` (the gibson042-feedback carry).
- Post: `4a879634e` (the surgical revert of `packages/chacha12-fast-check-test/package.json`).
- Push: `e627f7b13..4a879634e` to `origin/kriskowal-random-chacha12` (append, no force).

## The revert

Restored shape on `packages/chacha12-fast-check-test/package.json`:

```json
"exports": {
  "./package.json": "./package.json"
}
```

The post-edit blob hash (`f951aee79`) matches the parent commit (`e627f7b13~1`) exactly, so this is a clean inverse of the one-file edit in `e627f7b13` and nothing else.

The carry commit `e627f7b13` had collapsed this to `"exports": {}` per PR #75 thread `3223667088` (mirror-sweep ask: "Should be present and empty. There should be no main nor module on a test package"). kriskowal's commit-comment now overrides that ask for this specific package because "some tools need to be able to import the `package.json`".

## Pre-push-gates result

Ran `pre-push-gates.sh --probes-only --summary`. Two probes fail; both are explained below.

- `test-package-no-main`: fails on the restored shape, because the probe encodes the prior PR #75 thread `3223667088` ask. The maintainer's commit-comment is the authoritative override for this specific package; the probe needs refinement (allow the `./package.json` self-export) but that is a gardener concern out of this dispatch's scope. Proceeded with the push per the maintainer directive.
- `sentence-per-line-md`: fails on pre-existing markdown content in `AGENTS.md`, `packages/chacha12-fast-check-test/SECURITY.md`, `packages/chacha12/BENCH.md`, `packages/chacha12/README.md`, `packages/chacha12/SECURITY.md`, `packages/random/SECURITY.md`. None of these files were touched by this dispatch; the failures are pre-existing on `e627f7b13`'s base.

All other probes pass: `filename-no-stutter`, `no-ascii-banners`, `no-inline-import-jsdoc`, `no-non-ascii-in-source`, `no-pull-citations`, `security-md-hash-uniform`.

## Reply on the commit comment

GitHub's REST API does not expose a `/replies` endpoint for commit comments (`POST /repos/{o}/{r}/comments/{id}/replies` returns 404). Fell back to posting a new commit comment on the addressing SHA (per the brief's authorized fallback):

- URL: https://github.com/endojs/endo-but-for-bots/commit/4a879634ecbc22497d63d903ce53b25717e0b0d3#commitcomment-188148534

The body cites the addressing commit SHA (`4a879634e`), reproduces the restored shape, and notes the gibson042 substance changes stay applied.

## Out-of-scope items deliberately not touched

- Did not amend `e627f7b13`.
- Did not revert the seven gibson042 inline-suggestion fixes folded into `e627f7b13`.
- Did not re-request review (the maintainer just touched the PR; they will re-review at their own pace per the brief).
- Did not rebase or force-push.
- Did not touch any other file.

## Self-improvement

`Self-improvement`: the prior fixer (`140d8f`) folded a mirror-sweep ask from PR #75 thread `3223667088` (a bot-juror panel hint, not a maintainer-reviewed thread) directly into the carry commit without surfacing the package-level shape question to the maintainer first. Mirror-sweep folding is fine in general (it is the point of a mirror sweep), but when the ask touches a *package-level shape* and the prior thread was not itself a maintainer review, the fixer should either (a) ask the orchestrator for maintainer confirmation, or (b) surface the change as a separate commit and call it out in the top-level PR summary so the maintainer can intercept it on review rather than after a merge-blocking commit-comment. The class lesson is "mirror-sweep folding is safe for code-shape but risky for package-shape; the latter wants explicit maintainer pre-approval or extra-prominent surfacing." A second class lesson: the `test-package-no-main` pre-push-gates probe now encodes a stale ask (the prior thread is now superseded for this specific package); a gardener follow-up should refine the probe to allow the `./package.json` self-export entry, since that satisfies the original "no leaking implementation modules" intent while keeping `package.json` importable.
