#lang racket

(require scope-operations)
(provide scopes/c
         →scopes
         →scopes*
         ->scopes
         ->scopes*
         (rename-out [empty-scopes scopes0]
                     [scopes-add scopes+]
                     [scopes-add scopes∪]
                     [scopes-remove scopes-]
                     [scopes-flip scopes~]
                     [scopes-intersect scopes∩]
                     [scopes-symmetric-difference scopesΔ]
                     [scopes-symmetric-difference scopes⊖]
                     [scopes-symmetric-difference scopes⊕])
         single-scope?
         scope-kind
         use-site-scope?
         macro-scope?
         module-scope?
         intdef-scope?
         local-scope?
         top-scope?)