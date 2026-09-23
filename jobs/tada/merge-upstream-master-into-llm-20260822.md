---
handed-off: finalize-merge-upstream-master-into-llm-20260822
deliverable-complete: false
---
Integrated upstream `endojs/endo` master `30147f5aa` into the fork’s current `llm` head `122fc2644` with true merge commit `124d8210e`. Preserved deliberate `llm` divergences across 70 conflicts, ported compatible upstream configuration/parser/SES changes, and documented non-obvious resolutions in PR #1048.

Kept regenerated `yarn.lock` isolated in commit `df0c9fb40`. Added follow-up compatibility fixes for SES permits, parser typing/formatting, daemon lockdown diagnostics, canonical security policy, and changelog import ordering. Pushed integration head `444dd653c` to `merge-upstream-master-into-llm-20260822`.

Verification:

- `npx -y prettier@3.9.6 --check ...` — passed.
- `bash scripts/check-security-md.sh` — passed.
- `git diff --check` — passed.
- CI at `dca83a950`: 26/27 passed; remaining security-policy mismatch fixed.
- CI at `f079a311c`: 25/27 passed; import-order failure fixed, while the macOS thixotrope timeout was a transient failure that passed in the preceding run.
- PR remains open and GitHub reports it mergeable; current 27-check run is attached to `444dd653c`.

The attempt deadline arrived before the current full CI run could finish. Posted durable successor job `finalize-merge-upstream-master-into-llm-20260822`, which owns final CI remediation, PR documentation, merge-commit landing into `llm`, ancestry verification, and completion-summary commenting.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/merge-upstream-master-into-llm-20260822.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 10217s

<!-- garden-usage-end -->
