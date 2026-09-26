All converged. Final state verified.

---

## Completion report

**Directive (issue #543, erights):** the inter-package case of the plain-re-export rule had a design+guidance PR for the *intra*-package case (#544) but none for the *inter*-package case; create it, and have #544 cite the inter-package design PR where it currently cites the bare issue.

**What I did:**

1. **Created PR #548** (`design: inter-package plain re-exports rule (#543)`, draft, base `llm`) — the design+guidance PR for the cross-package case, mirroring #544's shape:
   - `designs/inter-package-plain-re-exports.md` — the cross-package rule (import a name from its originating package, never from a plain re-exporter such as `@endo/far`), rationale (tooling disambiguation, smaller bundles, readable layering), the two-PR deprecate-then-remove staging #543 asks for, and its relationship to the intra-package design #544.
   - `CONTRIBUTING.md` § Coding Style — a concise rule entry pointing at the design.
   - Body carries the "must not merge to `endojs/endo` until confident no outstanding importers" guard from #543.

2. **Updated #544** to cite #548 where it referred to the cross-package *design / rule / staging / style-guide amendment* (design doc + PR body), keeping #543 where the issue itself is meant (Source line, the plain-re-export definition, the follow-up comment). Pushed as commit `50dae1166`; added `Updated: 2026-06-27` to the metadata table.

3. **Posted a top-level acknowledgment** on issue #543 (comment `4815252343`) naming #548, summarizing it, and noting the #544 citation change. Standing authorization for `endojs/endo-but-for-bots` covers the comment.

**Collision handled (notable):** a peer gardener (`...pr543-d40c7324`) claimed the same directive and opened a duplicate PR #549 (`design/cross-package-plain-re-exports`) plus an unpushed `recite` branch that would have re-pointed #544 at #549. I detected the race via leftover scratch worktrees, messaged the peer proposing a deterministic convergence (keep the lower/earlier PR #548, which also matches erights's verbatim "inter-package" wording). The peer independently reached the same conclusion and **closed #549, deleted its branch, and discarded its `recite` edit**, so #544's citation update was not clobbered.

**Final state:** #548 OPEN (draft) — inter-package; #544 OPEN (draft) — intra-package, citing #548 (7 references); #549 CLOSED, branch deleted; #543 comment posted. Both scratch worktrees torn down.

**Follow-ups:** none required. Both PRs are drafts pending maintainer review of the rules before any mechanical churn; the removal-pass follow-ups for each remain the explicit next stage when the rules are approved.

**Self-improvement:** the duplicate-claim race here (two gardeners both claiming a `pr543` attention job and both opening near-identical PRs) suggests attention/triage jobs derived from one comment should carry a dedupe key or a single-claim guard; worth a note to the liaison if it recurs. Nothing landed this time.
