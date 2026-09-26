CI is GREEN. The fix is pushed and verified.

## Completion report

**Job:** FIX round 1 of the endojs/endo-but-for-bots PR #241 gauntlet (design PR: `designs/familiar-run-apps-vfs.md`).

**What I did:** Read the panel-1 request-changes verdict (7 seats, disposition must-fix), applied the findings as a single review-feedback follow-up commit to the PR head (`design/familiar-run-vfs-apps` on `endojs`), safe-pushed (fast-forward `ac71c0424 -> e4860f55d`, no rewind), and watched CI to GREEN (5/5 checks, rc 0).

**Must-fix items applied:**
- **skeptic** — reconciled against the accepted four-layer `importLocation` stack: added a "Relationship to the four-layer `importLocation` stack" section mapping each Case 1 mechanism to its owning layer (`registry-capability`, `mvs-resolver`, `snapshot-mapper`, `daemon-worker-import-from-mount`) and stating what this design adds over it (two-case framing, Case 2 host-eject, the `endor` mirror).
- **critic #1** — added the transitive **re-walk-to-a-fixed-point** step to the Go-mod-shaped resolver so the reused MVS algorithm converges as its source spec (`endor-npm-registry-proxy.md` § Version resolution step 4) requires.
- **pedant #1 / copyeditor** — replaced the U+2192 arrow in a code span with `->`.

**Should-fix / copyedit items also applied** (to reduce panel-2 churn): critic #2 fail-closed conflict path; decomplector #1 caveat on cached-map determinism → `(package.json, registry-table state)`; decomplector #2 destination-mutation gate + single-use scratch on re-eject; ergonomist eject-vs-`checkout` naming, unified `endor run` entry point with explicit `type` dispatch, unified `@endo/errors` failure family; skeptic #3 observable-drift run log; skeptic #2 Case 2 test catalog; novice supervisor/`MountHandle` definitions and a worked MVS example; copyeditor voice (first-person → third), MVS acronym expansion, re-eject wording. Synced the `Updated` date in the doc and README summary row.

**Guarding checks:** introduced **no em-dashes** (doc convention, pedant-verified clean); only `§` non-ASCII remains (pre-existing). Prettier passes on the changed files; designs are outside the repo lint scope regardless.

**Follow-ups:** none blocking. The driver re-posts panel-2. A handful of panel *comment-only* out-of-scope notes (glossary staging, sentence-length, spelling convention `-ise`/`-ize`, exhaustive citation-form link/bare consistency sweep) were left for a later pass as flagged.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 138 tokens (6625721 cached reads)
- Output: 33934 tokens
- Cost: $5.301270499999999
- Wall-clock: 878s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
