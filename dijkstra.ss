#lang scheme
(require (planet jaymccarthy/fib-heap))

; http://en.wikipedia.org/wiki/Dijkstra's_algorithm

(define (shortest-path neighbors weight next src [stop? (lambda (n) #f)])
  (define dist (make-hash))
  (define visited (make-hash))
  (define previous (make-hash))
  (define queue (make-fib-heap (lambda (n1 n2) (< (hash-ref dist n1 +inf.0) (hash-ref dist n2 +inf.0)))))
  (hash-set! dist src 0)
  (fib-heap-insert! queue src)
  (let/ec esc
    (fib-heap-for-each! 
     queue
     (lambda (current)
       (let ([distance (hash-ref dist current)])
         (when (stop? current)
           (esc (void)))
         (unless (hash-ref visited current #f)
           (hash-set! visited current #t)
           (for ([e (in-list (neighbors current))])
             (define relaxed (+ distance (weight e)))
             (define end (next e))
             (define ed (hash-ref dist end #f))
             (when (or (not ed) (< relaxed ed))
               (hash-set! previous end current)
               (hash-set! dist end relaxed)
               (fib-heap-insert! queue end))))))))
  (values dist previous))

(define (shortest-path-to prev end)
  (reverse
   (let loop ([cur end])
     (let ([cp (hash-ref prev cur #f)])
       (if cp
           (list* cp (loop cp))
           empty)))))

(define node? any/c)
(define edge? any/c)
(define neighbors/c (node? . -> . (listof edge?)))
(define weight/c (edge? . -> . number?))
(define next/c (edge? . -> . node?))
(define stop?/c (node? . -> . boolean?))
(provide/contract
 [shortest-path (neighbors/c weight/c next/c node? stop?/c . -> . (values hash? hash?))]
 [shortest-path-to (hash? node? . -> . (listof node?))])