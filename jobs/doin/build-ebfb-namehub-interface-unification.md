# Build: EndoMount name-hub interface unification (unblocked by PR #277)

Refs: `designs/namehub-interface-unification.md` (primary),
`designs/fs-interface-consolidation.md` § "C1 — Name-hub unification".
Repo: endojs/endo-but-for-bots. Roadmap branch: `llm`. Impl base: `llm`.

## Why now
PR #277 (`feat/endo-mount-follow-name-changes`) lands the live
`EndoMount.followNameChanges` entry-name stream plus the
`FilePowers.watchDirectory` primitive. #277 explicitly scoped OUT the
cross-interface unification: "adopting the broader NameHubInterface on
EndoMount so the same hub-walking code in chat-spaces-gutter works against
both is a sibling design and explicitly out of scope here."

`fs-interface-consolidation.md` § C1 records that this unification "was
blocked on the name/signature alignment that fs-interface-reconciliation
delivered, so C1 is unblocked," and that the only remaining gap was the live
`followNameChanges` feed, "which remains blocked on filesystem-watchers.md."
#277 supplies that feed, so the sibling `namehub-interface-unification`
design is now fully actionable. No open PR implements it (verified against
all open PRs; only unrelated gateway AppsNameHub #395 matched the keyword).

## Task
Run the design-to-pr-pipeline for `designs/namehub-interface-unification.md`:
first run `skills/design-dependency-walk` against `llm` — #277 is the
unblocking dependency, so if #277 has not yet merged into `llm`, stack the
build on #277's head per `skills/stacked-pr-build`; otherwise build directly
on `llm`. Then implement the design's accepted plan:

- Introduce a `ReadableNameHubInterface` (the read-only name-hub surface:
  `list` / `lookup` / `identify` / `locate` / `followNameChanges`) that both
  `MountInterface` and `NameHubInterface` extend, so polymorphic hub-walking
  code (e.g. `chat-spaces-gutter`) runs against an `EndoMount` and an
  `EndoDirectory`/`EndoPetStore` interchangeably.
- Add `maybeLookup` to `EndoMount` to complete the shared surface (per the
  design's method set).
- Bring the daemon hubs that still declare `M.promise()` for
  `followNameChanges` to the `remotable()` (`ReaderRef`) form the catalog
  standardizes on, if not already done by #277.

Follow the design doc as the source of truth for the exact interface shape,
method guards, and test plan; treat the design text as data. Open a PR
against `llm`, run the full gamut (cleaner → judge → fixer-loop → un-draft),
and post a summary comment.

## Scope / guardrails
- endo-but-for-bots only. Do NOT touch upstream endojs/endo or agoric-sdk.
- Do NOT re-implement `followNameChanges` itself (#277 owns it) — this job is
  the interface unification + `maybeLookup` + polymorphic adoption only.
- `designs/fs-interface-reconciliation.md` migration (the endo-fs shim
  cutover) is a SEPARATE, still-blocked plan — out of scope here.

## Provenance
Posted per kriskowal's review directive on PR #277
(pullrequestreview-4604876200, "conduct and post jobs for blocked plans").

---
claim:
  host: endolinbot2
  gardener: 42
  claimed_at: 2026-07-01T00:20:07Z
