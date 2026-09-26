Done. The follow-up commit is on the PR branch and the note is posted.

## Completion report

**Job:** Absorb the deployment-coherence decision that #39 (`git-content-substrate.md`, merged to `main` via PR #39, final commit `d69a3b8`) settled into the superseding #41 design (`git-remote-capability.md`, branch `design/git-remote-capability`), so #41 does not silently re-open a question @kriskowal's review already closed.

**What I did (design-doc only — no live/runtime change):**
- Read the merged `designs/git-content-substrate.md` at `289d1a3` (esp. § 5, § 8) and `designs/git-remote-capability.md` at `609fdd5`. Confirmed the gap: #41's § 9 carried only the mutable-ref/immutable-blob `no-cache`+`ETag` read-path discriminant and never treated cookie-vs-URL-vs-in-document pinning or hyperlink durability.
- Made four coherent edits to `designs/git-remote-capability.md`:
  - **§ 9** rewritten to import #39 § 5's decision **normatively** — deployment root in the document's own immutable sub-resource references (no URL redirect, no cookie); the refined **two-tier** cache policy (`no-cache`+`ETag:"<contentRoot>"` on mutable entry/navigational documents; `max-age=31536000, immutable` on root-qualified `/.content/<contentRoot>/` sub-resources); per-top-level-document coherence scope keeping navigational hyperlinks clean/durable; and the projection/validation duty to root-qualify sub-resource refs while leaving `<a href>` root-free.
  - **§ 8** reuse bullet (b) now names the deployment-coherence decision among what #41 inherits from #39.
  - **§ 11** reclamation reconciled with #39's retention rule — a superseded `contentRoot` is unreachable from the live ref tip yet must stay served behind a retention horizon/lease while an advertised immutable URL can still request it; ref-reachability alone is not the reclamation boundary for a serving partition. (This also prevented a latent contradiction between the two docs.)
  - **Definition of done (§ 13)** updated to record the inherited decision.

**What changed:** 1 file, +75/−15. Commit `b344112` pushed to `design/git-remote-capability` (CAS push clean, no rebase needed).

**Noted on PR:** review-feedback comment posted to #41 → https://github.com/kriscendobot/minion.town/pull/41#issuecomment-5321543937

**Respected constraint:** did not propose landing the #39 projector experiment upstream (deferred by its own status line).

**Follow-ups:** none required by this job. (Pre-existing dangling items already tracked in #41 itself: #40 vitals-weblet substrate reconciliation and the marking of #39 as superseded — both out of scope here and already flagged in-doc.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr39-d69a3b8-reconcile-pr41.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (985673 cached reads)
- Output: 13608 tokens
- Cost: $1.5784064999999996
- Wall-clock: 192s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
