Job `pr-ebfb-511-fixer` complete.

**Assessment.** The COMMENTED review on #511 carried concrete asks, so I worked it as a fixer (not a gamut resume). The review had three actionable parts: two inline design-doc corrections (fixer-fixable) and one builder-dispatch directive in the review body.

**What I did**

1. **Applied both inline corrections** to `designs/sturdy-refs-finalization-registry.md` (+ the README summary row) and pushed to the PR branch as `kriscendobot` (commit `5c363f96`):
   - *"SturdyRefs are inert and cannot receive eventual messages; opaque data boxes, not references."* This premise was load-bearing across the doc, so I threaded the correction: dropped the `E()`-dispatch reason from "Why does pass-style need to know" (Four→Three reasons, renumbered); replaced the "HandledPromise integration" section with "Enlivening a SturdyRef" (bearer enlivens to a presence via `enlivenSturdyRef`, then `E(presence)`); and zeroed out the `@endo/eventual-send` / `registerSturdyRefHandler` surface in the layer table, closely-held section, remote-ref note, migration steps, comparison table, and acceptance criteria. `@endo/eventual-send` now needs no change.
   - Renamed the `ParsedLocator.formulaType` field to `type` with a broadened doc comment (formula type when from an Endo URL, or another peer-supplied hint for remote sturdy refs).
   - Left the verbatim maintainer "Prompt" blockquote (which contains the original misconception) intact as historical provenance, and left the existing `endo://...&type={formulaType}` URL-format placeholder (a different artifact) as-is.

2. **Replied to both inline review threads** (comment IDs `3457420824`, `3457426516`) noting the commit and what changed.

3. **Tracked the builder-dispatch directive.** The review body — *"Please dispatch an agent to build sturdy refs into pass style and ocapn as specified… [the design] will remain open for further review"* — is a maintainer directive, not a queued option. I posted a `build` job (`ebfb-build-sturdyrefs-pass-style-ocapn`) scoped to the pass-style + ocapn slice, carrying the inert-SturdyRefs correction as a do-not-regress note. The job is already on the board in `jobs/doin/` (claimed and in progress).

**State of #511.** Still DRAFT, design intentionally left open per the maintainer. Inline feedback addressed; CI was green on design checks (the change is doc-only).

**Follow-ups**
- The build job will produce a separate implementation DRAFT PR (pass-style + ocapn foundation); the daemon-ingest / FinalizationRegistry retention slice was deliberately left out of that first build.
- The PR #511 *description* still lists `HandledPromise.registerSturdyRefHandler` as a highlight (now contradicting the doc) — minor producer-side drift; not edited, since the artifact under review (the doc) is now correct.
