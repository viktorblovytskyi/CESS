(deftemplate rule
	(multislot if)
	(multislot then))

(defrule propagate-goal ""
	(goal is ?goal)
	(rule (if ?variable $?) (then ?goal ? ?value))
	=>
	(assert (goal is ?variable)))

(defrule goal-satified ""
	(declare (salience 30))
	?f <- (goal is ?goal)
	(variable ?goal ?value)
	(answer ? ?text ?goal)
	=>
	(retract ?f)
	(format t "%s%s%n" ?text ?value))

(defrule remove-rule-no-match ""
	(declare (salience 20))
	(variable ?variable ?value)
	?f <- (rule (if ?variable ? ~?value $?))
	=>
	(retract ?f))

(defrule modify-rule-match ""
	(declare (salience 20))
	(variable ?variable ?value)
	?f <- (rule (if ?variable ? ?value and $?rest))
	=>
	(modify ?f (if ?rest)))

(defrule rule-satisfied ""
	(declare (salience 20))
	(variable ?variable ?value)
	?f <- (rule (if ?variable ? ?value)
	(then ?goal ? ?goal-value))
	=>
	(retract ?f)
	(assert (variable ?goal ?goal-value)))

(defrule ask-question-legalvalues ""
	(declare (salience 10))
	(legalanswers ? $?answers)
	?f1 <- (goal is ?variable)
	?f2 <- (question ?variable ? ?text)
	=>
	(retract ?f1)
	(format t "%s " ?text)
	(printout t ?answers " ")
	(bind ?reply (read))
	(if (member (lowcase ?reply) ?answers)дув
		then (assert (variable ?variable ?reply))
		(retract ?f2)
	else (assert (goal is ?variable))))



(deffacts knowledge-base
	(goal is model.nissan)
	(legalanswers are yes no)
	(rule (if small is yes) (then car.size is small))
	(rule (if small is no) (then car.size is normal))
	(question small is "Do you need a small car?")
	(rule (if car.size is small and engine is yes) (then model.nissan is "Nissan Micra LE"))
	(rule (if car.size is small and engine is no) (then model.nissan is "Nissan Sentra"))
	(question engine is "Do you need economical car?")
	(rule (if car.size is normal and fuel is yes) (then type.nissan is diasel))
	(rule (if car.size is normal and fuel is no) (then type.nissan is other))
	(question fuel is "Do you need a car with diasel engine?")
	(rule (if type.nissan is diasel and turbo is yes) (then model.nissan is "Nissan Qashqai Diasel"))
	(rule (if type.nissan is diasel and turbo is no) (then model.nissan is "Nissan X-TRAIL"))
	(question turbo is "Do you need a car with turbo?")
	(rule (if type.nissan is other and style.nissan is yes) (then common.stylish is stylish))
	(rule (if type.nissan is other and style.nissan is no) (then common.stylish is common))
	(question style.nissan is "Do you need a stylish car?")
	(rule (if common.stylish is stylish and leather is yes) (then model.nissan is "Nissan SENTRA ELEGANCE"))
	(rule (if common.stylish is stylish and leather is no) (then model.nissan is "Nissan Murano SE"))
	(question leather is "Do you need a car with leather interior?")
	(rule (if common.stylish is common and transmission is yes) (then transmission is automatic))
	(rule (if common.stylish is common and transmission is no) (then transmission is manual))
	(question transmission is "Do you need automatic transmission?")
	(rule (if transmission is automatic and big.wheel is yes) (then model.nissan is "Nissan Patrol"))
	(rule (if transmission is automatic and big.wheel no) (then model.nissan is "Nissan Micra SE"))
	(question big.wheel is "Do you need a car with a large wheels?")
	(rule (if transmission is manual and climate.control is yes) (then equipment is comfort))
	(rule (if transmission is manual and climate.control is no) (then equipment is base))
	(question climate.control is "Do you need climate control system?")
	(rule (if equipment is comfort and car.abs is yes) (then model.nissan is "Nissan X-TRAIL SE"))
	(rule (if equipment is comfort and car.abs is no) (then model.nissan is "Nissan X-TRAIL XE"))
	(question car.abs is "Do you need ABS in your car?")
	(rule (if equipment is manual and wheel is yes) (then wheel is alloy))
	(rule (if equipment is manual and wheel is no) (then wheel is base))
	(question wheel is "Do you need alloy wheels?")
	(rule (if wheel is alloy and nissan.connect is yes) (then model.nissan is "Nissan Juke XE"))
	(rule (if wheel is alloy and nissan.connect is no) (then model.nissan is "Nissan Sentra SE"))
	(question nissan.connect is "Do you need Nissan Connect?")
	(rule (if wheel is base and super.car is yes) (then model.nissan is "Nissan GTR"))
	(rule (if wheel is base and super.car is no) (then model.nissan is "Nissan Juke LE Active" ))
	(question super.car is "Do you need super car?")
	(answer is "Your car is " model.nissan))