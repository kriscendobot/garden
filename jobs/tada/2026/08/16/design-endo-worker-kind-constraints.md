The work is complete. Let me write the report.

Design job complete. I designed a forward-looking, portable **worker constraint model** for the daemon and landed it as a design doc via PR (the `llm` branch is now branch-protected, so direct pushes are rejected — I routed through the kriscendobot fork and opened a PR).

## What I did

- **Traced the exact seam** the closed `kind: 'locked' | 'node'` union threads through: the `WorkerFormula` field and `DaemonicControlPowers.makeWorker` signature in `types.d.ts`; `formulateNumberedWorker`, `makeIdentifiedWorker`, `provideWorkerId`, the `defaultWorkerKind` option, and the `workerFormula.kind ?? defaultWorkerKind` archive-vs-tree resolution in `manager.js`; the load-bearing binary-selection in `bus-manager-rust-xs.js` (`ENDO_WORKER_BIN` vs `ENDO_NODE_WORKER_BIN`); the kind-ignoring Node/Go backends; and the caller surfaces (`@node`/`@main` special names, CLI `endo make`). Confirmed it threads through exactly five points and no others.
- **Wrote `designs/worker-constraint-model.md`** (Proposed): an open, multi-axis `WorkerConstraints` schema — **runtime**, **persistence**, **version**, **platform/arch** — each independently optional and flexible-by-default.
  - Today's `locked`/`node` become the two seed points of the runtime axis (Ironhorse `xs-in-rust` reserved as the third), migrated with **zero behavior change and zero formula-identity churn**: a fully-flexible request serializes byte-identically to today's no-`kind` formula, and the two legacy kinds keep their legacy `kind` formula bytes; a `constraints` field appears only for genuinely new axes. Precedence rule: `constraints.runtime` > legacy `kind` > `defaultWorkerKind`.
  - **Persistence** axis is the durable/orthogonal-persistence extension point, typed so **#984 (metered-storage) is one constraint combination, not a bespoke kind** — the brief's stated acceptance test. Reconciled (not duplicated) with thixotrope #786, quiescence embargo #989, snapshot substrate #281, live-upgrade continuity #813, sturdy-refs #511.
  - **Version** and **platform/arch** land as the two previously-unfiled categories' first home — typed `Not Started` extension points. Platform names the exact binary-fetch seam in `bus-manager-rust-xs.js`'s `makeWorker`, explicitly distinguished from the AWS state/blob storage line (#637/#689).
  - Flagged the additive `makeWorker`/formula surface, a `resolveWorkerConstraints` seam with an axis→backend mapping table, five open questions, and the informational `worker-rust-xs.md` status-sync (not this job's work).
- **Updated `designs/README.md`**: summary-table row + top "Layered on" note (count 151→152, Proposed 26→27), M11 bucket.

## What changed / follow-ups

- **PR #996** against `endojs/endo-but-for-bots:llm` (from `kriscendobot:design-worker-constraint-model`) — awaits panel review per the repo's design-corpus process.
- Note: I initially attempted a direct commit to `llm`; branch protection now requires a PR, so this design went through the fork-PR flow. Verified all markdown links resolve (the AWS storage doc isn't on `llm` yet, so it's referenced as a code-span, not a dangling link).
- Genuine follow-up left as a doc-hygiene item: `designs/worker-rust-xs.md` still reads "Not Started" though #600 merged — flagged informational, out of scope here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-worker-kind-constraints.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1982925 cached reads)
- Output: 24284 tokens
- Cost: $2.4134454999999995
- Wall-clock: 387s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
