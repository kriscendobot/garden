All edits landed and verified on `origin/journal2`. Inbox empty. Work complete.

---

## Completion report: `scholar-ingest-erights-equality-pages-mirror`

**Outcome: all 6 candidate pages re-ingested from the GitHub Pages mirror; pure provenance refresh (content byte-identical), no re-section needed.**

### What I did
1. **Fetched all 6 candidate URLs** via `scripts/jobs/fetch-source.sh`. Every one resolved `source_fetched_via=mirror` (erights.org refused connection from the sandbox as expected; the `erights.github.io/erights-org-website/<path>` mirror served each page). **No page 404'd on the mirror** — all six `elib/equality/*` paths are carried.
2. **Compared mirror bytes to the existing archive-sourced content.** Striking result: every mirror SHA-256 is **byte-identical** to the recorded `source_content_sha256` from the prior Internet-Archive capture. So this is a **provenance refresh, not a re-ingest** — no `supersedes:`, no section content change, no `status` flips.
3. **Flipped provenance to mirror** across all touched files, keeping the (unchanged) content hash:
   - **6 source files** — replaced `source_snapshot:` (Wayback URL) with `source_effective_url:` (mirror) + `source_fetched_via: mirror`; rewrote each `notes:` to drop the "erights.org unreachable / Internet Archive `id_` capture" language and state the mirror provenance + byte-identical fact. (Kept `source_mirror_url:` on the puzzle page as the caplet.com alternate-host pointer.)
   - **14 section files** — refreshed the body `Source:` footer from "ingested from the Internet Archive original-bytes capture" → "fetched 2026-06-27 via the erights.github.io GitHub Pages mirror … (byte-identical to the prior Internet-Archive capture)", preserving each SHA and any trailing notes.
   - **`sources/README.md`** — flipped the 6 status-column provenance blurbs to mirror, matching the `erights--elang-index` sibling style. Re-applied onto the freshly-fetched tip (not my earlier dump) to avoid clobbering concurrent row additions to this shared file.
4. **Landed all 21 files** through `scripts/jobs/land-journal-edit.sh` (isolated producer clone, CAS-to-`origin/journal2`).
5. **Link check:** all 6 clusters pass `library-link-check --source-slug … : OK`. The repo-wide `--changed` run reports 23 danglers, but I confirmed **none** reference my equality/grant-matcher slugs — they belong entirely to other gardeners' in-flight ingests (`cask--*`, `endo--marshal-*`, `endo-but-for-bots--*`).

### Not touched (correctly)
- `topics/*`, `concepts/*`, `keywords.md` — content is byte-identical, so no index entries changed.
- Out-of-scope PDF/talk sources — left as-is (the mirror doesn't carry them).

### Follow-ups
- None for this job. The 23 pre-existing `--changed` danglers in unrelated clusters are visible to any future `--changed` run but are other gardeners' to resolve — not introduced here.
- Worth noting library-wide: the GitHub Pages mirror serves these equality pages **byte-for-byte identical** to the Wayback `id_` captures, which validates the mirror as a faithful, higher-fidelity (no toolbar/rewrite) substitute for the whole `elib/equality/` tree.
