Done. The parked-PR queue now fuzzy-ranks by recency + roadmap relevance, capped at top 10, deployed and verified live.

## Completion report: `bulletin-parked-prs-fuzzy-sort-top10`

**What I did** — Replaced the parked-for-maintainer-feedback section's "list everything" behavior (was rendering all ~33 review-requested PRs, some idle 789 days) with a deterministic fuzzy ranking that shows only the top ~10. Built in an isolated worktree off `origin/main2` under the bot (`endolinbot`) identity, committed/pushed, fast-forwarded the live `/home/kris` checkout, restarted `garden-bulletin.service`, and confirmed a clean live tick.

**SHAs (origin/main2)**
- `96bc90ea` — fuzzy-rank parked-PR queue by recency + roadmap, cap at top ~10 (+ new unit subtest)
- `73f21ceb` — fix: split parked rows on tab only (`awk -F'\t'`) so multi-word titles keep their spaces

**Scoring (deterministic, no claude)** — each PR scored 0..100 = weighted sum of two integer factors:
- **Recency**: exponential decay `100·2^(-idle_age/halflife)`, `GARDEN_BULLETIN_PARKED_HALFLIFE_DAYS=14` → today ≈100, 14d ≈50, 30d ≈23, 450d ≈0.
- **Roadmap relevance**: 0..100 from `roadmap_index`.
- **Weights**: `WEIGHT_RECENCY=50`, `WEIGHT_ROADMAP=50` (combined = `(wr·rec + wm·road)/(wr+wm)`). Tuned so stale-but-critical (rec≈0, road=100 → ~50) and fresh-but-peripheral (rec=100, road=0 → ~50) both surface, while ancient-peripheral (~0) drops off. Integer scores so a sub-day clock tick can't reorder day-apart PRs (keeps the idempotent change-compare stable). Cap `TOPN=10`; all knobs are env-overridable.

**Roadmap-relevance source** — `roadmap_index()` reads the journal plan tree at `journal/plan/designs/**/*.md` frontmatter (the source of truth being built by `implement-plan-in-journal`): parses a `pr:` field (number / `owner/repo#N` / `…/pull/N` URL forms) and a relevance signal (`roadmap_relevance:` 0..100, else `priority:` mapped 1→100/2→85/…, else neutral 50). That tree **does not exist yet**, so the live render correctly runs the **recency-only fallback** — never wedges. A `GARDEN_BULLETIN_PARKED_ROADMAP_CMD` override hook lets tests and a future deterministic mapping plug in.

**Constraints preserved** — throttled `gh search` (≤1/`PARKED_TTL`s, host-local cache) with graceful degradation; gh built-in `--jq` only; scoring runs over the cached set; no claude added.

**Tests** — new `run-test.sh` SUBTEST 10b (7 assertions): roadmap_index parses both pr-forms; stale-high-roadmap surfaces; fresh-peripheral surfaces; ancient-peripheral drops; cap + "showing N of M" note; recency-only fallback. All pass. `bash -n` clean; `shellcheck` introduces **zero** new findings (the 5 reported are all pre-existing: common.sh source, GARDEN_TAG, render_board backtick printfs). (The full suite aborts earlier in the unrelated concurrency subtest — an environmental gardener-fleet limitation in this worktree, not touched by this change.)

**Sample live rendering** (from `origin/journal2:README.md` after redeploy):
```
## Parked for maintainer feedback

- [endojs/endo-but-for-bots#513](…) — feat(pubsub): create @endo/pubsub … (waiting 3h)
- [endojs/endo-but-for-bots#442](…) — feat(daemon-cas): extract CAS surface … (waiting 1d)
… 6 more …
- [endojs/endo-but-for-bots#231](…) — design(familiar): MVR release plan (closes #229) (waiting 24d)
- [endojs/endo-but-for-bots#182](…) — test(ses): isImmutableDataProperty regression … (waiting 34d)

_Showing top 10 of 33 parked PRs (ranked by recency + roadmap relevance)._
```

**Redeploy** — `garden-bulletin.service` restarted on the new code; I cleared a stale `~/.garden-state/bulletin/parked.md` cache (rendered by the pre-fix binary, which had tab-corrupted titles) and confirmed the next live tick posted a clean spaces-preserved top-10 with the count note.

**Caught/fixed mid-task** — the first cut's `awk` used the default field separator, shredding multi-word titles into tab-joined fragments; fixed with `-F'\t'` (matches the original `IFS=$'\t' read` semantics) and verified against real GitHub data.

**Follow-up** — when `implement-plan-in-journal` lands the `journal/plan/designs/` tree, the roadmap factor activates automatically (no further code change needed); worth a quick re-check then that the frontmatter field names (`pr:`, `priority:`/`roadmap_relevance:`, `repository:`) match what the reconciler emits, and tune weights if the live ranking warrants.
