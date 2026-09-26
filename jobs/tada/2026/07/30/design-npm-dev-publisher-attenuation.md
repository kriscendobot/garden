• I'll start by reading the role brief, repo conventions, and the existing designs this job must reconcile with.

• Now let me read the designer role brief and find the existing designs this job references.

• Now I understand the two designs to reconcile with. Let me read the project's design conventions and check how recent designs were structured.

• Let me read the designs AGENTS.md conventions and the endo-gateway design that the credentials lane is expected to compose with.

• Conventions are fully mapped. Now I'll draft the design document — the core deliverable — while the fact-check agents run.

• Now revising chunk 2 with the fact-check results before appending it.

• Now chunk 3a — the promotion service, audit records, and operations sections.

• Verdaccio brief is in — middleware plugins can intercept publishes, but auth hooks never see versions or tags, and tokens carry no per-package attenuation. Writing the comparison and remaining sections.

• Document assembled at 1310 lines. Now a consistency pass — checking section references and chunk seams.

• Four section references point at non-existent headings. Fixing them.

• All references resolve. Now a full read-through of the assembled document for coherence.

• The document reads well. Applying the four fixes I noted during review.

• Design doc complete. Now validating the two mermaid diagrams per the mermaid-validation skill.

• Both diagrams parse. Now the README sync — let me first check how the most recent design (cap-std-watch) was incorporated, to match the footprint.

• All anchors located. Making the seven README edits now, in distinct regions.

• Diff is clean (+20/−2 README, new design file). Now the branch, commit, push, and draft PR.

• Remotes are as expected (`bot` = bot fork, `origin` = upstream with `llm`). Committing on the design branch.

• Draft PR #890 opened. Verifying its shape, draining my inbox, and cleaning up temp files.

• # Completion report — design-npm-dev-publisher-attenuation

  **Deliverable:** design `npm-dev-publisher-attenuation`, opened as draft PR **endojs/endo-but-for-bots#890** (https://github.com/endojs/endo-but-for-bots/pull/890) against the `llm` roadmap branch, from `kriscendobot:design/npm-dev-publisher-attenuation` (commit `534d847c5`, work tree `project-wt-design-npm-dev-publisher-attenuation-f4d57e5d`). Spec only — no implementation, credentials, DNS, deployment, or publication, per the job's boundary.

  **What the design specifies** (`designs/npm-dev-publisher-attenuation.md`, ~1.3k lines):
  - **Dev-release semantics:** "dev- tags" = npm dist-tags beginning with the literal prefix `dev-`; a development release co-requires a semver **prerelease** version (invisible to default ranges) **and** exactly one `dev-*` tag (keeps `latest` structurally unreachable).
  - **Exact mutation vocabulary:** route allowlist + validation pipeline P1–P8 making `latest`, production tags, unpublish (all three wire forms), deprecate, owner/token/login routes, metadata smuggling, and out-of-allowlist packages impossible at the proxy boundary; monotonic `dev-*` tags close tag-rollback.
  - **Capability model:** `PublishGrant`/`PublishGrantIssuer` (allowlist, mandatory expiry, limits, subject binding, attenuation-only delegation, cascading revocation) realized as 256-bit bearer tokens; system policy is non-negotiable, never per-grant.
  - **Deterministic promoter** (no agent/LLM in path): sole holder of a granular, org-scoped, Bypass-2FA, CIDR-pinnable upstream token (90-day npm-capped lifetime); durable event log + reconciled poll; independent revalidation from operator-owned per-subject policy (the compromised-proxy bound); crash-safe state machine with at-least-once delivery, 403-duplicate confirm flow, quarantine/manual review, rotation, layered emergency stop; hash-chained audit ledgers joining proxy event → upstream result; **tarball bytes never rebuilt between registries**.
  - Threat model + trust-boundary mermaid; npm/yarn/pnpm CLI compat; no-read-through behavior with scope routing; minion.town-consistent deployment/DNS/TLS for `npm.minion.town`; `@minion-town/*` fixtures; observability without secret leakage; backup/recovery; near-zero cost; S0–S3 rollout with an explicit 8-condition gate before any real upstream publication; **build-vs-Verdaccio decision: build the minimum proxy** (auth hooks never see versions/tags, tokens carry no per-package attenuation, and a plugin fails open where the minimum proxy fails closed); acceptance tests A–G including adversarial and failure-injection cases; 7 open questions.

  **Reconciliation:** positioned as the write-path sibling of `endor-npm-registry-proxy` and `registry-capability` (read path untouched; `@registry` stays read-only; the proxy composes as a plain registry URL). Technical claims fact-checked live against npm docs/CLI source and Verdaccio source (classic-token retirement, granular-token limits, manifest-confusion, publish/dist-tag wire shapes, 403-duplicate semantics).

  **Also changed:** `designs/README.md` synced per convention (summary row, M10 row, dependency-graph node/edges, per-design estimate, totals 150→151 / Proposed 32→33). All mermaid fences in both files parse-validated with `mermaid.parse()` (flowchart-v2, stateDiagram, gantt — all OK).

  **Verification evidence:** PR confirmed draft/base `llm`/exactly the two design files via `gh pr view 890 --json`; mermaid parse output `OK flowchart-v2`, `OK stateDiagram`, `OK gantt`.

  **Follow-ups (for the maintainer/review):** review and un-draft PR #890; the doc's open decisions (code home — standalone repo recommended; trusted-publishing/OIDC promoter variant; provenance posture; macaroons; subject binding strength; human publishers; grant expiry ceiling). No infrastructure, DNS, npm credentials, or publication was performed — the stage-2 gate lists the conditions under which any of that could begin.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-npm-dev-publisher-attenuation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 300727 tokens (10555648 cached reads)
- Output: 109052 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2322s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
