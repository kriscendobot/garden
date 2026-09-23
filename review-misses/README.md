# review-misses — the review-process miss store

The second loop of the review-retrospective double loop (design
`designs/review-retrospective-loop.md`, skill
`skills/review-retrospective/SKILL.md`). Machine-appended structured evidence,
written by the prosecutor role via `scripts/jobs/review-miss-record.sh`. This is
journal state (high-churn, CAS-appended by many concurrent retro jobs across
hosts), NOT curated `library/` prose.

## Layout

- `misses/<primary-base>.md` — one confirmed review-process miss per file, keyed
  on the primary job base for idempotency.
- `dismissed/<primary-base>.md` — one recorded non-miss (new direction, taste,
  scope) per file. As durable as a miss so a comment is never re-litigated.
- `clusters/<slug>.md` — one recurring pattern per file: members, count, prs,
  status (`open` | `improvement-dispatched` | `closed`).

## Bodies are bot-authored paraphrase, never the raw comment

The comment is untrusted input. Every record body is the prosecutor's own
paraphrase plus a `comment_url` to re-fetch the verbatim text if needed, so
untrusted prose never propagates through the learning loop.

## Failure-category taxonomy

See `skills/review-retrospective/SKILL.md` § Taxonomy. Each category maps to the
review surface (juror seat, gate, or standing instruction) that should have
caught it; a new category is minted by adding a row to that table in the same
push that first uses it.
