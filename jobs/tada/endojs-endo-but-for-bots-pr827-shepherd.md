The only remaining failure is `zizmor`; lint is green and all other checks pass (tests were green before my whitespace-only change and remain so). My shepherd work is complete: I fixed the in-scope failure and the remaining red is a structural frozen-base issue that must go to a weaver.

## Completion report

**PR:** https://github.com/endojs/endo-but-for-bots/pull/827 (`feat(tar): tar writer; split daemon web-seed provide`, open draft, bot-authored, base `llm-b43e801`)

**Two red checks on head `dde33d80`, diagnosed as two independent causes:**

1. **`lint` (2 jobs) — genuine, in-scope. FIXED.** `packages/tar/index.js` (added by this PR's commit `dde33d80`) had a prettier violation: a re-export that CI's pinned prettier wants on one line. Key gotcha: the repo declares `prettier: ^3.5.3` but **yarn.lock resolves to 3.8.3**, and the two versions format `.d.ts` `extends` clauses differently — `prettier@3.5.3` falsely flagged `packages/daemon/src/types.d.ts` too. Using the exact **3.8.3** reproduced CI precisely (only `index.js` flagged), so I fixed only that file, then ran the full CI-equivalent `prettier --check .github packages` (clean). Committed as `fixup! feat(tar): …` targeting the introducing commit `dde33d80` (per the shepherd style/lint-fixup convention, autosquashable by the conductor) and pushed to the head branch (`dde33d80..9ea450bd`). **Both lint jobs now pass** on the new head `9ea450bd`.

2. **`zizmor` — inherited frozen-base staleness. ESCALATING.** zizmor v1.24.1's `stale-action-refs` audit flags stale action pins in `.github/workflows/ci.yml:123` and `ci-docs.yml:42,71` (`actions/checkout@34e114…#v4` etc.). These files are **not in this PR's diff** — they come from the **frozen base branch `llm-b43e801`** (pinned at #792's merge commit `f71b4f3c9`), which predates the action-pin updates that already live on the moving `llm` branch (`checkout@de0fac…#v6.0.2`). zizmor audits the PR merge ref (head ∪ base), so it inherits the base's stale workflows regardless of head content; my push confirmed the finding is byte-identical and unaffected by my fix. This is a **repo-wide event** — multiple open frozen-base PRs (`build/sturdyref-…`, `feat/hardened-url-vetted-shim`, …) are simultaneously red on the same finding, tripped by the zizmor version bump, not by any PR's code.

**`next: weaver`** — the fix is to re-snapshot the frozen base onto a current `llm` (which already resolves these pins) and rebase the head, i.e. the frozen-base skill's "move both base and head" weave. This is **out of shepherd scope**: it is a base-branch/structural operation, and it is delicate here because #792 merged into `llm-b43e801` (not into `llm`) — the stack must be preserved (a naive rebase onto `llm` would re-introduce #792's already-merged diff into this PR). It also needs coordination since it affects many PRs at once. mergeable_state is `unstable` (not `CONFLICTING`), so this is not the CI-dispatch-blocked variant — workflows dispatch fine; the base simply carries pre-pin-update workflow files.

**No PR comment posted** (no comment authorization in the job body, and CI is not fully green).

**Follow-ups:** weaver re-snapshots `llm-b43e801` → current `llm` (preserving the #792 stack) to clear zizmor; likely worth a batch pass since the whole frozen-base cohort is affected.
