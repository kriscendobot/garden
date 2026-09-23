---
id: payment-as-credential
aliases: ["payment is the credential", "no account required", "no prior relationship", "unverified buyer", "buyer needs no account"]
topics: [agent-payments, capability-security]
---

# payment-as-credential

In the x402 model the **payment itself is the credential**: a buyer needs no
account with, no API key from, and no prior relationship to the seller, because
proof of payment attached to the retried request is what authorizes access. This
inverts the classic API-monetization precondition (sign up, get issued a key,
incur metered billing against a known identity), which is exactly why prior
rails could not serve unverified buyers for sub-cent transactions. The property
is capability-flavored: authority to obtain the resource travels **with the
request** rather than being provisioned ahead of time against an account, so it
sits close to object-capability discipline where holding the token is the
authority (compare [[object-capability]] and the seller's freedom to decide "how
much you need to know about that buyer"). A seller may still layer identity on
top when it wants it (Cloudflare's Monetization Gateway pairs x402 with Web Bot
Auth and verified agent identity), but the base case grants access on payment
alone.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [monetization-gateway-x402/x402-protocol-and-flow](../sections/web--cloudflare-monetization-gateway-x402--x402-protocol-and-flow.md) | "The buyer needs no account with the seller, because the payment itself is the credential." |
| [monetization-gateway-x402/gateway-rules-and-capabilities](../sections/web--cloudflare-monetization-gateway-x402--gateway-rules-and-capabilities.md) | No signup, no API key, no prior relationship; the seller decides how much to know about the buyer and may add Web Bot Auth. |
| [monetization-gateway-x402/agent-identity-and-settlement-vision](../sections/web--cloudflare-monetization-gateway-x402--agent-identity-and-settlement-vision.md) | Some resources will require identity, some payment, some both, settled in one request. |

## See also

- [[x402-protocol]] — the HTTP exchange this property rides on.
- [[object-capability]] — authority-by-holding-the-token, the capability-security analog.
- [[monetization-gateway]] — the product that can require payment, identity, or both.
