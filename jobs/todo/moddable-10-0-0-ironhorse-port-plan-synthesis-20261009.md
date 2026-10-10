---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-10T02:14:32Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Synthesize the Moddable SDK 10.0.0 to IronHorse port plan

Produce the original designer deliverable; do not implement any ports.

Read and follow `roles/designer/AGENT.md` and its required skills. In a fresh garden-board snapshot, locate and read the completed reports for `moddable-10-0-0-xs-source-inventory-20261009` and `moddable-10-0-0-ironhorse-audit-20261009` using `tada_find_tree`. Recheck any material discrepancy against primary source before using it.

Create the project design/plan for `endojs/endo-but-for-bots` (IronHorse is `rust/engine`, roadmap base `llm`) covering Moddable SDK 10.0.0 prerelease commit `5f215f776f93039755343dbe75a09aa2615045f4` and release range 2026-09-04 through 2026-10-08. Follow the project's design conventions and the designer role's frozen-`llm` draft-PR procedure. The design must:

1. classify every listed release item as exactly `already-conformant`, `needs-port`, `not-applicable`, or `Temporal/host-excluded`, with evidence from named IronHorse code symbols/files and test262 expectations;
2. cover the String.prototype.replace capture-group memory-safety issue explicitly;
3. turn only the `needs-port` set into sized, ordered, independently claimable child jobs and recommend a serial/parallel orchestration shape with dependencies and failure policy; and
4. flag every change to the oracle `xst` version, immutable-arraybuffer validation matrix, or IronHorse ratchet baseline.

Items: immutable ArrayBuffer; Math.round subnormals; charAt/charCodeAt truncation; setFromHex validation order; revoked Proxy IsCallable; TypedArray set/fill/constructor/species ordering and detached checks; String repeat/replace/search; Symbol.for no-arg; Array.from ordering/ToLength; Reflect.apply/construct read order; Object.prototype.toString Symbol.toStringTag via handler; Array.fromAsync next; ArrayBuffer resize rejection order; Set method large size; Atomics.wait; Math.irandom; >65535 scope slots; labelled switch break/continue; and replace capture-group memory safety. Keep ECMA-419/device/Piu/board/TypeScript/xsdb out of scope unless the evidence proves an IronHorse impact.

Do not start the ports. Park the resulting implementation children according to the standing designer/multi-part pattern, with complete bodies and stable basenames, so they remain held pending the design review/authorization path. Name the recommended orchestration and exact child order in the design and report. Open the draft design PR as the review surface, and report the PR URL plus all parked child basenames.
