;- Procedure: symbol-length
;- Input : Takes only one parameter named inSym
;- Output : Returns the number of items in the symbol.
; If the input is not a symbol, then it returns 0. 
;- Examples :
; (symbol-length 'a) ------> returns 1
; (symbol-length 'abc) ----> returns 3 
; (symbol-length 123) -----> returns 0 
; (symbol-length '(a b)) --> returns 0 
(define symbol-length 
        (lambda (inSym) 
               (if (symbol? inSym) 
                       (string-length (symbol->string inSym)) 
                0 
                ) 
        ) 
)

;- Procedure: sequence? 
;- Input : Takes only one parameter named inSeq 
;- Output : Returns true if inSeq is a list of symbols where each 
; symbol is of length 1 
;- Examples : 
; (sequence? '(a b c)) ----> returns true 
; (sequence? '()) ---------> returns true 
; (sequence? '(aa b c)) ---> returns false since aa has length 2 
; (sequence? '(a 1 c)) ----> returns false since 1 is not a symbol 
; (sequence? '(a (b c))) --> returns false since (b c) is not a symbol 
; (sequence? 'a) --> returns false since a is not a list 
(define sequence? 
    (lambda (inSeq)
        (cond
            ((not (list? inSeq)) #f)
            ((null? inSeq) #t)
            ((and (symbol? (car inSeq)) (= (symbol-length (car inSeq)) 1))
                (sequence? (cdr inSeq)))
            (else #f)
        )
    )
)

;- Procedure: same-sequence? 
;- Input : Takes two sequences inSeq1 inSeq2 as input 
;- Output : Returns true if inSeq1 and inSeq2 are sequences and they are the 
; same sequence. 
;- Examples : 
; (same-sequence? '(a b c) '(a b c)) --> return true 
; (same-sequence? '() '()) ------------> return true 
; (same-sequence? '(a b c) '(b a c)) --> returns false 
; (same-sequence? '(a b c) '(a b)) ----> returns false 
; (same-sequence? '(aa b) '(a b c)) ---> produces an error 
(define same-sequence? 
    (lambda (inSeq1 inSeq2)
        (cond
            ((not (sequence? inSeq1)) (display "ERROR305: First parameter is not a valid sequence") (newline))
            ((not (sequence? inSeq2)) (display "ERROR305: Second parameter is not a valid sequence") (newline))
            ((and (null? inSeq1) (null? inSeq2)) #t)
            ((or (null? inSeq1) (null? inSeq2)) #f)
            ((eq? (car inSeq1) (car inSeq2))
                (same-sequence? (cdr inSeq1) (cdr inSeq2)))
            (else #f)
        )
    )
)

;- Procedure: reverse-sequence 
;- Input : Takes only one parameter named inSeq 
;- Output : It returns the reverse of inSeq if inSeq is a sequence. Otherwise 
; it produces an error. 
;- Examples : 
; (reverse-sequence '(a b c)) --> returns (c b a) 
; (reverse-sequence '()) -------> returns () 
; (reverse-sequence '(aa b)) ---> produces an error 
(define reverse-sequence 
    (lambda (inSeq)
        (cond
            ((not (sequence? inSeq)) (display "ERROR305: Input is not a valid sequence") (newline))
            (else (reverse-helper inSeq '()))
        )
    )
)

(define reverse-helper
    (lambda (lst result)
        (if (null? lst)
            result
            (reverse-helper (cdr lst) (cons (car lst) result))
        )
    )
)

;- Procedure: palindrome? 
;- Input : Takes only one parameter named inSeq 
;- Output : It returns true if inSeq is a sequence and it is a palindrome. 
; It returns false if inSeq is a sequence but not a palindrome. 
; Otherwise, i.e. if inSeq is not a sequence it gives an error. 
;- Examples : 
; (palindrome? '(a b a)) --> returns true 
; (palindrome? '(a a a)) --> returns true 
; (palindrome? '()) -------> returns true 
; (palindrome? '(a a b)) --> returns false 
; (palindrome? '(a 1 a)) --> produces an error 
(define palindrome? 
    (lambda (inSeq)
        (cond
            ((not (sequence? inSeq)) (display "ERROR305: Input is not a valid sequence") (newline))
            (else (same-sequence? inSeq (reverse-sequence inSeq)))
        )
    )
)

;- Procedure: member? 
;- Input : Takes a symbol named inSym and a sequence named inSeq 
;- Output : It returns true if inSeq is a sequence and inSym is a symbol 
; and inSym is one of the symbols in inSeq. It returns false if inSeq is a sequence 
; and inSym is a symbol but inSym is not one of the symbols in inSeq. 
;- Examples : ; (member? 'b '(a b c)) ---> returns true 
; (member? 'd '(a b c)) ---> returns false 
; (member? 'd '()) --------> returns false 
; (member? 'aa '(a b c)) ---> produces an error 
; (member? 5 '(a 5 c)) ----> produces an error 
; (member? 'd '(aa b c)) --> produces an error
(define member? 
    (lambda (inSym inSeq)
        (cond
            ((not (symbol? inSym)) (display "ERROR305: First parameter is not a symbol") (newline))
            ((not (sequence? inSeq)) (display "ERROR305: Second parameter is not a valid sequence") (newline))
            ((not (= (symbol-length inSym) 1)) (display "ERROR305: Symbol is not of length 1") (newline))
            ((null? inSeq) #f)
            ((eq? inSym (car inSeq)) #t)
            (else (member? inSym (cdr inSeq)))
        )
    )
)

;- Procedure: remove-member 
;- Input : Takes a symbol named inSym and a sequence named inSeq 
;- Output : If inSym is a symbol and inSeq is a sequence and inSym is one of 
; the symbols in inSeq, then remove-member returns the sequence 
; which is the same as the sequence inSeq, where the first occurrence of 
; inSym is removed. For any other case, it produces an error. 
;- Examples : 
; (remove-member 'b '(a b b c b)) --> returns (a b c b) 
; (remove-member 'd '(a b c)) ------> produces an error 
; (remove-member 'b '()) -----------> produces an error 
; (remove-member 'b '(a b 5 c)) ----> produces an error 
; (remove-member 5 '(a b c)) -------> produces an error 
(define remove-member 
    (lambda (inSym inSeq)
        (cond
            ((not (symbol? inSym)) (display "ERROR305: First parameter is not a symbol") (newline))
            ((not (sequence? inSeq)) (display "ERROR305: Second parameter is not a valid sequence") (newline))
            ((not (= (symbol-length inSym) 1)) (display "ERROR305: Symbol is not of length 1") (newline))
            ((null? inSeq) (display "ERROR305: Symbol not found in sequence") (newline))
            ((not (member? inSym inSeq)) (display "ERROR305: Symbol not found in sequence") (newline))
            ((eq? inSym (car inSeq)) (cdr inSeq))
            (else (cons (car inSeq) (remove-member inSym (cdr inSeq))))
        )
    )
)

;- Procedure: anagram? 
;- Input : Takes two sequences inSeq1 and inSeq2 as paramaters. 
;- Output : If inSeq1 and inSeq2 are both sequences and if inSeq1 is an 
; anagram of inSeq2, then anagram? returns true. 
;- Examples : 
; (anagram? '(m a r y) '(a r m y)) --> returns true 
; (anagram? '() '()) ----------------> returns true 
; (anagram? '(a b b) '(b a a)) ------> returns false 
; (anagram? '(a b b) '()) -----------> returns false 
; (anagram? '(a bb) '(a bb)) --------> produces an error 
; (anagram? 5 '(a b b)) -------------> produces an error 
(define anagram? 
    (lambda (inSeq1 inSeq2)
        (cond
            ((not (sequence? inSeq1)) (display "ERROR305: First parameter is not a valid sequence") (newline))
            ((not (sequence? inSeq2)) (display "ERROR305: Second parameter is not a valid sequence") (newline))
            ((and (null? inSeq1) (null? inSeq2)) #t)
            ((not (= (length inSeq1) (length inSeq2))) #f)
            (else (anagram-helper inSeq1 inSeq2))
        )
    )
)

(define anagram-helper
    (lambda (seq1 seq2)
        (cond
            ((null? seq1) #t)
            ((not (member? (car seq1) seq2)) #f)
            (else (anagram-helper (cdr seq1) (remove-member (car seq1) seq2)))
        )
    )
)

;- Procedure: unique-symbols 
;- Input : Takes a sequence named inSeq 
;- Output : Returns a sequence containing only the unique symbols from inSeq in the 
; order of the first occurrence of the symbols. 
;- Examples : 
; (unique-symbols '(a b a c)) ----------> returns (a b c) 
; (unique-symbols '(a b a b c b a)) ----------> returns (a b c) 
; (unique-symbols '()) --------------------> returns () 
; (unique-symbols '(a a a)) --> returns (a) 
; (unique-symbols '(a b 5 c)) ------> produces an error 
(define unique-symbols 
    (lambda (inSeq)
        (cond
            ((not (sequence? inSeq)) (display "ERROR305: Input is not a valid sequence") (newline))
            ((null? inSeq) '())
            ((member? (car inSeq) (cdr inSeq))
                (unique-symbols (cdr inSeq)))
            (else
                (cons (car inSeq) (unique-symbols (cdr inSeq))))
        )
    )
)

;- Procedure: count-occurrences 
;- Input : Takes a symbol named inSym and a sequence named inSeq 
;- Output : Returns the number of times inSym appears in inSeq. 
;- Examples : 
; (count-occurrences 'a '(a b a c) ----------> returns 2 
; (count-occurrences 'b '(a b a c)) --------------------> returns 1 
; (count-occurrences 'd '(a b a c))) --> returns 0 
; (count-occurrences 5 '(a b a c)) ------> produces an error 
; (count-occurrences 'a '(aa (b a))) ------> produces an error 
(define count-occurrences 
    (lambda (inSym inSeq)
        (cond
            ((not (symbol? inSym)) (display "ERROR305: First parameter is not a symbol") (newline))
            ((not (sequence? inSeq)) (display "ERROR305: Second parameter is not a valid sequence") (newline))
            ((not (= (symbol-length inSym) 1)) (display "ERROR305: Symbol is not of length 1") (newline))
            ((null? inSeq) 0)
            ((eq? inSym (car inSeq))
                (+ 1 (count-occurrences inSym (cdr inSeq))))
            (else (count-occurrences inSym (cdr inSeq)))
        )
    )
)

;- Procedure: anapoli? 
;- Input : Takes a sequence inSeq1 as parameter. 
;- Output : If inSeq1 is not a sequence, it produces an error. 
; When inSeq1 is sequence, it returns true, if inSeq1 is an anagram 
; of any palindrome. In other words, if it is possible to rearrange 
; the symbols in inSeq1 to obtain a palindrome sequence, it returns true. 
;- Examples : 
; (anapoli? '(a b b)) ----------> returns true since we can obtain bab 
; (anapoli? '()) --------------------> returns true 
; (anapoli? '(d a m a m)) --> returns true since we can obtain madam
; (anapoli? '(a b b c)) ------> returns false 
; (anapoli? '(aa bb b c)) ------> produces an error 
; (anapoli? '(5 a bb)) --------------------> produces an error
(define anapoli? 
    (lambda (inSeq1)
        (cond
            ((not (sequence? inSeq1)) (display "ERROR305: Input is not a valid sequence") (newline))
            ((null? inSeq1) #t)
            (else (check-anapoli inSeq1 (unique-symbols inSeq1)))
        )
    )
)

(define check-anapoli
    (lambda (seq unique-seq)
        (cond
            ((null? unique-seq) #t)
            ((= (remainder (count-occurrences (car unique-seq) seq) 2) 0)
                (check-anapoli seq (cdr unique-seq)))
            (else
                (check-odd-center seq (cdr unique-seq) 1))
        )
    )
)

(define check-odd-center
    (lambda (seq unique-seq odd-count)
        (cond
            ((> odd-count 1) #f)
            ((null? unique-seq) #t)
            ((= (remainder (count-occurrences (car unique-seq) seq) 2) 0)
                (check-odd-center seq (cdr unique-seq) odd-count))
            (else
                (check-odd-center seq (cdr unique-seq) (+ odd-count 1)))
        )
    )
)
