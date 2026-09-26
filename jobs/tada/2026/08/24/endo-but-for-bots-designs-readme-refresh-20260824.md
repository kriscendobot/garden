The work is complete. The README index has been refreshed, committed under the bot identity, and — because `llm` is branch-protected requiring PRs — landed in draft PR #1057.

## Completion report

**Job:** Refresh `designs/README.md` on `endojs/endo-but-for-bots@llm` so it accurately indexes the current state of `designs/`.

**What I did**

Audited the summary table against the actual `designs/*.md` files on `llm` (HEAD `edb59f2eee`) and against each design file's own Status header, then made a surgical, conventions-preserving refresh (not a rewrite):

1. **Indexed six landed designs that had no summary-table row** — the Ironhorse trio (`ironhorse-engine` Approved, `ironhorse-meter-opcode-cost-instrumentation` Not Started, `ironhorse-test262-convergence` In Progress), plus `platform-neutral-hash` (In Progress), `conservative-regexp-subset` (Not Started), `readableblob-range-attenuation` (Proposed). After this pass every design file on disk has a table row (verified by diff).

2. **Folded the three Ironhorse designs into the M11 (Rust Daemon `endor`) table**, matching the convention that their `ironhorse-snapshot-store-seam` / `ironhorse-debugger-recovery-and-uncaught` siblings already live there, with sourced one-line notes.

3. **Reconciled stale Status cells** against each file's own header: importLocation stack (`daemon-worker-import-from-mount`, `registry-capability`, `mvs-resolver`, `snapshot-mapper`) Proposed → Not Started (applying the 2026-07-10 flip the prose recorded but the table never carried); git trio (`daemon-git-capability`, `daemon-git-remotes`, `daemon-git-next-steps`) Proposed → In Progress; `daemon-agent-network-identity` / `daemon-locator-terminology` Not Started → In Progress; `agentry-git-verb-gaps` / `endopi-edit-tool` Proposed → In Progress; `endo-fs-seam-review-followups` Proposed → Complete.

4. **Refreshed totals** — added an authoritative `2026-08-24` current-totals line (191 designs; tally reproducible from the Status column) superseding the drifted historical counts, plus top-of-file and totals `Layered on 2026-08-24` notes in the file's existing voice.

I deliberately left editorial-only differences untouched (Draft≈Proposed, Complete≈Implemented, Reference≈Current, `break-dev-dependency-cycles`'s intentional Complete-on-`llm` marking) to avoid churn.

**What changed:** one file, `designs/README.md` (+39 / −12).

**Landing:** committed under the bot identity; `llm` is branch-protected ("changes must be made through a pull request"), so I pushed head branch `kriscendobot:designs-readme-refresh-20260824` and opened **draft PR endojs/endo-but-for-bots#1057** via `ensure-pr.sh` (job marker embedded for idempotency). The draft opening will trigger the garden's auto-gauntlet.

**Follow-ups:** none required from me; the PR awaits panel/maintainer review and merge. (Note: the repo currently has >200 open bot PRs, so the marker query needed `GARDEN_ENSURE_PR_LIST_LIMIT` raised — worth being aware of for other endo-but-for-bots PR jobs.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-designs-readme-refresh-20260824.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (5536942 cached reads)
- Output: 41810 tokens
- Cost: $5.203175000000002
- Wall-clock: 696s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
