---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1301-review-34598631
verdict: miss
category: naming
pr: 1301
cluster: api-method-names-cross-product
cluster_pattern: A public API's sibling methods are named ad hoc (a bare verb like fetch beside range/textRange, or one bundled info getter) rather than systematically across the cross product of the surface's dimensions (content kind x extent, one accessor per algorithm/attribute), and no code-panel seat checks the method set as a whole.
review_at: 2026-09-18T21:21:34Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1301#pullrequestreview-5252703859
identity: endojs/endo-but-for-bots#1301:review:5252703859:retro
producing_role: builder
producing_job: build-readableblob-range-attenuation-20260916
missed_by: ergonomist (design panel, surface coherence) / stylist (code panel, no set-level naming check)
severity: minor
grounds: The maintainer asked for two changes. First, rename the whole-content byte reader so that the reader set follows the bytes/byteRange/text/textRange cross product. Second, split a bundled hash-and-size info getter into separate per-algorithm hash methods plus a size method, as precedent already does. The maintainer said outright that the naming reviewer should catch the first. The rule was already on file. The ergonomist brief requires sibling operations to spell similarly (surface coherence, point a), and the duality-auditor brief requires paired names to share an axis. It did not bind at either review surface. Design PR 826 merged on 2026-07-22 with the asymmetric fetch/range/textRange set, and the journal holds no design-panel run for it. The only code panel over that surface was the 826-build gauntlet on 2026-08-01, whose findings covered liveness and clamping but not naming. PR 1301 was a draft under the manual-gauntlet regime, so its lack of a pre-review gauntlet is policy, not avoidance. The code panel has no seat that reads a public method set as a set. The stylist judges each identifier alone, and the ergonomist sits on the design panel only. The primary job's deliverable exists: commit 5a42d0bff8 records the decisions in the design, and the parked rename stages carry the annotations.
---

# Miss: blob reader method set not named on the cross product of its dimensions

The maintainer asked for naming and shaping changes on the ReadableBlob surface.
The whole-content byte reader should be renamed so that the four readers form a
systematic set: all bytes, a byte range, all text, and a text range. A single
info getter that bundles the hash algorithm, digest, and size should become one
method per hash algorithm plus a separate size method. That lets a blob offer
several algorithms and migrate between them gradually. This is a bot-authored
paraphrase. The untrusted review is available only at `comment_url`.

## Grounds

The garden's seat briefs already carry a sibling-coherence naming rule
(ergonomist, duality-auditor). The asymmetric names came from the merged design
(PR 826). That design has no design-panel run in the journal, and the one code
panel that reviewed the surface (826-build, 2026-08-01) did not raise naming. No
code-panel seat reviews a public method set as a whole.
