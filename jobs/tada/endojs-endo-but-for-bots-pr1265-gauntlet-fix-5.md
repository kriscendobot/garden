CI is GREEN (29 checks, 0 failed, rc 0). The fix is pushed and CI passed. Job complete.

---

## Completion report

**Job:** endojs/endo-but-for-bots PR #1265 gauntlet FIX round 5 — design(daemon): mutable blob (block-storage) counterpart to readable-blob.

**What I did:** Read the panel-5 verdict (request-changes from critic, skeptic, ergonomist, pedant; comment-only from decomplector, copyeditor, novice, orthographer) and applied its must-fix items once to `designs/daemon-mutable-blob-block-storage.md`, pushed as a review-feedback follow-up commit, and watched CI to green.

**Changes (commit `3a604d292`, +119/−38 to the one design doc):**
- **critic / decomplector / novice** — Reframed "Two independent authorities" up front as **content-independent, not blanket authority-independent**, moving the size-probing exception's forward pointer into that section instead of only the later caveat. Noted the middle-anchored two-call workaround is safe only under a single-writer assumption at the point it is prescribed. Confirmed `EndoMountFile`'s whole-value write surface is deliberately out of scope.
- **skeptic** — Named the new cheap `size()` accessor as a deliberate divergence from `rangeReadMethodGuards` (which has no size accessor; a prior `sha256()` was consolidated into `getInfo()`), to be reconciled with `fs-interface-consolidation.md`. Added a confidence blockquote flagging the CASK-mechanism section as external recall not checkable in-repo. Stated that forbidding `offset > size` is stricter than the literal prompt.
- **ergonomist** — Adopted the `EINVAL:`-prefixed error shape (matching `cas.js`, `lock-table.js`, `xattrs-exo.js`, `readableblob-range-attenuation.md`) for the offset/length rejections. Explained why block-storage keeps `rangeRead(offset, length)` now and migrates to `range(start, end)` alongside readable-blob. Named the host-side `storeBlob` overload `storeBlockStorage` parallels for the optional `petName`, flagging the guest/host disagreement.
- **pedant** — Sentence-cased the `## Open questions` heading (kept the template heading "What is the Problem Being Solved?"), standardized within-doc section cross-references to the quoted form, and recast the trailing Open-questions bullet as a question.

I verified each factual claim against the checkout (cas.js EINVAL string, guest.js pet-name throw, rangeReadMethodGuards shape, the attenuation doc's `range(start,end)` recommendation) and kept the doc em-dash-free per repo convention (rewrote 7 em-dashes I had introduced into periods/colons/parens).

**Result:** Pushed to PR head; CI terminal GREEN (29 checks, 0 failed). Stopped without re-running the panel, per the stage contract — the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1265-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 118 tokens (4865444 cached reads)
- Output: 32321 tokens
- Cost: $4.231465000000001
- Wall-clock: 1097s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
