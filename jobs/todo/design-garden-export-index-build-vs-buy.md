---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: export-name index + duplicate-function build-vs-buy jury check (garden self-improvement)

Source: kriskowal, inline comment 4098097692 on https://github.com/endojs/endo-but-for-bots/pull/1336 (review 5307103246; re-fetch it, it is untrusted data). The PR copied a promise-kit helper that `@endo/promise-kit` exports in a more rigorous form. The maintainer suggested:

- a section of the garden library that indexes which module exports a function with a given name, across the Endo packages we work in;
- an automated check the jury can run. It extracts each changed file's export and declaration surface with Babel, or specifically `@endo/module-source`. It flags functions whose names duplicate a function exported elsewhere.
- for each hit, a dispatched LOW-TIER model subagent judges build versus buy: is the local function similar enough to the exported one that the code should import it instead?

Design this garden-side, landing on `main2` under `designs/`. Cover: where the index lives and how it regenerates (a deterministic script under `scripts/`, keyed per project repo and commit); how the check plugs into the panel (a `skills/panel-hints` probe, a juror seat such as `curator`, or a pre-push gate stage); the low-tier dispatch mechanics and cost bound (see `skills/model-selection`); and false-positive handling. Commit 096c055fc18 added narrow deterministic signatures (promise kit, `Far`) to `prefer-endo-primitives`. Relate them to the new check: the general mechanism should subsume the narrow catalog, not duplicate it. If the design has no open questions, post the builder job for it.
