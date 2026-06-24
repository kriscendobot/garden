---
ts: 2026-05-25T19:41:00Z
kind: result
role: botanist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/25/193145Z-dispatch-botanist-362.md
  - entries/2026/05/25/193802Z-message-botanist-6166c6.md
  - entries/2026/05/13/000050Z-message-steward-e08492.md
  - entries/2026/05/20/011222Z-message-botanist-310e99.md
---

# Result: botanist on endojs/endo-but-for-bots#362

**Verdict**: EMBARGO until **2026-05-31**.

Grouped Dependabot PR with 15 headline upgrades (rolled-up to 56 lockfile version
changes across the transitive set). Pre-flight clean: diff touches only root
`package.json`, two per-package `package.json` files, and `yarn.lock`. Install
with project-default `enableScripts: false` succeeds against the new lockfile.

One CVE-fix in the group: `ws` 8.20.0 to 8.21.0 patches
GHSA-96hv-2xvq-fx4p / CVE-2026-48779 (high severity, remote memory-exhaustion DoS).
The project consumes `ws` in four packages that accept remote peers
(`relay-server`, `daemon`, `ocapn-noise`, `ocapn`), so it is exposed.

Under the role's MERGE-NOW rule the `ws` bump alone would justify immediate merge,
but it is grouped with 14 non-vuln-repairing upgrades whose freshest member
(`ink@7.0.4`) was published this morning (0 days mature). The CVE class is
DoS-only (no RCE / no data exfil) and the PR base is `llm` (feature branch),
not `master`. Embargoing one week from `ink`'s publish (2026-05-31; also 2 days
past `ws`'s own 7-day floor) preserves the supply-chain wait without
significant production exposure.

The maintainer's override path remains open: if the `ws` CVE is judged urgent
enough to fast-track ahead of the embargo, the override is theirs.

**Artifacts**:

- Verdict comment: <https://github.com/endojs/endo-but-for-bots/pull/362#issuecomment-4536766907>
- Dependabotany ledger row: `entries/2026/05/25/193802Z-message-botanist-6166c6.md`
- Scheduled re-dispatch: 2026-05-31 (steward's per-cycle scan picks up the maturity date)

**CI status at verdict** (commit `c0a38cde9`, run `26371350951`): 10 FAILURE,
15 SUCCESS, mergeable. Shepherd is dispatched in parallel (separate work item);
the embargo decision is independent of CI state.

Self-improvement: nothing this time. The role file already encoded the rules I
used (default-embargo for non-vuln-repairing groups, exposure check on the
consumed-package call sites, GHSA / publish-date / call-site reads). The
ledger-as-journal-message precedent is the prior endo (#3267) row's shape and
this engagement followed it without modification. One possible note worth
recording in the ledger's self-notes for future engagements: a DoS-class CVE
on a feature branch is weaker justification to override the supply-chain wait
than an RCE-class CVE on a master-bound PR; landed that in the ledger's
self-notes inline rather than promoting it to the role file (one data point
is below the role-edit threshold).
