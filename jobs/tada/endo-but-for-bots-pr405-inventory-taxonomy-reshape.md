I've completed the implementation and pushed. Now waiting on CI to settle to fulfill the "also shepherd" part of the directive. Summary of where things stand:

**Done:**
- Reshaped the inventory taxonomy to the exact 5 groups kriskowal specified (Directories incl. `pet-store`, Agents, Personas, Values, Capabilities), folding the former Handles/Workers into Capabilities — applied in lockstep across `space-chat` (chat grouping) and `cli` (`endo list --grouped`).
- Completed empty-group hiding (CSS header now `display: none`, not dimmed).
- Repinned all CLI + chat tests; both targeted suites pass locally (8/8 and 22/22), ESLint + Prettier clean, no new type errors (daemon needed no changes — `pet-store` is an existing formula type).
- Updated the design doc + README.
- Pushed `de17db257` to `feat/inventory-grouping-by-type` and posted the top-level summary comment on #405.

**Pending:** CI is running; a background poll will report results so I can shepherd any red back to green before closing the job.
