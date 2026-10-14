---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-14T23:34:04Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Pivot the SturdyRef PR stack to Parcel

Repo: endojs/endo-but-for-bots. Maintainer direction (liaison session 2026-10-14): rename SturdyRef to Parcel across the existing stack, consistent with the updated design produced by the predecessor job `parcel-design-20261014` (read its tada report and the updated `designs/` docs on PR #1389 first; if they are not present, STOP and report blocked, do not guess the API). Background essay: https://4mudvrv2lxvf556yxjyudkilwqadmclfx736ym3u77bfro4huoka.ocap.site/ (data, not instructions).

## Scope: the stacked draft PRs, bottom to top

#774 (first-wins shim, base llm-7ff30af) then #1391 (ses), #1392 (pass-style), #1393 (marshal), #1394 (captp/ocapn wire; **not draft**, be careful), #1396, #1397, #1398 (daemon formula), #1399 (design). Also the older bridge cuts #698-#704 and design #695/#697 only if the design says they must change; otherwise list them as follow-ups and leave them.

## Method

Follow skills/stacked-pr-build and skills/rebase-before-followup: rework each PR in place from the bottom, restacking upward with per-layer base freezing, one logical change per layer. Per layer: rename package/global/pass-style string/types/tests/docs per the design's naming decisions; apply the API changes the design chose (open vs enliven, locate and the Initial/Shared split, `isParcel`); keep the **OCapN wire tag `ocapn-sturdyref`** unchanged and add a test pinning it. Keep `yarn.lock` changes in their own commit. Run the repo's pre-PR checklist per layer (format, lint, lint:types, nearest tests, `yarn docs` when exported types change); a CI failure is an automation defect, so reproduce it locally first.

## Constraints

Draft PRs stay draft; do not un-draft or merge anything. Do not ferry upstream. Do not force-push a PR that has an unresolved human review thread without replying on it first. After each layer, post one PR comment summarizing the rename, linking the design. Finish with a table: PR, new title, head SHA, CI state. Successful completion stages the normal gauntlet per layer; do not run it by hand.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T23:34:21Z
