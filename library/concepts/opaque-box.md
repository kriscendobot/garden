---
id: opaque-box
aliases: ["opaque box", "opaque-box", "hardware encapsulation", "tamper-responding box", "tamper-evident hardware", "secure enclave", "Intel SGX", "AMD SEV", "ARM TrustZone", "Apple Secure Enclave", "AWS Nitro Enclave", "Microsoft Pluton", "trusted execution environment", "TEE", "hardware-attested companion channel"]
topics: [capability-security, patterns]
---

# opaque-box

The §6.1.2 *Markets and Computation* (Miller-Drexler 1988) hardware-encapsulation pattern: **a box containing sensors and electronics able to recognize an attempt to violate the box's integrity, plus a processor, dynamic RAM, and a battery; the box's manufacturer-issued private key lives in the RAM; objects encrypted with the box's public key can migrate to the box and be decrypted internally; if the box detects an attempt to violate its physical integrity, it wipes the dynamic RAM (deleting the private key and all other sensitive data).** The box is **opaque** because no one can see its contents — and yet capability-shaped *services* can be offered from inside it. The 1988 paper proposed the opaque box as the substrate that makes *charge-per-use software markets* feasible: a piece of software can migrate to the box and be billed per use without ever being readable by either the customer or the box's manufacturer.

**The §6.1.2 1988 prediction has been almost completely realized in production hardware in the 38 years since**:

- **Intel SGX** (Software Guard Extensions, 2015) — encrypted enclaves with attestation.
- **AMD SEV** (Secure Encrypted Virtualization, 2016) — VM-level memory encryption.
- **ARM TrustZone** (2003) — TEE with secure-world isolation.
- **Apple Secure Enclave** (2013) — coprocessor with its own keypair, used for biometrics + payment.
- **AWS Nitro Enclaves** (2020) — production cloud TEEs.
- **Microsoft Pluton** (2020) — TPM-integrated secure-enclave.
- **TPM 2.0** (TCG, 2014) — the substrate for hardware-attested storage and operations.

The §6.1.2 paper's structural prediction — *hardware encapsulation + attestation + per-use billing as the substrate for software-distribution markets* — is the contemporary cloud-functions billing model (Lambda, Cloud Run, et al), partially realized. The §6.1.3 *inhibiting theft* corollary anticipated the contemporary microservices / serverless posture: a thief stealing one service-instance gets a service-instance, not the source.

The contemporary 2026 *Sleeper Channels* paper's §VII-F **hardware-attested companion channel `Σ`** is the opaque-box pattern applied to the AI-agent-control layer: a channel the model has no emit primitive into, used for attestation-based authorization of consequential actions. The Sleeper Channels D2 gate's I-Channel invariant is the opaque-box discipline at the agent-control layer.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems](../sections/papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems.md) | **Canonical exposition.** §6.1.2 introduces the opaque-box pattern with sensors + processor + RAM + battery + private-key + tamper-detection-wipes-RAM. §6.1.1 motivates with charge-per-use markets. §6.1.3 extends to inhibition of theft via composition. The 1988 prediction is now realized as Intel SGX et al. |
| [papers--maloyan-namiot-sleeper-channels-2026--provenance-gate-d2-and-soundness-theorem](../sections/papers--maloyan-namiot-sleeper-channels-2026--provenance-gate-d2-and-soundness-theorem.md) | The 2026 D2 gate's **I-Channel invariant**: attestations arrive only over the hardware-attested companion channel `Σ`; the model has no emit primitive into `Σ`. The opaque-box pattern applied to AI-agent control. |
| [papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option](../sections/papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md) | §4.2 cryptographic capabilities: vats generate public/private key pairs; the *VatID* is the vat's public-key fingerprint. The 2000 paper's vat-as-TCB framing is the conceptual ancestor of opaque-box-as-vat — a vat *implemented as an opaque box* gives strong cryptographic guarantees beyond software-only enforcement. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch.md) | §9.3 vat persistence: a vat keeps its key pair in persistent state across incarnations. An opaque-box-hosted vat keeps the keypair *encrypted at rest*, with decryption only inside the box. |

## See also

- [[per-agent-keypair]] — opaque-box-hosted agents use this primitive for cryptographic identity. The opaque box is the substrate that makes per-agent-keypair *unforgeable* even against the box's manufacturer.
- [[vat-and-compartment]] — the unit of isolation an opaque box hosts. A vat-in-an-opaque-box is structurally a vat with hardware-enforced encapsulation rather than language-enforced.
- [[agoric-system]] — the broader framework opaque boxes operate within. The §6.1 1988 paper motivates opaque boxes as the substrate that makes charge-per-use software markets feasible.
- [[smart-contract]] — smart contracts hosted inside an opaque box gain hardware-level confidentiality. The contemporary *confidential computing* movement extends this to multi-party computation.
- [[principle-of-least-authority]] — opaque boxes are POLA enforcement at the hardware layer: the box's manufacturer can no longer read the software running inside; only the explicit interfaces (encrypted-channel attestation + per-use billing) are exposed.
- [[subjective-aggregation]] — an opaque box is a natural granularity for subjective aggregation: a party can choose to trust *the box's TCB* (the manufacturer's attestation infrastructure) without trusting the software running inside.
- [[positive-vs-negative-reputation]] — opaque-box attestation can underwrite positive-reputation systems by providing unforgeable evidence of software identity at runtime.

## Common confusions

- **"Opaque box = TPM."** Closer to *opaque box ⊇ TPM*. TPMs are *one realization* of the opaque-box pattern at the storage-attestation layer. Full opaque boxes (Intel SGX, AWS Nitro Enclaves) include a *processor* that runs code inside, not just key storage; TPMs are typically just key storage + attestation. The §6.1.2 1988 framing requires both the processor and the storage.
- **"Opaque box = blockchain consensus."** No — opaque boxes are *physical* hardware artifacts; blockchain consensus is a *protocol* over many nodes. The two can compose (opaque-box-hosted validators provide hardware-attestable consensus) but they are different concepts. The §6.1.2 framing predates blockchains by 21 years.
- **"Opaque boxes solve software piracy."** §6.1.1 motivates opaque boxes with charge-per-use markets, which *do* address piracy (software can never escape the box uncoded). But the §6.1.3 paper notes a deeper goal: *making it the case that distributed software systems are composites of many proprietary packages, each having its security guarded by its creator* — the thief faces stealing a railroad rather than stealing a car. Anti-piracy is the *technique*; composition-encouraging incentive structure is the *goal*.
- **"The contemporary opaque-box realizations all work."** Each has had vulnerabilities. Intel SGX had Spectre-class side-channel attacks; AMD SEV had memory-encryption flaws; ARM TrustZone has had implementation bugs. The §6.1.2 1988 paper does not address side channels (the paper says it ignores covert and side channels by assumption). Real-world opaque boxes are *partial* enactments; the architectural prediction holds even if specific implementations have flaws.
- **"Opaque boxes are only for hardware."** No — the *concept* applies at any layer. The 2026 *Sleeper Channels* paper's hardware-attested companion channel `Σ` extends the opaque-box pattern to AI-agent control. Any *enclosure* whose external interface includes attestation + does-not-include-readout is structurally an opaque box. The pattern composes across the software-hardware boundary.
- **"This is a 1988 prediction we have to wait for."** No — the prediction has been substantially realized. Intel SGX (2015), Apple Secure Enclave (2013), AWS Nitro Enclaves (2020) are all production opaque boxes. The remaining work is *deploying* opaque-box-hosted services at scale (Confidential Computing Consortium, Project Oak, AWS Nitro Enclaves for ML workloads). The §6.1.2 thesis is no longer speculative.
