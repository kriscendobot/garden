---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr796-review-d2f129fc
verdict: not-a-miss
category: new-direction
pr: 796
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/796#pullrequestreview-4998159010
identity: endojs/endo-but-for-bots#796:review:4998159010:retro
review_at: 2026-08-21T23:27:30Z
producing_role: gardener
producing_job: endo-vfs-parity-press-20260718-122003
missed_by: nobody
severity: none
---

Paraphrase: the maintainer observed that CRC-32 already had another use in Endo
and selected a specific shared implementation shape: a hardened, dedicated
package following the repository's SHA-256 package precedent. The review body
itself was empty and the direction appeared in its sole inline comment. The
verbatim untrusted comment remains available at `comment_url` and is not copied
into this record.

**Grounds: not a review miss because the panel anticipated the reuse problem,
while the maintainer supplied a new architectural choice.** The code panel ran
before review 4998159010 and posted review 4935233760 against the relevant head.
Its purist seat identified that the new daemon CRC-32 implementation duplicated
the existing zip implementation byte for byte, cited the standing
reuse-over-reimplementation rule, returned a request-changes verdict, and
recommended hoisting the implementation to a shared location or exporting it
from zip. The panel fix record then explicitly listed CRC-32 sharing as deferred,
so this was neither an undiscovered duplicate nor a review lens that failed to
fire. The later maintainer review chose one narrower solution from that already
surfaced design space: create a new hardened package patterned after an existing
hash package. No standing seat brief, skill, gate, design, or project rule then
required that exact package boundary instead of the panel's other shared-code
option. The choice was first stated in the review and changed the PR's package
scope, so it is new direction rather than a defect the gauntlet should have
anticipated.

The first loop's deliverable also exists independently of its report. At current
PR head `3ff70e67695a4a2d046c9cb08df25f17b716cccd`, GitHub serves
`packages/crc32/package.json`, and both daemon hashline code and zip's writer
import `crc32` from the new package. That confirms the new direction was carried
out; it does not change this discriminator. No miss cluster is minted and no
improvement job is warranted.
