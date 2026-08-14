Inbox empty. Done.

## Completion report

**Job:** `design-frozen-base-supersession-check` — a design job responding to the 2026-08-12 liaison-bus finding that the fleet built `@endo/sha256` twice (`#836` merged into frozen base `llm-bfc91f5`, invisible from live `llm`; `#903` rebuilt from scratch ~10 days later).

**What I did:** Wrote `designs/frozen-base-supersession-check.md` (Status: Proposed) and added its index row to `designs/README.md`. Committed both with explicit pathspecs and pushed to `main2` via a rebase-CAS loop (landed first attempt).

**What the design specifies:**
- **Root cause named:** a producer's "does this exist yet?" read is *base-local* (reads live trunk via `git ls-tree`, or a design-slug/issue-number PR search), so it's blind to a package merged into a frozen `<base>-<sha>` snapshot that hasn't rebased forward.
- **The check (candidate 1, landing cut):** a deterministic, no-LLM `scripts/jobs/supersession-check.sh` running two lookups by changeset slug / package path — **Lookup A** `gh pr list --state all --search` across *all* bases (unbase-scoped, so a frozen-base merge surfaces; classifies hits `frozen-base` vs `live` off the `<trunk>-<sha>` pattern), **Lookup B** a `git ls-remote`/`ls-tree` scan of the fork's own frozen-base branch trees. Fail-open on infra error.
- **Two call sites:** the **producer** as a pre-post gate (on a hit, park the build `--gate supersession-hold` and surface to the maintainer for a promote-or-redirect decision instead of posting a blind `build`), and the **builder's** widened *verify-no-duplicate* preflight as a stop-at-impasse backstop.
- **Candidate 2 weighed:** the frozen-base merge policy (net-new only on live trunk + a fleet-visible `frozen-base-additions` note) is framed as the *push/index-time* half and explicitly **flagged to the maintainer as a followup**, not landed — with the reasoning that the pull half already prevents the incident's cost and stands alone against existing strands.

**Changed:** `designs/frozen-base-supersession-check.md` (new), `designs/README.md` (index row).

**Follow-ups (owned by the design's own build, when accepted):** the helper script, a `skills/supersession-check/SKILL.md`, and the three wiring edits (design-to-pr-pipeline covered-rule, builder preflight, triager build-post). Separately, rebasing the stranded frozen stacks (`llm-bfc91f5` et al.) forward is noted as out-of-scope janitorial work under existing weave/rebase vocabulary. The maintainer decision on candidate 2 is the only open policy question.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-frozen-base-supersession-check.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 25 tokens (805872 cached reads)
- Output: 13742 tokens
- Cost: $1.413396
- Wall-clock: 224s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
