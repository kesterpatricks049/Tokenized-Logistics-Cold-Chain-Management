;; Loss Prevention Contract
;; Manages loss prevention measures and incident tracking

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_INCIDENT_NOT_FOUND (err u501))
(define-constant ERR_INVALID_SEVERITY (err u502))
(define-constant ERR_INVALID_STATUS (err u503))

;; Incident severity levels
(define-constant SEVERITY_LOW u1)
(define-constant SEVERITY_MEDIUM u2)
(define-constant SEVERITY_HIGH u3)
(define-constant SEVERITY_CRITICAL u4)

;; Incident status
(define-constant STATUS_REPORTED u1)
(define-constant STATUS_INVESTIGATING u2)
(define-constant STATUS_RESOLVED u3)
(define-constant STATUS_CLOSED u4)

;; Loss incident structure
(define-map loss-incidents
  { incident-id: (string-ascii 50) }
  {
    shipment-id: (string-ascii 50),
    incident-type: (string-ascii 100),
    severity: uint,
    status: uint,
    reported-date: uint,
    resolved-date: uint,
    reporter-id: principal,
    description: (string-ascii 500),
    estimated-loss: uint,
    actual-loss: uint,
    preventive-measures: (list 5 (string-ascii 200))
  }
)

;; Risk assessment data
(define-map risk-assessments
  { assessment-id: (string-ascii 50) }
  {
    shipment-id: (string-ascii 50),
    risk-factors: (list 10 (string-ascii 100)),
    risk-score: uint,
    mitigation-strategies: (list 10 (string-ascii 200)),
    assessment-date: uint,
    assessor-id: principal
  }
)

;; Insurance claims
(define-map insurance-claims
  { claim-id: (string-ascii 50) }
  {
    incident-id: (string-ascii 50),
    claim-amount: uint,
    claim-status: uint,
    filed-date: uint,
    processed-date: uint,
    insurance-provider: (string-ascii 100)
  }
)

;; Report loss incident
(define-public (report-incident
  (incident-id (string-ascii 50))
  (shipment-id (string-ascii 50))
  (incident-type (string-ascii 100))
  (severity uint)
  (description (string-ascii 500))
  (estimated-loss uint))
  (begin
    (asserts! (<= severity SEVERITY_CRITICAL) ERR_INVALID_SEVERITY)
    (asserts! (>= severity SEVERITY_LOW) ERR_INVALID_SEVERITY)

    (map-set loss-incidents
      { incident-id: incident-id }
      {
        shipment-id: shipment-id,
        incident-type: incident-type,
        severity: severity,
        status: STATUS_REPORTED,
        reported-date: block-height,
        resolved-date: u0,
        reporter-id: tx-sender,
        description: description,
        estimated-loss: estimated-loss,
        actual-loss: u0,
        preventive-measures: (list)
      }
    )
    (ok true)
  )
)

;; Update incident status
(define-public (update-incident-status
  (incident-id (string-ascii 50))
  (new-status uint)
  (actual-loss uint)
  (preventive-measures (list 5 (string-ascii 200))))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-some (map-get? loss-incidents { incident-id: incident-id })) ERR_INCIDENT_NOT_FOUND)
    (asserts! (<= new-status STATUS_CLOSED) ERR_INVALID_STATUS)

    (map-set loss-incidents
      { incident-id: incident-id }
      (merge
        (unwrap-panic (map-get? loss-incidents { incident-id: incident-id }))
        {
          status: new-status,
          resolved-date: (if (is-eq new-status STATUS_RESOLVED) block-height u0),
          actual-loss: actual-loss,
          preventive-measures: preventive-measures
        }
      )
    )
    (ok true)
  )
)

;; Create risk assessment
(define-public (create-risk-assessment
  (assessment-id (string-ascii 50))
  (shipment-id (string-ascii 50))
  (risk-factors (list 10 (string-ascii 100)))
  (risk-score uint)
  (mitigation-strategies (list 10 (string-ascii 200))))
  (begin
    (map-set risk-assessments
      { assessment-id: assessment-id }
      {
        shipment-id: shipment-id,
        risk-factors: risk-factors,
        risk-score: risk-score,
        mitigation-strategies: mitigation-strategies,
        assessment-date: block-height,
        assessor-id: tx-sender
      }
    )
    (ok true)
  )
)

;; File insurance claim
(define-public (file-insurance-claim
  (claim-id (string-ascii 50))
  (incident-id (string-ascii 50))
  (claim-amount uint)
  (insurance-provider (string-ascii 100)))
  (begin
    (asserts! (is-some (map-get? loss-incidents { incident-id: incident-id })) ERR_INCIDENT_NOT_FOUND)

    (map-set insurance-claims
      { claim-id: claim-id }
      {
        incident-id: incident-id,
        claim-amount: claim-amount,
        claim-status: STATUS_REPORTED,
        filed-date: block-height,
        processed-date: u0,
        insurance-provider: insurance-provider
      }
    )
    (ok true)
  )
)

;; Get incident details
(define-read-only (get-incident (incident-id (string-ascii 50)))
  (map-get? loss-incidents { incident-id: incident-id })
)

;; Get risk assessment
(define-read-only (get-risk-assessment (assessment-id (string-ascii 50)))
  (map-get? risk-assessments { assessment-id: assessment-id })
)

;; Get insurance claim
(define-read-only (get-insurance-claim (claim-id (string-ascii 50)))
  (map-get? insurance-claims { claim-id: claim-id })
)
