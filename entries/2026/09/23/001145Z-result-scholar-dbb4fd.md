---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-09-23T00:11:47Z
---
cat > ./result-body.md <<'EOF'
---
kind: result
role: scholar
project: garden
---

# Scholar ingest: Simon Willison, "Claude Opus 5.5, GPT-6 Sol, GPT-6 Luna, and a new price war"

Ingested one new `source_kind: web` source per the standing scholar cycle (maintainer directive kriskowal, 2026-09-22; job `scholar-ingest-source-opus-sol-luna-20260922`).

## Source ingested

- **`web--willison-opus-sol-luna-price-war`** (4 sections). Simon Willison link-blog, https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/ , source_date 2026-09-22. Fetched via `scripts/jobs/fetch-source.sh` (`source_fetched_via=direct`, 24303B); idempotency anchor `source_content_sha256=097589c4a69cb06f3166b85b792da67191b29db74ce77349e33fdc6e66f4d6b1`. Prefix check (`library-slug-prefix-check.sh --propose`) OK: `web` matches the established simonwillison.net sibling prefix (`web--willison-muse-spark-1-1`).
  - Sections: `overview` (same-day releases + price-war framing), `pricing-and-the-price-war` (the 2026-09-22 price table; GPT-6 Luna $0.10/$0.50), `opus-5-5-price-cut` (20% cut to $4/$20 + 60% cache-read drop), `opus-5-5-max-over-thinks` (Opus 5.5 "max" exhausted the 128k output-token budget while reasoning, returned nothing, twice).

## Topic / concept pages touched

- Topics (existing, rows added via `insert-sections-table-row.sh`): `frontier-model-apis` (4 rows), `coding-agent-economics` (3 rows).
- Concept (new): `thinking-budget-output-overrun` — the failure mode where reasoning tokens exhaust the shared maximum-output-token budget at the highest effort level; garden-relevant caution for the fleet's Opus high/max runs. Linked from the max-over-thinks section and See-also to `[[model-routing]]`.
- Indexes updated by hand: `sources/README.md` (new web row), `concepts/README.md` (new concept bullet), `keywords.md` (8 keyword synonyms -> `thinking-budget-output-overrun`).

## Integrity gate (step 8)

- `library-link-check.sh --library <staging> --changed`: **OK** — every checked link resolves to a committed file (cluster `web--willison-opus-sol-luna-price-war` all `ok`).
- `regenerate-topics-counts.sh --check`: reported STALE counts (informational, no missing topic page) — reconciled by the step-9 `--land`.

## Landing / regeneration

- All 11 content files landed through `land-journal-edit.sh` (new files bare; existing README/topic/keyword files with `--base-blob` guards).
- Final landing step: `regenerate-sections-index.sh` (landed `sections/README.md`) and `regenerate-topics-counts.sh` (landed `topics/README.md`) both regenerated and current.

## Follow-on jobs / backlog

None. The source is a single short link-blog post, fully covered in one cycle; no remainder to defer.

## Curatorial notes

- The pricing table is Willison's dated 2026-09-22 snapshot of vendor announcements (secondary material); recorded as a dated landscape, not a durable price list, per the source `notes:`.
- The max-over-thinks finding is filed as a caution (external report), not a measured claim about the garden's own runs; the concept page states this explicitly.
