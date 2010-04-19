#lang scribble/doc
@(require (planet cce/scheme:4:1/planet)
          scribble/manual
          (for-label scheme
                     "main.ss"))

@title{Dijkstra's Algorithm}
@author{@(author+email "Jay McCarthy" "jay@plt-scheme.org")}

@defmodule/this-package[]

This package provides an implementation of @link["http://en.wikipedia.org/wiki/Dijkstra's_algorithm"]{Dijkstra's Algorithm} that uses a
@link["http://en.wikipedia.org/wiki/Fibonacci_heap"]{Fibonacci heap} for the queue.

@defproc[(shortest-path [node-edges (any/c . -> . (listof any/c))]
                        [edge-weight (any/c . -> . number?)]
                        [edge-next (any/c . -> . node?)]
                        [start any/c]
                        [stop? (any/c . -> . boolean?) (lambda (n) #f)])
         (values hash? hash?)]{
 Starts the algorithm at @scheme[start] using @scheme[node-edges] to determine a node's edges @scheme[edge-weight] to find the weight
 of the edge and @scheme[edge-next] to find the node at the end of an edge. The search is stopped if @scheme[stop?] returns @scheme[#t]
 on the minimum element in the queue (so you can pass @scheme[(lambda (n) (= n target))] to have a directed search.)
 
 The return values are first a hash table mapping nodes to their distance from @scheme[start] and second a hash table mapping nodes to the
 previous node on the shortest path.
}
                              
@defproc[(shortest-path-to [previous hash?]
                           [target any/c])
         (listof node?)]{
 Uses @scheme[previous] (the second return value from @scheme[shortest-path]) to trace a path from the @scheme[_start] to @scheme[target].
}

@section{Example}

@(require scribble/eval)
@(define the-eval
  (let ([the-eval (make-base-eval)])
    (the-eval `(require scheme/list))
    (the-eval `(require (planet ,(this-package-version-symbol))))
    the-eval))

@defs+int[#:eval the-eval
((define-struct edge (end weight))
(define-struct graph (adj))

(define (create-graph)
  (make-graph (make-hasheq)))
(define (graph-add! g start end [weight 0])
  (hash-update! (graph-adj g)
                start
                (lambda (old)
                  (list* (make-edge end weight) old))
                empty))
(define (graph-shortest-path g src [stop? (lambda (n) #f)])
  (shortest-path (lambda (n) (hash-ref (graph-adj g) n empty))
                 edge-weight
                 edge-end
                 src
                 stop?))
(define g (create-graph)))
(graph-add! g 1 2 4)
(graph-add! g 1 4 1)
(graph-add! g 2 1 74)
(graph-add! g 2 3 2)
(graph-add! g 2 5 12)
(graph-add! g 3 2 12)
(graph-add! g 3 10 12)
(graph-add! g 3 6 74)
(graph-add! g 4 7 22)
(graph-add! g 4 5 32)
(graph-add! g 5 8 33)
(graph-add! g 5 4 66)
(graph-add! g 5 6 76)
(graph-add! g 6 10 21)
(graph-add! g 6 9 11)
(graph-add! g 7 3 12)
(graph-add! g 7 8 10)
(graph-add! g 8 7 2)
(graph-add! g 8 9 72)
(graph-add! g 9 10 7)
(graph-add! g 9 6 31)
(graph-add! g 9 8 18)
(graph-add! g 10 6 8)

(define-values (dist1 prev1)
  (graph-shortest-path g 1))
(shortest-path-to prev1 10)
(hash-ref dist1 10)

(define-values (dist2 prev2) 
  (graph-shortest-path g 1 (lambda (n) (= n 10))))
(shortest-path-to prev2 10)
(hash-ref dist2 10)
]