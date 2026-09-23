Inbox empty. Both halves are delivered and verified. Job complete.

## Completion report

**Job:** `review-improve-existing-cli-surface-equivalence` — close the double loop for the `existing-cli-surface-equivalence` review-miss cluster (endojs/endo-but-for-bots #658, #897, #1085): code panels approved a new public surface without tracing the pre-existing equivalent, so redundant/incoherently-fused surface reached maintainer review. Root cause: the two seats owning that lens (decomplector, ergonomist) are design-panel-only, so a code panel had no lens for it.

**Delivered both halves, landed on main2 in one commit (`5475bc942d`):**

- **(a) Prevention** — `roles/COMMON.md` § *Pre-existing equivalent surface before adding a new one*: a fleet-wide authoring norm (covers builder, web-builder, fixer, gardener-gauntlet — all producer roles) requiring a builder to locate the pre-existing equivalent before adding an exported symbol / CLI verb / path-route branch, and either compose with it or justify the divergence. Mirrors the shape of the existing § *Definite technical claims in authored prose*.
- **(b) Sensing** — `skills/panel-hints/probes/C-curator-sibling-surface.sh` (new probe) + `roles/jurors/curator/AGENT.md` § *Trace the pre-existing sibling surface* (new seat lens), landed together per the "Adding a probe" convention. The probe fires the **curator** on a variant-affixed export/interface method (streaming/eager twin) or a path-discipline surface (`*Path`/`*Segments`/`*NamePath`/`*PathArgument` def, `parsePetNamePath`, a slash split, a "path segment must not" guard, or a path-bearing CLI verb). Slug mismatch avoids double-listing the already-path-triggered curator (same pattern as `C-archivist-claim-accuracy`); its load-bearing role is routing curator onto a PR that changes no package.json/index/.d.ts — the #658 shape `B-curator` alone skips. Documented in `skills/panel-hints/SKILL.md` (content-triggered prose + a Notes-from-the-field entry).

**Verification (re-litigation test, mandatory per member):** `scripts/jobs/test/existing-cli-surface-equivalence-probe-test.sh` — 11/11 pass.
- **#658** → fires on `mountPathSegments` export + `.split('/')` + `write <mount> <path...>` verb; curator traces the pre-existing `parsePetNamePath`/slash-path route → flags duplication.
- **#897** → fires on `segmentsFromEntryPathArgument` + the "Path segment must not" guard; curator traces the CLI adapter's `parsePetNamePath` layer ownership → flags misplacement.
- **#1085** → fires on `streamGlob`/`streamGrep` interface methods; curator traces the eager `grep(pattern, glob(g))` seam → flags the fusion.
- Also confirmed the probe fires on each PR's **full real added-line set** piped through `--scan-stdin`; controls (unrelated export, plain `grep` method, comma split) abstain. shellcheck clean; integration-tested through `panel-hints.sh`.

**Cluster closed:** `review-miss-record.sh cluster-status existing-cli-surface-equivalence closed` → `status=closed`, count=3/3 (members 658/897/1085), `improved_by` recorded on journal2.

**Follow-ups:** none. (Note: the deployed `/home/kris/garden/journal` snapshot was stale at count=2; the authoritative journal2 was already at 3/3 — no action needed.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-existing-cli-surface-equivalence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (4158506 cached reads)
- Output: 41865 tokens
- Cost: $4.754991
- Wall-clock: 641s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
