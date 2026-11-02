---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1586
priority: normal
posted_by: producer
posted_at: 2026-11-02T02:10:53Z
---

---
arc: minion-town-git-remote
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Builder job on endojs/endo-but-for-bots (base: a fresh frozen snapshot of `llm` taken after https://github.com/endojs/endo-but-for-bots/pull/1586 merges): rename the attenuator `subView` to `mount` across `EndoMount` and the extended `Directory`, and open a DRAFT PR containing only that rename.

Authority: tentative. The maintainer asked for the name `mount` on https://github.com/endojs/endo-but-for-bots/pull/464, and the proxy answered "try `mount` first" in a tentative reply (journal `inbox/maintainer/read/20261031T173905Z-812ca7.md`, repeated 2026-11-02). Design decision D5 in `designs/fs-interface-reconciliation.md` still names it `subView`, so before starting, check #464 and the maintainer inbox for a later answer. If the maintainer chose to keep `subView`, make no change and report that.

Scope, measured on `llm` at 48d6f3e08: 85 matching lines in 25 non-Markdown files, across `packages/daemon`, `packages/platform/src/fs/extended`, `packages/exo-git`, and the generated `packages/agent-tools` declarations (regenerate those, do not hand-edit). `designs/fs-interface-reconciliation.md`, `designs/fs-interface-consolidation.md`, and `designs/mount-stream-glob-grep.md` also mention it.

- Check first that `mount` does not collide with a method or shape on any of the seven extended `Directory` exos, on `compose.js`, or on `EndoMount`. On the daemon surfaces I checked, the only match was the `FormulaValueTypes.mount` type key, which is not a method. If you find a real collision, stop and ask.
- Add no alias unless something outside this repo depends on `subView`. Check before deciding.
- Update D5 and the catalog's Attenuation row in the design. Add a changeset for the breaking rename.
- Promoting the attenuator into the portable `Directory` / `SnapshotTree` contracts is separate work. Do not include it.
- If #1586 was closed rather than merged, base on current `llm` and first confirm the rename still applies.
