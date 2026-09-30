Fix round 3 is done for endojs/endo-but-for-bots#1360: the panel's one must-fix is applied and CI is green (28/28 checks, 0 failed; `ci-wait-merge` rc=0).

**Must-fix: the PR body was missing two template headings.** I edited the body through `gh pr edit` and added:
- **Scaling Considerations:** design only, so there is no runtime scaling impact. The future classifier is a pure, bounded string parse.
- **Upgrade Considerations:** no persisted state or wire format changes. Existing `endo://` links and minion.town `#v=1&invitation=` links stay valid.

The body now has all seven template headings, in the template's order.

**Other fixes from the panel's comments.** These went into one follow-up commit, `f9e08e423c`. `safe-push-pr-head.sh` pushed it in advance mode, moving the head from `596187b23a` to `f9e08e423c`.
- `designs/README.md`: added an index row for `capability-url-locators` with status Proposed (integrator and critic).
- `designs/capability-url-locators.md`:
  - It now says `parseLocator` is a narrower view of the one shared grammar that rejects `view`. So a share link from `formatEndoLocator(…, { view })` goes only through `adoptFromLocator` and never reaches `storeLocator` (decomplector and critic).
  - "The sentinel" is now defined as the all-zero `LOCAL_NODE` node identifier (novice).
  - The opening "is sound" claim is now a pointer to § Daemon Surfaces (novice).
  - "Open forks" became "Open questions" (novice).
  - Copyedits: "neither" became "none of them", "beside" became "alongside", and the parenthetical list is now parallel (copyeditor).

**Not addressed.** These are design decisions or larger rewrites, so they are left for the maintainer and the next panel:
- Adding an `invalid` kind to the classifier so it never throws (decomplector).
- Refusing a locator passed directly on the command line, defaulting that mode to closed (critic, ergonomist).
- The `--locator-stdin` spelling, and reconciling the flags with `cli-store-verb-text-modes.md` (ergonomist, integrator).
- Resolving the argument order of `storeLocator` / `adoptFromLocator` (ergonomist).
- Recommending the `formatHttpsLocator` name (ergonomist).
- The skeptic's three points:
  - pasted `view` links already fail today;
  - the decision table has no envelope-plus-`view` row;
  - the fingerprint check can only warn after the fact.
- The pruner's trims.
- Folding the "address panel round N" commits into one before un-drafting.

The panel was not re-run; the driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (969987 cached reads)
- Output: 5041 tokens
- Cost: $0.7810893999999998
- Wall-clock: 825s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
