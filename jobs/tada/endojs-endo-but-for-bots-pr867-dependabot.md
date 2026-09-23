Botany review of https://github.com/endojs/endo-but-for-bots/pull/867 (`@noble/curves` 1.9.0 to 2.2.0, base `llm`) is complete.

## Verdict: MERGE-NOW, held at the maintainer-approval gate

All four legs of the gate hold; the only thing standing between this PR and a merge is a human approval, which is not mine to grant.

**Transitive set (full, not just the headline).** `@noble/curves` 1.9.0 and 1.9.7 collapse to 2.2.0; the transitive `@noble/hashes` 1.8.0 pin is dropped and dedupes into the 2.2.0 already present via `^2.0.1`. No newly introduced package, nothing published in the last 24 hours (freshest moved version is 2026-04-12), MIT unchanged on both, `paulmillr` still sole npm maintainer. Lockfile is net smaller (8 added, 24 removed).

**Advisories.** OSV returns zero for both packages; `yarn npm audit --all --recursive` names no `@noble/*` entry; GHSA has nothing. No CVE closed, so the verdict rests on maturity: 2.2.0 is 108 days old, well past the 7-day floor.

**Source read.** No install scripts of any kind. A scan of the 113 installed files for network, filesystem, process, and dynamic-evaluation primitives hit only specification citations in comments. Verification semantics are preserved: ed25519 defaults to `zip215: true` in both 1.9.0 and 2.2.0, so wire acceptance is unchanged, corroborated by green Guile and Python interop runs.

## What I changed

Dependabot's bump alone could never go green, and the failure was real, not flaky. Every red check traced to one cause: 2.0.1 disabled extension-less subpath imports, so `'@noble/curves/ed25519'` raised `ERR_PACKAGE_PATH_NOT_EXPORTED`. A second break waited behind it: v2 renamed `ed25519.utils.randomPrivateKey` to `randomSecretKey`.

Rather than escalate a break I had already fully characterised, I drove CI to green under the shepherd discipline step 6 authorizes, pushing https://github.com/endojs/endo-but-for-bots/commit/5b7d79eb2f383075d1c7ab1eee056e5af46bedfd: extension-ful specifier in `packages/ocapn/src/cryptography.js` and `packages/relay-server/src/relay.js`, plus `randomSecretKey` at the two ocapn call sites. Locally `yarn test` in `packages/ocapn` passed 534 tests and `yarn lint` reported 0 errors in both packages.

**All 23 checks now green**, `mergeStateStatus=CLEAN`. One intermediate `test (22.x, macos-15)` failure classified as a flake on three independent grounds: it failed as `@endo/agentry#test` with `Timed out while running tests` then `Exiting due to SIGINT`; `@endo/agentry` has no `@noble/*` dependency so the upgrade cannot reach it; and it passed on re-run.

## Disposition

`ci-wait-merge.sh endojs/endo-but-for-bots 867 --merge` read the rollup as GREEN (23 checks, 0 failed) and refused with `merge blocked: no maintainer approval (reviewDecision=none)`, exit 1. Correct behaviour: the gate is intact by design, and it deserves to hold here, because the PR is no longer a pure Dependabot diff.

Also done: verdict comment posted (https://github.com/endojs/endo-but-for-bots/pull/867#issuecomment-5111717289); journal `result` entry `entries/2026/07/29/013416Z-result-gardener-6a2bad.md`; kriskowal's review requested, since the bulletin's parked queue is built from `gh search prs --review-requested kriskowal` and would otherwise never surface this PR; maintainer messaged. No dependabotany ledger row, no recheck one-shot, no daily backstop: the verdict is terminal, not an embargo.

## Follow-ups

1. **A real hole, sent to the liaison.** `scripts/jobs/ensure-project-worktree.sh` installs with native builds ENABLED (its own log says "native builds included") before a botanist ever gets control. That silently defeats the role's scripts-disabled install discipline, which it states three times and which is its strongest control against the classic supply-chain vector. Any botanist "installing with scripts disabled" at step 3 is performing the control after the fact and reporting something untrue. This affects every dependabot job on every host; the fix is a spine change, not a role change.
2. **Step 6 ambiguity**, same message: the fixer-escalation clause reads as mandatory even when the botanist has already solved the break, which would have wasted a whole job here re-deriving a diagnosis to type three substitutions. Suggested wording included.
3. **Awaiting kriskowal.** Once approved, the conductor spine merges with no further botany.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr867-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 37 tokens (2626031 cached reads)
- Output: 15351 tokens
- Cost: $3.0298754999999997
- Wall-clock: 268s

<!-- garden-usage-end -->
