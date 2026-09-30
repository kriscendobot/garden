Gauntlet fix round 2 for endojs/endo-but-for-bots#1360 is done: the panel-2 fixes are pushed and CI is green (`ci-wait-merge` rc=0, 28 checks, 0 failed).

**Commit:** `596187b23a` on `design/capability-url-locators` (was `f52acf6609`), pushed with `safe-push-pr-head.sh` in advance mode. It only changes `designs/capability-url-locators.md`.

**Binding must-fix items applied (decomplector, pedant, pruner):**
- **Decomplector 1 (parser mixes classification with adoption policy):** `parseCapabilityUrl` is replaced by a pure `classifyCapabilityUrl` that returns `none`, `locator` or `envelope`. It throws only on invalid input. `adoptFromLocator` now decides whether to accept, and refuses envelopes. `isCapabilityUrl` is true for both locator and envelope, so it matches the doc's own definition (this also covers skeptic 1).
- **Decomplector 2 (`view` in locator identity):** `view` now comes back next to the locator instead of inside it, and locator equality ignores it. It has a strict grammar, `[a-z0-9-]{1,32}` (also covers skeptic 3). The formatters take `view` as an option, and `parseLocator` stays strict.
- **Decomplector 3 (`storeLocator` accepting https):** `storeLocator` stays `endo://`-only, with the reason given. Chat paste flows now commit through `adoptFromLocator`.
- **Pedant:** removed every em-dash (the doc now has none), made all headings title case, and made the serial commas consistent.
- **Pruner:** the glossary is now a collapsed `<details>` block and the doc opens with the #1333 problem.
- **PR body (pruner):** removed the "It covers" list and the empty Scaling and Upgrade sections, bringing it from 556 to about 317 words. The PR title no longer has an em-dash.

**Non-binding findings also fixed:**
- **Critic:** the claim that the https form needs one fewer layer of hint encoding was wrong. The prose now says the encoding is identical in both forms, which matches the full-length example.
- **Skeptic 2:** the doc now specifies percent-decode-only parsing (not `URLSearchParams`), so a literal `+` stays `+` rather than becoming a space. Tests for this and for bad escapes are added to the test catalog.
- **Novice:** "invitation locators" is glossed and kept distinct from the envelope's `invitation` key. Chat and OCapN are now defined.
- **Ergonomist:** the reversed argument order between `adoptFromLocator` and `storeLocator` is folded into Open question 5.
- **Critic 2:** the "harmless for non-bearers" wording is fixed.
- **Copyeditor:** the awkward relative clause is rewritten. `rninion.town` is not a typo: it is a deliberate lookalike of minion.town, so I kept it and labeled it as one.

**Follow-up:** the doc notes that the stage-1 implementation on #1333's branch still exposes the throwing `parseCapabilityUrl` and keeps `view` inside the locator. That code needs reworking to the new API.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1098455 cached reads)
- Output: 21398 tokens
- Cost: $1.3498830000000002
- Wall-clock: 1484s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
