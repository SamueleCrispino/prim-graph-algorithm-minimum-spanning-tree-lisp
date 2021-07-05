Generazione del Minimum Spanning Tree (MST) e sua esplorazione pre-order:

1- Creare il grafo
  Questa operazione può essere eseguita con le apposite funzioni:
  - new-graph
  - new-vertex
  - new-arc
  Assicurandosi di rispettare la consistenza dei dati, al momento della creazione dei vertici
  non vengono eseguite verifiche sull'esistenza del grafo.
  Invece, tilizzando la funzione new-arc è possibile creare in automatico il grafo e i vertici
  passati come paramtri. Ciò semplifica la creazione di grafi, infatti è sufficiente caricare,
  con il comando load, una lista di new-arc.

2- Eseguire la funzione mst-prim con i parametri indicati dall'esempio, per creare l'MST:
  >_ (mst-prim 'nome_grafo 'nome_radice)

  Ad eccezione di casi non previsti l'output desiserato da questa funzione è NIL.

3- Eseguire la funzione mst-get con i parametri indicati dall'esempio,
  per ottenere la lista degli archi che definiscono l'MST visitati con criterio pre-order l'MST:

  >_ (mst-get 'nome_grafo 'nome_radice)

NB: L'esecuzione della funzione mst-prim provoca inizialmente la rimozione di tutti i dati relativi
    a precedenti MST. Ne segue che non è possibile recuperare tale informazioni dopo l'elaborazione
    di un nuovo MST.



Descrizione funzioni:

is-graph graph-id → graph-id or NIL
Questa funzione ritorna il graph-id stesso se questo grafo è già stato creato, oppure NIL se
no.

new-graph graph-id → graph-id
Questa funzione genera un nuovo grafo e lo inserisce nel data base (ovvero nella hash-table)
dei grafi.

delete-graph graph-id → NIL
Rimuove l’intero grafo dal sistema; ovvero rimuove tutte le istanze
presenti nei data base (ovvero nelle hash-tables: *vertices*, *arcs* e *graphs*) del sistema.
Non ha nessun effetto se il graph-id passato come parametro non esiste.

delete-graph-from-vertices
Funzione ausiliaria di delete-graph. Cancella i vertici associati al grafo.

delete-graph-from-graph
Funzione ausiliaria di delete-graph. Cancella il grafo associati al graph-id.

delete-graph-from-arcs
Funzione ausiliaria di delete-graph. Cancella gli archi associati al grafo.

new-vertex graph-id vertex-id → vertex-rep
Aggiunge un nuovo vertice vertex-id al grafo graph-id.
Non crea un nuovo grafo, ne esegue controlli, deve essere premura dello sviluppatore
assicurarsi che il graph-id passato come parametro sia riferito ad un grafo esistente

print-vertex
Stampa un elenco del contenuto di *vertices*

graph-vertices graph-id → vertex-rep-list
Questa funzione torna una lista di vertici del grafo.
Ritorna una lista vuota se il grafo esiste ma non ha vertici associati.
Ritorna Nil se il grafo non esiste.

new-arc graph-id vertex-id vertex-id &optional weight -> arc-rep
Questa funzione aggiunge un arco del grafo graph-id nella hash-table *arcs*. La
rappresentazione di un arco è  (arc graph-id u v weight).
Al fine di facilitare la creazione di grafi usando soltanto questo comando si è scelto
di creare in automatico grafo e vertici qualora non esistessero

print-arc
stampa il contenuto di *arcs*

graph-arcs graph-id → arc-rep-list
Questa funzione ritorna una lista una lista di tutti gli archi presenti in graph-id.

graph-vertex-neighbors graph-id vertex-id → arc-rep-list
Questa funzione ritorna una lista arc-rep-list contenente gli archi
che portano ai vertici N immediatamente raggiungibili da vertex-id.
Vengono inclusi eventuali cappi.


graph-vertex-adjacent graph-id vertex-id → vertex-rep-list
Questa funzione ritorna una lista vertex-rep-list contenente i vertici
adiacenti a vertex-id.


graph-print graph-id
Questa funzione stampa alla console dell’interprete Common Lisp una lista dei vertici e degli
archi del grafo graph-id.

print-arc-by-id
stampa tutti gli archi associati al graph-id passato come argomento

print-vertex-by-id
stampa tutti i vertici associati al graph-id passato come argomento


new-heap H &optional (capacity 0) → heap-rep
Questa funzione inserisce un nuovo heap nella hash-table *heaps*.
Una heap-rep è una lista (potete anche usare altri oggetti Common Lisp) siffatta:
(HEAP heap-id heap-size actual-heap).
L'array dello heap è un array dinamico la cui dimensione iniziale è zero e viene aggiornata
a seguito di operazioni di inserimento ed estrazione. Gli eventuali valori Null che si possono
generare a seguito delle operazioni di modifica o estrazione vengono eliminati dall'array.


heap-id
ritorna l'attributo heap-id di heap-rep.

heap-size
ritorna l'attributo heap-size di heap-rep.

actual-heap
ritorna l'attributo actual-heap, ovvero l'array, di heap-rep.

heap-real-size
ritorna il numero di elementi non nulli contenuti nell'array dello heap

array-length
ritorna la dimensione dell'array

array-end
ritorna la posizione dell'ultimo elemento nell'array

heap-delete heap-id → T
Rimuove tutto lo heap indicizzato da heap-id.

heap-empty heap-id → boolean
Questo predicato è vero quando lo heap heap-id non contiene elementi.

heap-not-empty heap-id → boolean
Questo predicato è vero quando lo heap heap-id contiene almeno un elemento.

heap-insert heap-id K V → boolean
La funzione heap-insert inserisce l’elemento V nello heap heap-id con chiave K.
Il nuovo elemento viene riposizionato in modo da rispettare il minHeap

heap-head heap-id → (K V)
La funzione heap-head ritorna una lista di due elementi dove K è la chiave minima e V il valore
associato.

increment-size
aumenta di 1 la dimensione dell'array e ritorna la dimensione aggiornata

reduce-size
riduce di 1 la dimensione dell'arraye ritorna la dimensione aggiornata

heap-modify-key heap-id new-key old-key V → boolean
La funzone heap-modify-key sostituisce la chiave OldKey (associata al valore V) con
NewKey. Naturalmente, lo heap heap-id dovrà essere ristrutturato in modo da mantenere la
“heap property” ad ogni nodo dello heap.

heap-extract heap-id → (K V)
La funzione heap-extract ritorna la lista con K, V e con K minima; la coppia è rimossa dallo
heap heap-id. Naturalmente, lo heap heap-id dovrà essere ristrutturato in modo da mantenere
la “heap property” ad ogni nodo dello heap.

heap-print heap-id → boolean
Questa funzione stampa sulla console lo stato interno dello heap heap-id.

mst-vertex-key graph-id vertex-id → k
Questa funzione, dato un vertex-id di un grafo graph-id ritorna, durante e dopo l’esecuzione
dell’algoritmo di Prim, il peso minimo di un arco che connette vertex-id nell’albero minimo; se
questo arco non esiste (ed all’inizio dell’esecuzione) allora k è MOST-POSITIVE-DOUBLE-FLOAT


mst-previous graph-id V → U
Questa funzione, durante e dopo l’esecuzione dell’algoritmo di Prim, ritorna il vertice U che il
vertice “genitore” (“precedente”, o “parent”) di V nel minimum spanning tree V

mst-prim graph-id source → NIL
Questa funzione termina con un effetto collaterale. Dopo la sua esecuzione, la hash-table
*vertex-key* contiene al suo interno le associazioni (graph-id V) ⇒ d per ogni V
appartenente a graph-id; la hash-table *previous* contiene le associazioni
(graph-id V) ⇒ U calcolate durante l’esecuzione dell’algoritmo di Prim.


mst-get graph-id source → preorder-mst
Questa funzione ritorna preorder-mst che è una lista degli archi del MST ordinata secondo un
attraversamento preorder dello stesso, fatta rispetto al peso dell’arco

heapify-down-top
Questa funzione ristabilisce il minheap a seguito di un'alterazione della sua struttura.
Esegue l'operazione partendo dalle foglie dello heap e risalendo verso la radice,
pertanto viene usata in seguito all'operazione di inserimento.

get-parent-pos
Restituisce la posizine del nodo padre nel minHeap a partire dalla posizione del nodo figlio

get-parent-key
Restituisce il valore della chiave del nodo padre nel minHeap a partire dalla posizione del nodo figlio

get-parent-node
Restituisce il nodo padre nel minHeap a partire dalla posizione del nodo figlio

get-key
Restituisce la chiave di un nodo a partire dalla sua posizione nel MinHeap

get-node
Restituisce il nodo a partire dalla sua posizione nel MinHeap

sostituisci
Inverte le posizioni di un nodo figlio e del rispettivo nodo padre all'interno del minHeap

heapify-top-down-2
Questa funzione ristabilisce il minheap a seguito di un'alterazione della sua struttura.
Esegue l'operazione partendo dalla 'head' dello heap.
Questa funzione è stata pensata come una seconda versione della heapify-top-down,
più adatta nel caso di modifiche della chiave di un nodo del minHeap, in quanto, a differenza
dell'estrazione, lo heap non subisce variazioni della sua dimensione.


heapify-top-down
Questa funzione ristabilisce il minheap a seguito di un'alterazione della sua struttura.
Esegue l'operazione partendo dalla 'head' dello heap e viene invocata in seguito a un'operazione
di estazione.

sostituisci-2
Variante dell'operazione di sostituzione che tuttavia sfrutta la hashtable *look-up*

get-left-pos
Ritorna la posizione del figlio sx di un nodo se esiste, NIL altrimenti.

get-right-pos
Ritorna la posizione del figlio dx di un nodo se esiste, NIL altrimenti.

get-left
Ritorna il figlio sx di un nodo se esiste, NIL altrimenti.

get-right
Ritorna il figlio dx di un nodo se esiste, NIL altrimenti.

for-each-vertex
Cicla sui nodi del grafo e li inserisce nel minHeap inizializzando i valori iniziali delle chiavi.

loop-on-heap
Esegue estrazioni sullo heap fino al suo svuotamento.
Per ogni nodo estratto vengono calcolati i rispettivi 'neighbours'.

for-each-adjs
Cicla su ogni vertive 'neighbours' e calcola gli eventuali aggiornamenti sulle
hashtables *vertex-keys* e *previous* andando a costruire l'MST.

get-v
Dato un arco e un vertice, restituisce l'altro vertice.

get-min-arc
Ritorna l'arco minimo data una lista di archi

preorder
Costruisce una lista di attraversamento preorder degli archi dell'MST

prim-delete
Rimuove ogni informazione riguardante l'MST memorizzata nelle hashtables:
*vertex-keys*, *previous*, *look-up*, *visited*.

In riferimento alle hashtables: *vertex-keys*, *previous*, *look-up*, *visited*
sono stati predisposti dei metodi per le operazioni di: inserimento, lettura, aggiornamento,
eliminazione e stampa.
