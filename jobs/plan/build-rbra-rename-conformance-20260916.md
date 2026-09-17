---
gate: orchestrated
orchestrated_by: build-rbra-cleanbreak-20260916
priority: normal
posted_by: producer
posted_at: 2026-09-17T01:52:45Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---
Step 3 (RENAME + CONFORMANCE + PROSE) of ReadableBlob range attenuation on
endojs/endo-but-for-bots, per `designs/readableblob-range-attenuation.md`.
Prerequisite: step 2 (clean break) is merged into draft PR
endojs/endo-but-for-bots#1301's branch
`kriscendobot:build/readableblob-range-attenuation`. STACK ON IT (resume via
`ensure-project-worktree.sh` + `git reset --hard
kriscendobot/build/readableblob-range-attenuation`; re-adopt #1301 with
`ensure-pr.sh` by the job marker — never open a new PR).

Rename the shared guard to the single `ReadableBlob` surface and drop the
`ReadableBlobRange*` names:
- `packages/platform/src/fs/interfaces.js`: collapse `ReadableBlobRangeInterface`
  / `ReadableBlobRangeReadInterface` into one `ReadableBlob` rich surface
  (`help`, `streamBase64`, `text`, `json`, `getInfo`, `range`, `textRange`);
  keep a compatibility export only if still referenced, else remove. Update
  `packages/platform/src/fs/index.js` exports.
- `packages/platform/src/fs/types.ts`, `types-index.d.ts`,
  `packages/platform/src/fs/extended/types.ts`, `packages/exo-git/src/types.ts`:
  drop the `ReadableBlobRange`/`ReadableBlobRangeRead` type names, land the
  single `ReadableBlob` rich type.
- Update all implementers' `makeExo(..., <interface>, ...)` and imports (local-blob,
  blob-ref, daemon manager/mount, git backend) to the renamed guard.

Daemon guard/declarations/help: `packages/daemon/src/interfaces.js`,
`packages/daemon/src/types.d.ts`, `packages/daemon/src/help-text-data.js`, and
`help.md` — replace `fetch`/`rangeRead*` documentation with `range`/`textRange`.

Conformance: add method-set tests asserting every DERIVED cap
(`blob.range(...)`, `blob.textRange(...)`) exposes exactly the same method set
as its parent, across platform + daemon + git blobs.

Design/API prose: update the files listed in the design's inventory table
(`designs/{fs-interface-consolidation,platform-range-and-tree-reads,agentry-git-eval-scenarios,endo-fs-from-git,fs-interface-reconciliation,registry-capability,snapshot-mapper}.md`,
`designs/README.md`, `packages/platform/src/fs/extended/DESIGN.md`) to describe
the attenuation surface rather than the old `fetch` window read. Flip the design
doc `Status` if appropriate.

Verify: full `packages/{platform,daemon,git,exo-git}` lint + lint:types +
test:types + ava; grep the tree to confirm NO `ReadableBlobRange`,
`rangeReadMethodGuards`, `rangeReadConvenienceMethodGuards`, or range-`fetch`
survivors remain. Push #1301. This is the final stage: when green, report that
the full clean break is complete and #1301 is ready for a `run the gauntlet`.
