<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-06-27T05:06:11Z -->

# Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town

Context: `kriscendobot/minion.town` ships a working OAuth-authenticated MCP
server (design: `designs/mcp-oauth.md`) whose AWS authorization server is Amazon
Cognito. Cognito has three gaps against the MCP authorization spec, all
bridgeable with a small API Gateway + Lambda beside Cognito (see
`infra/README.md` § follow-ons):

1. RFC 8414 AS metadata — Cognito only serves OIDC /.well-known/openid-configuration,
   not /.well-known/oauth-authorization-server. Serve a static RFC 8414 doc
   (authorize/token → Cognito hosted UI, code_challenge_methods_supported:
   ["S256"], advertise client_id_metadata_document_supported).
2. RFC 7591 Dynamic Client Registration — add a /register Lambda mapping
   RFC 7591 → Cognito CreateUserPoolClient. (Or, if clients are known, skip DCR
   per design Open Question #2 and ship only the metadata doc.)
3. RFC 8707 audience binding — Cognito doesn't honor the resource param; set the
   Resource Server identifier to the MCP URL / customize the token so the
   server's existing aud check passes.

Deliverable: the bridge as CDK constructs + Lambda source in `infra/`, with
`cdk synth` passing and a local unit test of the metadata/register handlers.
Bot repo only. No real AWS creds needed to author + synth-verify; live wiring is
covered by the deploy follow-on. Resolve design Open Questions #1 (Cognito+bridge
vs MCP-native IdP) and #2 (need DCR?) with the maintainer before building.
