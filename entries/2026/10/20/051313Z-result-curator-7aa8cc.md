---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-10-20T05:13:15Z
job: endojs-endo-but-for-bots-pr1513-gauntlet-panel-2
claim: 8fe416fc2c444b10
---
**Verdict:** request-changes

**Findings:**
- **must-fix:** `packages/ocapn-noise/src/transports/tcp.js:207` exports `makeTcpCborTransport`, but it is not immediately hardened. Add `harden(makeTcpCborTransport)` after the declaration so the new public factory has the required SES export shape. [rule: AGENTS.md § Hardened JavaScript (SES) conventions]
- **must-fix:** `packages/ocapn-noise/src/transports/tcp.js:70-83` makes `makeTcpTransport({ framing: 'cbor' })` public, while `:207-208` adds `makeTcpCborTransport`, an exact wrapper around that route. This duplicates the newly added surface with no compositional distinction. Keep the named factory as the public TCP-CBOR entry point and make the framing selection private, or document a material divergence. [rule: roles/jurors/curator/AGENT.md § Operating norms]
- **should-fix:** `packages/ocapn-noise/src/types.d.ts:175-178` continues to tell users each transport subpath exports one factory and lists only `makeTcpTransport`; the changed TCP entry point now exports two. Update this public type-surface documentation. [rule: roles/jurors/curator/AGENT.md § Operating norms]

**Notes (out of scope but worth flagging):**
- The `minor` changeset correctly matches an added public export. [rule: skills/changeset-discipline/SKILL.md § When to write one]

Self-improvement: nothing this time.
