---
handed-off: daemon-git-clone-bootstrap-design-split
deliverable-complete: false
---
**Handed off: I did not open a new design PR. The design update is pushed to draft #709, and the only work left is publishing its PR description, which now belongs to `daemon-git-clone-bootstrap-design-split`.**

**Why no new PR:** draft #709 already carries `designs/daemon-git-clone.md`, from an earlier job with the same request, and draft #1538 implements it. A second PR would compete with both. The job's other premises were also out of date:
- `daemon-git-next-steps` has no § Open Work section on `llm`.
- The mount creation and `EndoMount` + `Git` return it asks for are rejected in the design: the mount stays an input and the call returns `{ git, remote }` (Design Decision 2).

**What changed on #709 (commit `d8f255557`):**
- **Contract:** the design now matches #1538 at `f00001ed01`:
  - the clone names only the `Git`, and `origin.petName` is refused;
  - the destination is exclusive, and a failed clone clears the mount so the call can be retried;
  - XS refuses the clone before anything is cloned.
- **False claim corrected:** the draft said a caller could retry after a daemon restart. A daemon that stops mid-clone actually leaves partial content, and a retry into that mount is refused.
- **`daemon-git-remotes`:** it no longer says the bootstrap returns an `EndoMount`.
- **`designs/README.md`:** the design's updated date is now 2026-11-02.

**New open questions, added to the two already there (commit signing and a clone depth bound):**
1. Should this document land as the contract, or should #709 close in favor of `daemon-git-remotes`, where #1538 writes the same contract?
2. Should the exclusive destination stand? The liaison proxy only ruled for it tentatively, on #1538.
3. Should the daemon reclaim a mount left partial by a restart during a clone?

**Checks:** the mermaid fence parses, and the orthography and cliché greps report 0 candidates. No code changed, so I ran no tests.

**Not finished:**
- **PR description:** `gh pr edit` gets a 403 on this host, so #709 still shows the old description, without the new open questions or this job's marker.
- **Design panel:** none has reviewed the new head; the last one saw `5724cc6e23`. The child's report is set up to stage one, but I haven't seen that happen.

**Split decision: indivisible.** The remaining work is one PR-description edit, so there is nothing to partition. The overrun came from repo-lock contention and a stalled `ensure-pr --find-only` on this host, not from the size of the work.
- **Parked child:** `daemon-git-clone-bootstrap-design-expanded-window`, pinned to `endolin-garden-ece02cb4` with a 3600s timeout and the full description embedded.
- **Recorded orchestration:** `daemon-git-clone-bootstrap-design-split`, serial with one child. I confirmed both records on `origin/journal2`, with the reason and timeout on each.

If endolin is over its token cap, the child may wait unclaimed; that has happened with these relays before.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-git-clone-bootstrap-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 12 tokens (885154 cached reads)
- Output: 7083 tokens
- Cost: $2.2456837999999997 (1 engagement(s) unpriced)
- Wall-clock: 2948s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
