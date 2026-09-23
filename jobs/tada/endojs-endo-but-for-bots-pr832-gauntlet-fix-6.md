CI is green (rc 0). The fix round is complete.

## Completion report

**Job:** gauntlet FIX round 6 for endojs/endo-but-for-bots PR #832 (design doc `readableblob-lines.md`).

**Latest panel verdict (round 6):** must-fix — critic, skeptic, decomplector, novice requested changes; ergonomist approved; copyeditor/pedant comment-only.

**Fixes applied** (one follow-up commit `675d412bc` to the PR head, verified against the actual daemon source before writing):

- **Growth mid-stream (decomplector must-fix + critic + decomplector should-fix):** replaced the "resumption exact without re-reading consumed lines" claim, which the design's own scan-from-top mechanism cannot support, with the truth: `startLine`-resumption is exact but re-decodes from byte 0 each call (O(K·N) over K polls), a concrete reason the deferred follow-mode reader matters. Added the append-only invariant `startLine` rests on, and the silent-reshift failure mode if a live source truncates/rewrites consumed content.
- **Revocation mid-stream (skeptic ×2 + copyeditor):** corrected the streaming-recheck precedent from single-shot `getInfo`/`fetch` to `streamBase64` (per-chunk revocation recheck, confinement once — verified at `mount.js` streamBase64); corrected the error characterization to the bare `Error('Mount has been revoked')` the daemon actually throws (verified `assertLive()` tags no `code`/`EPERM`), pinning the *outcome* rather than an EPERM shape a conformance test would wrongly assert; moved the "not a silent stream end" contrast next to "rejects."
- **Per-line cap (critic):** named the byte reader as the mitigation available *today*, with `textRange` flagged as unlanded — no mitigation is left solely to an unlanded design.
- **Base-guard listing (critic):** corrected the member list to `help`/`streamBase64`/`text`/`json`(+`lines`), noting `getInfo`/`fetch` come from composed guards, not the base record (verified in `interfaces.js`).
- **Verification plan (skeptic):** added an explicit growth/resume conformance bullet alongside the existing revocation one.
- **Prose (copyeditor + pedant):** folded the `text`/`json` aside and removed the ambiguous "It"; unified the worked-example table to the single-backslash notation used in prose.

**CI:** green — 5 checks, 0 failed (rc 0). Per instructions, I did not re-run the panel; the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr832-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (1725481 cached reads)
- Output: 16746 tokens
- Cost: $1.9821314999999995
- Wall-clock: 610s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
