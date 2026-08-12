# Patrick Cooney's contribution volume, comparative standing, and dependency weight

Research completed 2026-08-12 against `endojs/endo-but-for-bots`. This is a follow-up to [the contribution and identity inventory](patrick-cooney-endo-but-for-bots-contributions-report.md), which establishes that Patrick Cooney is GitHub user [`0xpatrickdev`](https://github.com/0xpatrickdev), explains the `0xpatrickbot` transport boundary, and inventories the underlying pull requests, commits, and reviews. This report does not repeat that work and does not propose a payment amount.

## Findings in brief

- The prior inventory's 104 content commits account for 27,581 additions and 4,321 deletions. A repository-wide comparative pass surfaced one additional Patrick-authored commit on a third-account PR, exactly the blind spot the prior report disclosed. Including it gives **105 content commits, 27,636 additions, 4,327 deletions, and 31,963 total changed lines**.
- The work was not a year-long stream of authored code: the observed content commits run from 2026-04-29 through 2026-06-26, just under eight weeks. Formal reviews continue through 2026-08-12, making the observed contribution span 105 days, about three and a half months.
- Among 5,821 distinct commit SHAs submitted across all 901 repository PRs, Patrick has 105 (1.80%), tied for eighth among 32 API identity buckets. GitHub's inherited-history default-branch statistic instead places him 24th with 72 of 9,949 commits (0.72%); both figures and the reason for their difference are reported below.
- Patrick ranks **third by submitted reviews**, with 188 of 2,642 repository reviews (7.12%). He reviewed 103 of the repository's 375 merged PRs, or **27.47%**.
- A conservative dependency inventory identifies **37 later merged PRs and 2 still-open PRs** that explicitly extend the mount/Git spine he designed and implemented. Those descendants cover daemon mounts, immutable Git trees, Git remotes and history rewriting, Agent Tools, Agentry evaluations/code mode, public capability facets/types, and authority enforcement.

## Authored volume

I fetched GitHub's per-commit `stats.additions` and `stats.deletions` for the human-authored content objects. The nine merge-only objects from the prior report are excluded: their author field evidences merge activity, not authorship of the merged implementation, and counting their diff would duplicate content. Exact duplicate SHAs are counted once.

| Prior-report thematic cluster | Content commits | Added | Removed | Total changed |
| --- | ---: | ---: | ---: | ---: |
| Mount/Git-capability spine, including the open Endor Git-backbone spike | 54 | 16,857 | 1,266 | 18,123 |
| LAL, FAE, Genie, and Agent Tools | 37 | 9,411 | 2,604 | 12,015 |
| SES and Compartments | 8 | 528 | 73 | 601 |
| Endor and registry design | 1 | 671 | 0 | 671 |
| OCapN | 1 | 14 | 228 | 242 |
| CI, benchmarks, and repository hygiene | 4 | 155 | 156 | 311 |
| **Total** | **105** | **27,636** | **4,327** | **31,963** |

The correction is [`3ce1feb`](https://github.com/endojs/endo-but-for-bots/commit/3ce1febf58b724dd0412a9a231fda6d2f0ab3c5f), a +55/-6 `module-source`/SES correctness change on open [`#311`](https://github.com/endojs/endo-but-for-bots/pull/311), a PR authored by `kriscendobot`. It passes `defineProperty` through the functor calling convention so a user import named `Object` cannot shadow the intrinsic used by generated module preambles. The prior audit explicitly said it could not rule out a Patrick commit on an unmerged PR authored by a third account; this is one such commit. The prior 113-object total should therefore be read as 114 presently observed objects: 105 content commits plus 9 merge-only objects.

Without that newly found commit, the prior report's fixed 104-content-commit universe sums to **27,581 additions, 4,321 deletions, and 31,902 changed lines**. Both totals are stated so the correction is auditable rather than silently folded into the earlier inventory.

These are change-set sizes, not hours or exclusive personal authorship. They include tests, design documents, fixtures, generated material, and dependency lockfiles; deletions count equally with additions in "total changed." Git author metadata attributes the change set, while co-author trailers on some commits mean it should not be interpreted as a claim that every changed line was typed by Patrick alone.

### Duration

The first observed content commit is [`e4beebf`](https://github.com/endojs/endo-but-for-bots/commit/e4beebf3713462fb684dcc79969cc9a2cd7bcae3) on 2026-04-29; the last is [`04083b8`](https://github.com/endojs/endo-but-for-bots/commit/04083b872d77c7f411d91152d241b910f3c8f001) on 2026-06-26. That is a concentrated implementation period of just under 58 days. Patrick's formal-review record begins 2026-05-19 and continues through a change request on [`#962`](https://github.com/endojs/endo-but-for-bots/pull/962#pullrequestreview-4918532012) on 2026-08-12. From first authored commit to latest observed review is 105 days: sustained involvement for roughly three and a half months, but not evidence of longer-term involvement outside that window.

## Comparative standing

### Reviews

The comparison enumerated the review endpoint for all 901 PRs and counted each submitted review object once. It includes human and bot accounts and does not merge `0xpatrickbot` into Patrick's identity.

| Rank | Reviewer | Submitted reviews | Share of 2,642 | Distinct PRs reviewed |
| ---: | --- | ---: | ---: | ---: |
| 1 | `kriscendobot` | 1,330 | 50.34% | 296 |
| 2 | `kriskowal` | 654 | 24.75% | 329 |
| **3** | **`0xpatrickdev`** | **188** | **7.12%** | **109** |
| 4 | `0xpatrickbot` | 182 | 6.89% | 51 |
| 5 | `erights` | 123 | 4.66% | 26 |

There are 551 PRs with at least one submitted review. Patrick reviewed 109 of them (19.78%). More consequentially, 103 of the repository's 375 merged PRs carry at least one Patrick review: **27.47% of all merged PRs**. His 179 review submissions on merged PRs are 11.73% of the repository's 1,526 review submissions on merged PRs. Fourteen reviewed bot PRs also carried Patrick-authored commits, as the prior report notes, so review reach should not be misread as 109 wholly independent third-party assessments.

### Commits

The repository's default branch includes a large imported Endo history, so one ranking cannot answer both "activity in this bot-development repository" and "all commits currently reachable from its default branch." I report both rather than selecting the favorable denominator.

For the repository-native comparison, I enumerated commit lists for all 901 PRs, deduplicated exact SHAs, and retained GitHub's linked login or, when no login was linked, the exact author-name/email bucket. There are 5,821 distinct submitted SHAs across 32 such identity buckets:

| Rank | GitHub identity bucket | Distinct submitted commits | Share of 5,821 |
| ---: | --- | ---: | ---: |
| 1 | `ph0ngb0t` | 1,101 | 18.91% |
| 2 | unlinked `endolinbot <main.barn5084@fastmail.com>` | 925 | 15.89% |
| 3 | `kriscendobot` | 774 | 13.30% |
| 4 | `kriskowal` | 698 | 11.99% |
| 5 | `claude` | 691 | 11.87% |
| 6 | unlinked `endolinbot <endolinbot@users.noreply.github.com>` | 533 | 9.16% |
| 7 | `0xpatrickbot` | 500 | 8.59% |
| **8 (tie)** | **`0xpatrickdev`** | **105** | **1.80%** |
| 8 (tie) | `turadg` | 105 | 1.80% |
| 10 | `kumavis` | 96 | 1.65% |

This method measures submitted commit objects, not merged-only work: open and closed-unmerged work is intentionally present because the prior Patrick inventory includes it. Exact SHA deduplication removes the same commit reused across stacked PRs, but a rebased or recreated commit has a new SHA and remains a separate object. The two unlinked Endolin buckets are left separate because the API did not link them to one account; combining identity buckets by name would require a separate identity audit for every contributor.

As a cross-check with a different scope, GitHub's Contributors endpoint over the current default-branch history reports 9,949 commits and ranks Patrick **24th of 77 contributor buckets**, at 72 commits (0.72%). Its leading entries are `kriskowal` 2,662, `michaelfig` 1,162, `turadg` 663, `erights` 611, and `kumavis` 489. That endpoint includes inherited upstream history and omits Patrick's unreachable/open-branch work; its 72 is the same indexed/reachable count explained in the prior report, not a contradiction of the 105 observed content objects.

## Criticality and dependency weight

### Mount/Git-capability spine

The foundational sequence is the design in [`#327`](https://github.com/endojs/endo-but-for-bots/pull/327), the EndoMount implementation in [`#339`](https://github.com/endojs/endo-but-for-bots/pull/339), and the Git capability, remotes, credential transport, design reconciliation, and authority/correctness hardening in [`#364`](https://github.com/endojs/endo-but-for-bots/pull/364), [`#365`](https://github.com/endojs/endo-but-for-bots/pull/365), [`#366`](https://github.com/endojs/endo-but-for-bots/pull/366), [`#368`](https://github.com/endojs/endo-but-for-bots/pull/368), [`#370`](https://github.com/endojs/endo-but-for-bots/pull/370), and [`#371`](https://github.com/endojs/endo-but-for-bots/pull/371). Open spike [`#369`](https://github.com/endojs/endo-but-for-bots/pull/369) explores an Endor-backed storage substrate but is not treated as landed infrastructure.

A conservative title/scope inventory finds 39 later PRs that explicitly extend this spine: **37 merged and 2 open**. This is a dependency count, not a same-directory churn count; it excludes generic daemon maintenance whose relationship is not plain from the PR's stated scope.

- **Mount, daemon, and authority enforcement (8 merged):** data safety in [`#375`](https://github.com/endojs/endo-but-for-bots/pull/375); independent GitRemote fetch in [`#532`](https://github.com/endojs/endo-but-for-bots/pull/532); native-Git environment hardening in [`#642`](https://github.com/endojs/endo-but-for-bots/pull/642); contract consolidation in [`#643`](https://github.com/endojs/endo-but-for-bots/pull/643); formula-owned commit identity in [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706); rejection of writable Git over a read-only mount in [`#920`](https://github.com/endojs/endo-but-for-bots/pull/920); extended-filesystem Exo/type reconciliation in [`#926`](https://github.com/endojs/endo-but-for-bots/pull/926) and [`#941`](https://github.com/endojs/endo-but-for-bots/pull/941).
- **Git remotes, public facets, and history operations (12 merged, 2 open):** immutable Git trees in [`#367`](https://github.com/endojs/endo-but-for-bots/pull/367); noninteractive rebase in [`#527`](https://github.com/endojs/endo-but-for-bots/pull/527); clone seam in [`#538`](https://github.com/endojs/endo-but-for-bots/pull/538); public types in [`#633`](https://github.com/endojs/endo-but-for-bots/pull/633); amend/reword and stack replay in [`#644`](https://github.com/endojs/endo-but-for-bots/pull/644), [`#645`](https://github.com/endojs/endo-but-for-bots/pull/645), and [`#646`](https://github.com/endojs/endo-but-for-bots/pull/646); credential/ref typing in [`#734`](https://github.com/endojs/endo-but-for-bots/pull/734); authority postures and Exo facets in [`#835`](https://github.com/endojs/endo-but-for-bots/pull/835) and [`#906`](https://github.com/endojs/endo-but-for-bots/pull/906); remote policy in [`#929`](https://github.com/endojs/endo-but-for-bots/pull/929); streamed status in [`#959`](https://github.com/endojs/endo-but-for-bots/pull/959); plus open smart-HTTP [`#394`](https://github.com/endojs/endo-but-for-bots/pull/394) and status/tracking [`#962`](https://github.com/endojs/endo-but-for-bots/pull/962).
- **Agent Tools and Agentry consumers (17 merged):** the initial confined Git/filesystem tools and live integration in [`#408`](https://github.com/endojs/endo-but-for-bots/pull/408) and [`#423`](https://github.com/endojs/endo-but-for-bots/pull/423); Git and mount-read tool shaping in [`#518`](https://github.com/endojs/endo-but-for-bots/pull/518) and [`#523`](https://github.com/endojs/endo-but-for-bots/pull/523); Git evaluations/integration in [`#525`](https://github.com/endojs/endo-but-for-bots/pull/525), [`#526`](https://github.com/endojs/endo-but-for-bots/pull/526), and [`#537`](https://github.com/endojs/endo-but-for-bots/pull/537); the reconciled design and later filesystem/Git tools in [`#611`](https://github.com/endojs/endo-but-for-bots/pull/611), [`#614`](https://github.com/endojs/endo-but-for-bots/pull/614), and [`#616`](https://github.com/endojs/endo-but-for-bots/pull/616); checked declarations and verb/eval designs in [`#623`](https://github.com/endojs/endo-but-for-bots/pull/623), [`#635`](https://github.com/endojs/endo-but-for-bots/pull/635), and [`#636`](https://github.com/endojs/endo-but-for-bots/pull/636); and code-mode globals, daemon-backed Pi code mode, reusable types, and export checks in [`#902`](https://github.com/endojs/endo-but-for-bots/pull/902), [`#907`](https://github.com/endojs/endo-but-for-bots/pull/907), [`#925`](https://github.com/endojs/endo-but-for-bots/pull/925), and [`#932`](https://github.com/endojs/endo-but-for-bots/pull/932).

The dependency chain is therefore not merely "later PRs touched Patrick's files." EndoMount supplies the bounded filesystem object; Git and GitRemote compose over it; Agent Tools expose those capabilities to agents; Agentry then builds evaluation and code-mode surfaces over the tools. Later work repeatedly tightens the original authority dimensions: read-only mounts, history-rewrite authority, remote credentials/policy, formula-owned identity, and streamed status.

No other Patrick cluster has comparably strong landed dependency evidence. The LAL/FAE/Genie cluster has substantial volume and later lineage, but major architectural bases such as [`#290`](https://github.com/endojs/endo-but-for-bots/pull/290) and [`#416`](https://github.com/endojs/endo-but-for-bots/pull/416) were authored by other accounts; assigning all later Agent Tools/Agentry work to Patrick's LAL commits would overstate causality. His SES changes are on open PRs [`#297`](https://github.com/endojs/endo-but-for-bots/pull/297) and [`#311`](https://github.com/endojs/endo-but-for-bots/pull/311), the Endor/registry designs [`#331`](https://github.com/endojs/endo-but-for-bots/pull/331) and [`#369`](https://github.com/endojs/endo-but-for-bots/pull/369) remain open, and the OCapN change [`#341`](https://github.com/endojs/endo-but-for-bots/pull/341) closed unmerged. Those may be useful work, but the repository state does not support calling them load-bearing landed infrastructure.

## Nature of the review authority

The raw review-state split is 112 approvals, 35 change requests, and 41 comment-only reviews. A mechanical content proxy gives a more cautious distinction: 92 of the 188 submissions either requested changes, contained a nonempty review body, or owned at least one inline comment; the other 96 were bare approvals with no attached body or inline comment. Those 96 should not be presented as 96 documented technical interventions. Conversely, a bare approval can follow substantive earlier rounds, and some written reviews are procedural, so the proxy is descriptive rather than a quality score. Patrick issued change requests on 29 distinct PRs and authored 147 inline comments.

Representative records show several kinds of gatekeeping judgment:

- **Persisted authority boundary, followed through to approval:** on Shell capability [`#615`](https://github.com/endojs/endo-but-for-bots/pull/615), Patrick identified that omitting `policy.searchPath` caused a persisted formula to re-read ambient `PATH` after restart, allowing the same allowlisted command to resolve to a different executable. He directed that the effective path be persisted or omission rejected ([comment](https://github.com/endojs/endo-but-for-bots/pull/615#discussion_r3545029939)), then submitted two change-request reviews and approved only after the fixes ([approval](https://github.com/endojs/endo-but-for-bots/pull/615#pullrequestreview-4657408351)). This is a concrete authority-boundary merge gate, not a style preference.
- **Correctness defect outside existing test coverage:** on Git amend/reword [`#644`](https://github.com/endojs/endo-but-for-bots/pull/644), he reproduced an ancestor-path root reword that succeeded and then permanently locked the capability behind a false repository-identity error. He explained why the existing root-equals-HEAD test missed it and proposed the generalized refresh point ([comment](https://github.com/endojs/endo-but-for-bots/pull/644#discussion_r3560634913)). In the same pass he found that `gitMode: 'historyRewrite'` advertised elevated operations without verifying the resolved capability actually had rewrite authority ([comment](https://github.com/endojs/endo-but-for-bots/pull/644#discussion_r3560638487)). These were comment-state reviews rather than formal `CHANGES_REQUESTED`, so they evidence technical diagnosis but should not be mislabeled as a formal block; he approved later that day.
- **Architecture redirected across component boundaries:** on Agent Tools [`#751`](https://github.com/endojs/endo-but-for-bots/pull/751), Patrick called deadline timers and structured pending/timeout results a "misdirection," required their removal from the tool because waiting belongs to the harness, and kept daemon `--no-wait` as separate work ([comment](https://github.com/endojs/endo-but-for-bots/pull/751#discussion_r3600377291)). That review was formally `CHANGES_REQUESTED`; approval came after the redesign ([approval](https://github.com/endojs/endo-but-for-bots/pull/751#pullrequestreview-4834989905)).
- **Subsystem architecture, not local patch review:** on the Agentry design [`#416`](https://github.com/endojs/endo-but-for-bots/pull/416), Patrick required the builder layer to be capable of recreating LAL, FAE, and Genie ([comment](https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3351565663)), rejected a premature generic harness abstraction ([comment](https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3351649209)), and required filesystem and Git to be designed as cooperating capabilities with bounded `GitRemote` rather than unrelated backends ([comment](https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3352992543)). The record contains two formal change requests before approval three weeks later.
- **Public-interface discipline:** on the initial Git capability [`#364`](https://github.com/endojs/endo-but-for-bots/pull/364), he required typed options and return values on all exposed `NativeGitBackend` methods, explaining that caller-inaccessible casts do not type a public interface ([comment](https://github.com/endojs/endo-but-for-bots/pull/364#discussion_r3311695729)). He then clarified that newly introduced opaque promise guards had to be fixed in the same PR, not deferred to a broad follow-up ([comment](https://github.com/endojs/endo-but-for-bots/pull/364#discussion_r3313254427)).

The same record also contains light/procedural work: commit-scope corrections, fixup/autosquash requests, date changes, import-style preferences, and the 96 bare approvals. The evidence supports describing Patrick as exercising technical-lead or maintainer-like judgment in specific architecture, correctness, typing, and authority-boundary cases; it does not support treating every one of his 188 submitted reviews as equally substantive.

## Coverage and limitations

- The volume calculation uses GitHub's per-commit stats for all presently observed human-authored content objects. Binary changes may report no line count, generated/lockfile churn is included, and author metadata is not a time sheet.
- The new `#311` finding demonstrates the prior report's stated incompleteness. There may still be force-pushed-away objects or Patrick commits on unmerged third-account PRs that are no longer observable. No estimate fills that gap.
- PR-commit rankings include merged, open, and closed-unmerged PRs and count recreated SHAs separately. Default-branch contributor rankings include inherited upstream history. Neither denominator is presented as uniquely canonical.
- The 39-PR dependency inventory is intentionally conservative and based on explicit PR scope. It establishes a lower bound, not a claim that no other later work depends indirectly on the spine.
- Review "substantive signal" is a reproducible metadata proxy, not semantic scoring. The linked examples provide the concrete evidence for the authority claim.

No code, pull request, or issue was changed; this is a journal-only evidence report.

Self-improvement: nothing this time.
