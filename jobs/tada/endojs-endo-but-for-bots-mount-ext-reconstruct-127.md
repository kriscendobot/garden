Design job complete. Completion report:

## Report: endojs-endo-but-for-bots-mount-ext-reconstruct-127

**What I did.** Wrote the reconstruction plan for PR #127's mount extensions and routed the build.

**The design** — slug `mount-extensions-reconstruction`, posted as draft PR [endojs/endo-but-for-bots#648](https://github.com/endojs/endo-but-for-bots/pull/648) against `llm` (branch `design/mount-extensions-reconstruction`), file `designs/mount-extensions-reconstruction.md`. It specifies:

- **Drift accounting**: `EndoMount` is now a `@endo/platform/fs` `Directory` specialization with a conformance-allowlist contract; `subDir` is already renamed to `subView`/`provideSubMount` (so review comment 3548875661 is satisfied by existing code and no reconstructed PR reintroduces the abbreviation); `followNameChanges` is now implemented and must be newly covered by revocation and deny gating; `stat()` already landed, so only four features remain to split.
- **Four stacked serial PRs** off a frozen `llm-<sha>` base: `feat/mount-revocation` (revocation caretaker + deny patterns with overridable `deniedSegments` option, review comment 3548865148) → `feat/mount-glob` → `feat/mount-grep` → `feat/mount-json` (`readJson`, `maybeReadJson` per comment 3548857836, `writeJson`). Stacking chosen because glob must consult the deny set and grep selects files through glob; independent PRs rejected in the doc.
- **Test strategy for Rust/Node parity**: a declarative fixture manifest plus JSON case tables (`mount-fixture-manifest.json`, `mount-glob-cases.json`, `mount-grep-cases.json`) as the cross-language contract — Node ava runner now, Rust/XS-side runner over the same artifacts as a named follow-up — with a glob variant coverage matrix (literals, `*` positions, `**` recursion including zero levels, metacharacter-literal names, deny interaction, dotfiles, case/ordering, normalization, confinement, truncation). Normative glob semantics are pinned (only `*`/`**` special, final code-unit sort, silent 10k truncation as builder default with throw-vs-truncate flagged as an open question).
- Also updated `designs/daemon-mount.md`'s Status to point at the reconstruction, and cross-referenced the separate `streamGlob`/`streamGrep` designer job (`endojs-endo-but-for-bots-mount-stream-glob-grep-127`) as a consumer of the shared fixture contract.

**Posted the plan** on #127 as a top-level comment: https://github.com/endojs/endo-but-for-bots/pull/127#issuecomment-4928478627 (per the repo's standing posting authorization).

**Routed the build**: parked five orchestrated children (`mount-revocation-build`, `mount-glob-build`, `mount-grep-build`, `mount-json-build`, `mount-ext-close-127` — the last verifies all four PRs are open, cross-links, and closes #127 per the maintainer's lifecycle directive) and recorded serial orchestration `endojs-endo-but-for-bots-mount-ext-rebuild-orch-127` with halt-on-failure.

**Follow-ups**: maintainer review of design PR #648 (three open questions: glob-cap throw vs truncate, petnameable `EndoMountControl`, CI parity lanes); the orchestration drives everything else, and #127 stays open until the closer child runs.
