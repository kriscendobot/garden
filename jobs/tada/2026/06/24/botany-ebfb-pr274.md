Pushed to `origin/journal2`. All steps of the botanist workflow complete. Here is my completion report.

---

# Job `botany-ebfb-pr274` — completion report

**Verdict: MERGE-NOW. Disposition: executed (merged).**

PR: endojs/endo-but-for-bots#274 — Dependabot bump `cbor` 9.0.2 → 10.0.12 (a **devDependency** of `packages/ocapn`; base branch `llm`).

## What I did
1. **Pre-flight** — diff touches only `packages/ocapn/package.json` and `yarn.lock`. No source/workflow/config files. Clean.
2. **Transitive set** — the only resolved version that moved is `cbor` itself. The lockfile loosens cbor's declared `nofilter` range (`^3.1.0`→`^3.0.2`) but nofilter still resolves to **3.1.0** (checksum unchanged) — no real transitive move. No newly-introduced package; nothing published in the last 24h.
3. **Maturity** — `cbor@10.0.12` published **2026-03-04**, ~112 days old (≫ 7-day floor).
4. **Vulnerability check** — OSV clean for cbor@10.0.12, cbor@9.0.2, nofilter@3.1.0; GHSA `securityVulnerabilities` returns zero for cbor. Not a CVE-repairing upgrade — qualified on the maturity-and-benign path.
5. **Source read** — inspected the published 10.0.12 tarball (hildjj/node-cbor): pure CBOR codec, no `scripts`/`bin`/install hooks, no new network/fs/child_process/eval/telemetry; sole dep nofilter ^3.0.2; MIT unchanged.
6. **CI (shepherd)** — all **23/23 check-runs `success`** at head SHA `b88f242`, cross-checked directly against the commit check-runs API (not just the rollup). The legacy combined-status `pending` is the empty-context default (`total_count: 0`); no shepherding needed. The major-version bump does not break the consumer (its `test-ocapn-*`/`cover`/`test` jobs pass under 10.0.12).
7. **Gate** — all legs held → MERGE-NOW.
8. **Executed** — posted the structured verdict comment ([#issuecomment-4788348877](https://github.com/endojs/endo-but-for-bots/pull/274#issuecomment-4788348877)), then conducted onto live trunk `llm` via `gh pr merge --merge --delete-branch`. **state=MERGED**, merge commit `6da436b676e3bb846befdaebef65961e6450ee99`, mergedAt 2026-06-24T10:36:26Z, head branch deleted.
9. **Ledger + journal** — appended the per-PR ledger row (terminal MERGE-NOW; PR was never embargoed, so no prior row to remove and no recheck schedule needed) and a `result` entry; committed and pushed to `origin/journal2` (`5f7a8502`).

## What changed
- endojs/endo-but-for-bots `llm` now carries cbor 10.0.12 in packages/ocapn.
- Verdict comment on PR #274; PR closed as merged; head branch deleted.
- Two journal entries on `journal2` (ledger row + result).

## Maturity date
N/A — terminal MERGE-NOW, not embargoed.

## Follow-ups
None. No embargo, no recheck schedule, no escalation. (Note for future botanists, recorded in the ledger self-notes: a loosened dependency *range* with an unchanged resolved version is not a transitive move; and the legacy combined-status reads `pending`/`total_count: 0` on this repo because all CI runs as Actions check-runs — cross-check the check-runs endpoint, don't trust that pending.)
