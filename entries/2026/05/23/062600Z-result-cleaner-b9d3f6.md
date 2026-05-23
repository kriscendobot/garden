---
ts: 2026-05-23T06:26:00Z
kind: result
role: cleaner
host: endolinbot
project: endojs/endo-but-for-bots
pr_number: 361
dispatch_root: /home/kris/dispatches/cleaner--9ed401
refs:
  - entries/2026/05/23/062130Z-dispatch-general-contractor-cleaner-pr361.md
  - entries/2026/05/23/061902Z-result-fixer-d3c7df-wrap.md
---

# Cleaner result — PR #361 (cleaner-skipped variant; no push)

Determination: **cleaner-skip**. The PR is a single-file test-only port (`packages/ocapn/test/netlayer-tcp-syrup.test.js`, +63 / -34). No production code is touched; no new tests are added. The diff itself *is* the test restoration. The cleaner has no production coverage surface to expand for this PR. Per `roles/cleaner/AGENT.md` § Operating norms, the skip variants are "pure documentation, lockfile-only churn, a one-file format sweep, or a single bug-fix line whose test fixture is already in the diff"; the single-file test-only port fits the same shape (one file, no production diff to mutate against, no fixture work that would itself be a coverage candidate). Any package-wide ocapn coverage sweep would be out of per-PR scope; that is a separate maintainer-directive dispatch path.

The cleaner does not push.

## CI snapshot on cleaner's read (head: 2ecf40ed8)

Green:
- test (20.x / 22.x / 24.x, ubuntu and macos) — all six configs pass
- cover (20.x ubuntu) — pass
- test262 (20.x / 24.x) — pass
- test-hermes, test-xs, sandbox-drivers, browser-tests
- test-ocapn-guile-interop, test-ocapn-python, build-wasm
- check-action-pins, zizmor, familiar-bundle
- viable-release (24.x) — pass

In progress:
- cover (24.x ubuntu)
- viable-release (20.x ubuntu)

Red — both pre-existing on `llm`, not introduced by PR #361:
- **lint** — `scripts/check-security-md.sh` reports `packages/bytes/SECURITY.md` hash mismatch against the canonical body (`d9acd9...` vs `071c74...`). Verified: this state already exists on `origin/llm`'s tree (the `packages/bytes/SECURITY.md` blob at `origin/llm` hashes to `d9acd9...`, the same divergence). PR #361 does not touch `packages/bytes/SECURITY.md`.
- **build** (workflow: *Test project mutual dependency versions*) — failed before any project work began: `git fetch` of the PR merge ref returned `fatal: could not read Username for 'https://github.com'`. GitHub Actions checkout/auth transient.

Neither failure is a fixer-loop input. The next stage proceeds.

## Panel-hints for the code panel

`panel-hints.sh --base origin/llm` against the PR head:

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (1): fast-checker  packages/ocapn/test/netlayer-tcp-syrup.test.js
Content-triggered (0): -
Cross-panel (0): -
Suppressed (16): benchmarker, breaker, changeset-auditor, curator, gateway, migrator, pruner, surfacer, engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher, copyeditor, pedant
Recommended total: 12 of 26 code-panel seats.
```

For the test-only character of this PR the strongest in-scope seats are:
- **prover** — verify the three restored tests are load-bearing (each fails when its target path is broken); the PR claims wire-format sniff, round-trip echo, and framing-option rejection.
- **integrator** — concept-namespace coherence with the `makeOcapn` / `locator` / `syrupCodec` renames from PR #59; rename completeness within the test file.
- **archivist** — JSDoc accuracy on the new `captureTcpNetLayer` helper and the `Buffer` cast comment.
- **typist** — the `NetlayerRef<T>` typedef and the `/** @type {Buffer} */` cast over the socket-data overload.
- **assessor** — the ref-capture pattern (the netlayer is read after `await makeOcapn`; the test throws when the ref is still empty) is correct, but the helper resolves the netlayer **before** `makeOcapn` resolves, so the ordering should be verified.
- **fast-checker** — sees a test file in the diff; the seat will rightly conclude the existing tests are example-based by necessity (TCP-syrup framing is a small fixed catalog), so the seat will likely return acknowledge / no-finding.
- **packager** — single-commit diff; verify the commit message follows the project conventions.
- **stylist** — `swissnumTable` to `locator` rename; check no stragglers.

The full 12-seat recommended set still applies; this list is a triage prioritization for the judge's aggregator.

## Recommended next stage

**barrister** (first code-panel round). The cleaner-skip variant routes builder → barrister directly per `skills/pr-creation-flow/SKILL.md` § Flow ordering ("Cleaner-skipped tiny-PR variant"). The PR remains DRAFT until the judge un-drafts after the loop terminates.

The barrister should be briefed with the panel-hints subset above so the dispatch fan-out is the 12-seat recommended set rather than the full 26.

Self-improvement: nothing this time. The cleaner-skip determination for a single-file test-only port matched the existing variants cleanly; the role file already names the four canonical skip cases ("pure documentation, lockfile-only churn, a one-file format sweep, or a single bug-fix line whose test fixture is already in the diff"); the single-file test-only port slots in by analogy without a new rule.
