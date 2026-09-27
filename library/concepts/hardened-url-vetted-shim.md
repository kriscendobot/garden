---
id: hardened-url-vetted-shim
aliases: ["hardened URL shim", "hardened-url-shim", "URL vetted shim", "%InitialURL%", "%SharedURL%", "urlBlobTaming"]
topics: [hardened-javascript, capability-security]
status: draft
---

# hardened-url-vetted-shim

The SES treatment for host-provided `URL` and `URLSearchParams`: the start
compartment may retain the powered URL constructor, shared compartments receive
a blob-authority-free constructor over the same prototype, `URLSearchParams` is
universal, and its otherwise-hidden iterator prototype is explicitly sampled
into the permits graph and hardened. The design shipped upstream in
endojs/endo#3332 with `%InitialURL%` / `%SharedURL%` and the
`urlBlobTaming: 'retain' | 'remove'` lockdown option.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [problem and hazards](../sections/endo-but-for-bots--llm-designs-hurl--problem-and-hazards.md) | Names the hidden iterator-prototype and ambient blob-registry hazards that make naive `harden(URL)` unsafe. |
| [shared versus start integration](../sections/endo-but-for-bots--llm-designs-hurl--integration-shared-vs-start.md) | Specifies the Date-style powered/tamed constructor split and shared-prototype behavior. |
| [iterator-prototype sampling](../sections/endo-but-for-bots--llm-designs-hurl--iterator-prototype-sampling.md) | Shows how the anonymous iterator prototype enters the SES intrinsic and permits graphs. |
| [tests and decisions](../sections/endo-but-for-bots--llm-designs-hurl--comparison-tests-decisions.md) | Covers the SES-internal placement, absent-host behavior, compatibility, tests, and rejected external-shim shape. |

## See also

- [[throwaway-instance-prototype-walk]] — the general hidden-intrinsic sampling pattern used for `URLSearchParams` iterators.
- [[ambient-authority]] — why blob-registry statics stay out of shared compartments.
