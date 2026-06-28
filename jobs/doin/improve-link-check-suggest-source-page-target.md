In `scripts/jobs/library-link-check.sh`, when `check_links_in` reports a DANGLING markdown link, add a deterministic "did you mean" hint: if the dangling target's basename (`<name>.md`) does not resolve as a sibling-section file but a source page `sources/<name>.md` (or `../sources/<name>.md` relative to the referrer) DOES resolve to a committed file, append ` — did you mean ../sources/<name>.md?` to the DANGLING line. This is pure graph resolution already available to the script (it has the committed-file set in TRACKED and the LIBRARY root), so it belongs in code, not in scholar guesswork. Rationale: the 2026-06-28 KernelQueue.ts ingest hit exactly this — a parent-index See-also linked `<slug>.md` as a sibling section when the target was the source page; the gate flagged it but the scholar had to manually diagnose and re-land. Surfacing the likely-correct source-page target turns a re-land round-trip into a one-shot fix. Add a case to `scripts/jobs/test/library-link-check-test.sh` covering the overview-style source (parent index with a long descriptive slug, no bare `sections/<slug>.md`) so the suggestion fires on the real footgun shape and not on legitimate sibling-section links.

---
claim:
  host: endolinbot
  gardener: 10
  claimed_at: 2026-06-28T14:51:54Z
