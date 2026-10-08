---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish the awesome-ocap PetNames reference walk

Continue `scholar-ingest-source-awesome-ocap-petnames` under `roles/scholar/AGENT.md` and `journal/library/conventions.md`. The first cycle ingested the awesome-ocap wiki, Zooko Wilcox-O'Hearn's 2001 essay, Shapiro's April 2000 dcms-dev public antecedent, Miller's PNML page, and Stiegler's 2005 paper.

Idempotency-check, fetch, preclassify, and ingest the remaining real primary sources linked by or discovered through that cluster:

- Christine Lemmer-Webber, Mark S. Miller, Zachary Larson, Kate Sills, and Eli Yaacoby, *Petnames: A humane approach to secure, decentralized naming* (2022), fetched direct in the prior cycle with SHA-256 `c9f221a9a7aa4c2541ce81510aae03c0a1553a0eb867c1b66df7a3fea6982ee2`.
- Tyler Close, *Petname Tool: Enabling web site recognition using the existing SSL infrastructure* (2005), fetched direct with SHA-256 `8c8fef18371588f6000f0957760fd8b1b7011b9bd52fe3cf4a1fb851ff8e09f8`.
- Bill Frantz's same-day dcms-dev reply `0039.html`, fetched from the Internet Archive with SHA-256 `43a5296ca60162ab388d1de2c8728a599e8b33da86192c2027a19f69cabfed79`.
- The Walnut *Petnames and Forgery among partially trusted participants* page. The canonical host refused connection and both Wayback indexes were unavailable in the prior cycle; `fetch-source.sh` reported `source_retryable=true`.
- The 2026 DCF *Containing AI Agents: The Endo Familiar Demo* and the Endo daemon changelog range linked by the wiki, if primary-source review shows they add petname behavior not already represented by the Endo source corpus.

Also inspect the two issue links only as issue/discussion evidence, not as authoritative definitions, and record a reason if they are not library-worthy primary sources. Preserve the derived-from-not-the-original framing for Miller's public texts. The prior cycle's Jev gate was unavailable because `TYPESAFE_API_KEY` was absent; run it again and record the disposition.
