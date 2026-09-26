All five checks pass, head `09b6ae8dade`, PR MERGEABLE/CLEAN.

## Fix round 1 — endojs/endo-but-for-bots #666 (`designs/platform-dimension-packages.md`)

**Prior-attempt discovery.** A previous claimant of this same job had already pushed `b9ebbdcb7f` ("apply panel round-1 must-fix items") at 06:23Z and died before reporting. I verified that commit against the panel verdict: all ten must-fix items across critic / skeptic / decomplector / ergonomist / copyeditor / pedant / novice were genuinely addressed. I did not redo them.

**What I added on top** (four commits):

1. **Should-fix sweep** — `## Prompt` section restating the originating brief's four asks; target-package column on the dimension table; which packages actually get exo-free weight; named placements win over the mechanical chain (with the exceptions enumerated); `src/interfaces.js` as the guard-module name and `./src/<file>.js` as the subpath spelling; "child" everywhere instead of "tranche"; the four-vs-six count bridge; quotation attributed to `packages/daemon-cas/package.json`; Node capitalization, hyphenation, American quote punctuation, title-case headings; C4 edge drawn as pending. README: status-total delta line, missing dependency-graph node/edge, `mostly mechanical`, quote punctuation. Also fixed a stale "Two clarifications" count the must-fix commit left behind when it added a third.
2. **Rebase reconciliation** — see below.
3. **Publishability correction** — `@endo/platform` is no longer `"private": true` (it carries `publishConfig.access: public`), which invalidated the umbrella-removal gate, the scaffolding `package.json` shape, and the name-collision open question. All three rewritten.
4. **mkmem.js** counted as the third named exception to the placement chain.

**The real CI blocker was not a test failure.** No checks had ever attached to this PR since July, including to the prior attempt's push. The cause: `mergeable: CONFLICTING` / `mergeStateStatus: DIRTY` — GitHub cannot build a merge ref for a conflicting PR, so no `pull_request` workflow fires. I rebased the branch from its July base onto current `llm` (1703 commits, later re-rebased when `llm` moved 5 more). Conflicts were confined to `designs/README.md`, whose structure changed on `llm` (groom narration moved to `ARCHIVE.md`; totals now recorded as incremental delta lines). Immediately after the rebase landed, mergeability flipped to MERGEABLE and all five checks attached.

**Rebasing exposed real design drift**, which I reconciled so the doc describes the tree it now governs: `shared/blobref.js` → `shared/blob-ref.js`, `backend-types.js` → `backend-types-index.js`, `fs/types.d.ts` → `fs/types.ts`; the `./fs/extended/*` deep wildcard is gone from the umbrella's `exports` (the problem bullet, compatibility item, scaffolding note, and C5 all claimed otherwise); modules added since the draft placed (`src/blob.js` → `@endo/exo-fs`; `fs/confinement.js` + `fs/search.js` → `@endo/fs`; `fs-node/search-powers.js` → `@endo/fs-node`; `fs/extended/{clone,posture,mkmem}.js` → `@endo/exo-filesystem`); importer count thirteen → eighteen; test relocation list extended.

**Verified, not assumed:** every path the design cites now exists on the rebased base (checked file-by-file); all three mermaid blocks parse via `mermaid.parse()` under jsdom; `designs/*.md` is outside `lint:prettier`'s scope (`.prettierignore` excludes `*.md`), so no formatting risk.

**Follow-ups for the driver / next round:**
- The PR is a rebase treadmill on `designs/README.md` — `llm` moved 5 commits in the ~20 minutes between my two rebases, and every landing design touches that file. If panel-2 takes long, expect CONFLICTING again and re-rebase before reading CI.
- The `## Prompt` section is an explicit restatement, not a verbatim transcript; the original job body is no longer in the journal working tree and `gh` was rate-limited when I tried to recover it from `journal2` history. Labeled as such in the doc.
- Ergonomist's naming must-fix was answered by *recording* the `fs-backend`/`exo-filesystem` and `exo-fs`/`exo-filesystem` departures in Summary + Decision 1 (the option critic and novice both offered), not by renaming to `@endo/snapshot`. Panel-2 may still push for the rename.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr666-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (1 unmetered)
- Input: 446 tokens (27165845 cached reads)
- Output: 136920 tokens
- Cost: $27.323358749999997 (1 engagement(s) unpriced)
- Wall-clock: 6959s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
