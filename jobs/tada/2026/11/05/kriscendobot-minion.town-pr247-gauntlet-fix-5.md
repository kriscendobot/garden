**Gauntlet FIX round 5 on kriscendobot/minion.town #247 is done.** I applied the panel-5 findings to `designs/ordered-gutter-context-menu.md` and pushed them as `967f708a`, using `safe-push-pr-head.sh` in advance mode. `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN). The bot PAT can't read the status rollup, so that result comes from the Actions runs API, which shows one run and doesn't show commit statuses or non-Actions checks. I didn't re-run the panel.

No deterministic pre-pass block was attached, so I worked from the latest panel review, dated 2026-11-05T05:50Z.

**Must-fix items**
- **Controller capability (critic, skeptic):** a new § 4 section, "The #142 prerequisite", compares the deployed `@sites` facet with what the design needs. It also sets out four recovery guarantees, the grant path and the rollout order.
  - Increment 1 can ship now. Increments 2–5 wait for #142, and their tests must run through the real facet in a real daemon.
- **Recovery deleting another writer's data (skeptic):** clip directories are now staged in a catalog-private `staging/` namespace, and the intent records the directory's formula id. A guest name is removed only if it still holds that id.
- **Delayed retry after Destroy (decomplector):** each entry records its `operationId`, and a durable `retiredOperations` list keeps the ids of removed entries. A late retry of a destroyed clip now refuses with `operation-retired` instead of recreating it.
- **Who classifies outcomes (decomplector):** a new "Who classifies an outcome" section makes the registry the classifier, with a closed set of refusal codes; no layer reads error text. The catalog applies the continue-or-discard policy, and the ownership map now says so.
- **Gutter layout and failure states (ergonomist):**
  - More actions now has a layout contract for compact, portrait and a future expanded gutter, with a 24 CSS px minimum target.
  - A new table gives the visible success, refusal and no-answer states for each action.
  - A `recovering` flag on `list()` drives a banner.
- **Migration deferral (novice):** the text now explains why having no controllers defers while a partial gap doesn't.

**Should-fix items**
- **`entryId` versus `hash` (critic):** the doc now says `hash` is stable today and defines the fresh-id upgrade as a separate future operation from #142 and #88.
- **Copy edits (copyeditor):** I made the leaf-first and retry wording fixes, plus the optional "Freeze governs" wording.
- **Dead link (pedant):** `new-clip.md` now uses a full URL to `main`, because the frozen base doesn't contain that file.

**Finding not applied:** the copyeditor's `…` at line 302 doesn't exist. A grep finds no U+2026 anywhere in the document, so I changed nothing there.

**Other changes for the panel to check**
- **`register` signature:** the doc now requires a directory reference instead of an id, because a bare id would give anyone who learned it a full controller once #142 drops the owner check.
- **`register` result:** it must return `registered` or `refused`, which differs from #142's bare controller. **#142 will need to adopt both of these changes.**
- **Discard path:** it no longer unpublishes, since a refusal now guarantees nothing was registered.
- **Reconciliation:** it compares registration ids, so re-registering a dead clip can't revive it.
- **#201 references:** updated because #201 has merged.

**Checks:** `thesaurus-cliche-grep.sh report` found 0 candidates. A grep found no em dashes, and the only non-ASCII character in the doc is `§`. No maintainer or peer messages arrived.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr247-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1774155 cached reads)
- Output: 42297 tokens
- Cost: $2.3257790000000003
- Wall-clock: 1644s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
