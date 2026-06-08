---
title: "endoclaw-oauth — §the-agent-never-sees-the-token (canonical ocap pattern) + §authority-to-use-not-authority-to-delegate + §path-restrictions-structural-confinement + §read-only-mode + §tenth-member-of-endoclaw-cluster + §built-on-endoclaw-network-fetch"
source-slug: endo-but-for-bots--llm-designs-endoclaw-oauth
section-id: the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-oauth.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-oauth.md
total-lines: 99
status: Not Started (Parent: endoclaw)
ingest-cycle: 234
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-oauth — OAuth/Credential Capability that the agent never sees

A 99-line **Not Started** design (created and updated 2026-03-03; Parent: endoclaw). The §tenth-member of the endoclaw cluster (extending the §nine-design-cluster from cycle 232 to ten). An `OAuth` capability lets an agent make authenticated HTTP requests without ever seeing the credential.

## §The-tenth-member-of-the-endoclaw-cluster

| Cycle | Design | Role |
|-------|--------|------|
| 196 | endoclaw | Parent |
| 222 | endoclaw-skill-registry | Discovery |
| 226 | endoclaw-network-fetch | Network capability |
| 226 | endoclaw-notifications | Notification capability |
| 226 | endoclaw-proactive-messages | Pattern (composition recipe) |
| 226 | endoclaw-webhooks | Webhook capability |
| 226 | endoclaw-voice | UI feature |
| 226 | endoclaw-browser | Browser capability |
| 232 | endoclaw-channel-bridges | Channel-bridge guest |
| 234 | endoclaw-oauth | Credential capability |

§Ten-design-cluster for §the-endoclaw-feature now. §The-cluster-grows-by-one-with-cycle-234 as a §later-member-of-the-established-cluster-template (cycle 232's shape).

## §The-load-bearing-architectural-property: §the-agent-never-sees-the-token

> The `OAuth` interface has no method that returns the credential. The agent can *use* the service but cannot extract the token to forward it elsewhere or use it on a different endpoint. This is the canonical ocap pattern: authority to use, not authority to delegate outside the capability graph.

§Borrowable-pattern: §authority-to-use-not-authority-to-delegate-outside-the-capability-graph. §The-canonical-ocap-pattern-named-explicitly. §The-agent-never-sees-the-token is §a-structural-invariant-of-the-interface-not-a-runtime-check.

§Borrowable-pattern: §when-a-capability-must-not-leak-its-underlying-credential, §design-the-interface-so-no-method-returns-the-credential + §the-credential-only-flows-through-the-call-not-through-a-getter.

§Sibling to cycle 226 endoclaw-cluster's §structural-confinement-checked-inside-exo-at-only-call-site + cycle 224 daemon-web-gateway's §bearer-token-as-formula-ID. §Different-from-cycle-224: cycle-224 makes the formula-ID-IS-the-token (the agent has the identifier); cycle-234 hides the token entirely (the agent never sees it). §Two-different-capability-shapes for §two-different-trust-relationships.

## §Two-facet-control-pair (consistent with cycle 226 template)

```ts
interface OAuth {
  fetch(path: string, options?: FetchOptions): Promise<Response>;
  baseUrl(): string;
  scopes(): string[];
  help(): string;
}

interface OAuthControl {
  setScopes(scopes: string[]): void;
  setAllowedPaths(patterns: string[]): void;
  setReadOnly(flag: boolean): void;  // restricts to GET/HEAD
  refresh(): Promise<void>;  // force token refresh
  revoke(): void;
  help(): string;
}
```

§Consistent-with-cycle-226's-canonical-two-facet-control-pair. §Four-named-control-methods (setScopes + setAllowedPaths + setReadOnly + refresh) + §revoke + §help.

§Borrowable-pattern: §the-control-facet-has-more-methods-than-the-capability-facet because the host needs more knobs than the user; §the-capability-facet-is-minimal (fetch + baseUrl + scopes + help).

## §Path-restrictions-structural-confinement

> `OAuthControl.setAllowedPaths(['/gmail/v1/users/me/messages*'])` limits the agent to specific API endpoints. An agent with Gmail read access cannot call the Calendar API on the same Google domain.

§Within-the-baseUrl, §the-path-allowlist-further-confines-which-endpoints-are-callable. §Borrowable-pattern: §two-layer-confinement (baseUrl scope + path allowlist within scope). §The-baseUrl-IS-the-coarse-scope; §the-path-allowlist-IS-the-fine-scope.

§Sibling to cycle 226 endoclaw-network-fetch's §origin-allowlist-is-structural — both designs §allowlist-checked-inside-the-exo. §Different-layer: cycle 226 allowlist is origins (cross-host); cycle 234 allowlist is paths within a single host.

§The-example-is-particularly-load-bearing: §an-agent-with-Gmail-read-access-cannot-call-the-Calendar-API-on-the-same-Google-domain. §Two-Google-APIs-on-the-same-domain-with-different-confinement-scopes. §The-domain-is-not-the-confinement-boundary; §the-path-is.

§Borrowable-pattern: §named-positive-example-with-distinct-API-on-same-domain illustrates the §subdomain-vs-path-distinction.

## §Read-only-mode

```ts
setReadOnly(flag: boolean): void;  // restricts to GET/HEAD
```

§A-boolean-mode-toggle that restricts the HTTP method allow-list to GET and HEAD. §Borrowable-pattern: §a-boolean-mode-flag-with-named-restriction-class — the §named-restriction-class is §HTTP-safe-methods (GET + HEAD).

§The-agent-can-read-emails-but-not-send-them, §read-calendar-events-but-not-create-them. §Borrowable-pattern: §when-the-host-grants-a-credential-for-read-use, §a-boolean-toggle-prevents-write-side-effects.

§Sibling to cycle 226 endoclaw-browser's §BrowserControl.setReadOnly(true) (disables fill/click/submit). §Two-cycles-with-the-setReadOnly-mode-toggle.

## §Six-step-OAuth-flow

```
1. Host initiates OAuth flow (browser redirect or device code grant) and stores the token in the daemon's formula store.
2. Host creates an OAuth / OAuthControl pair bound to the stored token and a base URL.
3. Host grants the OAuth facet to an agent via pet name.
4. Agent calls E(gmail).fetch('/gmail/v1/users/me/messages').
5. The OAuth exo prepends baseUrl + validates path + checks method + injects Authorization header + makes request.
6. Token refresh is handled transparently by the exo.
```

§Six-named-steps with §step-5-as-the-five-substep-internal-flow. §Borrowable-pattern: §the-exo-does-five-substeps-on-each-call (prepend + validate + check + inject + make); §the-user-sees-only-the-fetch-call.

§Token-refresh-handled-transparently-by-the-exo — §the-agent-doesn't-know-when-tokens-are-refreshed; §the-control-facet's-refresh-method-exists-for-explicit-force-refresh but the §default-path-is-transparent. §Borrowable-pattern: §lifecycle-events-handled-transparently-by-default + §explicit-control-via-control-facet-method.

## §Use-Cases section (five named OAuth targets)

```
- Gmail: read emails, draft responses, label messages
- Google Calendar: read events, create events
- Notion: read/write pages and databases
- Todoist: read/create tasks
- Any OAuth2-compatible API
```

§Five-named-use-cases with §per-use-case-named-operations (read/draft/label for Gmail; read/create for Calendar; etc.). §The-fifth-use-case is the §general-pattern (Any OAuth2-compatible API).

§Borrowable-pattern: §enumerate-concrete-use-cases-and-then-generalize. §The-specific-examples-tell-the-reader-what-the-design-supports; §the-general-case-tells-the-reader-the-shape.

## §Built-on-endoclaw-network-fetch (composable cluster)

```
- endoclaw-network-fetch — underlying HTTP capability for making requests
- OAuth2 client library for token management (or minimal implementation)
- Daemon formula store for durable token persistence
```

§Three-named-Depends-On items. §Cycle-234-is-composed-on-top-of-cycle-226-network-fetch — §the-OAuth-capability-wraps-the-HttpClient-capability with §token-injection + §path-restrictions + §read-only-mode.

§Borrowable-pattern: §a-higher-level-capability-is-a-wrapper-around-a-lower-level-capability. §Cycle 226's network-fetch is the substrate; §cycle 234's OAuth is the §authenticated-decorator on top.

§Sibling to cycle 226 endoclaw-proactive-messages' §composable-with-other-capabilities — cycle 226 is the §composition-pattern; cycle 234 is the §composition-instance.

§The-OR-between *OAuth2 client library for token management* and *minimal implementation* — §when-the-design-doesn't-prescribe-which-library, §the-OR-leaves-it-open. §Borrowable-pattern: §when-a-design-can-use-an-existing-library-or-implement-minimally, §the-Depends-On-says-OR.

## §Caretaker-revocation

> Revoking the capability invalidates the exo and optionally revokes the OAuth token with the provider.

§Two-named-revocation-actions: (1) §invalidate-the-exo (local); (2) §optionally-revoke-the-OAuth-token-with-the-provider (remote). §The-optionally-acknowledges-that §provider-side-revocation-might-fail-or-be-unavailable.

§Borrowable-pattern: §two-layered-revocation (local + remote) with §the-remote-step-as-optional-because-it-might-fail. §The-local-step-is-the-authoritative-revocation; §the-remote-step-is-best-effort-cleanup.

§Sibling to cycle 226 endoclaw-cluster's §every-capability-pair-has-revoke-and-help — cycle 234 §extends-revoke-with-an-optional-provider-side-step.

## §Library-scope: cluster grows to ten members

The endoclaw cluster grows from cycle 232's nine to cycle 234's ten:

§Ten-design-cluster for §the-endoclaw-feature now. §The-cluster-Idiom-established-in-cycle-226 + §each-later-member-inherits-the-template. §The-design-language-is-stable + §the-application-surfaces-multiply.

§Borrowable-pattern: §when-a-cluster-establishes-a-design-language, §later-members-add-application-surfaces-without-re-explaining-the-language. §The-cluster-grows-in-breadth-not-depth.

## Related material in the library

- **cycle 226 endoclaw-cluster** (six designs; cycle 226 ingest): §the-cluster-this-extends.
- **cycle 226 endoclaw-network-fetch**: §the-substrate-this-builds-on.
- **cycle 226 endoclaw-browser**: §sibling-with-setReadOnly-mode.
- **cycle 222 endoclaw-skill-registry**: §earlier-sibling.
- **cycle 232 endoclaw-channel-bridges**: §previous-later-member-of-the-cluster; both §later-member-of-an-established-cluster-template.
- **cycle 224 daemon-web-gateway**: §bearer-token-as-formula-ID sibling — §two-different-capability-shapes-for-credential-handling.
- **cycle 220 familiar-localhttp-protocol**: §two-layer-confinement sibling (baseUrl + path is like CSP + iframe-sandbox).
- **cycle 196 endoclaw** (parent): §the-design-this-is-a-component-of.

## §Library-reaches-740-sections at cycle 234 (designs-lane endoclaw-oauth).

## §Sixty-eighth consecutive designs-chat alternation cycles 166-234.

## §Twenty-seventh-honest-design-evolution-record family member

§A-new-shape (or §reinforcement-of-an-existing-shape): §later-member-of-an-established-cluster-template (cycle 232's shape) §at-the-tenth-instance. §Eleven-different-shapes-of-design-evolution-record in 2026-06 cluster still (cycle 234 reinforces the cycle 232 shape rather than introducing a new one).

§The-twelfth-shape-arrives-when-a-new-rhetorical-form-emerges. §Cycle-234 is §an-instance-of-the-eleventh-shape, §not-a-new-twelfth-shape. §The-design-evolution-record-grows-not-just-by-new-shapes-but-also-by-more-instances-of-existing-shapes.

## §Ten-design-cluster-membership table

§The-endoclaw-cluster-is-now-ten-strong:

| Cycle | Design | Status | Role |
|-------|--------|--------|------|
| 196 | endoclaw | shipped | Parent design |
| 222 | endoclaw-skill-registry | Not Started | Discovery |
| 226 | endoclaw-network-fetch | Not Started | Network capability (substrate for cycle 234) |
| 226 | endoclaw-notifications | Not Started | Notification capability |
| 226 | endoclaw-proactive-messages | Not Started | Pattern (composition recipe) |
| 226 | endoclaw-webhooks | Not Started | Webhook capability |
| 226 | endoclaw-voice | Not Started | UI feature |
| 226 | endoclaw-browser | Not Started | Browser capability (sibling with setReadOnly) |
| 232 | endoclaw-channel-bridges | Not Started | Channel-bridge guest (via Vercel chat SDK) |
| 234 | endoclaw-oauth | Not Started | Credential capability (built on network-fetch) |

§Ten-design-cluster for §the-endoclaw-feature. §The-cluster-shape-is-now-a-mini-substrate-on-its-own.
