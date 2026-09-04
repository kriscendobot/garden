CI is green on head `4651ee078` (`ci-wait-merge.sh` rc=0, `rollup-terminal total=5 failed=0 → CI GREEN`), independently confirmed by the check monitor reaching ALL-TERMINAL with every check `SUCCESS`.

## Report

**Stage: FIX round 1 on endojs/endo-but-for-bots#715** (`design(inspect): @endo/inspect package + shim`), a docs-only design PR.

### What I found on arrival
A prior claimant of this job had already applied and pushed the bulk of the panel-1 must-fix items (commit `a8f1faddcc`, "apply panel round-1 review feedback"). I verified that commit against each seat's findings rather than assuming it was complete: critic (SES-shim adopter guidance), decomplector + ergonomist (return-shape split by name), skeptic (Node's implicit `node` condition; `Date.prototype.getTime` reclassified trap-free; Phase 4 test catalog), novice/copyeditor/pedant (glosses, forward pointer, `unstyled`, "its side effects", `portably` placement, reviewer-handle typography) were all genuinely applied.

### What I added
1. **Design Decision 4** — the skeptic's finding cited it explicitly; the prior fix corrected the § Condition-parameterized resolution section but left Decision 4's standalone "Selecting no condition yields the capability-free portable core" framing intact. Rescoped it to the resolver *fallback*, with the Node-implicit-condition caveat.
2. **Retired the vestigial `{ as: 'string' }` escape hatch.** The round-1 restructure made `inspect` always return a string, which makes `{ as: 'string' }` exactly `inspect` — yet four references survived, including an *open question* asking whether that opt-out was sufficient, which the split had already answered. Dropped `as` from the shared options bag, restated the browser rows, and narrowed the open question to what is still undecided. Then reworded that bullet to lead with the question rather than the resolution.

### The real blocker (root cause of "no CI")
The PR reported **no checks at all** — and would have forever. It was **CONFLICTING** with `llm`, 1683 commits behind. GitHub cannot compute a merge ref for a conflicting PR, so it runs *no* `pull_request` workflows; the status rollup stays permanently empty. `ci-wait-merge.sh` treats an empty rollup as pending, so this stage would have burned its full deadline and reported `still-pending` on **every** gauntlet iteration, looping indefinitely without ever surfacing why.

I rebased onto `llm`, resolving `designs/README.md` twice. Upstream had restructured that index (groom notes moved to `ARCHIVE.md`; a single current-totals block replaced the layered "Last updated" prose), so the original insertion was reapplied in the new idiom: summary-table row, M10 milestone row, per-design estimate row, and a totals-delta note — not a blind conflict resolution. Net diff versus `llm` is purely additive: two files, +457 lines, no upstream content displaced.

**Verified as non-issues:** em dashes (I initially miscounted with a broken pattern — they are in fact the norm here, 114 of 164 design files), and Prettier (`lint:prettier` covers only `.github`/`packages`, and `.prettierignore` excludes `*.md`).

### Follow-ups
- **PR is still a draft.** Un-drafting is the gauntlet's later stage, not this one.
- **Panel-1 posted its verdict as `COMMENTED`, not `REQUEST_CHANGES`**, despite the body reading "Disposition: must-fix — the panel requests changes." Worth checking whether the panel's review-submission path is passing the right state; a driver keying on review state would misread this.
- **Systemic risk worth a garden-level fix:** any long-lived PR that drifts into conflict goes silently checkless, and the gauntlet reads that as "pending" forever rather than as a blocked state. `ci-wait-merge.sh` already has a `GARDEN_CI_ALLOW_NO_CHECKS` knob for genuinely checkless repos, but nothing distinguishes *checkless* from *conflicting*. Having it probe `mergeable == CONFLICTING` on an empty rollup and fail fast would convert an hour-long silent stall into an immediate, actionable signal. I did not implement this — it is outside this stage's scope.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr715-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 32 tokens (1548298 cached reads)
- Output: 11297 tokens
- Cost: $15.23898375
- Wall-clock: 7680s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
