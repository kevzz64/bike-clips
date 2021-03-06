;; =======================================
;; =========      C R E D I T S   ========
;; =======================================
;;	Kevin Schaap
;;	Rafael Lobato
;;

(defglobal ?*nod-gen* = 0)
(defglobal ?*last* = null)
(defglobal ?*end* = null)
(defglobal ?*stations* = (create$ A B J H K M R N))

(deffacts city
(path A B 10 bike)
(path A B 10 foot)
(path A C 8 foot)
(path A E 10 bike)
(path A E 10 foot)
(path B A 10 bike)
(path B A 10 foot)
(path B F 6 foot)
(path B C 5 foot)
(path C A 8 foot)
(path C D 6 foot)
(path C B 5 foot)
(path C G 6 foot)
(path C H 6 foot)
(path D C 6 foot)
(path D H 14 bike)
(path D H 14 foot)
(path E A 10 bike)
(path E A 10 foot)
(path E I 20 foot)
(path E J 9 bike)
(path E J 9 foot)
(path F B 6 bike)
(path F K 10 foot)
(path F L 6 foot)
(path G C 6 foot)
(path G L 9 foot)
(path G H 8 foot)
(path G M 12 foot)
(path H G 8 foot)
(path H D 14 bike)
(path H D 14 foot)
(path H C 6 foot)
(path H I 12 bike)
(path H I 12 foot)
(path I H 12 bike)
(path I E 20 foot)
(path I O 2 foot)
(path J E 9 bike)
(path J O 7 foot)
(path J O 7 bike)
(path K L 2 bike)
(path K F 10 foot)
(path L K 2 foot)
(path L K 2 bike)
(path L F 6 bike)
(path L M 7 bike)
(path L M 7 foot)
(path L G 9 foot)
(path L P 6 bike)
(path L P 6 foot)
(path L F 6 bike)
(path M L 7 bike)
(path M G 12 foot)
(path M Q 2 foot)
(path N Q 6 foot)
(path N O 8 bike)
(path N O 8 foot)
(path O I 2 foot)
(path O J 7 bike)
(path O J 7 foot)
(path O N 8 bike)
(path O N 8 foot)
(path P L 6 bike)
(path P L 6 foot)
(path P Q 2 foot)
(path P R 4 bike)
(path P R 4 foot)
(path Q P 2 foot)
(path Q R 3 foot)
(path Q M 2 foot)
(path Q N 6 foot)
(path R P 4 bike)
(path R P 4 foot)
(path R Q 3 foot)

(stations A B J H K M R N)
(neighbourhoods A1 B2 C2 D2 E2 J2 F3 G3 H3 I3 O3 K4 L4 M4 N4 P5 Q5 R6))

(defrule walking
?f<-(person ?initial bike ?bike cost ?c level ?level)
(max-depth ?depth)
(test (< ?level ?depth))
(test (eq ?bike NO))
(path ?initial ?to ?cost ?method)
(test (neq ?initial ?to)) 
(test (neq ?*last* ?to)) 
=>
(assert (person ?to bike ?bike cost (+ ?c ?cost) level (+ ?level 1)))
(bind ?*nod-gen* (+ ?*nod-gen* 1))
(bind ?*last* ?initial))

(defrule cycling
?f<-(person ?initial bike ?bike cost ?c level ?level)
(max-depth ?depth)
(test (< ?level ?depth))
(path ?initial ?to ?cost bike)
(test (eq ?bike YES))
=>
(assert (person ?to bike YES cost (+ ?c (div ?cost 2)) level (+ ?level 1)))
(bind ?*nod-gen* (+ ?*nod-gen* 1))
(bind ?*last* ?initial))

(defrule drop-bike

?f<-(person ?initial bike ?bike cost ?c level ?level)
(max-depth ?depth)
(test (< ?level ?depth))
;; test if person state has bike
(test (eq ?bike YES))
;; test if initial point is bike point
(test (member$ ?initial ?*stations*))
=>
(printout t "Dropping bike.." crlf)
;; change person state to walk
(assert (person ?initial bike NO cost (+ ?c 1) level ?level)))

(defrule take-bike

?f<-(person ?initial bike ?bike cost ?c level ?level)
(max-depth ?depth)
(test (< ?level ?depth))
;; test if person state has bike
(test (eq ?bike NO))
;; test if inital point is bike point
(test (member$ ?initial ?*stations*))
=>
(printout t "Taking a bike..")
;; change person state to cycling
(assert (person ?initial bike YES cost (+ ?c 1) level ?level)))

;; ========================================================
;; =========      S E A R C H   S T R A T E G Y    ========
;; ========================================================
;; The goal rule is used to detect when the goal state has been reached 

(defrule goal
    (declare (salience 100))
    (destination ?end)
    ?f<-(person ?end bike ?bike cost ?cost level ?level)
   =>
    (printout t "SOLUTION FOUND AT LEVEL: " ?level crlf)
    (printout t "COST OF REACHING GOAL STATE: " ?cost crlf)
    (printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES: " ?*nod-gen* crlf)
    (printout t "GOAL FACT: " ?f crlf)
    
    (halt))

(deffunction start ()
 (set-salience-evaluation when-activated)
 (reset)
 (printout t "Maximum depth:= " )
 (bind ?depth (read))  		
 (printout t "Where do we start?" crlf)
 (bind ?start(read))
 (printout t "Where do we end?" crlf)
 (bind ?end(read))
 (assert (destination ?end))
 (printout t " Execute run to start the program " crlf)

 (assert (person ?start bike YES cost 0 level 0))
 (assert (max-depth ?depth)))