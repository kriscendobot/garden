---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-10-23T16:10:11Z
job: endojs-endo-but-for-bots-pr1367-gauntlet-panel-2
claim: 5fc706df7882e9d9
---
Originating dispatch: skeptic jury review for endojs/endo-but-for-bots PR #1367; reviewed only `d5ac41980a675aba1a2e5b8cd8d518f74625eff7...HEAD` in `/home/kris/garden/scratch/project-wt-endojs--398d542f16a0-e3dd506c`.

**Verdict:** request-changes

**Findings:**
- **Must-fix:** `designs/daemon-git-remote-capability-urls.md:52-55,116,123,130-133` promises that the supplied URL token reaches only the material map and will not appear in the formula record or audit log, but the design gives no redaction or non-recording boundary for the secret-bearing `capabilityUrl` host-method argument. Merely testing the claimed absence cannot make that premise true: normal formula/audit serialization can retain method arguments before the helper separates them. Specify the redacted call/record representation and the layer that prevents persistence, then exercise that real serialization path in the integration test. [proposed-rule: A design that introduces a host method accepting a secret must specify the record and audit redaction boundary for that argument, and test the actual persistence path rather than only asserting a desired absence.]
- **Should-fix:** `designs/daemon-git-remote-capability-urls.md:16,107,130-133` claims the token never reaches argv, but its test catalog checks formula records, inspection, audit, and rejections only. Add an execution-level regression assertion against the spawned Git/askpass invocation, or narrow the claim to the previously verified fd-pipe transport guarantee. [proposed-rule: Every separately claimed secret-exposure channel, including process argv, needs a matching execution-level negative test in the implementation plan.]

Self-improvement: nothing this time.
