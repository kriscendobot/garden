Panel round 5 for endojs/endo-but-for-bots#1414 ran and the verdict is **must-fix**. I posted the full panel output to the PR as a review.

- **How it ran:** `panel.sh` ran in single-round mode against head `38ad01d0a6`, compared with the pinned base `afc72caff9` (the `llm-afc72ca` branch), and exited 0. The ownership-map check flagged the cross-boundary map, so the decomplector seat was required. The PR-body length check flagged the description, so the pruner seat was required too.
- **How it was posted:** GitHub refused a request-changes review because the bot opened this PR itself. I posted it as a COMMENTED review instead, headed "Garden panel — round 5 (single-round gauntlet): **must-fix**". Rounds 3 and 4 were posted the same way.
- **Main must-fix findings:**
  - **The `@`-name block is only described for `lookup`/`maybeLookup`.** The design's rule that the restricted host refuses `@`-prefixed names is only spelled out for those two methods. Other methods it exposes also take a path: `copy`, `move`, and the endowment names passed to `evaluate`. Two attacks follow:
    - `copy(['@agent'], ['x'])` followed by `lookup(['x'])` gets back the full, unrestricted host.
    - `claude-sandbox-factory.js:409` and `provision-claude-session.js:277` already call `evaluate` with `'@agent'` as an endowment, and the migration table doesn't cover them. If the block applies there, those calls break. If it doesn't, that path hands back the full host.
  - **Channel accessors not wrapped:** `getMember` and `getMembers` on the channel return the full member object, which still shows identifiers. The design doesn't wrap them the way it wraps `createInvitation` and the two `join` methods.
- **Smaller findings:**
  - The design credits one of its two survey greps with a hit that only the other grep finds.
  - The pruner wants the "Documentation Considerations" and "Testing Considerations" sections cut from the PR body.
  - The other seats raised copy-editing and pedant points.
- **Checked and correct:** the skeptic checked the design's list of methods the restricted host exposes and withholds. Together they cover all 93 `HostInterface` methods with no gaps or overlaps.

There were no garden repo changes. The PR stays a draft, and the next gauntlet stage handles the fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (514502 cached reads)
- Output: 2597 tokens
- Cost: $0.5604084
- Wall-clock: 396s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
