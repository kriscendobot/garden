---
id: x402-protocol
aliases: ["x402", "402 Payment Required", "HTTP 402", "pay over HTTP", "x402 Foundation", "x402 facilitator"]
topics: [agent-payments, networking, capability-security]
---

# x402-protocol

**x402** is an open protocol for paying over HTTP, named for the `402 Payment
Required` status code it puts to use. The exchange: a client requests a
payment-gated resource; the server answers `402 Payment Required` with a small
payload stating the price, the accepted asset, and where to pay; the client
pays and repeats the request with proof of payment attached; a **facilitator**
verifies the payment and the server returns the resource. It happens entirely
inside ordinary HTTP requests and responses (no checkout-page redirect, no
separate payment API), settlement is peer-to-peer (funds go straight to the
seller's wallet), and it is **rail-agnostic** but a natural fit for stablecoins
(sub-second, fraction-of-a-cent, zero-chargeback settlement). Two properties
make it fit machine payments: amounts can be tiny because overhead is near-zero,
and the buyer needs no account with the seller because the **payment itself is
the credential** (see [[payment-as-credential]]). Cloudflare is building x402
with a 25+-member coalition via the x402 Foundation and uses it as the
settlement rail for its [[monetization-gateway]].

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [monetization-gateway-x402/x402-protocol-and-flow](../sections/web--cloudflare-monetization-gateway-x402--x402-protocol-and-flow.md) | The four-step x402 exchange, facilitator verification, peer-to-peer settlement, and the two machine-payment-fit properties. |
| [monetization-gateway-x402/overview](../sections/web--cloudflare-monetization-gateway-x402--overview.md) | x402 as the launch settlement rail for the Monetization Gateway; payment evidence moves into the request itself. |

## See also

- [[payment-as-credential]] — the property that lets an unverified buyer pay with no prior seller account.
- [[monetization-gateway]] — the proxy-edge product that enforces x402 pricing rules.
- [[pay-per-request-monetization]] — the economic model x402 makes feasible below the sub-cent floor.
