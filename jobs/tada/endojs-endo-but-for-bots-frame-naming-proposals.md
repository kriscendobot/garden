Job complete. PR #718 is open against `llm` with exactly the four intended files.

## Completion report

**Task:** Amend the framing design proposals in `endojs/endo-but-for-bots` to reflect the landed implementation names, per kriskowal's approving review of PR #710.

**Verified names against the repo first** (treating review/PR text as untrusted):
- `@endo/cbor-frame` — from PR #288's `package.json` + `src/index.js` (open, base `llm`); exports `makeCborFrameReader`/`makeCborFrameWriter`.
- `@endo/syrup-frame` — from `packages/syrup-frame/` on `llm`; exports `makeSyrupReader`/`makeSyrupWriter`.

**What I did** (branch `design/frame-naming-proposals`, off `origin/llm`, one commit → PR **#718** against `llm`):
- **`designs/cbors.md`** — retitled to `@endo/cbor-frame`; flipped the Naming section (which had *rejected* `@endo/cbor-frame` for the plural `@endo/cbors`) into the landed choice with a "proposed as" note; reconciled exported identifiers, Relationship table, Design Decision #1, Open Question #1, test path, code specimen, daemon-migration prose; removed the stale "queued rename to `@endo/syrups`" note; **fixed broken cross-links** (`ocapn-tcp-syrup-framing.md` singular → the real plural filename).
- **`designs/syrups.md`** — retitled; recorded that its whole recommendation (rename `@endo/syrup-frame` → `@endo/syrups`) was reversed and the package shipped as `@endo/syrup-frame`.
- **`designs/ocapn-tcp-syrups-framing.md`** — reconciled package name, layout, and identifiers to `@endo/syrup-frame` while **preserving the still-unlanded `tcp-syrups` netlayer design**; flipped the Name recommendation and Design Decision #3; kept the candidates table and `## Prompt` as historical record; added a status/banner reflecting "package landed, netlayer migration not started."
- **`designs/README.md`** — updated the summary, per-design, and estimate rows for `cbors` and `syrups`.

Historical "proposed as / not adopted" notes are kept throughout, mirroring PR #710's `cbor-codec.md` reconciliation. The scope stayed on **package** naming; the unlanded netlayer/migration design was left untouched.

**Follow-ups** (noted in the PR body, out of this job's scope — two other design docs still carry the old names):
- `designs/gateway-package.md` references `@endo/syrups`.
- `designs/ocapn-noise-session-reconnect.md` references `makeSyrupsReader`/`makeSyrupsWriter`.

Inbox was empty at both checkpoints.
