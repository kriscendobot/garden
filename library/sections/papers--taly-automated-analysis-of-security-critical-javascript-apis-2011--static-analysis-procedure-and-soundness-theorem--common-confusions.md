---
title: Common confusions
source: "Automated Analysis of Security-Critical JavaScript APIs (Taly, Erlingsson, Mitchell, Miller, Nagra, IEEE S&P 2011)"
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_paper_pages: "3-12 (§3 The Language SES_light through §5 Analysis Procedure)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem
---

- **"The flow-insensitive analysis is too imprecise."** It is — but *sound*: any vulnerability the runtime exhibits, the analysis flags. The cost is false positives (analysis flags things that are not actually vulnerable). The §5 paper accepts this trade-off: simpler analysis + scalable + provably sound.
- **"Datalog is overkill."** The choice is justified by *fixpoint computation*: Datalog's Herbrand-semantics-and-least-fixpoint matches points-to-analysis's transitive closure. Existing tools (`bddbddb` per ref [39]) provide efficient Datalog engines.
- **"The labeled semantics is just bureaucracy."** It is *the formal device* that makes the Confinement Property statable: without labels, we cannot say *the attacker cannot reach a forbidden object* because we cannot identify *which object the attacker reached*. Labels are the abstract identities of allocation sites.
- **"Theorem 1 (Renaming) is obvious."** It is *necessary* — without it, the analysis would have to be re-done for every α-renamed program. With it, the analyzer can canonicalize variable names without affecting confinement-decision.
- **"Soundness without completeness is useless."** It is *necessary, not sufficient*. Soundness means *the analysis never approves an unsafe program*. Completeness would mean *the analysis never disapproves a safe program*. For confinement-verification, soundness is the load-bearing direction — false positives (over-approximations) are acceptable because they prompt the developer to re-examine; false negatives (under-approximations) would silently approve unsafe code.
- **"Context-insensitivity is fatal for JavaScript."** It is *imprecise* for JavaScript, but not fatal: the §6 *Applications* section shows ENCAP successfully verifies confinement for ADSafe, Sealer-Unsealer, and Mint. The trade-off between context-insensitivity (cheap, imprecise) and context-sensitivity (expensive, precise) is real; the §5 paper picks the cheap-and-imprecise side for tractability.
- **"The analysis runs on ES5S, not SES_light."** The §4.B paper describes an emulation: *we present a first cut at an approach for emulating the SES_light restrictions on a browser supporting ES5S. The main idea is to run an initialization script that makes the heap SES_light-compliant with the initial SES_light heap and then use a static verifier on all code that runs subsequently.* So in practice the analysis can run on ES5S browsers with an initialization script.
