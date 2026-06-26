# Design an MCP server with OAuth authN/authZ — great local DX + AWS-deployable (toy: minion.town)

Wear the **researcher** then **designer** role (research the current specs first, then design;
follow the garden's researcher-precedence). **Goal: a design for an MCP (Model Context Protocol)
server with OAuth-based authentication AND authorization, optimized for two things at once: (1)
an excellent local developer experience, and (2) clean deployability to Amazon AWS.** Validate it
with an **initial toy experiment** in **`kriscendobot/minion.town`** (a domain the maintainer has
reserved for such experiments — create the repo if it does not exist; bot identity, bot repo).

## Research first (ground the design in current specs)

- The **MCP authorization specification** (MCP adopted an OAuth 2.1-based authorization framework:
  authorization-server metadata discovery, dynamic client registration, **PKCE**, **resource
  indicators (RFC 8707)**, scopes; MCP server as an OAuth **resource server**). Use the LATEST MCP
  auth spec — it has evolved; do not design against a stale memory of it.
- OAuth 2.1 / OIDC best practices for a resource server + the authZ (scopes/claims → which MCP
  tools/resources a token may invoke).
- AWS deployment patterns for an MCP server, accounting for **MCP transport** (streamable-HTTP /
  SSE want persistent connections — that shapes the AWS target: API Gateway+Lambda with response
  streaming vs. ECS Fargate / App Runner for a long-lived server). Note Cognito as a candidate
  authorization server vs. an external IdP.

## Design for the two goals

1. **Local developer experience.** A frictionless local loop: a dev mode with a local/mock OAuth
   authorization server (or a one-command real one), minimal config, hot-reload, and clear docs so
   a developer can run the authenticated MCP locally with `npm run dev`-level simplicity and
   exercise the full OAuth flow without standing up cloud infra. This is a first-class design
   constraint, not an afterthought.
2. **AWS deployability.** A concrete, clean path to AWS: the chosen compute shape (justified
   against the MCP transport needs), the authorization server (Cognito or external), IaC
   (CDK/SAM/Terraform — pick and justify), TLS + the **minion.town** domain (Route53 + ACM), and
   how secrets/config differ between local and deployed. The SAME MCP code should run locally and
   on AWS with only config differences.

## Deliverable

- A **design document** (in `kriscendobot/minion.town`, e.g. `designs/mcp-oauth.md`): the
  architecture, the OAuth authN/authZ model (flows, scopes→tool-authorization mapping, token
  validation), the local-DX design, and the AWS deployment design — with open questions called out.
- A **toy experiment** in `kriscendobot/minion.town`: a minimal MCP exposing a toy tool or two,
  with the OAuth flow actually working, **runnable locally** and **deployable to AWS** (even if the
  AWS deploy is IaC + a documented `deploy` path rather than a live deployment). This validates the
  design end to end. Keep secrets/keys out of the repo.
- If the toy build is large, land the design + a minimal local-runnable prototype and **post
  follow-on jobs** for the AWS deploy scaffolding.

## Bounds

- Bot repo only (`kriscendobot/minion.town`); no agoric-sdk. Public standards/tools only. Do not
  commit real OAuth client secrets, AWS credentials, or keys — use placeholders + a `.env.example`.

## Definition of done

A design doc for an OAuth-authenticated/authorized MCP server (great local DX + AWS-deployable) and
a minimal working toy experiment in `kriscendobot/minion.town` (locally runnable, with an AWS
deploy path), grounded in the current MCP authorization spec. Report the repo/PR, the chosen AWS
shape + why, and the local-dev story. Flag any open questions for the maintainer.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 57
  claimed_at: 2026-06-26T00:55:04Z
