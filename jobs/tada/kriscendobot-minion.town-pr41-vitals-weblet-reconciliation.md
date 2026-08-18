The work is complete. PR #49 is open (draft, against `main`), the doc is reconciled, and the mermaid re-validates.

## Completion report

**Job:** Reconcile `designs/vitals-weblet.md` (#40) onto the superseding capability-addressed git remote design (`designs/git-remote-capability.md`, #41, merged to `main` at `b23b091`), which #41 § 8 and #39 both explicitly deferred to a separate job.

**Decision made (stated, not left open):** The vitals weblet's delivery substrate is now a **capability-addressed partition the garden's leader pushes to** — the leader holds a write capability for the `vitals` partition as a pet-named ocap, and a `git push` of the `vitals/` subtree replaces "commit to `journal2` and wait for a poll." Publishing is push-triggered (`receive-pack` interns → projects the tip tree → re-points the record), so there is no poll interval. The read-only **polled mirror is deliberately retained as a labeled bridge** (the degenerate special case #41 § 8 names), for the case where the weblet is built before #41's partition/git-server stack (§ 12, named-not-actioned) lands; cutting over changes neither the rendered view, privacy, nor isolation fit.

**What changed in the doc (204 insertions, 134 deletions):**
- Header/"What this is", status block, grounded-against "delivery substrate" bullet, and companions/header — reframed onto #41; #39 recast as superseded-but-retained bridge.
- § 1 shape + **mermaid** — push-triggered flow; the `weblet-git-sync` poller node and `git fetch (poll)` edge replaced with the leader push → authenticated git endpoint.
- § 4 — new *Delivery substrate* / *bridge* subsections; arming as a held write capability; content-types onto the reused git-tree→manifest projector; freshness budget with no poll interval.
- § 6 base32 origin from partition identity; § 7 assets assembled into the pushed tree; § 9 dependency table now the #41 partition path with #39 G1–G3 as the lighter bridge prerequisite; § 10/§ 11/DoD updated.
- **Preserved unaffected** per #41 § 8: #40's rendered view (§ 2), privacy carry-over (§ 5), isolation-floor fit.

**Verification:** Mermaid re-validated parse-only → `flowchart-v2 OK`. No new Latin shorthand; pet-name spelling and the doc's existing glyph style preserved. Scope discipline honored: design-document only, no code, and no action on #41 § 12's named-not-actioned `endojs/endo-but-for-bots` work.

**Output:** Draft PR **kriscendobot/minion.town#49** against `main` (https://github.com/kriscendobot/minion.town/pull/49), carrying the `garden-job` marker.

**Follow-ups:** None required by this job. The PR is draft in the usual way for this repo; a maintainer review or gauntlet run can un-draft it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr41-vitals-weblet-reconciliation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (4772184 cached reads)
- Output: 45676 tokens
- Cost: $4.742553
- Wall-clock: 634s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
