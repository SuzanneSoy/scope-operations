#lang racket

(provide scopes/c
         →scopes
         →scopes*
         (rename-out [→scopes ->scopes]
                     [→scopes* ->scopes*])
         empty-scopes
         scopes-add
         scopes-remove
         scopes-flip
         scopes-intersect
         (rename-out [scopes-flip scopes-symmetric-difference])
         single-scope?
         scope-kind
         use-site-scope?
         macro-scope?
         module-scope?
         intdef-scope?
         local-scope?
         top-scope?)

(define scopes/c
  (->* (syntax?) ([or/c 'add 'remove 'flip]) syntax?))

(define/contract (→scopes stx)
  (-> syntax? scopes/c)
  (make-syntax-delta-introducer (datum->syntax stx 'stx)
                                (datum->syntax #f 'zero)))

(define/contract empty-scopes
  scopes/c
  (→scopes (datum->syntax #f 'zero)))

(define/contract (→scopes* stx)
  (-> (or/c syntax? scopes/c) scopes/c)
  (if (syntax? stx)
      (→scopes stx)
      stx))

(define/contract (scopes-add sc1 sc2)
  (-> (or/c syntax? scopes/c) (or/c syntax? scopes/c) scopes/c)
  (→scopes ((→scopes* sc1) ((→scopes* sc2) empty-scopes)
                           'add)))

(define/contract (scopes-remove sc1 sc2)
  (-> (or/c syntax? scopes/c) (or/c syntax? scopes/c) scopes/c)
  (→scopes ((→scopes* sc1) ((→scopes* sc2) empty-scopes)
                           'remove)))

(define/contract (scopes-flip sc1 sc2)
  (-> (or/c syntax? scopes/c) (or/c syntax? scopes/c) scopes/c)
  (→scopes ((→scopes* sc1) ((→scopes* sc2) empty-scopes)
                           'flip)))

(define/contract (scopes-intersect sc1 sc2)
  (-> (or/c syntax? scopes/c) (or/c syntax? scopes/c) scopes/c)
  (scopes-remove sc1 (scopes-remove sc1 sc2)))

#;(define/contract (scopes-symmetric-difference sc1 sc2)
    (-> (or/c syntax? scopes/c) (or/c syntax? scopes/c) scopes/c)
    (scopes-add (scopes-remove sc1 sc2)
                (scopes-remove sc2 sc1)))

(define/contract (single-scope? sc)
  (-> (or/c syntax? scopes/c) boolean?)
  (= (length (hash-ref (syntax-debug-info ((→scopes* sc) empty-scopes))
                       'context))))

(define/contract (scope-kind sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) symbol?)
  (define stx ((→scopes* sc) empty-scopes))
  (vector-ref (list-ref (hash-ref (syntax-debug-info stx) 'context) 0) 1))

(define/contract (use-site-scope? sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) boolean?)
  (eq? (scope-kind sc) 'use-site))

(define/contract (macro-scope? sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) boolean?)
  (eq? (scope-kind sc) 'macro))

(define/contract (module-scope? sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) boolean?)
  (eq? (scope-kind sc) 'module))

(define/contract (intdef-scope? sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) boolean?)
  (eq? (scope-kind sc) 'intdef))

(define/contract (local-scope? sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) boolean?)
  (eq? (scope-kind sc) 'local))

;; Untested, I've seen this once, but can't remember where exactly. I think it
;; occured while expanding a module with local-expand, and injecting the
;; expanded body somewhere else.
(define/contract (top-scope? sc)
  (-> (and/c (or/c syntax? scopes/c) single-scope?) boolean?)
  (eq? (scope-kind sc) 'top))