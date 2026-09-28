---
created: 2026-09-28
updated: 2026-09-28
author: gardener
---

# Ironhorse ratchet evidence contract

For the [ratchet autopilot](ironhorse-ratchet.md), verify independently before
writing a head-pinned attestation.


Use the tick's isolated project checkout, fetched at the exact PR head.
Preserve the pinned corpus and XS oracle. Read the source diff and the raw sweep
artifacts; rerun missing measurements. Do not trust builder totals or assertions
of test coverage. A report measured before the final commit/rebase does not
cover that head. Test code, runner/classifier changes, skipped cases, and the
meaning of the coverage floor are part of this audit.

Write a local JSON manifest with this shape (paths name actual files):

```json
{
  "worktree": "/isolated/project",
  "before_report": "/artifacts/before-report.json",
  "after_report": "/artifacts/report.json",
  "covered": "/artifacts/covered.txt",
  "refreshed_floor": "rust/engine/ironhorse-262/baseline/refresh-20260928/covered.txt",
  "gauntlet_report": "jobs/tada/2026/09/28/<gauntlet-base>.md",
  "panel_report": "panel-runs/endojs-endo-but-for-bots-1359/<run>.md",
  "dual_run": {
    "head": "<40-character-head>",
    "command": "<actual oracle dual-run test command>",
    "exit_code": 0,
    "log": "/artifacts/dual-run.log"
  },
  "new_code": {
    "head": "<40-character-head>",
    "command": "<actual instrumented test command>",
    "exit_code": 0,
    "test_log": "/artifacts/coverage-tests.log",
    "lcov": "/artifacts/lcov.info",
    "non_executable": [
      {"path": "rust/engine/example.rs", "line": 12, "reason": "<independently checked syntax-only line>"}
    ]
  }
}
```

Run `scripts/jobs/ironhorse-ratchet.sh attest /path/to/manifest.json` only after
independently auditing it. The verifier reads the enforced floor from its pinned
Git object and first requires `verdict: pass` from the
[pinned comparator](ironhorse-test262-ratchet-gate.md) against both the enforced
floor and branch-point measurement. Classifier fingerprints, run parameters,
category vocabulary, case count, corpus and oracle pins must be compatible;
`incompatible` is never interpreted as permission to replace the floor.
The verifier also re-derives both covered sets from complete `cases[]`, checks all
branch-point/floor cases survived, requires strict growth, and compares the
result byte-for-byte to both supplied and committed `covered.txt`.
It checks corpus/oracle identity, complete case enumeration, and no increased
failure count. LCOV must cover every added substantive Rust line. Blank lines,
comments, and delimiter-only lines are syntax; other non-executable lines need
an explicit, independently reviewed exclusion and cannot override an instrumented
zero-count line. Unsupported source languages require a coverage adapter and
fail closed. Documentation and data files do not require executable line coverage.

The exact-head passed panel and completed full gauntlet are read from the
journal, including the latest panel disposition. `review-budget-reached`, stale
panels, and unresolved must-fix are insufficient. Compressed raw reports, covered
set, LCOV, test logs, panel/gauntlet receipts, manifest, and watcher claim are
committed with SHA-256 digests beside
`ratchets/ironhorse-test262-ratchet/attestations/<PR>/<head>.json`.
The writer admits only the canonical live watcher running an inventory mentat
model. These artifacts survive worker/worktree teardown.

On failure, write the reason/evidence to a file and run
`scripts/jobs/ironhorse-ratchet.sh fail /path/to/reason.txt`.
Do not create an attestation for an incomplete check. The conductor uses only:

```sh
scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1359 \
  --ratchet-delegated-merge
```

This replaces only the maintainer APPROVED signature. It still enforces the
live `llm` base, bot authorship, marker, delegation, exact-head attestation,
CI freshness, maintainer CHANGES_REQUESTED and dismissal, and downstream branch
retention. A rebase restarts the CI wait and invalidates the attestation; the
watcher must obtain fresh gauntlet/coverage evidence before a later merge attempt.
The final GitHub merge uses `--match-head-commit` and must actually reach MERGED.
