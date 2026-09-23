# Patrick Cooney’s contributions to `endojs/endo-but-for-bots`

Research completed 2026-08-12 using GitHub’s REST search, pull-request, commit, review, review-comment, and issue-comment APIs.

## Executive summary

Identity confidence is high: Patrick Cooney is GitHub user [`0xpatrickdev`](https://github.com/0xpatrickdev). The profile itself says “0xPatrick,” but the account’s `patrick@0xpatrick.dev` commit email is associated with an historical GitHub email reply naming “Patrick Cooney” ([evidence](https://github.com/ds300/patch-package/issues/97#issuecomment-455291665)). A repository commit also links `pcooney10@icloud.com` to `0xpatrickdev`. The separate [`0xpatrickbot`](https://github.com/0xpatrickbot) profile explicitly identifies itself as “0xPatrick’s Bot — Bot for @0xpatrickdev.”

The totals found were:

- 2 pull requests authored directly by `0xpatrickdev`: 1 merged and 1 closed unmerged.
- 22 `0xpatrickbot` pull requests containing 96 Patrick-authored content commits: 16 merged, 4 open, and 2 closed unmerged.
- 3 further bot-authored pull requests whose GitHub merge commits name Patrick as author, but whose branch commits belong to the bot; these are separated below.
- 72 commits returned by GitHub commit search: 63 content/direct commits and 9 merge commits.
- 41 additional Patrick-authored commits found only through open or closed-unmerged PR commit lists.
- 113 distinct attributable Git objects observed in total: 104 content commits and 9 merge commits.
- 109 pull requests formally reviewed, through 188 submitted reviews: 112 approvals, 35 change requests, and 41 comment-only reviews. Those reviews include 147 inline comments.
- 6 additional, non-authored PRs with substantive discussion but no formal submitted review.
- 0 issues opened; 1 issue substantively discussed through 2 comments.

The report lands at `jobs/tada/patrick-cooney-endo-but-for-bots-contributions-report.md`.

## Identity and bot-account boundary

The identification is stronger than a name guess:

- `0xpatrickdev` consistently authors commits as `0xPatrick <patrick@0xpatrick.dev>`.
- An historical reply to a comment from that account records the sender as Patrick Cooney.
- [`0xpatrickbot`](https://github.com/0xpatrickbot) explicitly links itself to `0xpatrickdev`.
- [`endojs/endo-but-for-bots#531`](https://github.com/endojs/endo-but-for-bots/pull/531) contains a commit linked by GitHub to `0xpatrickdev` using `pcooney10@icloud.com`, independently corroborating the surname initial.

I treated activity performed by `0xpatrickdev` as Patrick’s. Bot-authored commits using `0xpatrickbot <patchrick@0xpatrick.dev>` were excluded. Human-authored commits transported by a bot-authored PR were included but are clearly separated from directly authored PRs.

## Directly authored pull requests

### LAL, FAE, and model-provider integration

- **Merged:** [`endojs/endo-but-for-bots#146`](https://github.com/endojs/endo-but-for-bots/pull/146) — fixed FAE setup scripts to bind providers through `storeIdentifier`, restoring the documented factory setup flow.
- **Closed unmerged:** [`endojs/endo-but-for-bots#147`](https://github.com/endojs/endo-but-for-bots/pull/147) — introduced an OpenRouter provider, consolidated the shared OpenAI Chat Completions representation, preserved reasoning blocks, and improved provider injection; closed as superseded by [`endojs/endo-but-for-bots#290`](https://github.com/endojs/endo-but-for-bots/pull/290).

There were no open PRs authored directly by `0xpatrickdev`.

## Patrick-authored commits carried by `0xpatrickbot` PRs

### LAL, FAE, Genie, and agent tools

- **Merged:** [`endojs/endo-but-for-bots#221`](https://github.com/endojs/endo-but-for-bots/pull/221) — removed obsolete LAL notification-queue references.
- **Merged:** [`endojs/endo-but-for-bots#292`](https://github.com/endojs/endo-but-for-bots/pull/292) — preserved OpenAI-compatible tool-call history and provider-specific types.
- **Merged:** [`endojs/endo-but-for-bots#293`](https://github.com/endojs/endo-but-for-bots/pull/293) — added dependency-injected, deterministic provider replay and reusable mock powers.
- **Merged:** [`endojs/endo-but-for-bots#294`](https://github.com/endojs/endo-but-for-bots/pull/294) — added deterministic FAE replay, provider fixtures, and end-to-end smoke coverage.
- **Open:** [`endojs/endo-but-for-bots#298`](https://github.com/endojs/endo-but-for-bots/pull/298) — splits the FAE system prompt, hardens message/tool handling, and adds a prompt-optimizer baseline and scoring helpers.
- **Merged:** [`endojs/endo-but-for-bots#422`](https://github.com/endojs/endo-but-for-bots/pull/422) — migrated Genie’s Pi dependencies to the `@earendil-works` scope.
- **Merged:** [`endojs/endo-but-for-bots#518`](https://github.com/endojs/endo-but-for-bots/pull/518) — derived agent-tool Git parameter names from capability method names.
- **Closed unmerged:** [`endojs/endo-but-for-bots#531`](https://github.com/endojs/endo-but-for-bots/pull/531) — contributed typing to the gap-revealing OCap SWE-loop clone-to-push probe.

### Daemon, mounts, Git capabilities, and storage

- **Merged:** [`endojs/endo-but-for-bots#327`](https://github.com/endojs/endo-but-for-bots/pull/327) — authored the daemon-mount and Git-capability design plans.
- **Merged:** [`endojs/endo-but-for-bots#339`](https://github.com/endojs/endo-but-for-bots/pull/339) — delivered the EndoMount specialization as a Directory, including host-only path access, snapshots, materialization, conformance tests, and documentation.
- **Merged:** [`endojs/endo-but-for-bots#364`](https://github.com/endojs/endo-but-for-bots/pull/364) — added the Git capability over EndoMount.
- **Merged:** [`endojs/endo-but-for-bots#365`](https://github.com/endojs/endo-but-for-bots/pull/365) — implemented GitCredential, GitRemote, transport plumbing, policy enforcement, audit behavior, and broad authority-boundary tests.
- **Merged:** [`endojs/endo-but-for-bots#366`](https://github.com/endojs/endo-but-for-bots/pull/366) — reconciled the mount-capability design with the shipped implementation.
- **Merged:** [`endojs/endo-but-for-bots#368`](https://github.com/endojs/endo-but-for-bots/pull/368) — added file-descriptor-based `askpass` credential transport and subsequent correctness fixes.
- **Open:** [`endojs/endo-but-for-bots#369`](https://github.com/endojs/endo-but-for-bots/pull/369) — explores a Git-backed, reachability-retained CAS substrate for the Rust Endor content store.
- **Merged:** [`endojs/endo-but-for-bots#370`](https://github.com/endojs/endo-but-for-bots/pull/370) — folded review findings into the daemon-Git design and recorded its follow-up roadmap.
- **Merged:** [`endojs/endo-but-for-bots#371`](https://github.com/endojs/endo-but-for-bots/pull/371) — hardened the Git capability’s read-only authority, executable configuration, status typing, text-conversion behavior, and audit correctness.

This is Patrick’s most foundational implementation cluster. It established much of the repository’s mount/Git capability spine, then continued into credential transport, remote policy, secrecy, and data-safety work.

### SES and Compartments

- **Open:** [`endojs/endo-but-for-bots#297`](https://github.com/endojs/endo-but-for-bots/pull/297) — fixes `module-source` namespace re-exports and SES re-export cycles so Pi can run inside a confined Endo Compartment.

### Endor and registry design

- **Open:** [`endojs/endo-but-for-bots#331`](https://github.com/endojs/endo-but-for-bots/pull/331) — designs an npm-registry capability companion to the registry proxy.

### OCapN

- **Closed unmerged:** [`endojs/endo-but-for-bots#341`](https://github.com/endojs/endo-but-for-bots/pull/341) — temporarily skipped the TCP Syrup netlayer pending the `makeClient` port.

### CI and repository hygiene

- **Merged:** [`endojs/endo-but-for-bots#291`](https://github.com/endojs/endo-but-for-bots/pull/291) — removed tracked test scratch directories and ignored future package-local `tmp` output.
- **Merged:** [`endojs/endo-but-for-bots#354`](https://github.com/endojs/endo-but-for-bots/pull/354) — hardened GitHub Actions workflows in response to Zizmor findings.

## Merge-only attribution and direct push

Three bot-authored PRs contain no Patrick-authored branch commits, but their GitHub-generated merge commits name Patrick as author:

- [`endojs/endo-but-for-bots#386`](https://github.com/endojs/endo-but-for-bots/pull/386) — replaced the hanging `esvu` benchmark setup with direct XS/V8 downloads.
- [`endojs/endo-but-for-bots#433`](https://github.com/endojs/endo-but-for-bots/pull/433) — corrected `trace_reply` detection in the Genie integration harness.
- [`endojs/endo-but-for-bots#639`](https://github.com/endojs/endo-but-for-bots/pull/639) — audited agent command guidance.

These indicate merge activity, not authorship of the underlying implementation.

One Patrick-authored commit was not associated by GitHub with a pull request:

- [`04083b872d`](https://github.com/endojs/endo-but-for-bots/commit/04083b872d77c7f411d91152d241b910f3c8f001) — a post-merge benchmark follow-up, committed by Kris Kowal, that made XS/V8 downloads relocatable and addressed shell-review feedback.

## Code-review activity and inferred areas of authority

Patrick formally reviewed 109 PRs: 103 are now merged, 4 remain open, and 2 closed without merge. Of these, 100 were authored by `0xpatrickbot` and 9 by `kriscendobot`. Fourteen bot PRs reviewed by Patrick also carried his own commits, so account separation should not be mistaken for wholly independent review.

The review record suggests broad maintainer or technical-lead authority:

- **Daemon, Git, filesystem, and capability security:** 53 reviewed titles match this cluster. Reviews repeatedly examine read/write attenuation, credential flow, executable lookup, remote policy, mount boundaries, audit secrecy, and failure recovery.
- **Agent runtimes and LLM tooling:** 46 reviewed titles concern LAL, FAE, Genie, Agent Tools, Agentry, Chat, or Pi. Patrick shaped tool boundaries, harness layering, deterministic replay, eval design, code-mode APIs, and provider compatibility.
- **Types and public API quality:** recurring feedback insists on explicit public types, generics instead of `any`/`unknown`, `types.ts` ownership, guard/type agreement, declaration tests, and preserving inference.
- **Commit and review hygiene:** many approvals were conditional on fixups, autosquash, retconning, coherent commit scope, concise PR bodies, and preserving reviewable history.
- **Tests and operational realism:** reviews ask for boundary-level integration coverage, clean-state TypeScript checks, lower evidence-based timeouts, Linux/Windows consideration, and tests that validate observable behavior instead of implementation scaffolding.
- **Design stewardship:** Patrick frequently distinguishes goals and constraints from premature mechanism, reconciles design documents with landed behavior, and directs follow-up work when a PR exposes a broader architectural gap.

## Formal review inventory

The state shown is current as of 2026-08-12. The title supplies the one-line scope summary.

- **Merged** [`#290`](https://github.com/endojs/endo-but-for-bots/pull/290) — refactor LAL onto the Pi-based harness and memory internals.
- **Merged** [`#291`](https://github.com/endojs/endo-but-for-bots/pull/291) — remove and ignore package-local scratch directories.
- **Merged** [`#292`](https://github.com/endojs/endo-but-for-bots/pull/292) — preserve LAL tool-call history and provider types.
- **Merged** [`#293`](https://github.com/endojs/endo-but-for-bots/pull/293) — add deterministic provider replay.
- **Merged** [`#294`](https://github.com/endojs/endo-but-for-bots/pull/294) — add deterministic FAE replay and smoke coverage.
- **Merged** [`#327`](https://github.com/endojs/endo-but-for-bots/pull/327) — design daemon mount and Git capabilities.
- **Merged** [`#339`](https://github.com/endojs/endo-but-for-bots/pull/339) — complete and specialize EndoMount.
- **Open** [`#357`](https://github.com/endojs/endo-but-for-bots/pull/357) — extend Prettier formatting to Markdown.
- **Merged** [`#363`](https://github.com/endojs/endo-but-for-bots/pull/363) — correct repository-wide SECURITY document spelling.
- **Merged** [`#364`](https://github.com/endojs/endo-but-for-bots/pull/364) — add Git capability over EndoMount.
- **Merged** [`#365`](https://github.com/endojs/endo-but-for-bots/pull/365) — compose GitRemote, transport, and credentials.
- **Merged** [`#366`](https://github.com/endojs/endo-but-for-bots/pull/366) — align mount-capability design with implementation.
- **Merged** [`#367`](https://github.com/endojs/endo-but-for-bots/pull/367) — archive immutable Git trees.
- **Merged** [`#368`](https://github.com/endojs/endo-but-for-bots/pull/368) — transport Git credentials through descriptor-based `askpass`.
- **Merged** [`#370`](https://github.com/endojs/endo-but-for-bots/pull/370) — reconcile daemon-Git design follow-ups.
- **Merged** [`#371`](https://github.com/endojs/endo-but-for-bots/pull/371) — harden Git capability correctness and authority boundaries.
- **Merged** [`#375`](https://github.com/endojs/endo-but-for-bots/pull/375) — improve EndoMount data safety and XS powers.
- **Merged** [`#386`](https://github.com/endojs/endo-but-for-bots/pull/386) — install benchmark engines without `esvu`.
- **Open** [`#394`](https://github.com/endojs/endo-but-for-bots/pull/394) — implement Git smart-HTTP with formula bearer authorization.
- **Merged** [`#408`](https://github.com/endojs/endo-but-for-bots/pull/408) — add confined Git/filesystem tools and schema/guard checks.
- **Merged** [`#414`](https://github.com/endojs/endo-but-for-bots/pull/414) — repair CI after the upstream merge.
- **Merged** [`#416`](https://github.com/endojs/endo-but-for-bots/pull/416) — design Agent Tools and the Agentry agent builder.
- **Merged** [`#422`](https://github.com/endojs/endo-but-for-bots/pull/422) — migrate Genie’s Pi dependencies.
- **Merged** [`#423`](https://github.com/endojs/endo-but-for-bots/pull/423) — integration-test Git tools against a live Exo capability.
- **Closed unmerged** [`#424`](https://github.com/endojs/endo-but-for-bots/pull/424) — resolve capability petnames at tool invocation.
- **Merged** [`#433`](https://github.com/endojs/endo-but-for-bots/pull/433) — fix Genie reply-trace detection.
- **Merged** [`#436`](https://github.com/endojs/endo-but-for-bots/pull/436) — lock the LAL/Familiar/Chat contract.
- **Merged** [`#515`](https://github.com/endojs/endo-but-for-bots/pull/515) — split LAL’s agent implementation by extension axis.
- **Merged** [`#517`](https://github.com/endojs/endo-but-for-bots/pull/517) — add Agentry’s execute-only code-mode runtime and Git loop.
- **Merged** [`#518`](https://github.com/endojs/endo-but-for-bots/pull/518) — derive Git tool parameter names from capability methods.
- **Merged** [`#523`](https://github.com/endojs/endo-but-for-bots/pull/523) — reconcile mount-read tools with the canonical tool record.
- **Merged** [`#524`](https://github.com/endojs/endo-but-for-bots/pull/524) — inject generated TypeScript declarations into code mode.
- **Merged** [`#525`](https://github.com/endojs/endo-but-for-bots/pull/525) — score Git code-mode evaluations.
- **Merged** [`#526`](https://github.com/endojs/endo-but-for-bots/pull/526) — add a conflict/rebase evaluation scenario.
- **Merged** [`#527`](https://github.com/endojs/endo-but-for-bots/pull/527) — make `rebase --continue` noninteractive.
- **Merged** [`#532`](https://github.com/endojs/endo-but-for-bots/pull/532) — test independent fetch from a pushed GitRemote branch.
- **Merged** [`#537`](https://github.com/endojs/endo-but-for-bots/pull/537) — test file-transport and SWE-loop Git integration.
- **Merged** [`#538`](https://github.com/endojs/endo-but-for-bots/pull/538) — add the Exo Git remote-clone seam.
- **Merged** [`#566`](https://github.com/endojs/endo-but-for-bots/pull/566) — add confined HTTP and Exo HTTP-client capabilities.
- **Merged** [`#567`](https://github.com/endojs/endo-but-for-bots/pull/567) — align daemon locator-hint terminology.
- **Merged** [`#611`](https://github.com/endojs/endo-but-for-bots/pull/611) — reconcile the daemon-agent-tools design with landed capabilities.
- **Merged** [`#614`](https://github.com/endojs/endo-but-for-bots/pull/614) — add filesystem list/stat/edit tools.
- **Merged** [`#615`](https://github.com/endojs/endo-but-for-bots/pull/615) — add the daemon Shell capability and shell tool.
- **Merged** [`#616`](https://github.com/endojs/endo-but-for-bots/pull/616) — add mount-bridged Git status/add tools.
- **Merged** [`#620`](https://github.com/endojs/endo-but-for-bots/pull/620) — align agent-guide conventions.
- **Merged** [`#623`](https://github.com/endojs/endo-but-for-bots/pull/623) — move Git and filesystem declarations into checked sources.
- **Merged** [`#624`](https://github.com/endojs/endo-but-for-bots/pull/624) — record Agentry evaluation metrics.
- **Open** [`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) — add a stack-surgery evaluation fixture and scorer.
- **Merged** [`#628`](https://github.com/endojs/endo-but-for-bots/pull/628) — settle WebSocket-relay unknown-peer teardown.
- **Merged** [`#633`](https://github.com/endojs/endo-but-for-bots/pull/633) — move public Git capability types into Exo Git.
- **Merged** [`#635`](https://github.com/endojs/endo-but-for-bots/pull/635) — specify missing Agentry Git verbs.
- **Merged** [`#636`](https://github.com/endojs/endo-but-for-bots/pull/636) — define the Agentry Git evaluation scenarios.
- **Merged** [`#639`](https://github.com/endojs/endo-but-for-bots/pull/639) — audit agent command guidance.
- **Merged** [`#641`](https://github.com/endojs/endo-but-for-bots/pull/641) — prefer named imports in agent guidance.
- **Merged** [`#642`](https://github.com/endojs/endo-but-for-bots/pull/642) — harden environment-sensitive native-Git tests.
- **Merged** [`#643`](https://github.com/endojs/endo-but-for-bots/pull/643) — consolidate mount and Git contracts.
- **Merged** [`#644`](https://github.com/endojs/endo-but-for-bots/pull/644) — add commit amend and reword.
- **Merged** [`#645`](https://github.com/endojs/endo-but-for-bots/pull/645) — add Git stack-replay verbs.
- **Merged** [`#646`](https://github.com/endojs/endo-but-for-bots/pull/646) — add facet catalogs, conflict checkout, and rebase recovery.
- **Merged** [`#687`](https://github.com/endojs/endo-but-for-bots/pull/687) — propagate abort signals through the Pi tool bridge.
- **Merged** [`#706`](https://github.com/endojs/endo-but-for-bots/pull/706) — establish formula-owned Git commit identity.
- **Merged** [`#720`](https://github.com/endojs/endo-but-for-bots/pull/720) — preserve literal inference in compound patterns.
- **Merged** [`#727`](https://github.com/endojs/endo-but-for-bots/pull/727) — complete the compound-pattern inference fix.
- **Merged** [`#728`](https://github.com/endojs/endo-but-for-bots/pull/728) — make live-evaluation artifacts transcript-grade.
- **Merged** [`#729`](https://github.com/endojs/endo-but-for-bots/pull/729) — repin `setup-node`.
- **Merged** [`#733`](https://github.com/endojs/endo-but-for-bots/pull/733) — document the scope of JSON tool-call parking.
- **Merged** [`#734`](https://github.com/endojs/endo-but-for-bots/pull/734) — type Git credentials and ref updates.
- **Merged** [`#744`](https://github.com/endojs/endo-but-for-bots/pull/744) — contain Exo Stream reader-pump rejections.
- **Merged** [`#745`](https://github.com/endojs/endo-but-for-bots/pull/745) — contain detached Agentry eventual-send failures.
- **Merged** [`#746`](https://github.com/endojs/endo-but-for-bots/pull/746) — avoid Chat token-inventory races.
- **Merged** [`#750`](https://github.com/endojs/endo-but-for-bots/pull/750) — relocate and rename the code-mode substrate.
- **Merged** [`#751`](https://github.com/endojs/endo-but-for-bots/pull/751) — conditionally expose named result storage.
- **Merged** [`#766`](https://github.com/endojs/endo-but-for-bots/pull/766) — separate public readable blobs from CAS backing.
- **Merged** [`#767`](https://github.com/endojs/endo-but-for-bots/pull/767) — repair X402 hardening and dependency wiring.
- **Closed unmerged** [`#776`](https://github.com/endojs/endo-but-for-bots/pull/776) — design bounded reads around `ReadableBlob`.
- **Merged** [`#781`](https://github.com/endojs/endo-but-for-bots/pull/781) — check platform filesystem type sources.
- **Merged** [`#784`](https://github.com/endojs/endo-but-for-bots/pull/784) — supersede the bounded-read design with its landed form.
- **Merged** [`#810`](https://github.com/endojs/endo-but-for-bots/pull/810) — repin stale Actions hashes.
- **Merged** [`#833`](https://github.com/endojs/endo-but-for-bots/pull/833) — gate pull requests with the TypeScript composite build.
- **Merged** [`#834`](https://github.com/endojs/endo-but-for-bots/pull/834) — port the ESLint plugin to ESLint 10 flat configuration.
- **Merged** [`#835`](https://github.com/endojs/endo-but-for-bots/pull/835) — distinguish Exo Git authority postures.
- **Merged** [`#839`](https://github.com/endojs/endo-but-for-bots/pull/839) — check the root TypeScript program before declarations.
- **Merged** [`#840`](https://github.com/endojs/endo-but-for-bots/pull/840) — run opt-in `tsd` contracts in CI.
- **Merged** [`#844`](https://github.com/endojs/endo-but-for-bots/pull/844) — migrate type contracts to `expect-type`.
- **Merged** [`#845`](https://github.com/endojs/endo-but-for-bots/pull/845) — make decoded marshal roots safe by default.
- **Merged** [`#846`](https://github.com/endojs/endo-but-for-bots/pull/846) — repair collection and bare-return pattern inference.
- **Merged** [`#900`](https://github.com/endojs/endo-but-for-bots/pull/900) — check published declaration entry points.
- **Merged** [`#901`](https://github.com/endojs/endo-but-for-bots/pull/901) — retire `tsd`.
- **Merged** [`#902`](https://github.com/endojs/endo-but-for-bots/pull/902) — add typed Agent Tools code-mode globals.
- **Merged** [`#904`](https://github.com/endojs/endo-but-for-bots/pull/904) — convert bare-`tsc` fixtures to `expect-type`.
- **Merged** [`#905`](https://github.com/endojs/endo-but-for-bots/pull/905) — retain Agentry code-mode sessions.
- **Merged** [`#906`](https://github.com/endojs/endo-but-for-bots/pull/906) — convert Git into reader/writer/rewriter Exo facets.
- **Merged** [`#907`](https://github.com/endojs/endo-but-for-bots/pull/907) — add daemon-backed Pi code mode.
- **Merged** [`#920`](https://github.com/endojs/endo-but-for-bots/pull/920) — reject writable Git over read-only mounts.
- **Merged** [`#922`](https://github.com/endojs/endo-but-for-bots/pull/922) — check workspace TypeScript programs.
- **Merged** [`#924`](https://github.com/endojs/endo-but-for-bots/pull/924) — add checked workspace declarations and seams.
- **Merged** [`#925`](https://github.com/endojs/endo-but-for-bots/pull/925) — move reusable Agent Tools/Agentry types into TypeScript.
- **Merged** [`#926`](https://github.com/endojs/endo-but-for-bots/pull/926) — reconcile extended-filesystem types with Exos.
- **Merged** [`#928`](https://github.com/endojs/endo-but-for-bots/pull/928) — publish declarations under trackable names.
- **Merged** [`#929`](https://github.com/endojs/endo-but-for-bots/pull/929) — normalize Git remote policy and default pull refs.
- **Merged** [`#930`](https://github.com/endojs/endo-but-for-bots/pull/930) — run independent validations concurrently.
- **Merged** [`#932`](https://github.com/endojs/endo-but-for-bots/pull/932) — assert Agentry and Agent Tools export surfaces.
- **Merged** [`#941`](https://github.com/endojs/endo-but-for-bots/pull/941) — enforce typed filesystem guard records.
- **Merged** [`#947`](https://github.com/endojs/endo-but-for-bots/pull/947) — add graceful CapTP shutdown.
- **Merged** [`#955`](https://github.com/endojs/endo-but-for-bots/pull/955) — route CapTP rejection presentation by context.
- **Merged** [`#956`](https://github.com/endojs/endo-but-for-bots/pull/956) — upgrade Agentry’s Pi dependency.
- **Merged** [`#957`](https://github.com/endojs/endo-but-for-bots/pull/957) — optionally retain Pi tools in code mode.
- **Merged** [`#959`](https://github.com/endojs/endo-but-for-bots/pull/959) — stream large Git status output.
- **Open** [`#962`](https://github.com/endojs/endo-but-for-bots/pull/962) — add status copy-data and tracking behavior.

## Additional PR discussions without a formal review

Excluding Patrick’s own PR and PRs carrying his commits, substantive comments also appeared on:

- **Merged:** [`#382`](https://github.com/endojs/endo-but-for-bots/pull/382) — advised on package layering among Endo Git, Exo Git, and daemon integration.
- **Open:** [`#752`](https://github.com/endojs/endo-but-for-bots/pull/752) — directed a rebase of the Agentry code-mode setup work.
- **Open:** [`#771`](https://github.com/endojs/endo-but-for-bots/pull/771) — questioned the motivation for an npm migration experiment.
- **Open:** [`#807`](https://github.com/endojs/endo-but-for-bots/pull/807) — reconciled historical-read vocabulary with the existing filesystem design.
- **Open:** [`#808`](https://github.com/endojs/endo-but-for-bots/pull/808) — explained how Floot cleanup improved recovery from stale test state.
- **Closed unmerged:** [`#895`](https://github.com/endojs/endo-but-for-bots/pull/895) — identified the proposed timeout-declaration fix as already landed.

## Issues

Patrick opened no issues in this repository.

He substantively commented on one:

- **Open:** [`endojs/endo-but-for-bots#851`](https://github.com/endojs/endo-but-for-bots/issues/851) — connected stale TypeScript-build-state failures to the clean workspace checks in PR `#922`, explained how `ERef`/`FarRef` restore eventual-send inference, summarized the OCapN/Thixotrope typing work in PR `#952`, and identified per-import schema typing as the remaining gap. A second comment clarified the intended recipient.

## Coverage and limitations

GitHub reported `incomplete_results: false` for the commit and issue searches, but the commit index demonstrably omits commits reachable only from open or closed-unmerged PR branches. I therefore supplemented the 72 indexed commits by inspecting both directly authored PRs and all 140 PRs authored by `0xpatrickbot`.

That recovered 41 additional human-authored commits. It cannot rule out older, force-pushed-away commits or Patrick commits on an unmerged PR authored by some third account: GitHub exposes no complete repository-wide search for such unreachable objects. The 113-commit total is therefore “all presently observable through indexed history and the inspected Patrick/bot PR branches,” not a claim about garbage-collected or force-pushed history.

No code or pull request was changed; this is a journal-only audit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/patrick-cooney-endo-but-for-bots-contributions-report.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 545s

<!-- garden-usage-end -->
