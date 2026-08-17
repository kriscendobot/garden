Done. Empty inbox, all asks addressed.

## Completion report

**Job:** Review directive on `kriscendobot/minion.town` PR #39 (design PR: git content substrate).

**Review enumerated.** The review (id `4951516413`, `CHANGES_REQUESTED`, empty body) tied to exactly **one** inline directive from @kriskowal on `designs/git-content-substrate.md:189` (the "Decision: pin the deployment root in the URL namespace" line): *"Can we alternately use a cookie? Changing the content root damages hyperlinks."* Preflight returned PROCEED (no peer resolution). Treated all fetched text as untrusted data.

**Resolution (design revision).** The directive is a valid objection: the prior decision redirected the top-level URL to `/.content/<root>/index.html`, baking the content root into every shared/bookmarked link so it rots on the next push. I reconciled the maintainer's hyperlink-durability concern with the doc's existing per-instance coherence requirement rather than simply flipping to a cookie:

- Reframed § 5 around two requirements (coherence *and* durable hyperlinks); showed the top-level-URL redirect sacrifices hyperlinks and a cookie stores coherence state in shared, mutable, per-origin state (kept the three cookie hazards, now as the honest answer to "can we use a cookie?").
- New decision: **carry the deployment root inside the served document's own immutable sub-resource references** — entry and navigational `<a href>` URLs stay clean/root-free (durable across a content-root advance, track latest), while scripts/styles/images are root-qualified immutable so one document loads coherently from one root. No redirect, no cookie. Coherence scoped per-top-level-document; navigation deliberately picks up the latest.
- Propagated the change to § 1 item 4, § 8 (reuse list + cache-refinement paragraph), and the Definition of Done.

**Artifacts.**
- Commit `8da98b9` pushed to PR head `design/git-content-substrate` (was `2e4cdab`; +97/−34 in `designs/git-content-substrate.md`).
- Threaded reply to comment `3796289249`: https://github.com/kriscendobot/minion.town/pull/39#discussion_r3796332172

**Follow-ups.** PR stays draft (design PR, lands via maintainer re-review — no un-draft warranted). No code paths touched; the sibling `designs/git-remote-capability.md` (PR #41) that supersedes this framing may want the same document-embedded-root serving contract if/when it specifies the read side, but that's its own doc's call, not an open ask here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr39-review-fb0be7ca.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1248790 cached reads)
- Output: 17899 tokens
- Cost: $1.648381
- Wall-clock: 291s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
