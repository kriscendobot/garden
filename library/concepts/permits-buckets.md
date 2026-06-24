---
id: permits-buckets
aliases: ["permits buckets", "universalPropertyNames", "sharedGlobalPropertyNames", "initialGlobalPropertyNames", "universal vs shared vs initial", "SES permits buckets", "permits.js buckets", "start compartment vs shared compartment", "powered vs powerless intrinsics"]
topics: [hardened-javascript, compartments]
---

# permits-buckets

The three-bucket framework that SES's permits graph
(`packages/ses/src/permits.js`) uses to classify global intrinsics by
*where they live across compartments*. The placement of a host-
provided constructor is the load-bearing decision for any vetted-shim
design (URL, TextEncoder/TextDecoder, future text codecs).

| Bucket | What lives there | When the constructor is installed |
|---|---|---|
| `universalPropertyNames` | **Powerless** data and constructors — pure transformations with no static side channels, no ambient-authority methods | Start compartment + every post-lockdown compartment (identity-equal) |
| `initialGlobalPropertyNames` | The **powered** variants (`Date`, `Error`, `RegExp`, `Math`) | Start compartment only |
| `sharedGlobalPropertyNames` | The **tamed, powerless** variants of those same powered names | Every post-lockdown compartment (a different object from the initial variant) |

The discriminator between *universal* and *initial+shared* is
whether the constructor has a powered static method that must be
kept off the post-lockdown compartments (e.g.
`URL.createObjectURL` makes URL need the split; `TextEncoder` has
no such static, so it goes universal).

The discriminator between *initial* and *shared* (within the
initial+shared split) is whether the consumer needs the powered
version (start compartment) or the tamed version (post-lockdown).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [hurl/integration-shared-vs-start](../sections/endo-but-for-bots--llm-designs-hurl--integration-shared-vs-start.md) | The three buckets enumerated; URL placed in `initial` (powered `URL` with `createObjectURL`) + `sharedGlobalPropertyNames` (tamed `SharedURL` without it). |
| [htcs/problem-and-permits](../sections/endo-but-for-bots--llm-designs-htcs--problem-and-permits.md) | TextEncoder/TextDecoder placed on `universalPropertyNames` because pure transformations have no powered variant to tame down to. |
| [htcs/phases-tests-and-design-decisions](../sections/endo-but-for-bots--llm-designs-htcs--phases-tests-and-design-decisions.md) | The discriminating design decision — universal vs start-only — recorded as the first of three design decisions. |

## See also

- [[throwaway-instance-prototype-walk]] — the *other* taming complication that arises when an intrinsic exposes its own iterator prototype (URL needed it; TextEncoder did not).
- [[sentinel-with-rationale]] — sibling structural principle for choosing well-defined values.
