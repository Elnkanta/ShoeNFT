;; ShoeNFT - A platform for creating and trading limited edition shoe NFTs

(define-non-fungible-token shoe-nft uint)

;; Storage
(define-map token-uri uint (string-ascii 256))
(define-map token-metadata uint {creator: principal, model: (string-ascii 64), edition: uint})
(define-data-var last-token-id uint u0)

;; Error codes
(define-constant err-not-authorized (err u401))
(define-constant err-token-exists (err u102))
(define-constant err-token-not-found (err u103))
(define-constant err-invalid-params (err u104))

;; Core functions
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (ok (map-get? token-uri token-id))
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? shoe-nft token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    ;; Check authorization
    (asserts! (is-eq tx-sender sender) err-not-authorized)
    
    ;; Check if token exists by checking owner
    (asserts! (is-some (nft-get-owner? shoe-nft token-id)) err-token-not-found)
    
    ;; Check that sender and recipient are different
    (asserts! (not (is-eq sender recipient)) err-invalid-params)
    
    ;; Perform transfer
    (nft-transfer? shoe-nft token-id sender recipient)
  )
)

;; String validation helper
(define-private (non-empty-string (str (string-ascii 256)))
  (not (is-eq str ""))
)

;; Custom functions
(define-public (mint (recipient principal) (uri (string-ascii 256)) (model (string-ascii 64)) (edition uint))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    ;; Check authorization
    (asserts! (is-eq tx-sender contract-caller) err-not-authorized)
    
    ;; Validate string inputs
    (asserts! (non-empty-string uri) err-invalid-params)
    (asserts! (non-empty-string model) err-invalid-params)
    
    ;; Check that edition is valid
    (asserts! (> edition u0) err-invalid-params)
    
    ;; Mint the NFT
    (asserts! (is-ok (nft-mint? shoe-nft token-id recipient)) err-token-exists)
    
    ;; Store metadata - using let binding to mark as validated
    (let
      (
        (validated-uri uri)
        (validated-model model)
      )
      (map-set token-uri token-id validated-uri)
      (map-set token-metadata token-id {creator: tx-sender, model: validated-model, edition: edition})
    )
    
    ;; Update last token ID
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (ok (map-get? token-metadata token-id))
)