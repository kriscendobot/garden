# Dispatch build jobs for the next batch of ready-to-build designs (current active milestone)
Walk the **current active milestone** on the endo roadmap and post a **build job for each design that is
ready to build**. This is the batch design→build dispatch (the design-poller/foreman action, run once now).
Procedure:
1. Read the endo roadmap and identify the **current active milestone** and its designs. (Coordinate with
   any in-flight `groom-refine-endo-roadmap` — use the current committed roadmap state.)
2. For each design under that milestone, determine **ready-to-build** = the design is approved / design-
   complete, its **dependencies are met** (use the `design-dependency-walk` skill / dependency graph), and
   there is **no build already in flight** for it (check the board todo/doin/tada + open PRs — do NOT
   double-dispatch).
3. For each ready design, **post a build job** (`design-to-pr-pipeline` / builder), grounded in the design
   doc, with a deterministic basename derived from the design so a re-run is idempotent. Serial vs parallel
   per the designs' dependency order (independent designs can build in parallel; dependent ones wait).
4. Skip designs that are NOT ready (dependency unmet, still under review) and say why.
Report the batch: each build job posted (design → basename), and each ready design deliberately skipped
(with reason). Bot fork repos only; no upstream contact. End with a summary of the batch.
