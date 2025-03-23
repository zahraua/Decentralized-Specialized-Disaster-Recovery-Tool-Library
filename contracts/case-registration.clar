;; Case Registration Contract - Simplified
;; Records anonymized unusual medical cases

;; Data Variables
(define-data-var case-counter uint u0)

;; Data Maps
(define-map cases
  { case-id: uint }
  {
    provider: principal,
    condition-hash: (buff 32),
    demographics: (buff 64),
    timestamp: uint
  }
)

;; Register a new anonymized medical case
(define-public (register-case
    (condition-hash (buff 32))
    (demographics (buff 64)))
  (let ((case-id (var-get case-counter)))
    (begin
      (map-set cases
        { case-id: case-id }
        {
          provider: tx-sender,
          condition-hash: condition-hash,
          demographics: demographics,
          timestamp: block-height
        }
      )
      (var-set case-counter (+ case-id u1))
      (ok case-id)
    )
  )
)

;; Get case details by ID
(define-read-only (get-case (case-id uint))
  (map-get? cases { case-id: case-id })
)

;; Get the total number of registered cases
(define-read-only (get-case-count)
  (var-get case-counter)
)

