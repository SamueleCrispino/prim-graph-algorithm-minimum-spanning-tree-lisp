; Crispino Samuele 856339

(defparameter *graphs* (make-hash-table :test #'equal))
(defparameter *arcs* (make-hash-table :test #'equal))
(defparameter *vertices* (make-hash-table :test #'equal))
(defparameter *visited* (make-hash-table :test #'equal))
(defparameter *vertex-keys* (make-hash-table :test #'equal))
(defparameter *previous* (make-hash-table :test #'equal))
(defparameter *heaps* (make-hash-table :test #'equal))
(defparameter *look-up* (make-hash-table :test #'equal))


(defun new-graph (graph-id)
  (or (gethash graph-id *graphs*)
    (setf (gethash graph-id *graphs*) graph-id)))


(defun is-graph (graph-id)
  (gethash graph-id *graphs*))



(defun delete-graph (graph-id)
  (delete-graph-from-graph graph-id)
  (delete-graph-from-vertices graph-id)
  (delete-graph-from-arcs graph-id))


(defun delete-graph-from-vertices (graph-id)
  (maphash #'(lambda (k v)
	       (cond ((equal graph-id (second k))
		      (remhash k *vertices*))))
  *vertices*))


(defun delete-graph-from-graph (graph-id)
  (remhash graph-id *graphs*))


(defun delete-graph-from-arcs (graph-id)
  (maphash
    #'(lambda (k v)
	(cond ((equal graph-id (second k))
	       (remhash k *arcs*))))
  *arcs*))



(defun new-vertex (graph-id vertex-id)
  (let ((vertice (list 'vertex graph-id vertex-id)))
    (or (gethash vertice *vertices*)
	(setf (gethash vertice *vertices*) vertice))))



(defun print-vertex ()
  (maphash #'(lambda (k v) (print k)) *vertices*))


(defun graph-vertices (graph-id)
  (let (a '())
    (maphash
      #'(lambda (k v)
        (cond ((equal graph-id (second k)) (push k a))))
    *vertices*) a))


(defun new-arc (graph-id vertex-id-a vertex-id-b &optional weight)
  (new-vertex graph-id vertex-id-a)
  (new-vertex graph-id vertex-id-b)
  (new-graph graph-id)
  (cond ((null weight)
	 (let ((arco (list 'arc graph-id vertex-id-a vertex-id-b 1)))
	   (setf (gethash arco *arcs*) ()) arco))
	(t (let ((arco (list 'arc graph-id vertex-id-a vertex-id-b weight)))
             (setf (gethash arco *arcs*) ()) arco))))


(defun print-arc ()
  (maphash #'(lambda (k v) (print k)) *arcs*))



(defun graph-arcs (graph-id)
  (let (a '())
    (maphash
     #'(lambda (k v)
         (cond ((equal graph-id (second k))
		(push k a))))
     *arcs*) a))



(defun graph-vertex-neighbors (graph-id vertex-id)
  (let (a '())
    (maphash
     #'(lambda (k v)
         (cond ((or (and (equal graph-id (second k))
                         (equal vertex-id (third k)))
                    (and (equal graph-id (second k))
			 (equal vertex-id (fourth k))))
		(push k a))))
     *arcs*) a))


(defun graph-vertex-adjacent (graph-id vertex-id)
  (let (a '())
    (maphash
     #'(lambda (k v)
	 (cond ((and (equal graph-id (second k))
		     (equal vertex-id (third k)))
		(push (gethash
		       (list 'vertex graph-id (fourth k))*vertices*) a)))
         (cond ((and (equal graph-id (second k))
		     (equal vertex-id (fourth k)))
		(push (gethash
		       (list 'vertex graph-id (third k)) *vertices*) a))))
     *arcs*) a))


(defun graph-print (graph-id)
  (print-vertex-by-id graph-id)
  (print-arc-by-id graph-id))


(defun print-arc-by-id (graph-id)
  (maphash #'(lambda (k v)
	       (cond ((equal graph-id (second k))
		      (print k)))) *arcs*))



(defun print-vertex-by-id (graph-id)
  (maphash #'(lambda (k v)
	       (cond ((equal graph-id (second k))
		      (print k)))) *vertices*))



(defun new-heap (heap-id &optional (capacity 0))
  (or (gethash heap-id *heaps*)
      (setf (gethash heap-id *heaps*)
            (list 'heap heap-id 0
		  (make-array capacity :adjustable t)))))



(defun heap-id (heap-id)
  (second (gethash heap-id *heaps*)))


(defun heap-size (heap-id)
  (third (gethash heap-id *heaps*)))


(defun heap-real-size (array pos)
  (cond ((>= pos (length array)) 0)
	(t (cond ((null (aref array pos))
		  (+ 0 (heap-real-size array (+ pos 1))))
		 (t (+ 0 (heap-real-size array (+ pos 1))))))))


(defun heap-actual-heap (heap-id)
  (fourth (gethash heap-id *heaps*)))


(defun array-length (heap-id)
  (length (heap-actual-heap heap-id)))


(defun array-end (heap-id)
  (- (array-length heap-id) 1))


(defun heap-delete (heap-id)
  (maphash #'(lambda (k v)
	       (cond ((equal heap-id k)
		      (remhash k *heaps*)))) *heaps*) t)


(defun heap-empty (heap-id)
  (equal 0 (array-length heap-id)))


(defun heap-not-empty (heap-id)
  (not (equal 0 (array-length heap-id))))

(defun heap-head (heap-id)
  (if (not (null (gethash heap-id *heaps*)))
  (aref (heap-actual-heap heap-id) 0)))


(defun increment-size (heap-id array)
  (let ((new-size  (+ 1 (length array))))
    (adjust-array array new-size) new-size))


(defun reduce-size (array)
  (let ((new-size  (- (length array) 1)))
    (adjust-array array new-size) new-size))


(defun heap-modify-key (heap-id new-key old-key V)
  (let ((pos (get-look-up V))
	(array (heap-actual-heap heap-id)))
    (setf (elt array pos) (list new-key V))
    (heapify-down-top array pos heap-id)
    (heapify-top-down-2 heap-id array pos)) t)



(defun heap-insert (heap-id k v)
  (let ((array (heap-actual-heap heap-id))
	(posizione (- (increment-size heap-id (heap-actual-heap heap-id))
		      1)))
    (setf (elt array posizione) (list k v))
    (setf (gethash heap-id *heaps*)
          (list 'heap heap-id (+ 1 (heap-size heap-id))
                (heap-actual-heap heap-id)))
    (new-look-up v posizione)
    (heapify-down-top array posizione heap-id)) t)



(defun heapify-down-top (array son-pos heap-id)
  (cond ((and (> son-pos 0)
	      (> (get-parent-key son-pos heap-id)
		 (get-key son-pos heap-id)))
	 (sostituisci son-pos heap-id)
	 (heapify-down-top array (get-parent-pos son-pos) heap-id))))



(defun get-parent-pos (son-pos)
  (cond ((oddp son-pos) (floor son-pos 2))
	(t (- (floor son-pos 2) 1))))


(defun get-parent-key (son-pos heap-id)
  (first (aref (heap-actual-heap heap-id)
	       (get-parent-pos son-pos))))


(defun get-parent-node (son-pos heap-id)
  (aref (heap-actual-heap heap-id)
	(get-parent-pos son-pos)))


(defun get-key (pos heap-id)
  (first (aref (heap-actual-heap heap-id) pos)))


(defun get-node (pos heap-id)
  (aref (heap-actual-heap heap-id) pos))


(defun sostituisci (son-pos heap-id)
  (let ((son-value (get-node son-pos heap-id))
	(parent-value (get-parent-node son-pos heap-id))
	(parent-pos (get-parent-pos son-pos))
	(array (heap-actual-heap heap-id)))
    (setf (elt array son-pos) parent-value)
    (set-look-up (second parent-value) son-pos)
    (setf (elt array (get-parent-pos son-pos)) son-value)
    (set-look-up (second son-value) parent-pos)))



(defun heap-extract (heap-id)
  (let ((a (elt (heap-actual-heap heap-id) 0))
	(array (heap-actual-heap heap-id)))
    (setf (elt array 0) nil)
    (remove-look-up (second a))
    (heapify-top-down heap-id array 0)
    (setf (gethash heap-id *heaps*)
          (list 'heap heap-id (- (heap-size heap-id) 1)
		(heap-actual-heap heap-id))) a))



(defun heapify-top-down-2 (heap-id array pos)
  (let ((lunghezza (heap-size heap-id))
	(left-pos (get-left-pos pos))
	(right-pos (get-right-pos pos)))
    (cond ((and (< left-pos lunghezza)
		(< right-pos lunghezza)
		(> (first (get-left array pos)) (first (get-right array pos))))
           (sostituisci-2 heap-id pos right-pos)
           (heapify-top-down-2 heap-id array right-pos))
          ((and (< left-pos lunghezza)
		(< right-pos lunghezza)
		(<= (first (get-left array pos)) (first (get-right array pos))))
           (sostituisci-2 heap-id pos left-pos)
           (heapify-top-down-2 heap-id array left-pos))
          ((and (< left-pos lunghezza)
		(>= right-pos lunghezza))
           (sostituisci-2 heap-id pos left-pos)
           (heapify-top-down-2 heap-id array left-pos)))))




(defun heapify-top-down (heap-id array pos)
  (let ((lunghezza (length array))
	(left-pos (get-left-pos pos))
	(right-pos (get-right-pos pos)))
    (cond ((and (< left-pos lunghezza)
		(< right-pos lunghezza)
		(> (first (get-left array pos)) (first (get-right array pos))))
           (sostituisci-2 heap-id pos right-pos)
           (heapify-top-down heap-id array right-pos))
          ((and (< left-pos lunghezza)
		(< right-pos lunghezza)
		(<= (first (get-left array pos)) (first (get-right array pos))))
           (sostituisci-2 heap-id pos left-pos)
           (heapify-top-down heap-id array left-pos))
          ((and (< left-pos lunghezza)
		(>= right-pos lunghezza))
           (sostituisci-2 heap-id pos left-pos)
           (heapify-top-down heap-id array left-pos))
          ((and (>= left-pos lunghezza)
		(>= right-pos lunghezza)
		(>= (+ pos 1) lunghezza))
           (reduce-size array))
	  ((and (>= left-pos lunghezza)
		(>= right-pos lunghezza)
		(< (+ pos 1) lunghezza))
           (sostituisci-2 heap-id pos (- lunghezza 1))
           (reduce-size array)
           (heapify-down-top array pos heap-id)))))


(defun sostituisci-2 (heap-id pos1 pos2)
  (let ((pos1-value (get-node pos1 heap-id))
	(pos-2-value (get-node pos2 heap-id))
	(array (heap-actual-heap heap-id)))
    (setf (elt array pos1) pos-2-value)
    (set-look-up (second pos-2-value) pos1)
    (setf (elt array pos2) pos1-value)
    (set-look-up (second pos1-value) pos2)))


(defun get-left-pos (pos)
  (+ (* pos 2) 1))


(defun get-left (array pos)
  (aref array (get-left-pos pos)))


(defun get-right-pos (pos)
  (+ (* pos 2) 2))


(defun get-right (array pos)
  (aref array (get-right-pos pos)))



(defun heap-print (heap-id)
  (print (gethash heap-id *heaps*)))





(defun mst-prim (graph-id source)
  (prim-delete)
  (new-heap 'mst-heap)
  (for-each-vertex (graph-vertices graph-id) 'mst-heap source)
  (loop-on-heap 'mst-heap graph-id))


(defun for-each-vertex (lista-vertici heap-id source)
  (cond ((not (null (car lista-vertici)))
         (cond ((equal (third (car lista-vertici)) source)
		(heap-insert heap-id 0 source)
		(new-vertex-keys source 0))
               (t
		(heap-insert heap-id MOST-POSITIVE-DOUBLE-FLOAT
			     (third (car lista-vertici)))
		(new-vertex-keys (third (car lista-vertici))
				 MOST-POSITIVE-DOUBLE-FLOAT)))
         (for-each-vertex (cdr lista-vertici) heap-id source))))


(defun loop-on-heap (heap-id graph-id)
  (cond ((heap-not-empty heap-id)
         (let ((extracted
		(second (heap-extract heap-id))))
           (for-each-adjs graph-id heap-id
			  (graph-vertex-neighbors graph-id
						  (new-visited extracted))
			  extracted)
           (loop-on-heap heap-id graph-id)))))


(defun for-each-adjs (graph-id heap-id lista-archi u)
  (let ((v (get-v (car lista-archi) u)))
    (cond ((null (car lista-archi)) nil)
          ((and (is-not-visited v)
		(< (fifth (car lista-archi)) (mst-vertex-key graph-id v)))
           (let ((w (fifth (car lista-archi)))
                 (old-key (mst-vertex-key graph-id v)))
             (heap-modify-key heap-id w old-key v)
             (set-vertex-keys v w)
             (set-previous v u)
             (for-each-adjs graph-id heap-id (cdr lista-archi) u)))
          (t (for-each-adjs graph-id heap-id (cdr lista-archi) u)))))


(defun get-v (arco u)
  (cond ((equal u (third arco))
	 (fourth arco))
        ((equal u (fourth arco))
	 (third arco))))



(defun new-visited (vertex-id)
  (or (gethash vertex-id *visited*)
      (setf (gethash vertex-id *visited*) vertex-id)))


(defun is-not-visited (v)
  (null (gethash v *visited*)))


(defun truncate-visited ()
  (maphash #'(lambda (k v) (remhash k *visited*)) *visited*) t)


(defun print-visited ()
  (maphash #'(lambda (k v) (print k)) *visited*))


(defun new-vertex-keys (vertex-id key)
  (or (gethash vertex-id *vertex-keys*)
      (setf (gethash vertex-id *vertex-keys*) key)))


(defun set-vertex-keys (vertex-id new-key)
  (setf (gethash vertex-id *vertex-keys*) new-key))


(defun truncate-vertex-keys ()
  (maphash #'(lambda (k v) (remhash k *vertex-keys*))
	   *vertex-keys*) t)


(defun print-vertex-keys ()
  (maphash #'(lambda (k v) (print (list k v)))
	   *vertex-keys*))


(defun mst-vertex-key (graph-id vertex-id)
  (gethash vertex-id *vertex-keys*))


(defun mst-vertex-key-2 (graph-id vertex-id)
  (get-min MOST-POSITIVE-DOUBLE-FLOAT
	   (graph-vertex-neighbors graph-id vertex-id)))


(defun get-min (m l)
  (cond ((null (car l)) m)
        ((< (fifth (car l)) m) (get-min (fifth (car l)) (cdr l)))
        (t (get-min m  (cdr l)))))


(defun new-previous (vertex-id key)
  (or (gethash vertex-id *previous*)
      (setf (gethash vertex-id *previous*) key)))


(defun set-previous (vertex-id new-key)
  (setf (gethash vertex-id *previous*) new-key))


(defun truncate-previous ()
  (maphash #'(lambda (k v) (remhash k *previous*)) *previous*) t)


(defun print-previous ()
  (maphash #'(lambda (k v) (print (list k v))) *previous*))


(defun mst-previous (graph-id V)
  (gethash V *previous*))


(defun findall-previous (padre graph-id)
  (let (a '())
    (maphash
     #'(lambda (k v)
         (cond ((equal v padre)
		(push (list 'arc graph-id v k
			    (mst-vertex-key graph-id k)) a))))
     *previous*) a))


(defun get-min-arc (m l)
  (cond ( (null (car l)) m)
        ((< (fifth (car l)) (fifth m)) (get-min-arc (car l) (cdr l)))
        ((and (= (fifth (car l)) (fifth m))
	      (string< (fourth (car l)) (fourth m)))
         (get-min-arc (car l) (cdr l)))
        (t (get-min-arc m  (cdr l)))))


(defun mst-get (graph-id source)
  (let ((preorder-mst '()))
    (preorder graph-id source preorder-mst)))


(defun preorder (graph-id source preorder-mst)
  (cond ((not (null (findall-previous source graph-id)))
         (let ((lista-figli (findall-previous source graph-id))
               (minimo (get-min-arc (car (findall-previous source graph-id))
                                    (cdr (findall-previous source graph-id)))))
           (cond ((null preorder-mst) (push minimo preorder-mst))
                 (t (push minimo (cdr (last preorder-mst)))))
           (preorder graph-id (fourth minimo) preorder-mst)
           (for-each-son (remove-it minimo lista-figli)
			 graph-id preorder-mst)))))



(defun for-each-son (lista-figli graph-id preorder-mst)
  (cond ((not (null lista-figli))
         (let ((minimo (get-min-arc (car lista-figli) (cdr lista-figli))))
           (cond ((null preorder-mst) (push minimo preorder-mst))
                 (t (push minimo (cdr (last preorder-mst)))))
           (preorder graph-id (fourth minimo) preorder-mst)
           (for-each-son (remove-it minimo lista-figli)
			 graph-id preorder-mst))))
  preorder-mst)




(defun remove-it (it list)
  (if (null list) nil
    (cond ((not (equal it (car list)))
           (cons (car list) (remove-it it (cdr list))))
          (t (remove-it it (cdr list))))))


(defun findall-sons (padre lista-previous)
  (let ((a '()))
    (mapcar ( ))))


(defun son-filter (elemento)
  (cond ((equal
	  (cond ((not (null (car lista-previous)))
		 (cond ((equal (second (car lista-previous)) padre)
			(cons (car lista-previous)
			      (findall-sons padre (cdr lista-previous)))))))))))

(defun trova-figli (genitore)
  (let (a '())
    (maphash
     #'(lambda (k v)
         (cond ((equal graph-id (second k)) (push k a))))
     *vertices*) a))

(defun prim-delete ()
  (truncate-previous)
  (truncate-vertex-keys)
  (truncate-visited))



(defun new-look-up (vertex-id pos)
  (or (gethash vertex-id *look-up*)
      (setf (gethash vertex-id *look-up*) pos)))


(defun set-look-up (vertex-id new-pos)
  (setf (gethash vertex-id *look-up*) new-pos))


(defun truncate-look-up ()
  (maphash #'(lambda (k v)
	       (remhash k *look-up*)) *look-up*) t)


(defun print-look-up ()
  (maphash #'(lambda (k v) (print (list k v))) *look-up*))


(defun get-look-up (vertex-id)
  (gethash vertex-id *look-up*))


(defun remove-look-up (vertex-id)
  (remhash vertex-id *look-up*))


