---
title: Listing and review process
source_kind: web
source_url: https://docs.aws.amazon.com/marketplace/latest/userguide/ami-single-ami-products.html
source_date: 2025-05-01
ingested: 2026-06-11
ingested_by: scholar
topics: [cloud-marketplace, node-packaging]
status: current
notes: "Pricing model table confirmed across ami-single-ami-products.html and product-submission.html. Timelines from product-submission.html."
parent: web--aws-marketplace-ami-requirements--pricing-and-listing
---

1. **Seller registration**: Tax and banking information required for paid products.
2. **AMI preparation**: Build AMI meeting all security and architecture requirements. AMI must reside in us-east-1 owned by the seller account.
3. **Self-service scan**: Use "Test Add Version" in the AWS Marketplace Management Portal; scan typically completes in under an hour.
4. **Submission**: Submit via the Build tab (self-service experience) or Assets tab (product load form for complex configurations).
5. **Limited state**: After submission validates, product enters Limited state — visible only to the seller's account and an optional allow-listed set of test accounts. Test thoroughly here.
6. **Public publication**: Request Update Visibility. AWS Marketplace Seller Operations reviews.
7. **AMI cloning**: AWS creates region-specific clones and attaches a product code for metering and access control.

Timing:
- Initial publication: 7–10 business days if no errors.
- Total request time: 2–4 calendar weeks for new products.
- Planned events or releases: submit at least 45 days in advance.
- Price changes: 90-day notice; effective on the first of the month following the 90-day window.
- Region or instance-type changes: 90-day process.

Source: [Creating AMI-based products](https://docs.aws.amazon.com/marketplace/latest/userguide/ami-single-ami-products.html) and [Submitting your product for publication](https://docs.aws.amazon.com/marketplace/latest/userguide/product-submission.html) retrieved 2026-06-11.
