;; ShoeNFT - A platform for creating and trading limited edition shoe NFTs
;; This contract implements the SIP-009 NFT standard

(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

(define-non-fungible-token shoe-nft uint)

;; Storage
(define-map token-uri uint (string-ascii 256))
(define-map token-metadata uint {creator: principal, model: (string-ascii 64), edition: uint})
(define-data-var last-token-id uint u0)

;; Error codes
(define-constant err-not-authorized (err u401))
(define-constant err-token-exists (err u102))
(define-constant err-token-not-found (err u103))

;; SIP-009 functions
(define-public (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-public (get-token-uri (token-id uint))
  (ok (map-get? token-uri token-id))
)

(define-public (get-owner (token-id uint))
  (ok (nft-get-owner? shoe-nft token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-authorized)
    (nft-transfer? shoe-nft token-id sender recipient)
  )
)

;; Custom functions
(define-public (mint (recipient principal) (uri (string-ascii 256)) (model (string-ascii 64)) (edition uint))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-eq tx-sender (contract-caller)) err-not-authorized)
    (try! (nft-mint? shoe-nft token-id recipient))
    (map-set token-uri token-id uri)
    (map-set token-metadata token-id {creator: tx-sender, model: model, edition: edition})
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-read-only (get-token-metadata (token-id uint))
  (ok (map-get? token-metadata token-id))
)