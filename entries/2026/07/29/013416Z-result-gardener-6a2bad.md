---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-29T01:34:25Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/867

# Botany review of endojs/endo-but-for-bots PR #867: MERGE-NOW (held at the approval gate)

Job `endojs-endo-but-for-bots-pr867-dependabot`, posted automatically by the
dependabot-PR watcher. Headline upgrade `@noble/curves` 1.9.0 to 2.2.0, base
`llm`. Reviewed head
https://github.com/endojs/endo-but-for-bots/commit/5b7d79eb2f383075d1c7ab1eee056e5af46bedfd
(dependabot's `277fc5c892` plus one migration commit of mine).

**Verdict: MERGE-NOW.** All four legs of the gate hold. Execution is blocked at
the maintainer-approval gate, which is intact by design.

## The four legs

1. **Transitive set benign.** `@noble/curves` 1.9.0 and 1.9.7 collapse to 2.2.0;
   the transitive `@noble/hashes` 1.8.0 pin is dropped and dedupes into the
   2.2.0 already present via `^2.0.1`. No newly introduced package, nothing
   published in the last 24 hours (the freshest moved version is 2026-04-12),
   MIT license unchanged on both, `paulmillr` still the sole npm maintainer. The
   lockfile is net smaller (8 added, 24 removed).
2. **No advisory on any moved version.** OSV returns zero for both packages,
   `yarn npm audit --all --recursive` names no `@noble/*` entry, and GHSA has
   nothing. This closes no CVE, so the verdict rests on maturity, not repair.
3. **Maturity satisfied.** `@noble/curves@2.2.0` published 2026-04-12T20:23:10Z,
   108 days before review. No embargo, no ledger row, no recheck to wire.
4. **Source read clean.** No install scripts of any kind. A scan of the 113
   installed files for network, filesystem, process, and dynamic-evaluation
   primitives hit only specification citations in comments. Verification
   semantics are preserved: ed25519 defaults to `zip215: true` in both 1.9.0 and
   2.2.0, so wire acceptance is unchanged, corroborated by green Guile and
   Python interop runs.

## CI: red for a real reason, driven to green

Dependabot's bump alone could never go green. Every red check traced to one root
cause: `@noble/curves` 2.0.1 disabled extension-less subpath imports, so
`'@noble/curves/ed25519'` raised `ERR_PACKAGE_PATH_NOT_EXPORTED`. A second break
waited behind it: v2 renamed `ed25519.utils.randomPrivateKey` to
`randomSecretKey`.

Rather than escalate, I drove CI to green under the shepherd discipline step 6
authorizes, pushing
https://github.com/endojs/endo-but-for-bots/commit/5b7d79eb2f383075d1c7ab1eee056e5af46bedfd:
the extension-ful specifier in `packages/ocapn/src/cryptography.js` and
`packages/relay-server/src/relay.js`, and `randomSecretKey` at the two ocapn
call sites. Locally `yarn test` in `packages/ocapn` passed 534 tests and
`yarn lint` reported 0 errors in both packages.

All 23 checks are now green. One intermediate `test (22.x, macos-15)` failure
classified as a flake on three grounds: it failed as `@endo/agentry#test` with
`Timed out while running tests` then `Exiting due to SIGINT`; `@endo/agentry`
has no `@noble/*` dependency so the upgrade cannot reach it; and it passed on
re-run. This is the macos-15 runner umbrella already recorded at
`journal/projects/endo-but-for-bots/macos-ci-flake-260.md`.

## Disposition

`scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 867 --merge`
read the rollup as GREEN (23 checks, 0 failed) and then refused with
`merge blocked: no maintainer approval (reviewDecision=none)`, exit 1. The PR is
green, mergeable, `mergeStateStatus=CLEAN`, and waiting on a human.

The approval is worth more than a rubber stamp here: the PR is no longer a pure
Dependabot diff, since it now carries a hand-written migration across a major
version boundary in the signature path. Verdict comment posted at
https://github.com/endojs/endo-but-for-bots/pull/867#issuecomment-5111717289.

## Ledger

No dependabotany ledger row: the verdict is terminal, not an embargo, so there
is no maturity date to record and no recheck one-shot or daily backstop to wire.
