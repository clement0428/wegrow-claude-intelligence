---
name: Add and delete on every list — 101 rule
description: Every item list in Orbit UI must support both add AND delete. Non-negotiable.
type: feedback
---

Every list, table, or collection of items MUST have both:
1. A per-row **delete/× button** to remove items
2. An **add button** to insert new items inline or via a quick picker

**Why:** User was furious that the 施肥計劃 fertilizer section had no way to add new products directly. Having delete without add (or vice versa) is incomplete and unusable. This is basic 101 UX.

**How to apply:** Before shipping ANY list/table component, verify both add and delete are present and functional. No exceptions — not even "read-only" views unless explicitly specified by user.
