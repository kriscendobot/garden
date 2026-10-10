The round-1 fix for PR #1435 is done and CI is green. I pushed one commit, `7d2d6f8d12`, to `design/moddable-10-0-0-ironhorse-port-plan`, and nothing is left uncommitted. CI passed on that head: 6 checks succeeded and 22 were skipped. I did not re-run the panel; the driver posts round 2.

**What the commit changes in the design:**
- **Split the immutable-ArrayBuffer child.** It now covers only the feature itself. A new sixth child, `moddable-10-0-0-ironhorse-oracle-validation`, takes the oracle move to XS 10.0.0, the overlay re-check, the hardened262 five-host run, the capture-group sanitizer run and the ratchet comparison.
- **Run order.** The five port children now run in parallel, and one failing child no longer blocks the others. Child 6 stays parked until the ports finish with no failed children, and the design gives the exact commands to start each stage.
- **Evidence.**
  - Every classification row now names its XS commit and the child that owns it, and a summary count sits above the table.
  - A new section says the pass/fail claims come from the checked-in expectation files at `7d2eb307a`, with a command to reproduce them.
  - Every `already-conformant` row now gets a targeted Rust test in a named child.
- **Pinned values.** `Math.round(±Number.MIN_VALUE)` should give `±0`, taken from the spec. The 65,535 scope-slot rule is quoted from the XS change `cfe72a8cfcd2`, and child 2 must port the XS test unchanged. The capture-group check is split between child 3 (the IronHorse test) and child 6 (the oracle run).
- **Readability.**
  - `Temporal/host-excluded` is renamed `host-excluded`, and `Math.irandom` moves into it.
  - The opening now explains IronHorse, XS, the oracle and the ratchet terms.
  - There is a worked revoked-Proxy example, and the capture-group note and ownership map moved to appendixes.
  - The design now uses American spelling and plain ASCII symbols.
- **`designs/README.md`.** Three entries now describe the six-child plan.

**Job board:** I parked the new validation child at `go-ahead`, narrowed the immutable-buffer child, and added notes to children 1–4.

**Panel points I did not change:**
- I kept the existing child names instead of renaming jobs that are already parked.
- Pedant's heading-case finding needed no edit, because every heading is already sentence case.

**Follow-up:** before starting child 6, whoever activates it must read `failed-children` in the ports completion record. `promote-plan.sh --require-tada` does not check that field.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (4215966 cached reads)
- Output: 32920 tokens
- Cost: $4.868750199999999
- Wall-clock: 1028s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
