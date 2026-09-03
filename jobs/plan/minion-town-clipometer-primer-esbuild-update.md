---
gate: orchestrated
orchestrated_by: minion-town-clipometer-esbuild-orchestration
priority: normal
posted_by: producer
posted_at: 2026-09-03T06:52:06Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
project: minion-town
orchestration: minion-town-clipometer-esbuild-orchestration (child 3 of 4, serial — runs after minion-town-clipometer-esbuild-validate)

Update the published "Bridging the MCP Gap" primer clip to reflect the validated esbuild/real-`@endo/captp` methodology (child 2), now that CLIPOMETER itself has been rebuilt on it. Maintainer directive (dckc), 2026-09-03.

## Context

The primer currently (deliberately, at the time it was written) argues **for** hand-rolling a narrow CapTP client, on the grounds that the full `@endo/captp` library is too heavy to safely hand-transcribe into an MCP `publish` call. Child 1's programmatic build+publish script closes exactly that risk (no more hand-transcription at all), and child 2 proved the real-library client actually works live. The primer's own advice is now stale on this specific point and should say the opposite: **use the real library** (this repo's `src/endo/captp-client.ts` precedent, esbuild, tree-shaking, and a programmatic publish path), not hand-roll a wire protocol from source. The primer's other lessons (read pinned source, the bidirectional promise-chain Reader protocol, the base64-transcription-corruption incident and its mitigations, the two-window live-proof methodology) remain valid and should stay — this is a revision of the "should I hand-roll or use the library" verdict specifically, not a rewrite of the whole document.

**This is a currently-published minion.town clip, not a repo file.** The primer's own live URL is `https://hynsfrih2qsl2nveht6kjh7jlacwfwpn3ie2ddtkplneaco3f57q.ocap.site/` (confirm this is still current before editing — it may have moved). Updating it means publishing corrected content and unpublishing the old hash (there is no live in-place `upgrade` path yet, confirmed directly against the `upgrade` MCP tool's own description during the primer's last edit). **If your job environment does not have the interactive `mcp__minion-town__*` MCP tools wired in**, use child 1's programmatic publish script instead (it should work for arbitrary clip content, not just CLIPOMETER's own bundle) rather than hand-typing base64 — and if neither is available, say so in your completion report and hand this step to the liaison/maintainer rather than skipping the correction.

## What to change

- Section 3 ("CapTP from scratch, on purpose"): currently argues for a narrow hand-rolled client because the full library is "wasteful and risky" to transcribe by hand. Revise this to point at the real solution instead: `@endo/captp` (a stock npm package, pinned to the version this repo's own `src/endo/captp-client.ts` already uses against this daemon), esbuild + tree-shaking to manage size, and a programmatic publish path so hand-transcription is never the bottleneck that justified hand-rolling in the first place. Cite the actual achieved bundle size from child 2's report.
- Anywhere else the primer frames "hand-roll your own client" as the takeaway (the checklist item "Hand-roll only the protocol slice you need...", the closing advice) should be revised to match: prefer the real library via a build pipeline; hand-rolling from source is the fallback when no build tooling is available, not the default recommendation.
- Add a short note (matching the existing "This primer had exactly this bug" callout style already in the doc, § 2) marking this as a second self-correction: the primer initially recommended hand-rolling for a reason (transcription risk) that a later engagement closed by fixing the actual bottleneck instead of working around it.
- Keep everything else: the exo-stream Reader protocol explanation, the two real bugs and how they were found, the base64-transcription-corruption incident and its mitigations (still true advice for anyone who *does* need to hand-transcribe something), the two-window live-proof methodology.

Follow the same rigor already established for this document: strip non-ASCII characters before encoding, verify any retyped base64 chunk byte-for-byte with `cmp` before using it in a publish call, and splice multi-chunk content with a shell `cat`, never by hand (the doc's own § 9 checklist item — follow your own advice while editing the document that gives it).

## Deliverable

The corrected primer live at a (possibly new) URL, with the old hash unpublished, and a completion report citing the new URL and confirming render (title, section count, zero console errors — the same check used for every prior revision of this document).
