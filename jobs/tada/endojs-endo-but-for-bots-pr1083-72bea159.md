The deliverable is posted and verified on the board.

## Completion report

**Job:** `endojs-endo-but-for-bots-pr1083-72bea159` (attention directive, role routing) — kriskowal on merged PR #1083 asked me to *post a follow-up job to add an indelible npm registry capability in every guest inventory*.

**What I found:**
- PR #1083 ("docs: design npm registry as directory tree") is **MERGED**; it landed `designs/npm-registry-as-directory-tree.md` (status "Not Started").
- Preflight returned exit 2 (HINT). Corroboration disproved a peer resolution: the one PR reply carrying the `<!-- garden-reply:5536135708 -->` marker said "I've posted a job (`endojs-endo-but-for-bots-pr1083-72bea159`)" — but that names **this attention job itself**, not a real follow-up. A board sweep of `journal/jobs/{plan,todo,doin,tada}/` found **no** job matching the directive (nothing on "indelible" / "guest inventory" beyond this job). So the actual follow-up had **not** been posted. → treated exit 2 as PROCEED.

**What I did:**
- Grounded the ask in the two design docs (`npm-registry-as-directory-tree.md`, the deprecated `registry-capability.md` with its `@registry` host-special-name precedent) and posted a **designer** follow-up job.
- Basename: `design-npm-registry-indelible-guest-inventory` (role: designer). First post was falsely deduped because post-job derived this attention job's directive identity from my body; re-posted with a distinct identity `…:5536135708:followup:indelible-guest-inventory`.
- The job body scopes a self-contained design: placement in the guest inventory, the indelibility mechanism, ocap/attenuation safety (read-only, no ambient authority), Node+Endor parity, and migration — landing per the designer bare-vs-PR rule, with a build to follow.

**Verified artifact (on origin/journal2):** `jobs/doin/design-npm-registry-indelible-guest-inventory.md` — posted, then already **claimed** by `endolin-garden2-5bcdff64/cleric-1` (journal2 commits: `todo(design-npm-registry-indelible-guest-inventory) posted` → `claim(...) cleric-1`).

**Follow-ups:** none required from me. The designer job now owns the design; a build job follows from the accepted design. The auto-generated retro job (`plan/endojs-endo-but-for-bots-pr1083-72bea159-retro`) is a separate second-loop and not part of this deliverable. Inbox empty.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1083-72bea159.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 54 tokens (1482106 cached reads)
- Output: 13278 tokens
- Cost: $1.6494130000000002
- Wall-clock: 299s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
