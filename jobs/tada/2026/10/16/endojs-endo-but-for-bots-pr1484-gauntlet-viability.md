I checked PR #1484 and it can go ahead: `viability=proceed`.

**PR facts:** #1484, "design: HTTPS fragment locators replacing endo://", is OPEN, a DRAFT and not merged. It was opened 2026-10-16T22:05Z by job `design-https-fragment-locators-20261016`. Its head is `design/https-fragment-locators` @ `a908c290` and its base is the frozen `llm-61cd656`. It changes two files: it adds `designs/https-fragment-locators.md` (667 lines) and adds 7 lines to `designs/README.md`. There are no reviews or comments yet.

**Deciding question:** Is there anything on `llm`, or any newer PR, that already specifies moving every `endo://` locator to an HTTPS fragment form, so that the need for this design no longer holds?

Answer: no.

**Evidence:**
- **Need still holds:** the PR body says @kriskowal asked for it in a liaison session today (2026-10-16). It counts 226 `endo://` lines across 65 files in endo-but-for-bots that are still to be migrated.
- **Nothing on `llm` covers it:** the related designs there are `daemon-locator-reference.md`, `daemon-locator-terminology.md`, `endo-content-locators-magnet-urn.md` and `familiar-deep-link-invitations.md`. None of them is an HTTPS-fragment migration. #1484 deliberately supersedes the `endo://invite/` envelope in `familiar-deep-link-invitations`.
- **No newer PR replaces it:** a search for "fragment locator" finds no newer PR. The closest is #1360, "capability URL locators (endo store --locator and the https fragment form)". It is older (opened 2026-09-28), still a draft, not merged, and narrower: it covers `store --locator` and adds the fragment form alongside `endo://` rather than migrating everything. As the newer and broader design, #1484 does not lose to #1360.

**Note for the review and fix stages:** #1484 never mentions #1360 or #1333, even though both define a `#v=1` fragment family (the minion.town invitation envelope and the self-contained locator family). The panel should check that the two designs reconcile, or that #1484 explicitly takes over #1360. Otherwise the maintainer will have two overlapping open designs.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1484-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (170329 cached reads)
- Output: 1618 tokens
- Cost: $0.4052498000000001
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
