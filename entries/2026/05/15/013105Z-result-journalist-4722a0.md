---
ts: 2026-05-15T01:31:05Z
kind: result
role: journalist
project: endo-but-for-bots
refs:
  - entries/2026/05/15/012700Z-dispatch-steward-4722a0.md
---

Populated the *Unstarted designs* bulletin section in `journal/README.md` per garden issue #2, replacing the placeholder text installed by gardener `7d4081`.

**Inventory results** (against `endojs/endo-but-for-bots@llm` at 2026-05-15T01:30Z):

- 117 candidate designs total (115 top-level `designs/*.md` plus 2 per-package `packages/*/designs/*.md`, excluding `CLAUDE.md` and `README.md`).
- 33 covered by an open or merged feat/fix/chore/mirror/test/refactor/ci/docs PR cross-referencing the canonical path.
- **84 uncovered.**

Coverage rule applied per the brief: closed-not-merged PRs do not cover; merged design-landing PRs with `headRefName` starting `design/<slug>` do not cover (they are the design's landing, not its tracking PR). Match required the canonical path string in PR title, body, or headRefName.

**Top-3 uncovered** (rendered into the bulletin table):

1. `designs/retention-path-notation.md` — last-modified 2026-05-12T00:23:53Z. Status Proposed; design landed via #181 but no tracking-PR for the bulk `listRetentionPaths` method.
2. `designs/endo-gateway.md` — last-modified 2026-05-12T00:19:30Z. Status Proposed; design landed via #199; per-user-daemon-and-system-gateway split awaits a builder dispatch.
3. `designs/trust-on-first-bind.md` — last-modified 2026-05-10T05:47:31Z. Status Reference; design landed via #164; the TOFU pattern is reference material for HTTP-client / Browser / Shell / Mount consumers but has no tracking PR pinning the consumer integrations.

Rendered top-15 newest-first as a markdown table with columns: last-modified date, canonical path (linked to `llm`), slug, one-line summary distilled from each design's *What is the Problem Being Solved?* opener plus Status line. Header notes the inventory date and total count (84). Footer points at [`skills/design-to-pr-pipeline/SKILL.md`](../../skills/design-to-pr-pipeline/SKILL.md) as the controlling skill that regenerates the inventory each cycle.

Cap of 20 was the brief's outer bound; settled on 15 because (a) the bulletin is a dashboard not a backlog and the maintainer's attention budget is the constraint, and (b) the 16th-through-20th entries share the same 2026-05-02 timestamp tie (a bulk-import commit touched eleven designs at once), so the dividing line between row 15 and row 16 is not a meaningful recency boundary.

Then commented and closed issue #2 (`kriskowal/garden`) per the dispatch brief: the section is now populated and the steward refreshes on each design-to-PR cycle.

Self-improvement: the bulk-import commit (`2026-05-02T14:18:35Z` touches ~11 designs simultaneously) defeats "last-modified newest-first" as a fine-grained recency signal for that cohort. A future revision of `skills/design-to-pr-pipeline/SKILL.md` could fall back to the design document's own `Updated` frontmatter line as a tiebreaker when the commit-date is shared across many designs.
