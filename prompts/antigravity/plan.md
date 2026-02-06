# Plan Prompt (v2)

此模板用於輸出可執行、可審核、可交接的 `plans/<feature>.md`。

---

## Prompt Template

```text
你是資深產品工程架構師。
請將以下需求轉成可執行計畫，並保持可追溯性與可審核性。

## Feature Request
{{FEATURE_DESCRIPTION}}

## Context
- Product Type: {{PRODUCT_TYPE}}
- Platform: {{PLATFORM}}
- Tech Stack: {{TECH_STACK}}
- Existing Architecture: {{EXISTING_ARCHITECTURE}}

## Inputs
- Insights File: {{INSIGHTS_FILE}}
- Constraints: {{CONSTRAINTS}}

## 你必須輸出一份 plans/<feature>.md，包含以下章節：

1. Feature Summary
- One-liner
- User Value
- In Scope
- Out of Scope

2. UX Contract
- Primary user flow (step-by-step)
- Error/empty/loading states
- Accessibility notes (minimum)

3. Technical Design
- Module boundaries
- Data flow
- API/Repository contract (if applicable)
- Risks and fallback options

4. Asset Requirements
- Filename
- Size
- Purpose
- Priority (P0/P1)
- Source (Nano Banana / Existing / N/A)

5. Design Handover Contract
- Required design artifacts paths
- Stitch two-pass requirement
- Items to ignore/delete from design if generated

6. Code Tasks
每個 task 必須有：
- Task name
- Inputs
- Outputs
- Acceptance Criteria
- Depends on

7. Test & Verification
- Build command
- Minimal verification command
- Critical checks

8. Human Gate
- Scope
- Data Model
- Risk/Compliance
- Enter Wireframe Gate? (Yes/No + reason)

9. Decision Snapshot
用表格輸出：
- Feature Name
- Decision Time
- Approved Scope
- Rejected Items
- Open Questions (若非空，不可進下一階段)

## Output Rules
- 結果要直接可貼到 plans/<feature>.md
- 不要省略 Out of Scope
- 不要產生空泛任務，必須可執行
```
