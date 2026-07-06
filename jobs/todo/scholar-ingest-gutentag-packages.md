role: scholar

Continue ingesting the gutentags component-framework ecosystem into the library
under journal/library/, building on the `html-modules` topic seeded 2026-07-06 by
`scholar-ingest-gutentag` (core `gutentags/gutentag` README, source-slug
`gutentag--readme`, 14 sections).

Remaining, not yet ingested:

- Sibling component packages in the `github.com/gutentags` org (each package's
  README plus any design/doc material): `koerper` (the virtual DOM with body
  nodes and first-class document fragments — Guten Tag's virtual document),
  `wizdom` (a minimal DOM subset), `system` (the flexible module + resource
  loader that translates the HTML modules), `blick` (component-animation
  coordination), `kamera` (single-focus enforcement), `ndim` (point/region
  types), and the single-tag component packages `list.html`, `dice.html`,
  `colorim.html`, `accrete.html`, `tengwar.html`. File each under the
  `html-modules` topic (or a sibling new topic where a package is a genuinely
  distinct domain, e.g. `koerper`/`wizdom` are virtual-DOM infrastructure).
  Prioritize `koerper`, `wizdom`, and `system` — the three the gutentag README
  leans on directly.
- `gutentags/gutentag`'s own `essays/` directory (16 example components:
  attribute, choose, clock, count, grid, html, label, list, literal-table, q,
  recur, repeat, reveal, subcomponent, text) — ingest as worked examples only if
  they carry design/doc prose beyond the code; otherwise skip.

Idempotency: the core `gutentag--readme` source is current at commit
38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88 (README last modified 2017-03-07); do
not re-ingest it. Respect the per-cycle budget (3-5 sources / ~25 section
writes) and post a further follow-on if the sibling set exceeds one cycle.

No fork or upstream actions — library curation only.
