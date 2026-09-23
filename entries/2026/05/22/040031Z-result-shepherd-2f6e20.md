---
ts: 2026-05-22T04:00:31Z
kind: result
role: shepherd
worktree: dispatches/shepherd--005172/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/035549Z-result-weaver-965a87.md
  - entries/2026/05/22/024433Z-result-shepherd-df0510.md
---

# Shepherd pass on PR #89 (genie-integration design), head 97b16962d

PR #89 `docs(designs): propose genie-integration`, base `llm`, head
`97b16962d` (post-weaver-rebase per entry `035549Z-result-weaver-965a87.md`).
Dispatch directive (kriskowal 2026-05-22T03:51Z): "Please shepherd".
The dispatch brief anticipated: "Failures likely all pre-existing infra
(makeClient/zizmor/SECURITY.md uniformity) since the PR is docs-only."

## CI snapshot at dispatch (and at exit; no push)

`gh pr view 89` reported `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE`,
`reviewDecision: ""` (no review on file yet), `isDraft: false`. Six
check-runs on head `97b16962d` after all matrices completed:

- SUCCESS: `lint` (CI docs-only), `test` (CI docs-only), `browser-tests`
  (Browser Tests), `build` (Test project mutual dependency versions),
  `.github/dependabot.yml` (Dependabot config).
- FAILURE: `zizmor` (Workflow security audit).

The docs-only CI surface is correctly narrow: the `CI (docs-only)`
workflow short-circuits the heavy node/os test matrix that the source-
touching `CI` workflow would dispatch. This is the right shape for a PR
whose net diff is two markdown files.

## Per-cluster disposition

### Cluster A: zizmor (1 job)

**Root cause:** `Workflow security audit` (zizmor v1.24.1, pedantic
persona, min-severity=low) reports 7 `##[error]` findings against
`.github/workflows/ci-docs.yml` and `.github/workflows/familiar-release.yml`:

- `ci-docs.yml:28`: overly broad permissions (`actions: write`).
- `familiar-release.yml:15`: overly broad permissions (`contents: write`).
- `familiar-release.yml:141,142,144`: code injection via template
  expansion.
- `familiar-release.yml:35,86`: runtime artifacts potentially vulnerable
  to cache-poisoning attack.

Plus the usual long tail of low-severity warnings on the same files plus
`ci.yml` and `release.yml` (mismatched action-hash pin comments, missing
`persist-credentials: false`, missing explanatory comments on
`permissions:` blocks).

**Provenance:**

- PR #89's diff against `llm` is exactly two files: `designs/README.md`
  (+13/-1) and `designs/genie-integration.md` (+736/-0, new file). Zero
  touches to `.github/workflows/`.
- The identical zizmor fingerprint appears on the parallel `claude/endo-
  chat-file-explorer-Vfey9` PR's runs at the same time (run id
  `26267558886`, lines `ci-docs.yml:28`, `familiar-release.yml:15`,
  `familiar-release.yml:141`, `:142`, `:144`, `:35`, `:86`; same exit code
  14). That branch's content has nothing in common with PR #89's, which
  pins the failure as base-side, not PR-introduced.
- The prior shepherd pass on PR #347 (entry
  `024433Z-result-shepherd-df0510.md` § Cluster B) documented the
  identical fingerprint with the identical disposition. The recognition
  is well-rehearsed: this is steady pre-existing workflow-security infra
  debt on the `llm` base.

**Operational-flake re-run check:** No retired `shepherd-ignore` broadcast
exists for zizmor in the journal (`grep -rl 'shepherd-ignore.*retired'
entries/2026/05/2[0-2]/` returned empty). The failure is deterministic
across PRs (proven by the parallel-PR comparison above), not a flake; a
defensive re-run would not change the outcome and was skipped.

**Disposition:** document and leave. Pre-existing workflow-security infra
debt on `llm`; same fingerprint as prior shepherd diagnoses on
#347/#101/#125/#333. Out of scope for a docs-only design PR; fixing the
workflow files would (a) touch files entirely outside the PR's
designs-only change set, (b) likely require a workflow-rewrite spanning
two-plus files exceeding the shepherd's hard-escalation points, and (c)
duplicate work better tracked on the existing `pc/fix-zizmor-workflows`
branch (which has been referenced in prior CI fetches).

## PR-introduced regressions

None. The PR's net diff is documentation-only: a new `designs/genie-
integration.md` (Proposed off-roadmap evaluation) and a small
`designs/README.md` update that the weaver already harmonized with the
fresher `llm`-side metadata (entry `035549Z-result-weaver-965a87.md`).
Every check that exercises documentation surface (`lint`, `test`,
`browser-tests`, `build`, and the Dependabot config check) passes.

## Commits

None. No push to `origin/docs/design-genie-integration`. Head unchanged at
`97b16962d`.

## Post-fix CI snapshot

Identical to the dispatch-time snapshot (no shepherd push). 5 SUCCESS, 1
FAILURE, the single FAILURE in the documented pre-existing infra-debt
cluster above. `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (the
UNSTABLE flag is the zizmor red).

## Hand-off

The PR is **substantively green for the PR-touched surface** under the
shepherd's framing: every check that exercises the design-doc change
passes; the lone failing check is an unrelated pre-existing red whose
disposition matches the prior shepherd pass on the same base.

The next stage in the gamut depends on the maintainer's framing for
design-only PRs on `llm`. Candidate next steps the orchestrator can route
to:

- `solicitor` (the design-panel judge, per the 2026-05-21 judge split) to
  panel and un-draft the design — if a panel pass has not already
  happened. (PR #89 is not currently DRAFT, so a prior panel pass or an
  out-of-band un-draft has occurred; check the panel-pass history before
  dispatching another.)
- Maintainer-direct review and merge, since the substantive content is a
  design proposal whose authority sits with the maintainer rather than
  with the panel.
- `boatman` to ferry the design upstream once the maintainer accepts. Not
  applicable until and unless the design is approved here.

The zizmor red does not gate the maintainer's review: it is identical to
the red present on every concurrent PR against `llm` and has been the
documented base-side debt for at least the prior several days of journal
history.

Self-improvement: nothing this time. The diagnostic chain (docs-only PR
diff; CI rollup narrow because the `CI (docs-only)` workflow correctly
discriminates; the one failing check fingerprints exactly to the prior
shepherd's documented base-side cluster on PR #347; parallel-PR cross-
check confirms determinism not flake) is exactly the same "pre-existing
infra red on llm-base" recognition the prior shepherd on PR #347 walked
through. No new skill or role edit is warranted on this occurrence; the
recognition is already well-rehearsed.
