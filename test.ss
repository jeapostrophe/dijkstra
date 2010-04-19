#lang scheme
(require "main.ss")

(define-struct edge (end weight))

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

; From http://en.wikipedia.org/wiki/Dijkstra's_algorithm
(define g (create-graph))
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

"Should be (1 2 3) and 18"

(define-values (dist prev) (graph-shortest-path g 1))
(shortest-path-to prev 10)
(hash-ref dist 10)

(define-values (dist2 prev2) (graph-shortest-path g 1 (lambda (n) (= n 10))))
(shortest-path-to prev2 10)
(hash-ref dist2 10)
