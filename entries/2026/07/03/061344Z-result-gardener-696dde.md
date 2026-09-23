---
kind: result
role: gardener
host: endolinbot2
at: 2026-07-03T06:13:46Z
---
Ingested danfinlay/quickjs @ `native-ses` (commit `49dc75e`, a quickjs-ng fork
adding native SES) into the context library under the XS-evolution lens (job
`scholar-ingest-quickjs-native-ses`, kriskowal 2026-07-03). Read-only research
distillation; no PR/issue/fork interaction.

**Source ingested (5 sections):**
`library/sources/danfinlay-quickjs--native-ses.md` with sections
`architecture-overview`, `harden-c-deep-freeze`, `lockdown-freeze-intrinsics`,
`compartment-context-model`, and the centerpiece `xs-transferable-strategies`.

**How native SES is realized (engine level).** Three C primitives:
`harden()` = `JS_DeepFreeze` (recursive C deep-freeze over
props/getters/setters/prototype with a visited set; skips proxies/module-ns;
re-reads moved pointers; preserves identity); `lockdown()` =
`JS_FreezeIntrinsics` (two-phase: force-resolve lazy AUTOINIT intrinsics, then
deep-freeze the reachable graph while keeping the global extensible);
`Compartment` = a fresh `JSContext` on the shared `JSRuntime` (realm-level
isolation, standard intrinsics only, strict eval, endowments copied as live
parent-heap refs). **Key characterization:** it realizes SES's *freeze* half
but **omits the taming/permits half** — no permits whitelist, no intrinsic
removal/repair, no determinism scrub, no eval/Function/Error taming, no
membrane at the compartment boundary. JIT-free (like XS), so no JIT-based
technique to reject.

**Transferable strategies + perf-vs-safety verdicts (the deliverable).**
Seven strategies with verdicts on the safety-first axis:
- **Adopt:** S1 engine-native deep-freeze (large, safety-neutral SES-startup
  speedup — but use a hash set / GC-mark bit, not the fork's O(n²) array);
  S2 force-resolve lazy intrinsics before sealing (correctness invariant);
  S3 snapshot-primed realms per compartment (answers xs-from-rust open-Qs
  #3/#6); S7 the small correctness details.
- **Reject:** S3′ shared-heap live-reference object passing (weakens isolation
  to realm-level — XS's separate-heap marshaling membrane is the safer boundary
  even though slower); S5 dropping permits/taming (a freeze-only `lockdown` is
  not a secure `lockdown` — the load-bearing asymmetry); S6 the string-splice
  `import('spec')` loader (keep XS/Endor's structured ModuleSource path).

**Connected to the XS→Rust (Endor) cluster.** Cross-linked to
`projects/endo-but-for-bots/xs-from-rust-investigation.md` and the designs
`xs2rust-endor-engine.md` / `daemon-rust-xs-performance.md` /
`daemon-xs-worker-snapshot.md` (PR #600 on endojs/endo-but-for-bots): S1/S7 →
the perf work, S3 → the worker-snapshot design, S5 → a guardrail on any native
`lockdown` in the Endor engine, S3′/S4 → the membrane-discipline rationale.

**New topic** `engine-implementation` (engine-level SES/ocap implementation;
sibling-engine comparisons for the XS→Rust program). Rows added to
`compartments` (26→29) and `hardened-javascript` (87→91); new source row in
`sources/README.md` (sibling-implementations table); new topic row in
`topics/README.md`.

**Integrity gate (step 8):** `library-link-check.sh --source-slug
danfinlay-quickjs--native-ses` → OK (all 5 section-table links resolve to
committed files); `regenerate-topics-counts.sh --check` → current.
**Regeneration (step 9):** `regenerate-sections-index.sh` and
`regenerate-topics-counts.sh` both landed and re-run idempotent (no further
diff).

No follow-on backlog: the SES surface is small and fully covered in one cycle
(the C implementations of harden/lockdown/Compartment plus the two test files).
Idempotency anchor recorded: fork branch `native-ses` HEAD `49dc75e`; re-ingest
only on a new HEAD touching the SES code.
