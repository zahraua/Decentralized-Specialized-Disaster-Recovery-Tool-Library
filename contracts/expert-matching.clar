;; Expert Matching Contract - Simplified
;; Connects rare conditions with experienced specialists

;; Data Maps
(define-map experts
  { expert-id: principal }
  {
    specialties: (list 10 (buff 32)),
    cases-reviewed: uint
  }
)

(define-map case-expert-matches
  { case-id: uint }
  {
    matched-experts: (list 5 principal)
  }
)

;; Register as an expert with specialties
(define-public (register-as-expert (specialties (list 10 (buff 32))))
  (begin
    (map-set experts
      { expert-id: tx-sender }
      {
        specialties: specialties,
        cases-reviewed: u0
      }
    )
    (ok true)
  )
)

;; Match experts to a case
(define-public (match-experts-to-case
    (case-id uint)
    (matched-experts (list 5 principal)))
  (begin
    (map-set case-expert-matches
      { case-id: case-id }
      {
        matched-experts: matched-experts
      }
    )
    (ok true)
  )
)

;; Accept a case as an expert
(define-public (accept-case (case-id uint))
  (let (
    (expert-data (default-to
                   { specialties: (list), cases-reviewed: u0 }
                   (map-get? experts { expert-id: tx-sender })))
  )
    (begin
      (map-set experts
        { expert-id: tx-sender }
        {
          specialties: (get specialties expert-data),
          cases-reviewed: (+ (get cases-reviewed expert-data) u1)
        }
      )
      (ok true)
    )
  )
)

;; Get expert details
(define-read-only (get-expert (expert-id principal))
  (map-get? experts { expert-id: expert-id })
)

;; Get matches for a case
(define-read-only (get-case-matches (case-id uint))
  (map-get? case-expert-matches { case-id: case-id })
)

