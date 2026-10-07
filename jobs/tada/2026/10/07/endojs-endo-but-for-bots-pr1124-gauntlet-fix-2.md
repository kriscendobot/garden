Fix round 2 for endojs/endo-but-for-bots#1124 is done. I fixed both must-fix items from the panel's round-2 review (on head `b20669cb4`), pushed one follow-up commit, and CI is green: all 33 checks passed, none failed, at head `8f7e15d7d`.

**1. Decomplector: another path reaches the same authority with no bound.** Any peer can call `endo-peer-entry` → `getGreeter()` → `hello` and get back `localGateway`. Its `provide` resolves the same formula identifiers with no miss bound, and its errors tell the peer why a lookup failed. So the new locator's protections can be bypassed. The reviewer offered two remedies: bound or retire `EndoGateway.provide`, or state plainly that the bound protects nothing until that path is closed. I took the second, because closing the path is daemon-wiring work that this PR deliberately leaves to the successor wiring job.
- **Commit:** `8f7e15d7d` (`docs(daemon,ocapn): state that the miss bound needs the gateway path closed`), pushed with `safe-push-pr-head.sh`.
- **Design doc** (`designs/daemon-ocapn-external-connectivity.md` §2):
  - "Compose" is relabeled from "recommended" to "transitional only; protects nothing yet", with the bypass spelled out.
  - "Migrate" is now "required for the guarantees to hold": retire the fixed `endo-peer-entry` word **and** retire or bound `EndoGateway.provide`.
- **Same caveat added in three more places:** the `makeFormulaNonceLocator` docstring, the `@endo/ocapn` README and `.changeset/ocapn-nonce-locator.md`.
- Prettier passes on the changed files.

**2. Integrator: the PR body didn't follow the template.** I rewrote it into `.github/PULL_REQUEST_TEMPLATE.md`:
- It now has `Refs:` lines (the design §2, #1116, #1013) and a Description that says which design phase this covers (none of the three; it lands only the mechanism and seam).
- It has all the Considerations headings. The gateway caveat is stated under Security Considerations.
- The draft-history wording is gone, and the `garden-job` marker is kept.
- **XS testing:** the coverage-auditor seat flagged XS coverage as must-fix-loop. The PR body now explains why it's deferred: `@endo/ocapn`'s `test:xs` is already a stub on the base branch, and the new code is platform-neutral. An XS harness should come with the daemon wiring.

**Follow-ups (should-fix, not applied):**
- Squash the eight commits into logical ones. Several are named for panel rounds and would land in `master` history.
- Make a throwing `makeLocatorForSession` factory fail closed instead of leaving a half-built session.
- Several corner-case tests suggested by the corner-prober and fast-checker seats.
- The decomplector suggests moving the generic miss bounding into `@endo/ocapn` and reusing `localGateway.provide`.
- Actually closing or bounding the gateway path belongs to the successor daemon-wiring job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1286592 cached reads)
- Output: 10129 tokens
- Cost: $0.9998743999999998
- Wall-clock: 2267s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
