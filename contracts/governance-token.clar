;; contracts/governance-token.clar
;; A basic fungible token used as the governance asset.

(define-fungible-token gov-token)

;; constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant CONTRACT-OWNER tx-sender)

;; data map for balances is internal to define-fungible-token

(define-read-only (get-balance (owner principal))
  (ok (ft-get-balance gov-token owner))
)

;; Mint function (only callable by the owner)
(define-public (mint (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ft-mint? gov-token amount recipient)
  )
)

;; Transfer function
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (ft-transfer? gov-token amount sender recipient)
)

;; Total supply
(define-read-only (get-total-supply)
  (ok (ft-get-supply gov-token))
)
