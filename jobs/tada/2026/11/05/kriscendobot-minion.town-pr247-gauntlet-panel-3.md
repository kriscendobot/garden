Panel round 3 on PR #247 ended in **must-fix**. `panel.sh` exited 0 and posted its own review; I did no fixing and left the PR in draft.

- **Pinned pair:** base `89e61564acd2831219a91084ad11946aeceecae7`, head `aaaad640c63300fc2699cecb2d854ea31626140a` (`kriscendobot:design/ordered-gutter-context-menu`). The detached checkout matched the head, and the PR head had not moved when the panel finished.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0 with no output, so the panel went ahead.
- **Panel:** it ran as a single design-panel round. The ownership-map pre-pass returned ATTENTION, which forced the decomplector lens.
- **Review:** the aggregate is a COMMENTED review on `aaaad640` under the `Must-fix before merge` heading: https://github.com/kriscendobot/minion.town/pull/247#pullrequestreview-5780094816

I read the skeptic and decomplector sections, but only the start of the review, so other seats may have more findings. The must-fix findings I saw, all in `designs/ordered-gutter-context-menu.md`:
- **skeptic:** the New/Clone roll-forward assumes `register` can be replayed safely without citing the registry's actual replay behavior. A crash between steps 3 and 4 can also leave a served origin that nothing unpublishes.
- **decomplector, `clips/` writers:** the catalog's queue is meant to serialize `clips/`, but other writers bypass it, including the #142 publish path and revoker bindings. Collisions and outside removals have no specified handling.
- **decomplector, directory removal:** the design and `unpublish` (`src/endo/gateway/publish.ts:367-372`) both remove the clip directory. The `clip-dirs/<operationId>` name also fails the `daemon-site-registry.ts:444` validator, so each destroy would log a false "stranded" warning.

Follow-ups: the driver routes this to fix-3, and no other work is needed from this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr247-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (268162 cached reads)
- Output: 2878 tokens
- Cost: $0.4560644
- Wall-clock: 399s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
