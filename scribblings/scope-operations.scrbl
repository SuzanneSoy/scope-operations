#lang scribble/manual
@require[@for-label[scope-operations
                    racket/base]]

@title{scope-operations}
@author{georges}

@defmodule[scope-operations]

@defproc[(scopes/c [v any/c]) boolean?]{                                       
 Contract which recognizes a set of scopes, represented as an introducer
 function. Equivalent to:
 @racketblock[(->* (syntax?)
                   ([or/c 'add 'remove 'flip])
                   syntax?)]
}

@defproc*[(((→scopes [stx syntax?]) scopes/c)
           ((->scopes [stx syntax?]) scopes/c))]{
 Extracts the scopes present on the topmost syntax object of @racket[stx].
 This is equivalent to:

 @racket[
 (make-syntax-delta-introducer (datum->syntax stx 'stx)
                               (datum->syntax #f 'zero))]

 Unlike a @racket[make-syntax-delta-introducer], this procedure does not
 expect a second argument (always creating an introducer for all the scopes
 present on @racket[stx]), and works on syntax objects which are not
 identifiers.}

@defproc*[(((→scopes* [stx (or/c syntax? scopes/c)]) scopes/c)
           ((->scopes* [stx (or/c syntax? scopes/c)]) scopes/c))]{
 Lenient version of @racket[→scopes], which acts as a no-op when passed a set
 of scopes, instead of raising an error.}

@defthing[empty-scopes]{
 The empty set of scopes, as produced by:
 @racketblock[(→scopes (datum->syntax #f 'zero))]
}

@defproc[(scopes-add [sc1 (or/c syntax? scopes/c)]
                     [sc2 (or/c syntax? scopes/c)])
         scopes/c]{Set union of the given sets of scopes.}

@defproc[(scopes-remove [sc1 (or/c syntax? scopes/c)]
                        [sc2 (or/c syntax? scopes/c)])
         scopes/c]{Set difference of the given sets of scopes.

 The resulting set of scopes contains all the scopes present in @racket[sc1]
 which are not present in @racket[sc2].}

@defproc*[(((scopes-flip [sc1 (or/c syntax? scopes/c)]
                         [sc2 (or/c syntax? scopes/c)])
            scopes/c)
           ((scopes-symmetric-difference [sc1 (or/c syntax? scopes/c)]
                                         [sc2 (or/c syntax? scopes/c)])
            scopes/c))]{

 Flips the scopes in @racket[sc2] on the @racket[sc1] set of scopes.
 
 The resulting set of scopes contains all the scopes present in @racket[sc1]
 which are not present in @racket[sc2], as well as the scopes present in
 @racket[sc2] which were not present in @racket[sc1].

 Flipping the @racket[sc2] scopes on @racket[sc1] has the same effect as
 computing the symmetric difference of the two sets of scopes.}

@defproc[(scopes-intersect [sc1 (or/c syntax? scopes/c)]
                           [sc2 (or/c syntax? scopes/c)])
         scopes/c]{Set intersection of the given sets of scopes.}


@defproc[(single-scope? [sc (or/c syntax? scopes/c)]) boolean?]{
 Predicate which returns @racket[#true] iff the given set of scopes contains
 only a single scope.}

@defproc[(scope-kind [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         symbol?]{
 Returns the kind of the single scope in @racket[sc]. To my knowledge, this
 will be one of @racket[use-site], @racket[macro], @racket[module],
 @racket[intdef], @racket[local] or @racket[top].}

@defproc[(use-site-scope? [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         boolean?]{A shorthand for @racket[(eq? (scope-kind sc) 'use-site)]}
@defproc[(macro-scope? [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         boolean?]{A shorthand for @racket[(eq? (scope-kind sc) 'macro)]}
@defproc[(module-scope? [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         boolean?]{A shorthand for @racket[(eq? (scope-kind sc) 'module)]}
@defproc[(intdef-scope? [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         boolean?]{A shorthand for @racket[(eq? (scope-kind sc) 'intdef)]}
@defproc[(local-scope? [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         boolean?]{A shorthand for @racket[(eq? (scope-kind sc) 'local)]}
@defproc[(top-scope? [sc (and/c (or/c syntax? scopes/c) single-scope?)])
         boolean?]{A shorthand for @racket[(eq? (scope-kind sc) 'top)]}
