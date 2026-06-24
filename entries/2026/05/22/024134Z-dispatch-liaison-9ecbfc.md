---
ts: 2026-05-22T02:41:34Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
refs:
  - entries/2026/05/22/000222Z-result-designer-600eb4.md
---

# Dispatch: designer authors a stacked design — Gateway packaging via CI + AWS deployment automation + AWS-attuned Gateway

Dispatch root: `dispatches/designer--9ecbfc/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Maintainer directive (verbatim)

> Please dispatch a designer to describe the next steps from implementing the Endo Gateway as pertaining to packaging for RPM, DEB &c, ideally using CI workflows. Then, stack a design on top of that describing automation for deploying Gateways to AWS. Consider also designing a Gateway attuned to AWS S3, EC2, Nitro Enclaves, Route53, and the appropriate analogue to sqlite for a hosted gateway service with a domain name.

## Anchor design (already landed earlier this engagement)

The parent design `designs/gateway-package.md` was authored by designer dispatch `600eb4` and landed as PR <https://github.com/endojs/endo-but-for-bots/pull/343> (DRAFT, base llm, head `6bbd0cbe`). That document is the overarching `@endo/gateway` package design covering 10 features the maintainer named (Chat hosting, virtual hosting, Git over HTTP, UDS bootstrap, Familiar-bundled fallback, CapTP relay, admin daemon, `/ocapn-cbor-np` WebSocket, HTTPS terminating proxy, OS packaging). Feature #10 (OS packaging) is named at the shape level only — that's the seam where this dispatch's first design picks up.

Read the parent design before drafting. It supersedes the prior `designs/endo-gateway.md` sibling-style and carries the phased rollout under which packaging lives in Phase 4.

## Task

Produce a **stacked sibling-design set**, each a self-contained markdown file under `project/designs/`. The designer decides the count (2 or 3) based on the *one-design-per-1-to-3-screens* rule in `garden/roles/designer/AGENT.md` § Operating norms; if any one design grows past 3 screens, split it.

### Design 1 (mandatory): Gateway packaging via CI

Slug suggestion: `gateway-packaging-ci.md`.

Covers the *"next steps from implementing the Endo Gateway as pertaining to packaging for RPM, DEB &c, ideally using CI workflows."*

Substance to lay out (the designer's editorial judgment trims; this is the maintainer's pointers, not a checklist):

- The packaging targets that follow from `gateway-package.md` § Feature 10: rpm, deb, Arch PKGBUILD, Dockerfile. Layered or independent? The parent design names them in sequence but doesn't pick a build topology — this design picks.
- **CI workflows.** The maintainer's framing is "ideally using CI workflows." That implies: matrixed builds per (distribution, architecture, Node.js LTS pin) triple, signed artifacts, and release-tag-triggered uploads. Cite the existing `.github/workflows/` patterns on `endojs/endo-but-for-bots` for the style; the matrix shape on the existing `ocapn-guile-interop.yml` and the Familiar build pipeline (`ci/familiar-ci-build-pipeline` per PR #318) are precedents.
- The systemd unit (or runit/openrc) the package installs, the user/group it runs as (per the parent design's open question on `endo:endo`), the data directories (`/var/lib/endo-gateway/`), and the configuration-file shape per packaging convention. This design *picks* answers where the parent left open questions, or marks the picks as "design decision N — alternatives considered: ..." with rationale.
- Signing model: GPG keys, the keyring that ships with the package, the role of `apt-cacher-ng`-style mirrors and Cloudfront/CDN-fronted yum repos. Where the signing keys live (the maintainer's GPG key? a Github-Actions-managed key per repo? the bot's identity?) is an open question the design surfaces rather than picks.
- Upgrade path: how the systemd unit hot-reloads vs. requires a restart; how the formula database (sqlite? — see Design 3) migrates between versions; how upgrade-time data backup interacts with the persistent state on disk.
- Release cadence: tied to `@endo/gateway`'s package version, the OS packages' versioning, and the Familiar-bundled variant's coordinate.
- Open questions: enumerated explicitly.

### Design 2 (mandatory): AWS deployment automation, stacked on Design 1

Slug suggestion: `gateway-aws-deployment.md`.

Covers the *"automation for deploying Gateways to AWS."* This design declares an explicit `Depends on: gateway-packaging-ci.md` row in its metadata and Dependencies table — the packaging artifacts from Design 1 are the inputs that Design 2 deploys.

Substance to lay out:

- The deployment topology: single-region vs. multi-region, single-AZ vs. multi-AZ, the front-end load-balancer choice (ALB? Network Load Balancer? CloudFront?), the role of the HTTPS terminating proxy from `gateway-package.md` § Feature 9.
- The provisioning tool. CloudFormation, CDK, Terraform — pick one (designer's call; CDK is the canonical AWS-vendor-supported path, Terraform is the portable path) and justify. Pulumi is the dark-horse third option; surface it in alternatives if relevant.
- The CI pipeline that ties Design 1's package artifacts → AMI build (Packer? cloud-init? a custom EBS snapshot generator?) → instance launch. The seam between "package build" and "deploy" lives between Design 1 and Design 2; this design names the artifact contract.
- Secrets management: the per-Gateway formula identifier (bearer token), the GPG signing key, the SSH bastion key — AWS Secrets Manager? KMS? Parameter Store? Pick one, justify.
- Auto-scaling, blue/green, canary: out of scope for the first cut or in scope? Surface as open questions if out of scope.
- Cost model: instance type (the parent design says nothing about resource sizing; Design 2 picks the first cut with a per-Gateway profile of compute / RAM / disk / network).
- The seam to Design 3 (the AWS-attuned Gateway variant): named explicitly but not duplicated.

### Design 3 (conditional — designer's call): AWS-attuned Gateway

Slug suggestion: `gateway-aws-attuned.md` (or `gateway-aws-services.md` — designer picks).

Covers the *"Gateway attuned to AWS S3, EC2, Nitro Enclaves, Route53, and the appropriate analogue to sqlite for a hosted gateway service with a domain name."*

This is the maintainer's "consider also" — softer than the first two. The designer's call whether it lands as a sibling design or folds into Design 2's *Out-of-scope* section as a "future variant." If it lands as a third design, it declares `Depends on: gateway-aws-deployment.md` in its metadata.

Substance the maintainer flagged:

- **S3** as the content-addressed store (replacing the sqlite/local-disk CAS the parent design's UDS-bootstrapped Gateway uses for multi-tenant isolation). S3 object naming via content-hash, lifecycle policies, intelligent tiering for cold formulas, public-read vs. signed-URL for weblet static content.
- **EC2** as the host fleet (the deployment topology in Design 2 names instance types; Design 3 names the *AWS-attuned* shape: AMI-baked Gateway, IAM role permissions, EC2 user-data bootstrap).
- **Nitro Enclaves** as the trusted execution boundary for the per-Gateway signing key and the bearer-token issuance. The parent design's open question #4 (rotation story for formula-identifier bearer tokens) plausibly answers itself if the key lives in a Nitro Enclave.
- **Route53** for the per-Host header → per-Weblet routing at the DNS layer, sibling to (or replacement for) the parent design's HTTP virtual hosting. The interaction is non-trivial: parent design routes by HTTP Host header to a Weblet formula; Route53 could route subdomains to Gateway instances (a different abstraction). The design picks the boundary.
- **The sqlite analogue.** "Appropriate analogue to sqlite for a hosted gateway service with a domain name" — likely DynamoDB (per-Gateway key-value, single-table design), Aurora Serverless (relational, autoscale-to-zero), or RDS Postgres (per-Gateway database). The designer picks one with rationale; surface alternatives. The parent design's multi-tenant CAS isolation question (open question #5) intersects this choice.

If Design 3 is folded into Design 2's *Out of scope*, name the AWS services in the Out-of-scope section as "AWS-attuned variant — see future Design 3" and stop there.

## Procedure

1. Read `garden/roles/COMMON.md`, then `garden/roles/designer/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md` (domain terms: RPM, DEB, PKGBUILD, systemd, AMI, CloudFormation, CDK, Terraform, Nitro Enclave, Route53, S3, KMS, IAM, ALB, etc. — index on the fly per writeback procedure).
3. Read `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`, `garden/skills/prompt-section-discovery/SKILL.md`.
4. Read `project/designs/CLAUDE.md` (the project's design-doc conventions).
5. Read `project/designs/gateway-package.md` (the anchor design). Note its phased rollout and open questions; the new designs answer some, defer others, leave still others as still-open.
6. Read `project/designs/README.md` (summary table, dependency graph, milestones — the new designs land here as new rows).
7. Read any existing AWS-related, packaging-related, or CI-related design docs already in `project/designs/` — there may be precedent for `.github/workflows/` patterns or for how the project describes packaging matrices. Skim `designs/ci-no-npm-lifecycle.md` and `designs/familiar-ci-build-pipeline.md` (per `endojs/endo-but-for-bots#318`) if they exist on llm.
8. **Draft Design 1** (`designs/gateway-packaging-ci.md`). Cite the maintainer directive verbatim under a `## Prompt` heading.
9. **Draft Design 2** (`designs/gateway-aws-deployment.md`). Cite the maintainer directive verbatim. Declare `Depends on: gateway-packaging-ci.md` in metadata.
10. **Decide on Design 3.** If it lands as a sibling, draft `designs/gateway-aws-attuned.md` with `Depends on: gateway-aws-deployment.md`. If it folds into Design 2, name the AWS services in Design 2's Out-of-scope section and stop.
11. **Sync `designs/README.md`:** new rows for each design, milestone assignments (probably M2 packaging, M3 cloud), dependency-graph edges to `gateway-package.md` and to one another, per-design size estimates, totals row update.
12. **Open as DRAFT PR** against `endojs/endo-but-for-bots@llm`. Branch: `design/gateway-packaging-aws-stack`. Title: `design(gateway): packaging + AWS deployment + AWS-attuned Gateway (stacked siblings of #343)`. Body cites the maintainer directive, names the parent design (`#343`), summarizes the stack, names which open questions from `gateway-package.md` each design newly resolves vs. defers.

## Per-action authorization

Standing on endojs/endo-but-for-bots: push to `design/gateway-packaging-aws-stack`, open draft PR against `llm`. No comment authority outside the new PR's body. READ-ONLY on endojs/endo.

## Out of scope

- No implementation. Designs only.
- No edits to existing `packages/daemon/` source.
- No upstream ferry.
- No un-draft.
- No edits to PR #343 (`gateway-package.md`) — that PR awaits maintainer review on its own cadence.

## Report

≤ 600 words. PR URL + head SHA. The three (or two) design file paths on llm. The dependency edges declared (each design's `Depends on`). Which open questions from `gateway-package.md` each new design newly resolves. The new open questions surfaced. The phased-rollout placement (which milestone). The Design 3 decision (sibling vs. folded into Design 2's Out-of-scope). One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-designer-9ecbfc.md` and push journal.
