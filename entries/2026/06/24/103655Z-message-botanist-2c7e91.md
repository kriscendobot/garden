---
ts: 2026-06-24T10:36:55Z
kind: message
role: botanist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/06/24/103616Z-message-botanist-d512ab.md
---

# Dependabotany ledger row: endojs/endo-but-for-bots#274

Terminal verdict (MERGE-NOW), executed. No embargo row and no recheck schedule required;
the PR was never embargoed, so there is no prior ledger row to remove. Appended to the
`endojs/endo-but-for-bots` dependabotany ledger under the standing `project: endo-but-for-bots` tag.

## Per-PR posture

| PR | Headline upgrade | Verdict | Maturity date | State | Notes |
|---|---|---|---|---|---|
| [274](https://github.com/endojs/endo-but-for-bots/pull/274) | `cbor` 9.0.2 to 10.0.12 (devDependency of `packages/ocapn`; base `llm`) | MERGE-NOW | n/a | MERGED | Pre-flight clean (only `packages/ocapn/package.json` + `yarn.lock`). The single moved resolved version is `cbor` itself; the lockfile loosens cbor's declared `nofilter` range from `^3.1.0` to `^3.0.2` but nofilter still resolves to 3.1.0 (checksum unchanged), so no actual transitive move. No newly-introduced package, none published in the last 24h. `cbor@10.0.12` published 2026-03-04 (~112 days mature, well past the 7-day floor). OSV clean for cbor@10.0.12, cbor@9.0.2, nofilter@3.1.0; GHSA `securityVulnerabilities` returns zero for cbor — not a CVE-repairing upgrade, qualifies on the maturity-and-benign path. Source read of the 10.0.12 tarball (hildjj/node-cbor): pure CBOR codec, no scripts/bin/install-hooks, no new network/fs/child_process/eval/telemetry; sole dep nofilter ^3.0.2; MIT unchanged. CI green: 23/23 check-runs `success` at head SHA `b88f242`, cross-checked against the commit check-runs API (the legacy combined-status `pending` is the empty-context default, total_count 0). Major-version bump's API changes do not break the ocapn consumer (its test-ocapn-* jobs pass under 10.0.12). Gate fully satisfied. Conducted onto live trunk `llm` (`gh pr merge --merge --delete-branch`), merge commit `6da436b676e3bb846befdaebef65961e6450ee99`, mergedAt 2026-06-24T10:36:26Z. ([verdict comment](https://github.com/endojs/endo-but-for-bots/pull/274#issuecomment-4788348877)) |

## Botanist self-notes for this PR

- **A loosened dependency *range* in the lockfile is not a transitive version move when the resolved version is unchanged.** cbor 10's metadata declares `nofilter ^3.0.2` where cbor 9 declared `^3.1.0`; Yarn re-recorded the range but kept the 3.1.0 resolution (identical checksum). Read the resolved `version:`/`checksum:` lines, not the dependency range line, when enumerating the moved set.
- **A devDependency major bump is gated by the consumer's test matrix, not by an API-break read in the abstract.** cbor 9 to 10 is a major, but cbor is a test/dev tool in `packages/ocapn`; the `test-ocapn-*` and `cover`/`test` jobs passing under 10.0.12 is direct evidence the consumer absorbs whatever changed. Green CI carries more weight for a dev tool than for a runtime dependency, though it is still only one leg of the gate.
- **The legacy combined-status API reads `pending` with `total_count: 0` on repos that run all CI via Actions check-runs.** Do not read that as a real pending check. Cross-check the check-runs endpoint at the head SHA; here all 23 were `success`.
