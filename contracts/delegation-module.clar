;; contracts/delegation-module.clar
;; Handles the logic for delegated voting power.

(define-map delegations 
    ;; key: the address delegating their vote (voter)
    principal
    ;; value: the address they are delegating to (delegate)
    principal
)

(define-public (delegate-vote (delegatee principal))
  (ok (map-set delegations tx-sender delegatee))
)

(define-public (undelegate-vote)
  (ok (map-delete delegations tx-sender))
)

(define-read-only (get-delegatee (voter principal))
  (ok (map-get? delegations voter))
)

;; --- Clarity 4.0 Trait Implementation ---
;; This contract fulfills the `can-vote-trait` requirements.
;; It calculates the total voting power of a delegatee.

(define-read-only (get-voting-power (delegatee principal))
  (let 
    (
      ;; Get the delegatee's own token balance
      (self-power (unwrap-response-panic (contract-call? 'SP000000000000000000002Q6VF78.governance-token get-balance delegatee)))
      (delegated-power (fold 
                          ;; The function to apply on each iteration
                          (lambda (voter power) 
                            (let 
                              (
                                (voter-delegatee (unwrap-default (map-get? delegations voter) voter))
                              )
                              ;; Only add power if the voter has delegated to the principal address
                              (if (is-eq voter-delegatee delegatee)
                                (unwrap-response-panic (contract-call? 'SP000000000000000000002Q6VF78.governance-token get-balance voter))
                                power
                              )
                            )
                          )
                          ;; Initial accumulator value (start with delegatee's own balance)
                          self-power
                          ;; The list of all principals (in a real-world scenario, this would be an iterable list of all token holders)
                          (list-of 'SP000000000000000000002Q6VF78 'ST1PQHQKV0PEHP7PVYDG5XJ0PXXQ9AHT6T932X5J5) 
                          ;; NOTE: In a real environment, you would use an iterable list of all token holders. 
                          ;; For Clarinet simulation, we use a placeholder list of known principals.
                        )
    )
  )
  (ok delegated-power)
)
