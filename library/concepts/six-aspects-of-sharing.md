---
id: six-aspects-of-sharing
aliases: ["Karp", "Stiegler", "Tyler Close", "Karp Stiegler Close", "six aspects of sharing", "seven aspects of sharing", "6/7 aspects", "dynamic chained cross-domain composable attenuated accountable revocable", "not one click for security", "Bob Alice Carol garage scenario"]
topics: [capability-security, persistence, ocapn]
---

# six-aspects-of-sharing

Karp, Stiegler, and Close's *Not One Click for Security* (HP Labs,
2009) identifies six aspects of sharing a capability system must
support: **dynamic**, **chained**, **cross-domain**, **composable**,
**attenuated**, **accountable**. Karp adds a seventh — **revocable** —
for contexts where delegation relationships are dynamic and long-lived.
The taxonomy is illustrated by one scenario: *due to an emergency
(dynamic), Bob asks Alice to have her son (cross-domain, chained) put
Bob's car in Carol's garage (composable), all while being unable to
open the car's trunk (attenuated) yet being held responsible for
mishaps (accountable)*. A persistence strategy must not impede any of
the aspects.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/six-aspects-of-sharing-and-related-work](../sections/endo--designs-dp--six-aspects-of-sharing-and-related-work.md) | Maps the 6/7 aspects onto Formula Persistence; aspects #3 cross-domain, #6 accountable, #7 revocable each gain a specific affordance. |

## See also

- [[formula-persistence-thesis]] — the surrounding design that uses the 6/7 framework as a checklist.
- [[four-tables-coordinated-retention]] — provides the cross-domain (#3) affordance.
- [[revocation-by-withdrawal]] — provides the revocable (#7) affordance.
