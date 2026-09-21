---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# weave (resolve conflict) on endojs/endo-but-for-bots PR #1285

Handed off from the shepherd job `endojs-endo-but-for-bots-pr1285-shepherd`.

PR: https://github.com/endojs/endo-but-for-bots/pull/1285
Head: kriscendobot/endo-but-for-bots @ design/slots-ocapn-op-lanes (bot-pushable)
Base: llm

State at handoff (re-fetch live before acting):
- `mergeable: false`, `mergeable_state: dirty` (CONFLICTING). GitHub is not
  producing a merge ref, so no `pull_request` workflow dispatches on new pushes —
  this is why the shepherd cannot drive CI. CI that *did* run is green
  (lint pass; the rest correctly skip on a markdown-only design PR).
- This PR is APPROVED but still DRAFT. It is a genuine pending design (the file
  designs/slots-ocapn-op-lanes.md does NOT yet exist on llm — not superseded).
- Changed files (242+/1-, 2 files):
    - designs/slots-ocapn-op-lanes.md  (new file — additive)
    - designs/README.md                (the live ranked roadmap — the conflict
      source; it moves frequently, see the endo roadmap memory)

Task: rebase the head onto current `llm` and resolve the conflict. The likely
conflict is confined to designs/README.md (the ranked roadmap / milestone
ordering); re-anchor this design's entry in the current roadmap ordering rather
than clobbering peers' entries. Preserve the design file's net content. Push the
resolved head with `--force-with-lease`. Once mergeable, the shepherd/conductor
chain resumes via the reconcile tick. Never link to upstream agoric/agoric-sdk.
