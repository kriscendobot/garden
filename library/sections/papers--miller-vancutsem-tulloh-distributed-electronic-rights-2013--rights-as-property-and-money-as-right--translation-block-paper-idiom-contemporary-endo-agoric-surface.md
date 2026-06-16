---
title: Translation block (paper idiom → contemporary Endo / Agoric surface)
source: "Distributed Electronic Rights in JavaScript (ESOP 2013, Springer LNCS 7792)"
source_kind: paper
source_authors: [Mark S. Miller, Tom Van Cutsem, Bill Tulloh]
source_year: 2013
source_venue: "ESOP 2013, Springer LNCS 7792, pp. 1-20"
source_url: https://papers.agoric.com/papers/distributed-electronic-rights-in-javascript/abstract/
source_pdf_sha256: 061ab339fb204ad2d609ce44130146bf9cb0897bf7c6d9e21248cac412454593
source_paper_pages: "10-14 (§3 Toward Distributed Electronic Rights; §4 Money as an Electronic Right)"
ingested: 2026-05-30
ingested_by: liaison-direct-draft
topics: [capability-security, patterns]
status: current
parent: papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--rights-as-property-and-money-as-right
---

| 2013 Dr. SES concept | Contemporary Endo / Agoric equivalent |
| -------------------- | ------------------------------------- |
| `WeakMap` as brand table | Agoric ERTP's brand primitive (cycle-77 [[brand-and-trademark]] concept page); structurally identical use of WeakMap-keyed-by-purse-identity. |
| `m.set(purse, decr)` | The contemporary issuer-kit's mint registering a fresh purse-and-amount-math triple. |
| `def(...)` for defensible methods | `harden(...)` in contemporary Hardened JavaScript. |
| `Nat(amount)` for natural-number guard | `Nat()` in @endo/nat; or @endo/patterns matcher `M.nat()`. |
| `Q(srcP).then(src => ...)` | `E.when(srcP, src => ...)` in @endo/eventual-send; or async-await on the source promise. |
| Four-dimensional rights taxonomy | Agoric ERTP's `AmountMath` design vocabulary: `nat` (fungible), `set`/`copySet` (specific exclusive), `copyBag` (fungible exclusive). |
| Rights as property law / contract law / tort law parallel | The library's `mint-purse-money` + `smart-contract` + `principle-of-least-authority` concept-page triple. |
