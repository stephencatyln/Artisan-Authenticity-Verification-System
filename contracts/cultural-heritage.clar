;; Cultural Heritage Contract
;; Protects traditional craft categories and cultural significance

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u500))
(define-constant ERR-HERITAGE-EXISTS (err u501))
(define-constant ERR-HERITAGE-NOT-FOUND (err u502))
(define-constant ERR-INVALID-INPUT (err u503))
(define-constant ERR-PROTECTION-LEVEL-INVALID (err u504))

;; Data Variables
(define-data-var next-heritage-id uint u1)
(define-data-var total-heritage-sites uint u0)

;; Data Maps
(define-map cultural-heritage-sites
  { heritage-id: uint }
  {
    name: (string-ascii 200),
    country: (string-ascii 100),
    region: (string-ascii 100),
    cultural-group: (string-ascii 100),
    protection-level: (string-ascii 50),
    registration-date: uint,
    registered-by: principal,
    is-active: bool,
    unesco-status: bool
  }
)

(define-map heritage-crafts
  { heritage-id: uint, craft-category: (string-ascii 100) }
  {
    craft-name: (string-ascii 100),
    traditional-techniques: (string-ascii 500),
    cultural-significance: (string-ascii 800),
    historical-period: (string-ascii 100),
    risk-level: (string-ascii 50),
    preservation-priority: uint,
    active-practitioners: uint
  }
)

(define-map heritage-documentation
  { heritage-id: uint }
  {
    description: (string-ascii 1000),
    historical-background: (string-ascii 1000),
    cultural-practices: (string-ascii 800),
    traditional-knowledge: (string-ascii 1000),
    preservation-efforts: (string-ascii 600),
    threats-challenges: (string-ascii 600)
  }
)

(define-map heritage-guardians
  { heritage-id: uint, guardian-id: uint }
  {
    guardian-principal: principal,
    guardian-name: (string-ascii 100),
    role: (string-ascii 100),
    appointment-date: uint,
    responsibilities: (string-ascii 400),
    is-active: bool
  }
)

(define-map cultural-impact-metrics
  { heritage-id: uint }
  {
    artisans-supported: uint,
    techniques-preserved: uint,
    products-certified: uint,
    cultural-events: uint,
    educational-programs: uint,
    community-engagement: uint
  }
)

(define-map heritage-guardian-count
  { heritage-id: uint }
  { count: uint }
)

;; Public Functions

;; Register cultural heritage site
(define-public (register-heritage-site
  (name (string-ascii 200))
  (country (string-ascii 100))
  (region (string-ascii 100))
  (cultural-group (string-ascii 100))
  (protection-level (string-ascii 50))
  (unesco-status bool)
  (description (string-ascii 1000))
  (historical-background (string-ascii 1000)))
  (let
    (
      (heritage-id (var-get next-heritage-id))
      (caller tx-sender)
    )
    ;; Validate input
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len country) u0) ERR-INVALID-INPUT)
    (asserts! (> (len cultural-group) u0) ERR-INVALID-INPUT)

    ;; Create heritage site record
    (map-set cultural-heritage-sites
      { heritage-id: heritage-id }
      {
        name: name,
        country: country,
        region: region,
        cultural-group: cultural-group,
        protection-level: protection-level,
        registration-date: block-height,
        registered-by: caller,
        is-active: true,
        unesco-status: unesco-status
      }
    )

    ;; Create documentation record
    (map-set heritage-documentation
      { heritage-id: heritage-id }
      {
        description: description,
        historical-background: historical-background,
        cultural-practices: "",
        traditional-knowledge: "",
        preservation-efforts: "",
        threats-challenges: ""
      }
    )

    ;; Initialize impact metrics
    (map-set cultural-impact-metrics
      { heritage-id: heritage-id }
      {
        artisans-supported: u0,
        techniques-preserved: u0,
        products-certified: u0,
        cultural-events: u0,
        educational-programs: u0,
        community-engagement: u0
      }
    )

    ;; Initialize guardian count
    (map-set heritage-guardian-count
      { heritage-id: heritage-id }
      { count: u0 }
    )

    ;; Update counters
    (var-set next-heritage-id (+ heritage-id u1))
    (var-set total-heritage-sites (+ (var-get total-heritage-sites) u1))

    (ok heritage-id)
  )
)

;; Add heritage craft
(define-public (add-heritage-craft
  (heritage-id uint)
  (craft-category (string-ascii 100))
  (craft-name (string-ascii 100))
  (traditional-techniques (string-ascii 500))
  (cultural-significance (string-ascii 800))
  (historical-period (string-ascii 100))
  (risk-level (string-ascii 50))
  (preservation-priority uint))
  (let
    (
      (heritage-data (unwrap! (map-get? cultural-heritage-sites { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND))
    )
    ;; Validate input
    (asserts! (> (len craft-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len craft-category) u0) ERR-INVALID-INPUT)
    ;; Replaced HTML entity &lt; with native Clarity <= operator
    (asserts! (and (>= preservation-priority u1) (<= preservation-priority u10)) ERR-INVALID-INPUT)

    ;; Add craft record
    (map-set heritage-crafts
      { heritage-id: heritage-id, craft-category: craft-category }
      {
        craft-name: craft-name,
        traditional-techniques: traditional-techniques,
        cultural-significance: cultural-significance,
        historical-period: historical-period,
        risk-level: risk-level,
        preservation-priority: preservation-priority,
        active-practitioners: u0
      }
    )

    (ok true)
  )
)

;; Appoint heritage guardian
(define-public (appoint-heritage-guardian
  (heritage-id uint)
  (guardian-principal principal)
  (guardian-name (string-ascii 100))
  (role (string-ascii 100))
  (responsibilities (string-ascii 400)))
  (let
    (
      (heritage-data (unwrap! (map-get? cultural-heritage-sites { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND))
      (guardian-count (get count (unwrap! (map-get? heritage-guardian-count { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND)))
      (registered-by (get registered-by heritage-data))
    )
    ;; Only site registrar or contract owner can appoint guardians
    (asserts! (or (is-eq tx-sender registered-by) (is-eq tx-sender CONTRACT-OWNER)) ERR-NOT-AUTHORIZED)
    ;; Validate input
    (asserts! (> (len guardian-name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len role) u0) ERR-INVALID-INPUT)

    ;; Add guardian record
    (map-set heritage-guardians
      { heritage-id: heritage-id, guardian-id: guardian-count }
      {
        guardian-principal: guardian-principal,
        guardian-name: guardian-name,
        role: role,
        appointment-date: block-height,
        responsibilities: responsibilities,
        is-active: true
      }
    )

    ;; Update guardian count
    (map-set heritage-guardian-count
      { heritage-id: heritage-id }
      { count: (+ guardian-count u1) }
    )

    (ok guardian-count)
  )
)

;; Update heritage documentation
(define-public (update-heritage-documentation
  (heritage-id uint)
  (cultural-practices (string-ascii 800))
  (traditional-knowledge (string-ascii 1000))
  (preservation-efforts (string-ascii 600))
  (threats-challenges (string-ascii 600)))
  (let
    (
      (heritage-data (unwrap! (map-get? cultural-heritage-sites { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND))
      (current-docs (unwrap! (map-get? heritage-documentation { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND))
      (registered-by (get registered-by heritage-data))
    )
    ;; Only site registrar or contract owner can update documentation
    (asserts! (or (is-eq tx-sender registered-by) (is-eq tx-sender CONTRACT-OWNER)) ERR-NOT-AUTHORIZED)

    ;; Update documentation
    (map-set heritage-documentation
      { heritage-id: heritage-id }
      (merge current-docs {
        cultural-practices: cultural-practices,
        traditional-knowledge: traditional-knowledge,
        preservation-efforts: preservation-efforts,
        threats-challenges: threats-challenges
      })
    )

    (ok true)
  )
)

;; Update cultural impact metrics
(define-public (update-impact-metrics
  (heritage-id uint)
  (artisans-supported uint)
  (techniques-preserved uint)
  (products-certified uint)
  (cultural-events uint)
  (educational-programs uint)
  (community-engagement uint))
  (let
    (
      (heritage-data (unwrap! (map-get? cultural-heritage-sites { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND))
      (registered-by (get registered-by heritage-data))
    )
    ;; Only site registrar or contract owner can update metrics
    (asserts! (or (is-eq tx-sender registered-by) (is-eq tx-sender CONTRACT-OWNER)) ERR-NOT-AUTHORIZED)

    ;; Update impact metrics
    (map-set cultural-impact-metrics
      { heritage-id: heritage-id }
      {
        artisans-supported: artisans-supported,
        techniques-preserved: techniques-preserved,
        products-certified: products-certified,
        cultural-events: cultural-events,
        educational-programs: educational-programs,
        community-engagement: community-engagement
      }
    )

    (ok true)
  )
)

;; Update heritage protection level (contract owner only)
(define-public (update-protection-level
  (heritage-id uint)
  (new-protection-level (string-ascii 50)))
  (let
    (
      (heritage-data (unwrap! (map-get? cultural-heritage-sites { heritage-id: heritage-id }) ERR-HERITAGE-NOT-FOUND))
    )
    ;; Only contract owner can update protection level
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    ;; Validate protection level
    (asserts! (> (len new-protection-level) u0) ERR-INVALID-INPUT)

    ;; Update protection level
    (map-set cultural-heritage-sites
      { heritage-id: heritage-id }
      (merge heritage-data { protection-level: new-protection-level })
    )

    (ok true)
  )
)

;; Read-only functions

;; Get heritage site
(define-read-only (get-heritage-site (heritage-id uint))
  (map-get? cultural-heritage-sites { heritage-id: heritage-id })
)

;; Get heritage craft
(define-read-only (get-heritage-craft (heritage-id uint) (craft-category (string-ascii 100)))
  (map-get? heritage-crafts { heritage-id: heritage-id, craft-category: craft-category })
)

;; Get heritage documentation
(define-read-only (get-heritage-documentation (heritage-id uint))
  (map-get? heritage-documentation { heritage-id: heritage-id })
)

;; Get heritage guardian
(define-read-only (get-heritage-guardian (heritage-id uint) (guardian-id uint))
  (map-get? heritage-guardians { heritage-id: heritage-id, guardian-id: guardian-id })
)

;; Get cultural impact metrics
(define-read-only (get-cultural-impact-metrics (heritage-id uint))
  (map-get? cultural-impact-metrics { heritage-id: heritage-id })
)

;; Get heritage guardian count
(define-read-only (get-heritage-guardian-count (heritage-id uint))
  (map-get? heritage-guardian-count { heritage-id: heritage-id })
)

;; Get total heritage sites
(define-read-only (get-total-heritage-sites)
  (var-get total-heritage-sites)
)

;; Check if heritage site is active
(define-read-only (is-heritage-site-active (heritage-id uint))
  (match (map-get? cultural-heritage-sites { heritage-id: heritage-id })
    heritage-data (get is-active heritage-data)
    false
  )
)

;; Check UNESCO status
(define-read-only (has-unesco-status (heritage-id uint))
  (match (map-get? cultural-heritage-sites { heritage-id: heritage-id })
    heritage-data (get unesco-status heritage-data)
    false
  )
)
