$nyquist plug-in
$version 4
$type process
$name (_ "Gradual Warp")
$author "Audacity Team"
$release 1.0.0
$debugbutton false

$control ELONGATE (_ "Increase length by (%)") int "" 50 0 100
$control DROPVOL (_ "Fade volume near end") boolean "" 1

 (defun warp-channel (sig dur)
   (let* ((factor (+ 1 (/ ELONGATE 100.0)))
          (segments 20)
          (ratio-end (+ 1 (* 2 (- factor 1))))
          (seglen (/ dur segments))
          (out (s-rest 0)))
     (dotimes (i segments)
       (let* ((start (* i seglen))
              (piece (extract-abs start (+ start seglen) sig))
              (ratio (+ 1 (* (/ i (- segments 1)) (- ratio-end 1))))
              (stretched (stretch-abs ratio piece)))
         (setf out (seq out stretched))))
     (let ((outdur (* dur factor)))
       (when (= DROPVOL 1)
         (setf out (mult out (pwlv 1 (* 0.9 outdur) 1 outdur 0))))
       out)))

(let ((dur (get-duration 1)))
  (multichan-expand #'warp-channel *track* dur))
