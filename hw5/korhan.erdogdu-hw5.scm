;; CS305 Homework 5 - Scheme s7 Interpreter
;; Author: Korhan Erdogdu
;; 
;; This interpreter implements the s7 subset of Scheme with:
;; - Numbers and variables
;; - Define expressions
;; - Let expressions with lexical scoping
;; - Lambda expressions (closures)
;; - Arithmetic operators (+, -, *, /)
;; - Proper error handling without crashing

;; ============================================
;; Environment Implementation
;; ============================================

;; Frame representation: (variables . values)
(define (make-frame vars vals)
  (cons vars vals))

(define (frame-vars frame)
  (car frame))

(define (frame-vals frame)
  (cdr frame))

(define (add-binding! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

;; Environment operations
(define (extend-env vars vals env)
  (cons (make-frame vars vals) env))

(define the-empty-env '())

(define (first-frame env) (car env))
(define (rest-env env) (cdr env))
(define (empty-env? env) (null? env))

;; Variable lookup in environment
(define (lookup var env)
  (define (scan vars vals)
    (cond ((null? vars) (lookup var (rest-env env)))
          ((eq? var (car vars)) (car vals))
          (else (scan (cdr vars) (cdr vals)))))
  (if (empty-env? env)
      'error
      (let ((frame (first-frame env)))
        (scan (frame-vars frame) (frame-vals frame)))))

;; Define/update variable in environment
(define (define-var! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars) (add-binding! var val frame))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-vars frame) (frame-vals frame))))

;; ============================================
;; Helper Functions
;; ============================================

;; Check for duplicate elements in a list
(define (has-duplicates? lst)
  (cond ((null? lst) #f)
        ((member (car lst) (cdr lst)) #t)
        (else (has-duplicates? (cdr lst)))))

;; Check if all elements are symbols
(define (all-symbols? lst)
  (cond ((null? lst) #t)
        ((not (symbol? (car lst))) #f)
        (else (all-symbols? (cdr lst)))))

;; Check if all elements are numbers
(define (all-numbers? lst)
  (cond ((null? lst) #t)
        ((not (number? (car lst))) #f)
        (else (all-numbers? (cdr lst)))))

;; Left-associative fold for arithmetic operations
(define (fold-left op init lst)
  (if (null? lst)
      init
      (fold-left op (op init (car lst)) (cdr lst))))

;; ============================================
;; Main Evaluator
;; ============================================

(define (s7-eval expr env)
  (cond
    ;; Numbers evaluate to themselves
    ((number? expr) expr)
    
    ;; Variable lookup
    ((symbol? expr)
     (lookup expr env))
    
    ;; List expressions (special forms and applications)
    ((pair? expr)
     (let ((operator (car expr)))
       (cond
         ;; DEFINE special form
         ((eq? operator 'define)
          (handle-define expr env))
         
         ;; LET special form
         ((eq? operator 'let)
          (handle-let expr env))
         
         ;; LAMBDA special form
         ((eq? operator 'lambda)
          (handle-lambda expr env))
         
         ;; Built-in arithmetic operators
         ((memq operator '(+ - * /))
          (handle-arithmetic operator (cdr expr) env))
         
         ;; Function application
         (else
          (handle-application operator (cdr expr) env)))))
    
    ;; Everything else is an error
    (else 'error)))

;; ============================================
;; Special Form Handlers
;; ============================================

;; Handle DEFINE expressions
(define (handle-define expr env)
  (if (and (= (length expr) 3)
           (symbol? (cadr expr)))
      (let ((var (cadr expr))
            (val-expr (caddr expr)))
        (let ((val (s7-eval val-expr env)))
          (if (eq? val 'error)
              'error
              (begin
                (define-var! var val env)
                var))))
      'error))

;; Handle LET expressions
(define (handle-let expr env)
  (if (and (>= (length expr) 3)
           (list? (cadr expr)))
      (let ((bindings (cadr expr))
            (body (caddr expr)))
        ;; Empty bindings case
        (if (null? bindings)
            (s7-eval body env)
            ;; Process bindings
            (let ((result (process-let-bindings bindings env)))
              (if (eq? result 'error)
                  'error
                  (let ((vars (car result))
                        (vals (cdr result)))
                    (s7-eval body (extend-env vars vals env)))))))
      'error))

;; Process let bindings and return (vars . vals) or 'error
(define (process-let-bindings bindings env)
  (let ((vars '())
        (vals '()))
    (define (process-binding binding)
      (if (and (list? binding)
               (= (length binding) 2)
               (symbol? (car binding)))
          (let ((var (car binding))
                (val (s7-eval (cadr binding) env)))
            (if (eq? val 'error)
                'error
                (begin
                  (set! vars (cons var vars))
                  (set! vals (cons val vals))
                  #t)))
          'error))
    
    ;; Process all bindings
    (let loop ((bs bindings))
      (if (null? bs)
          (if (has-duplicates? vars)
              'error
              (cons (reverse vars) (reverse vals)))
          (let ((result (process-binding (car bs))))
            (if (eq? result 'error)
                'error
                (loop (cdr bs))))))))

;; Handle LAMBDA expressions
(define (handle-lambda expr env)
  (if (and (= (length expr) 3)
           (list? (cadr expr))
           (all-symbols? (cadr expr)))
      (list 'closure (cadr expr) (caddr expr) env)
      'error))

;; Handle arithmetic operations
(define (handle-arithmetic op operands env)
  (if (< (length operands) 2)
      'error
      (let ((vals (map (lambda (e) (s7-eval e env)) operands)))
        (if (or (member 'error vals)
                (not (all-numbers? vals)))
            'error
            ;; Apply operation based on operator symbol
            (cond
              ((eq? op '+) (apply + vals))
              ((eq? op '*) (apply * vals))
              ((eq? op '-) (fold-left - (car vals) (cdr vals)))
              ((eq? op '/) (fold-left / (car vals) (cdr vals)))
              (else 'error))))))

;; Handle function application
(define (handle-application operator operands env)
  (let ((proc (s7-eval operator env)))
    (if (eq? proc 'error)
        'error
        (if (and (list? proc)
                 (eq? (car proc) 'closure))
            (apply-closure proc operands env)
            'error))))

;; Apply a closure to arguments
(define (apply-closure closure operands env)
  (let ((params (cadr closure))
        (body (caddr closure))
        (closure-env (cadddr closure)))
    (let ((args (map (lambda (e) (s7-eval e env)) operands)))
      (if (member 'error args)
          'error
          (if (= (length params) (length args))
              (s7-eval body (extend-env params args closure-env))
              'error)))))

;; ============================================
;; Output Functions
;; ============================================

;; Print value in the required format
(define (print-value val)
  (cond ((eq? val 'error) (display "ERROR"))
        ((and (list? val) (eq? (car val) 'closure))
         (display "[PROCEDURE]"))
        (else (display val))))

;; ============================================
;; Main REPL (Read-Eval-Print Loop)
;; ============================================

(define (cs305)
  ;; Create global environment
  (define global-env (extend-env '() '() the-empty-env))
  
  ;; REPL function
  (define (repl)
    (display "cs305> ")
    (flush-output)
    (let ((input (read)))
      (if (eof-object? input)
          (newline)
          (begin
            (display "cs305: ")
            (print-value (s7-eval input global-env))
            (newline)
            (newline) ;; <-- Added new line after each output
            (repl)))))
  
  ;; Start the REPL
  (repl))

;; ============================================
;; End of interpreter code
