;; traits/can-vote.clar
;; Defines the trait for any contract that provides voting power data to the DAO.

(define-trait can-vote-trait
  (
    ;; get-voting-power: Returns the total voting power for a given principal.
    (get-voting-power (voter principal) (response uint))
  )
)
