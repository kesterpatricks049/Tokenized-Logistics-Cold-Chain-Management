;; Compliance Tracking Contract
;; Tracks regulatory compliance for cold chain operations

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u400))
(define-constant ERR_COMPLIANCE_RECORD_NOT_FOUND (err u401))
(define-constant ERR_INVALID_COMPLIANCE_STATUS (err u402))

;; Compliance status constants
(define-constant COMPLIANCE_PENDING u0)
(define-constant COMPLIANCE_COMPLIANT u1)
(define-constant COMPLIANCE_NON_COMPLIANT u2)
(define-constant COMPLIANCE_UNDER_REVIEW u3)

;; Compliance record structure
(define-map compliance-records
  { record-id: (string-ascii 50) }
  {
    shipment-id: (string-ascii 50),
    regulation-type: (string-ascii 100),
    compliance-status: uint,
    audit-date: uint,
    auditor-id: principal,
    violations: (list 10 (string-ascii 200)),
    corrective-actions: (list 10 (string-ascii 200)),
    next-audit-date: uint
  }
)

;; Regulatory requirements
(define-map regulatory-requirements
  { regulation-id: (string-ascii 50) }
  {
    name: (string-ascii 100),
    description: (string-ascii 500),
    mandatory: bool,
    effective-date: uint,
    expiry-date: uint
  }
)

;; Authorized auditors
(define-map authorized-auditors
  { auditor-id: principal }
  {
    name: (string-ascii 100),
    certification: (string-ascii 100),
    specialization: (string-ascii 100),
    active: bool
  }
)

;; Add regulatory requirement
(define-public (add-regulation
  (regulation-id (string-ascii 50))
  (name (string-ascii 100))
  (description (string-ascii 500))
  (mandatory bool)
  (effective-date uint)
  (expiry-date uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)

    (map-set regulatory-requirements
      { regulation-id: regulation-id }
      {
        name: name,
        description: description,
        mandatory: mandatory,
        effective-date: effective-date,
        expiry-date: expiry-date
      }
    )
    (ok true)
  )
)

;; Add authorized auditor
(define-public (add-auditor
  (auditor-id principal)
  (name (string-ascii 100))
  (certification (string-ascii 100))
  (specialization (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)

    (map-set authorized-auditors
      { auditor-id: auditor-id }
      {
        name: name,
        certification: certification,
        specialization: specialization,
        active: true
      }
    )
    (ok true)
  )
)

;; Create compliance record
(define-public (create-compliance-record
  (record-id (string-ascii 50))
  (shipment-id (string-ascii 50))
  (regulation-type (string-ascii 100))
  (violations (list 10 (string-ascii 200)))
  (corrective-actions (list 10 (string-ascii 200)))
  (next-audit-date uint))
  (let
    (
      (auditor-data (unwrap! (map-get? authorized-auditors { auditor-id: tx-sender }) ERR_UNAUTHORIZED))
      (compliance-status (if (is-eq (len violations) u0) COMPLIANCE_COMPLIANT COMPLIANCE_NON_COMPLIANT))
    )

    (asserts! (get active auditor-data) ERR_UNAUTHORIZED)

    (map-set compliance-records
      { record-id: record-id }
      {
        shipment-id: shipment-id,
        regulation-type: regulation-type,
        compliance-status: compliance-status,
        audit-date: block-height,
        auditor-id: tx-sender,
        violations: violations,
        corrective-actions: corrective-actions,
        next-audit-date: next-audit-date
      }
    )
    (ok compliance-status)
  )
)

;; Update compliance status
(define-public (update-compliance-status
  (record-id (string-ascii 50))
  (new-status uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (is-some (map-get? compliance-records { record-id: record-id })) ERR_COMPLIANCE_RECORD_NOT_FOUND)
    (asserts! (<= new-status COMPLIANCE_UNDER_REVIEW) ERR_INVALID_COMPLIANCE_STATUS)

    (map-set compliance-records
      { record-id: record-id }
      (merge
        (unwrap-panic (map-get? compliance-records { record-id: record-id }))
        { compliance-status: new-status }
      )
    )
    (ok true)
  )
)

;; Get compliance record
(define-read-only (get-compliance-record (record-id (string-ascii 50)))
  (map-get? compliance-records { record-id: record-id })
)

;; Get regulatory requirement
(define-read-only (get-regulation (regulation-id (string-ascii 50)))
  (map-get? regulatory-requirements { regulation-id: regulation-id })
)

;; Check if auditor is authorized
(define-read-only (is-auditor-authorized (auditor-id principal))
  (match (map-get? authorized-auditors { auditor-id: auditor-id })
    auditor-data (get active auditor-data)
    false
  )
)
