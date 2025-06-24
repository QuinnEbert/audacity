$nyquist plug-in
$version 4
$type process
$name "Gradual Warp"
$control LENGTH "Output Length (%)" float-text "" 150 100 400
$control DROP "Drop volume near end" choice (("No" 0) ("Yes" 1)) 0

(setq ratio (/ LENGTH 100.0))
(setq dur (get-duration 1))
(setq stretchfn (pwlv 1 0 dur ratio))
(setq result (pv-time-pitch *track* stretchfn stretchfn dur))
(if (= DROP 1)
    (setf result (mult result (pwlv 1 (* dur 0.8) 0 dur 0))))
result
