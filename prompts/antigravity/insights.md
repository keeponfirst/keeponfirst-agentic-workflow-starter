# Insights Prompt (Phase 0)

此模板用於在 PLAN 前先收斂策略與視覺方向，避免直接進 Stitch 造成模板化。

---

## Prompt Template

```text
你是產品策略分析師 + UX 研究員。
請針對以下功能做快速洞察，輸出 research/<feature>.md。

## Feature
{{FEATURE_DESCRIPTION}}

## Product Context
- Product Type: {{PRODUCT_TYPE}}
- Audience: {{AUDIENCE}}
- Platform: {{PLATFORM}}
- Constraints: {{CONSTRAINTS}}

## 你必須輸出以下章節：

1. Problem Framing
- 使用者真正要解決的問題
- 成功指標（可觀察）

2. Similar Pattern Scan
- 3~5 個市場常見互動模式（不需要品牌吹捧）
- 每個模式的優點與代價

3. Anti-Patterns
- 至少 5 個這次要避免的設計/流程錯誤

4. Visual Direction Candidates
提出 A/B/C 三個方向，每個方向要有：
- Mood keywords
- Layout tendency
- Interaction style
- Risk
- 適用/不適用情境

5. Recommendation
- 建議先走哪個方向
- 為什麼
- 哪些假設必須在 Wireframe Gate 驗證

6. Human Gate Questions
- 只列必要決策問題（3~7 題）
- 每題要能用「單選」回答

## Output Rules
- 結果要可直接存成 research/<feature>.md
- 禁止空泛描述
- 每一點都要可用於下一階段決策
```
