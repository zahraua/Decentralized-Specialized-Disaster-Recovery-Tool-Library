import { describe, it, expect, beforeEach } from "vitest"

// Simple mock state
let mockCaseCounter = 0
const mockCases = new Map()

// Simple mock functions
const registerCase = (conditionHash, demographics) => {
  const caseId = mockCaseCounter
  mockCases.set(caseId, {
    provider: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
    conditionHash,
    demographics,
    timestamp: 123456,
  })
  mockCaseCounter++
  return { ok: caseId }
}

const getCase = (caseId) => mockCases.get(caseId) || null
const getCaseCount = () => mockCaseCounter

// Simple tests
describe("Case Registration Contract", () => {
  beforeEach(() => {
    mockCaseCounter = 0
    mockCases.clear()
  })
  
  it("should register a case", () => {
    const result = registerCase("condition-hash", "demographics-data")
    expect(result.ok).toBe(0)
    expect(mockCases.size).toBe(1)
  })
  
  it("should get case data", () => {
    registerCase("condition-hash", "demographics-data")
    const caseData = getCase(0)
    expect(caseData).not.toBeNull()
    expect(caseData.conditionHash).toBe("condition-hash")
  })
  
  it("should track case count", () => {
    expect(getCaseCount()).toBe(0)
    registerCase("c1", "d1")
    registerCase("c2", "d2")
    expect(getCaseCount()).toBe(2)
  })
})

