;; Treatment Outcome Contract - Simplified
;; Tracks effectiveness of interventions

;; Data Maps
(define-map treatments
  { treatment-id: uint }
  {
    case-id: uint,
    provider: principal,
    treatment-hash: (buff 32),
    timestamp: uint
  }
)

(define-map outcomes
  { treatment-id: uint }
  {
    effectiveness-score: uint,
    side-effects: (buff 64),
    follow-up-notes: (buff 256)
  }
)

;; Data Variables
(define-data-var treatment-counter uint u0)

;; Register a new treatment for a case
(define-public (register-treatment
    (case-id uint)
    (treatment-hash (buff 32)))
  (let ((treatment-id (var-get treatment-counter)))
    (begin
      (map-set treatments
        { treatment-id: treatment-id }
        {
          case-id: case-id,
          provider: tx-sender,
          treatment-hash: treatment-hash,
          timestamp: block-height
        }
      )
      (var-set treatment-counter (+ treatment-id u1))
      (ok treatment-id)
    )
  )
)

;; Record outcome for a treatment
(define-public (record-outcome
    (treatment-id uint)
    (effectiveness-score uint)
    (side-effects (buff 64))
    (follow-up-notes (buff 256)))
  (begin
    (map-set outcomes
      { treatment-id: treatment-id }
      {
        effectiveness-score: effectiveness-score,
        side-effects: side-effects,
        follow-up-notes: follow-up-notes
      }
    )
    (ok true)
  )
)

;; Get treatment details
(define-read-only (get-treatment (treatment-id uint))
  (map-get? treatments { treatment-id: treatment-id })
)

;; Get outcome details for a treatment
(define-read-only (get-outcome (treatment-id uint))
  (map-get? outcomes { treatment-id: treatment-id })
)

;; Get the total number of registered treatments
(define-read-only (get-treatment-count)
  (var-get treatment-counter)
)

