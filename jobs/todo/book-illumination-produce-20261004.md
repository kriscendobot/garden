---
role: builder
provider: openai
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# Produce the complete illuminated illustration asset set

Repository: `kriscendobot/garden-book`. Parent production: `book-illumination-supervisor-20261004`. Design brief: merged PR #7, merge commit `ab5990ed51bafaa5ad4cfde2d65194f53a08ea9f`, file `art/chapter-illustrations-brief.md`.

Read the merged design brief and produce exactly one illuminated-style, inline-safe SVG for every one of its 25 entries (ten chapter openers and fifteen selected section illustrations). Do not add illustrations for entries not in the brief, and do not integrate any new illustration into the generator or book HTML in this job.

Codex owns one consistent palette across the complete set. Choose the palette, apply it coherently to all 25 assets, and document it and every asset in `art/MANIFEST.md`, following that file's established asset-table and palette style without deleting the prior asset history. Record the corresponding target anchor, role/theme, suggested placement or ratio, and concise accessibility intent so the later integration job can consume the set deterministically.

Preserve the brief's ornate illuminated-manuscript gardening aesthetic: concrete scenes and readable relationships first, botanical marginalia and manuscript ornament in support. Keep the wizard-tower/beacon and hanging-garden motifs only in the subtle placements the brief permits; do not turn them into repeated mascots. Use strong silhouettes and compositions that remain legible at phone width.

All SVGs must be repository-local and safe to inline together into one HTML document under the current clip CSP: no external fetches or references, no script, no event handlers, no embedded fonts, and no remote or data-URL dependencies. Prefix every SVG definition, title, description, clip path, mask, filter, gradient, marker, and other referenced ID uniquely per asset so no IDs collide after all assets are inlined. Include meaningful `<title>` and `<desc>` content derived from each entry's accessibility guidance; keep purely decorative details out of the accessible description. Keep source reproducible and hand-auditable.

Verify that there are exactly 25 new thematic SVGs, every design entry and target anchor has exactly one manifest mapping, all IDs/references are collision-free across the combined set, the SVGs parse, prohibited/external content is absent, and the repository's test and build commands pass. Open or update a DRAFT PR through `scripts/jobs/gardening/ensure-pr.sh` using this durable marker in the body:

`<!-- garden-job: book-illumination-produce-20261004 -->`

Report the PR URL, head SHA, asset count, palette decision, manifest mapping evidence, SVG-safety checks, and test/build results. Leave the PR draft. Do not integrate the assets into `build/build.mjs`, `build/render-book.mjs`, HTML, or CSS yet, and do not publish an edition.

Self-improvement: follow the standing skill at the end of the claim.
