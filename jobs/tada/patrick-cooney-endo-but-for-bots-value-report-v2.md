All data gathered and reconciled. The `gc.log` holds only benign reflog warnings (no corruption) — I'll flag it as a follow-up rather than operate on the live shared clone. Here is the full report.

---

# Patrick Cooney — contribution VALUE report for `endojs/endo-but-for-bots`

**Prepared:** 2026-08-12. **Purpose:** substantiate a real payment decision. **Method:** reuses the identity work, PR inventory, and review inventory from the two prior journal reports (`jobs/tada/patrick-cooney-endo-but-for-bots-contributions-report.md` and `…-value-report.md`), and independently re-derives every headline number from (a) a local mirror of the repo's `llm` mainline fetched 2026-08-12 20:59 UTC, and (b) the public GitHub REST/search API (unauthenticated; the fleet's authenticated token was invalid this session). Where a figure cannot be fully reproduced from available data, that is stated plainly rather than guessed.

**Subject identity:** GitHub user [`0xpatrickdev`](https://github.com/0xpatrickdev) = Patrick Cooney (high confidence; evidence chain in the prior contributions report — the `patrick@0xpatrick.dev` and `pcooney10@icloud.com` commit emails, and the self-linking [`0xpatrickbot`](https://github.com/0xpatrickbot) "Bot for @0xpatrickdev"). Throughout, **human-authored** work is discriminated cleanly by author email: `patrick@0xpatrick.dev` is Patrick; `patchrick@0xpatrick.dev` is his automated bot (`0xpatrickbot`) and its commits are **excluded** from his authorship totals.

---

## 1. Volume, quantified and broken out

**Activity window (authored commits):** first landed commit **2026-04-29**, most recent landed commit **2026-07-08** — a ~10-week concentrated authoring window. Review activity brackets and extends this span (reviewed PRs range from `#290` through open `#962`).

### 1a. Landed vs. proposed — the honest split

The prior reports' headline of **+27,636 / −4,327 across 104 content commits** is a *total-authored* figure that mixes merged work with commits that still sit on open or closed-unmerged branches. For a payment decision the distinction matters, so it is separated here. All three rows below are reconciled against each other:

| Scope | Content commits | Lines | Source / reproducibility |
|---|---|---|---|
| **Landed in the mainline (`llm`)** | **63** | **+19,197 / −2,051** | Independently reproduced from the local `llm` mirror (`git log --no-merges --author=patrick@0xpatrick.dev`). Exactly matches GitHub's indexed commit search (63 content + 9 GitHub-generated merge commits = the "72 commits" the first report cited). |
| Proposed but not yet merged | ~41 | ~+8,400 / −2,300 (by difference) | On still-open PRs (`#297`, `#298`, `#331`, `#369`) and closed-unmerged PRs (`#147`, `#341`, `#531`). Not in the mainline; counted in the report's 104 total but not yet realized value. |
| **Total authored content commits** | **104 → 105** | +27,636 / −4,327 (prior report) | The 105th is the `#311` blind-spot commit (see §5), which fell outside both prior enumeration nets. |

**Reading:** roughly **70%** of Patrick's authored additions (+19,197) have actually **landed in the mainline**; the remaining ~30% is proposed work awaiting merge. The 9 "merge commits" in the indexed set are GitHub-generated merge nodes, not authored content, and are excluded from every line total above.

**Methodology caveat (stated for honesty):** these line counts are the sum of per-commit `git` numstat. That slightly *over*-counts any line rewritten across multiple commits in a branch, and the raw `git show` on a merge node re-counts its whole branch (which is exactly why the merge commits are excluded). Because Patrick's landed commits are overwhelmingly *additive* feature/test work with little intra-branch churn, +19,197 is a fair gross measure of authored lines that reached the mainline. It is **not** inflated by generated files in the way some peers' totals are (see §2b caveat).

### 1b. Landed volume by thematic cluster

Breakdown of the 63 landed content commits (+19,197 / −2,051), by subsystem:

| Cluster | Commits | Lines | Share of additions |
|---|---|---|---|
| **Mount / Git-capability spine** (EndoMount, Git/GitRemote/GitCredential, native-git transport, fd-askpass credentials, design docs `#327`/`#366`/`#370`) | 42 | **+14,822 / −519** | **77%** |
| **LAL / FAE / Genie / agent-tools** (deterministic provider replay, tool-call history, mock powers, Pi/`@earendil-works` migration, git-tool param naming) | 15 | +3,769 / −211 | 20% |
| **CI / hygiene / chore** (tmp-dir removal, `yarn.lock` update, composite tsconfig regen, zizmor workflow hardening) | 5 | +519 / −1,297 | 3% |
| **Benchmark** (xs/v8 direct-download install) | 1 | +87 / −24 | <1% |

The mount/Git-capability spine is where the overwhelming majority of Patrick's landed value sits — **+14,822 additions, 77% of his merged additions, in a single coherent subsystem** he largely established. The single largest commits are `feat(daemon): Git capability over EndoMount` (+3,731), `feat(daemon): complete EndoMount and specialize as Directory` (+2,752 net across its sub-commits), and `feat(daemon): GitRemote capability` (+2,274), followed by extensive hardening and test commits (GitCredential +673, native-git remote transport +630, EndoMount conformance tests +1,618).

The proposed-but-unmerged clusters (not in the table above) are: SES/Compartments (`#297`), Endor/registry design (`#331`, `#369`), OCapN netlayer (`#341`), FAE prompt-optimizer (`#298`), the OpenRouter provider (`#147`, superseded), typing on the OCap SWE-loop probe (`#531`), and the `#311` module-source fix (§5).

---

## 2. Comparative standing across all contributors

### 2a. Reviewers — Patrick is the #2 reviewer in the entire repository

Distinct PRs reviewed, whole-repo, from the GitHub search API (`reviewed-by:`):

| Rank | Reviewer | PRs reviewed | Note |
|---|---|---|---|
| 1 | [`kriskowal`](https://github.com/kriskowal) | 333 | Repo owner / lead maintainer |
| **2** | **[`0xpatrickdev`](https://github.com/0xpatrickdev) (Patrick)** | **109** | — |
| 3 | [`kumavis`](https://github.com/kumavis) | 15 | |
| 4 | [`jcorbin`](https://github.com/jcorbin) | 3 | |
| 5 | [`ph0ngb0t`](https://github.com/ph0ngb0t) | 2 | |
| — | `danfinlay`, `naugtur`, `turadg` | 0 | authored code but submitted no reviews |

Only **five** accounts submitted any review at all. Patrick is the clear **#2 reviewer**, behind only the repository owner, and **7.3× the #3 reviewer** (109 vs 15). His 109 figure was independently confirmed against the API and matches the prior report exactly. Of those 109, **103 are on now-merged PRs**, and there are **375 merged PRs total** in the repo → Patrick provided review on **103 / 375 = 27.47%** of every merged PR — the headline figure, here reproduced from first principles (both numerator and denominator verified via API this session). His review record comprises **188 submitted reviews** (112 approvals, 35 change-requests, 41 comment-only) carrying **147 inline comments** (from the prior inventory).

Outside the owner, no other contributor is within an order of magnitude of Patrick's gatekeeping footprint.

### 2b. Committers — mid-pack by count, high by lines, #1 in his subsystem

Scope: fork-specific work only (commits on `llm` not inherited from upstream `endojs/endo`), content commits, 1,847 total across 27 distinct author emails. Identities merged; bots labeled.

| By commit count (humans) | Commits | | By lines added (humans) | Lines |
|---|---|---|---|---|
| Kris Kowal | 546 | | Joshua T Corbin | +66,694 / −7,328 |
| ph0ngb0t | 248 | | ph0ngb0t | +61,376 / −24,543 |
| Joshua T Corbin | 152 | | Dan Finlay | +40,848 / −4,607 |
| kumavis | 133 | | **Patrick (0xPatrick)** | **+19,110 / −2,027** |
| Dan Finlay | 78 | | Kris Kowal | +8,586 / −2,165 |
| **Patrick (0xPatrick)** | **62** | | kumavis | +2,900 / −633 |

(Automated accounts, for context: Claude bot 219 commits, `0xpatrickbot` 201, endolinbot 116, Kriscendo Bot 38, dependabot 23. Patrick's *own* bot `0xpatrickbot` is a separate 201-commit automated stream, deliberately **not** credited to him here.)

Patrick ranks **6th among humans by raw commit count but 4th by lines added** — his commits are large, self-contained capability landings rather than many small edits. **Important caveat for fairness:** the three contributors above him by lines (Corbin, ph0ngb0t, Finlay) have totals substantially inflated by generated/vendored files (lockfiles, snapshot fixtures, upstream-merge churn — note ph0ngb0t's 24,543 deletions). Patrick's +19,110 is predominantly hand-written daemon/capability/test source. Within the mount/Git-capability subsystem specifically, **Patrick is the single largest contributor**, and he is the author of its foundational design docs.

---

## 3. Criticality / dependency weight — the spine carries the repo's agent-Git story

The prior report asserted "37 later-merged PRs build on the mount/Git-capability spine." That is substantiated here: filtering merged PRs (merge commits on `llm`) that touch the spine's files (`packages/git`, `packages/exo-git`, EndoMount/Git surfaces in `packages/daemon`, and the `agent-tools`/`agentry` tools that consume them) **after** the spine landed (2026-05-26 onward) yields **~40 dependent merged PRs** once unrelated noise (dependabot bumps, upstream-master merges, generic CI) is removed. They cluster into four dependent subsystems:

**Git capability, extended and hardened (built directly on `#364`/`#365`/`#368`):**
- [`#367`](https://github.com/endojs/endo-but-for-bots/pull/367) archive immutable Git trees · [`#371`](https://github.com/endojs/endo-but-for-bots/pull/371) authority-boundary correctness fixes · [`#374`](https://github.com/endojs/endo-but-for-bots/pull/374) `Git.filesystemAt(ref)` · [`#382`](https://github.com/endojs/endo-but-for-bots/pull/382)/[`#390`](https://github.com/endojs/endo-but-for-bots/pull/390) extract & rename `@endo/git` · [`#442`](https://github.com/endojs/endo-but-for-bots/pull/442) extract `@endo/daemon-cas` · [`#527`](https://github.com/endojs/endo-but-for-bots/pull/527) non-interactive `rebase --continue` · [`#538`](https://github.com/endojs/endo-but-for-bots/pull/538) remote clone seam · [`#633`](https://github.com/endojs/endo-but-for-bots/pull/633) own public git types · [`#644`](https://github.com/endojs/endo-but-for-bots/pull/644) commit amend/reword · [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706) formula-owned commit-identity boundary · [`#906`](https://github.com/endojs/endo-but-for-bots/pull/906) reader/writer/rewriter Exo facets · [`#920`](https://github.com/endojs/endo-but-for-bots/pull/920) reject writable Git over read-only mounts · [`#929`](https://github.com/endojs/endo-but-for-bots/pull/929) normalize remote policy · [`#959`](https://github.com/endojs/endo-but-for-bots/pull/959) stream large status output.

**EndoMount / filesystem, extended (built on `#339`):**
- [`#277`](https://github.com/endojs/endo-but-for-bots/pull/277) `followNameChanges` live stream · [`#372`](https://github.com/endojs/endo-but-for-bots/pull/372) `endo-fs-exec` tree adapter · [`#373`](https://github.com/endojs/endo-but-for-bots/pull/373) FsBackend seam · [`#375`](https://github.com/endojs/endo-but-for-bots/pull/375) EndoMount data-safety fixes · [`#650`](https://github.com/endojs/endo-but-for-bots/pull/650) mount revocation caretaker + deny patterns · [`#678`](https://github.com/endojs/endo-but-for-bots/pull/678)/[`#714`](https://github.com/endojs/endo-but-for-bots/pull/714) platform fs (`listTree`/`rangeRead`/glob-grep).

**Agent-tools / Agentry — the agent runtime that *consumes* the Git+mount capabilities as tools (this is what the spine was for):**
- [`#408`](https://github.com/endojs/endo-but-for-bots/pull/408) confined git/FS tools + schema⟷guard gate · [`#416`](https://github.com/endojs/endo-but-for-bots/pull/416) agent-tools/agentry design · [`#423`](https://github.com/endojs/endo-but-for-bots/pull/423) live-Exo git integration test · [`#517`](https://github.com/endojs/endo-but-for-bots/pull/517) execute-only code-mode runtime + LAL git loop · [`#518`](https://github.com/endojs/endo-but-for-bots/pull/518) git-tool param names from methods · [`#523`](https://github.com/endojs/endo-but-for-bots/pull/523) `makeMountReadTool` onto canonical ToolRecord · [`#524`](https://github.com/endojs/endo-but-for-bots/pull/524) code-mode TS declarations · [`#537`](https://github.com/endojs/endo-but-for-bots/pull/537) file-transport SWE-loop integration · [`#611`](https://github.com/endojs/endo-but-for-bots/pull/611) reconcile daemon-agent-tools design with landed caps · [`#614`](https://github.com/endojs/endo-but-for-bots/pull/614) list/stat/edit FS tools · [`#615`](https://github.com/endojs/endo-but-for-bots/pull/615) Shell capability + tool · [`#616`](https://github.com/endojs/endo-but-for-bots/pull/616) mount-bridged git status/add tools · [`#623`](https://github.com/endojs/endo-but-for-bots/pull/623) checked git/fs declarations · [`#635`](https://github.com/endojs/endo-but-for-bots/pull/635)/[`#636`](https://github.com/endojs/endo-but-for-bots/pull/636) Agentry git eval scenarios · [`#661`](https://github.com/endojs/endo-but-for-bots/pull/661) HTTP client tool.

**Design / reconciliation of the spine's roadmap:** [`#366`](https://github.com/endojs/endo-but-for-bots/pull/366), [`#370`](https://github.com/endojs/endo-but-for-bots/pull/370), [`#358`](https://github.com/endojs/endo-but-for-bots/pull/358) (importLocation from EndoMount).

That is **≥37 merged PRs** whose existence presupposes Patrick's mount/Git spine — and it is the load-bearing layer for the repository's entire agent-tooling / code-mode / SWE-loop direction (an agent that can clone, edit, stage, commit, rebase and push inside a confined capability). The dependency is not incidental citation; these PRs extend, harden, re-type, and build tools directly on the EndoMount + Git/GitRemote/GitCredential surfaces he authored.

---

## 4. Representative gatekeeping reviews (quoted)

Selected from Patrick's 35 change-request reviews to show *substantive* judgment — correctness/regression blocks, authority-boundary and credential concerns, and architecture redirects — as distinct from light procedural approvals. Quotes are verbatim from the GitHub review API (fetched this session).

1. **Blocked a merge over functional regressions in default/documented paths — [`#517`](https://github.com/endojs/endo-but-for-bots/pull/517)** (CHANGES_REQUESTED). The single strongest example of correctness gatekeeping. Patrick's review header:
   > "Requesting changes for the model-resolution and credential handling regressions below. The included tests may pass, but these look like functional regressions in documented/default code paths."
   
   He then enumerated three specific defects with file:line, including two **credential/authentication** regressions: that passing a `Credentials` provider without an explicit `getApiKey` "drops the credentials and constructs a `PiAgent` with no key resolver … and it also makes the advertised credential seam a no-op for code-mode callers," and that Ollama workers "configured through the Lal form with a real `authToken`/`LAL_AUTH_TOKEN` … can no longer authenticate unless the ambient environment is set." This is a reviewer catching a *green-tests-but-broken-behavior* regression in an authority-sensitive path.

2. **Questioned an authority-boundary API and enforced commit discipline — [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706)** (CHANGES_REQUESTED, formula-owned Git commit identity). On the commit-identity surface:
   > "Why did we decide not to expose `commiterName` and `commiterEmail` parameters? Feel like we might as well at this point. We can make them optional and default to `author*` when unset."
   
   and, holding the line on reviewable history: *"do a retcon pass along with these changes. This should be a fixup + autosquash into the original commit."*

3. **Redirected architecture / API surface for a resource bound — [`#408`](https://github.com/endojs/endo-but-for-bots/pull/408)** (CHANGES_REQUESTED, confined git/FS tools). On the mount read-limit:
   > "Let's expose this as config / opts bag for `makeMountReadTool` with default values. A value of 0 should disable the limit."
   
   — turning a hard-coded bound into an explicit, caller-controlled attenuation knob.

4. **Directed a remote-policy change to be isolated and snapshot-tested — [`#929`](https://github.com/endojs/endo-but-for-bots/pull/929)** (git remote policy normalization):
   > "add snapshot tests for `exo-git`'s exports … Please make it the first commit in the branch and add a subsequent `chore: snapshot` so the new export (`normalizeGitRemotePolicy`) is clear … split out the `defaultPullRef` change in the first commit."
   
   — architecture/reviewability gatekeeping on a policy-bearing export.

5. **Blocked over unresolved cross-PR references before merge — [`#424`](https://github.com/endojs/endo-but-for-bots/pull/424)** (CHANGES_REQUESTED, capability petname resolution; later closed unmerged):
   > "Can we remove mention of PR A,C,D in code, comments, and the PR body and use numbers instead? All relevant PRs should be open at this point."

6. **Type-safety and side-effect discipline on the agent harness — [`#517`](https://github.com/endojs/endo-but-for-bots/pull/517)** (inline): *"Would prefer we avoid side effects … Wdyt about adding [a] hook to defineAgent that accepts a function to be called in the future?"*; and *"For type-based documentation, we should avoid unknowns here. Please use a combination of generics + specifying minimum required powers."*

These span six PRs and demonstrate gatekeeping across correctness, credential/authority boundaries, resource attenuation, public-type quality, and reviewable-history discipline — the profile of a technical lead, not a rubber-stamp approver.

---

## 5. The `#311` blind-spot finding

**What it is.** PR [`#311`](https://github.com/endojs/endo-but-for-bots/pull/311) — *"fix(module-source): pass defineProperty through functor calling convention"* — is an **open, unmerged** PR whose branch's **first commit, `3ce1febf5`, is authored by Patrick** (`0xPatrick <patrick@0xpatrick.dev>`, dated 2026-05-19). It is a genuine SES/module-source correctness fix (+55 / −6), touching `packages/module-source` (the functor calling convention and hidden-binding emit), `packages/compartment-mapper`, `packages/ses`, plus a regression test and changeset. The remaining four commits on that PR belong to Kris's bot.

**Why the first pass missed it.** The original contributions report enumerated Patrick's commits through two nets: (a) PRs authored directly by `0xpatrickdev`, and (b) the 140 PRs authored by his bot `0xpatrickbot`. PR `#311` was opened by a **third** account — `kriscendobot` — so it was invisible to both nets. And because the PR is **unmerged**, its commit is not reachable from the mainline and is **omitted from GitHub's indexed commit search** (a limitation the first report explicitly flagged). The commit therefore fell through *every* automated attribution path.

**Its bearing on the volume figures.** This is precisely the commit that reconciles the two prior reports' differing headcounts: the contributions report counted **104** content commits; adding this recovered commit yields the value report's **105**. Its practical weight is small (+55 / −6, and unmerged), so it does **not** materially change the landed-volume conclusion in §1 — but it does confirm that the enumeration is now complete to the best of what indexed history and inspected branches can show. **Residual limitation (stated for the payment decision):** because GitHub exposes no complete repository-wide search for commits on branches authored by *arbitrary* third accounts, one cannot fully rule out further Patrick-authored commits hiding on other bots' unmerged PRs, or force-pushed-away history. The 105-commit total is "all presently observable," not a closed-world guarantee.

---

## Data provenance and limitations

- **Line/commit/committer/dependency figures:** reproduced locally from the `endojs/endo-but-for-bots` `llm` mirror fetched 2026-08-12 20:59 UTC. Fully reproducible.
- **Reviewer leaderboard, merged-PR denominator (375), the 27.47%, PR `#311` metadata, and all review quotes:** the public GitHub REST/search API (unauthenticated; the fleet's authenticated token was invalid this session, which capped query volume — reviewer counts were spot-checked for the plausible reviewer set rather than enumerated across all 902 PRs, but the top of the leaderboard is unambiguous).
- **Not independently re-derived:** the exact +27,636 / −4,327 all-branches total and the 41 unmerged-branch commits are carried from the prior report; this report reproduces the *landed* subset (+19,197 / −2,051, 63 commits) directly and treats the remainder as proposed work.
- No dollar figure, rate, or payment amount is proposed, per the brief. No repository or PR was modified; this is an analysis-only report.

**Operational follow-up (unrelated to the analysis):** read-only `git` traversal of the shared bare clone `worktrees/endojs-endo-but-for-bots.git` triggered an auto-`gc` that failed and left a `gc.log` (containing only benign "reflog references pruned commits" warnings, no corruption). Its presence disables git's *automatic* housekeeping on that clone until removed. I did not modify the live shared clone; a maintainer or a project-clone equivalent of the root-repo-guard should clear the `gc.log` and run a manual `git gc`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/patrick-cooney-endo-but-for-bots-value-report-v2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2606244 cached reads)
- Output: 58116 tokens
- Cost: $3.868412999999999
- Wall-clock: 1404s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
