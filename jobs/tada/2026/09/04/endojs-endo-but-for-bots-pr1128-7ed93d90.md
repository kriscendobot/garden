The build job has already been claimed — it's in `jobs/doin/`, so a gardener (builder tier, Opus) is actively working it. My routing task is complete.

## Completion report

**Job kind:** attention directive on endojs/endo-but-for-bots #1128 → read + route.

**What #1128 actually is (verified against `llm` source, HEAD `a11f6e3`):**
- #1128 is an **issue** (not a PR), by kumavis: "Ambient `@endo` makes every child host a full-authority peer of the root host." The preflight correctly reported INAPPLICABLE (issue, not PR).
- Maintainer kriskowal's directive: *"build a fix that omits the endo power from new and old guests."*
- Root cause confirmed in `packages/daemon/src/host.js` `makeHost` (~line 498): `specialNames['@endo'] = endoId` is set **unconditionally** for every host, including `provideHost` children. The `endo` facet's `host()` returns the **root** (`defaultHostId`), so a child host is a two-hop full-authority peer of the root.
- **Terminology corrected:** `provideGuest` guests *already* lack `@endo` (`guest.js` `makeGuest` builds `specialNames` with only `@agent`/`@self`/`@host`/`@mail`/`@nets`/`@planes`). The leak is on non-root **hosts**, so the maintainer's "guests" maps to delegated `provideHost` children. I flagged this in the spec so the builder doesn't chase a non-existent guest-side removal.

**What I did:**
- Posted a precise, builder-role job `build-endo-but-for-bots-issue1128-omit-endo-child-hosts` implementing issue direction (1): withhold `@endo` from non-root hosts. The spec highlights the key lever — `specialNames` is recomputed at every realization, never persisted, so a **load-time guard** (grant `@endo` only when `id` equals the endo formula's `.host`) fixes both **new and old** persisted child hosts with no migration. It names the exact realizer/formulation sites (`manager.js` `case 'host'` ~3518, `formulateEndo` ~6204) and requires daemon tests asserting a child host cannot reach `@endo` while the root still can.
- Confirmed the existing `eyes` reactji ack from the watcher is present (skill says the gardener does not re-react); added no GitHub comment to avoid noise.

**State:** The build job is already on `origin/journal2` in `jobs/doin/` — claimed and in progress. Its draft PR will auto-run the gauntlet.

**Follow-ups:** None from me. Related prior context: PR #1102 (`narrow-special-names`) and issue #982 special-names work touch the same `specialNames` surface — the builder may want to check for overlap/conflict on `llm`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1128-7ed93d90.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (915946 cached reads)
- Output: 13637 tokens
- Cost: $1.4067130000000003
- Wall-clock: 234s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
