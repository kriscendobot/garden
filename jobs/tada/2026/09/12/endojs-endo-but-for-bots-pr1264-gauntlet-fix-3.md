CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1264-gauntlet-fix-3 (FIX round 3, PR #1264 — design: daemon storage capability matrix)

**Panel round-3 verdict applied** to `designs/daemon-storage-capability-matrix.md` in one follow-up commit (`9e4fcce51`), pushed to the PR head `design/daemon-storage-capability-matrix`.

**Must-fix (both applied):**
1. Removed all ~16 em-dashes from prose (rewrote each as a period, parentheses, or colon); verified zero `—` remain.
2. Renumbered the duplicated Phase 3 step `5.` → `6.`; migration steps now run 1–6 continuously.

**Should-fix (all applied, source-verified against the PR head tree):**
- **Phase 1 self-contradiction** — corrected: `assertValidFormulaType` runs on the raw on-disk string *before* the alias, so `formula-type.js` must keep the old `readable-*` keys; only the `makers` table and record-writing path drop them.
- **Incomplete consumer enumeration** — ran the repo-wide grep and listed the full set: added `space-chat/src/inventory/tree-source.js`, `space-inventory-graph/src/graph.js`, and `daemon/src/types.d.ts` to the two already named.
- **`sha256()`-as-witness overclaim** — confirmed the daemon's snapshot-blob exo (`makeReadableBlob` → `BlobInterface`) carries no `sha256()` today; corrected the claim to hold at the platform type-tier layer, documented the daemon-exo gap, and added a Phase 2 step-4 action to give the blob snapshot a `sha256()` witness.
- **Third-axis smuggling** — scoped out backing-store as an orthogonal variable (`EndoMount` composed over `EndoDirectory`).
- **Ambiguous `ReadableTreeInterface`** — disambiguated the daemon-local vs `@endo/platform/fs` exports by module path.
- **Prose nits** — "Forming" (not "Formulation"), glossed "formula type" at first use, fixed intransitive "spell".

Incidentally reverted a spurious `packages/floot/package.json` change (a tooling/warm-cache artifact unrelated to this PR) so only the design file was committed.

**CI:** GREEN — 29 checks, 0 failed (docs-only change; substantive jobs correctly skipped, `lint`/`changes`/`zizmor` passed). Confirmed terminal via `ci-wait-merge.sh` rc 0.

Per stage instructions, I stopped after pushing + CI green; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 106 tokens (4255860 cached reads)
- Output: 38630 tokens
- Cost: $4.0847430000000005
- Wall-clock: 1162s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
