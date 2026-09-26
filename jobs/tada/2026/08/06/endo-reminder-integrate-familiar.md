Job complete. Report follows.

---

## Completion report: `endo-reminder-integrate-familiar` (designer)

**Deliverable:** Design plan for integrating `@endo/reminder` into Familiar, as a draft PR against `llm`.

- **Design file:** `designs/endo-reminder-familiar-integration.md`
- **Draft PR:** https://github.com/endojs/endo-but-for-bots/pull/938 (base `llm`, on `kriscendobot`… fork branch `design/endo-reminder-familiar-integration`)
- **Journal:** `result` entry `055854Z-result-gardener-fd0ac1.md`

**What I did:** Read the merged plugin sources and tests, the `endo-reminder.md` design, and mapped the `familiar` and `lal` packages via two Explore agents. Wrote a plan concrete enough to execute, validated its mermaid diagram parses (`mermaid.parse` OK), and coordinated with the live sibling peer.

**Key findings (some correct the job spec's premises):**
1. **PR #721 is MERGED (2026-07-30) and APPROVED** — not "open with CHANGES_REQUESTED" as the spec assumed. The API is final; the integration is not gated on the plugin changing shape, and the Phase-2 subscriber-capability delivery baseline needs no SturdyRef work.
2. **Familiar has no capability code of its own** — it is a thin Electron supervisor that bundles and runs an out-of-process Endo daemon + the `packages/lal` agent. So "integrate into Familiar" means wiring the plugin against the LAL agent and having the app own the `@pins` retention. This is the design's Phase-3 "one worked integration demonstrating restart-survival."
3. **The one genuinely missing seam:** LAL exposes no inbound `notify` facet (only `Lal.help`; the agent wakes solely via `followMessages()`). A **durable** recipient-adapter exo must be built to translate `notify(message)` into a wake of the agent loop and settle the one-shot response — durable because `revivePins` resolves `reminder-recipient` by name at boot.

**The plan covers:** integration points (recipient adapter, node-fs store, `setup.js` provisioning + `@pins`, powers guest, agent scheduling tool, `familiar-bundle` CI gate), the exact merged API surface used, persistence/lifetime, per-side changes, trust-posture assessment (unconfined shape fits, with interval-bomb/store-scope mitigations), test strategy, and ordering. It flags that the recipient-adapter/store/`setup.js`/scheduler substrate is **shared** with the in-flight Chat and minion.town plans and should be built once — coordination note sent to the live `endo-reminder-integrate-chat` peer.

**Open questions surfaced (not guessed):** the exact node-fs `reminder-store` minting mechanism (mount vs native writable tree), provisioning home (`setup.js` vs `agent.js`), recipient-adapter revival semantics, resolve-timing, one shared vs per-subagent scheduler, and whether any `packages/familiar` source change is needed at all.

**Follow-ups:** Chat and minion.town peers should cross-reference this design so the LAL substrate isn't triplicated; the build must resolve the six open questions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-reminder-integrate-familiar.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 704 tokens (2908197 cached reads)
- Output: 34286 tokens
- Cost: $4.94930575
- Wall-clock: 856s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
