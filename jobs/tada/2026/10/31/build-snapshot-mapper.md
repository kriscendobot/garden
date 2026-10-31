I didn't open a PR. The snapshot-mapper this job asks for is already on `endojs/endo-but-for-bots@llm`, and later open PRs have built past it, so a new PR would duplicate landed work or collide with in-flight work.

**What I checked** (in a project checkout at `llm` tip `9a14ddf660`):
- **The roadmap marks it done.** `designs/README.md` lists snapshot-mapper as **Complete (consolidated into `@endo/exo-npm`)**.
- **The code and tests exist.** `packages/exo-npm/src/snapshot-mapper.js` (424 lines) turns a `RegistryResolution` plus an entry source into a `CompartmentMap` in the layout the design asks for. Registry packages get `<name>@<version>/` directories and workspace members get a bare `<name>/`. It is exported from `packages/exo-npm/index.js`, tested in `packages/exo-npm/test/snapshot-mapper.test.js`, and has already been through a panel review (commits `c1cb5051c5`, `cce12ae802`). The MVS resolver this job calls "queued" is there too (`packages/exo-npm/src/mvs-resolver.js`).
- **The layer above it is already being built.** The "worker import from mount" work this was meant to unblock is in progress without needing this layer:
  - #1559 (draft) adds `makeFromPackage`. The worker serves compartment-mapper's own graph walk from a synthetic tree, which replaces the design's planned daemon-side `mapSnapshot`, `makeMountReadPowers` and new compartment-mapper hook.
  - #1590 and #1592 are Phases 3 and 4 of the same design.
  - #1417 adds `makeTreeReadPowers`, which covers the read-powers part.
  - #1117 replaces the registry interface the design was written against (`registry-capability` is deprecated in favour of `npm-registry-as-directory-tree`).

**Probable cause of the job:** the design file's own header is stale. `designs/snapshot-mapper.md` still says `Status: Not Started` (last updated 2026-07-10), while the roadmap says Complete. Whatever posted this job likely read that header.

**Follow-ups:**
1. Change the header in `designs/snapshot-mapper.md` to `Complete (consolidated into @endo/exo-npm; integration superseded by daemon-worker-import-from-mount phases, #1559/#1590/#1592)`. Until then, an automatic producer could post this job again.
2. Don't post another snapshot-mapper build job. What's left of the worker-import-from-mount work belongs to #1559, #1590 and #1592.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-snapshot-mapper.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (441444 cached reads)
- Output: 3626 tokens
- Cost: $0.6415688
- Wall-clock: 69s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
