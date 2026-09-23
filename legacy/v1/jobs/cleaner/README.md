# Per-role job board: cleaner

Per-role job board for the cleaner.
Posted by drivers (per `designs/driver.md`), claimed by cleaner workers (per `skills/cleaner/cleaner.sh` once the phase-3 worker lands).

The shape and lifecycle match the flat `journal/jobs/` board (see `journal/jobs/README.md`): a job is a markdown file with YAML frontmatter naming the verb, target, eligible_roles, and authorizations; transitions move the file between `open/`, `claimed/`, `done/`, and `abandoned/`; git push is the serialization point for the claim race.

## Layout

```
jobs/cleaner/open/<UTC>--<short-id>--<slug>.md             # posted; awaiting claim
jobs/cleaner/claimed/<UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md
jobs/cleaner/done/<UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md
jobs/cleaner/abandoned/<UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md
```

The `.gitkeep` files exist so the empty directories can be committed; jobs replace them as the board fills.

## Phase 1 boundary

Phase 1 scaffolds the directory structure only.
No real jobs flow through this board until phase 2 (design-only driver shake-out) and phase 3 (source-touching support).
The skeleton worker at `<garden-root>/skills/cleaner/cleaner.sh` demonstrates the worker-pool handshake without doing real cleaner work.

See `<garden-root>/designs/driver.md` § Role-specific job boards.
