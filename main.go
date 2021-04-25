package main

// TODO improve the logic for opening the index, see line 52 of this exemplar
// TODO see line 117 for example of walking directory
// https://github.com/blevesearch/beer-search/blob/master/main.go
// TODO Improve index time with batch?
// https://github.com/blevesearch/bleve/issues/831
// TODO command line argument to re-index? that would be quicker
// TODO just return the name of matches
// TODO I need to evaluate how long tantivy takes to index, Ideally I want to index on the fly, I need to see if that's an option
// i.e. an option if I had 100 times the notes I had, so the time taken would need to be 2 ms when this is 10, I doubt rust will
// bring that sort of a performance gain, but I should see none the less.
// NOTE Tantivy said it took 2000 docs per sec from the JSON, currently this does 70 docs/sec
// this should help
// https://tantivy-search.github.io/examples/basic_search.html
// TODO Can I map this over multiple cores? Indexing would be much faster in that case it looks like it's already working over many cores though.

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/blevesearch/bleve/v2"
	"github.com/schollz/progressbar/v3"
)

type text_structure struct {
	Path    string
	Content string
}

var batchSize = flag.Int("batchSize", 200, "batch size for indexing")

func main() {

	dir := ""
	if len(os.Args) < 2 {
		dir = "./"
	} else {
		dir = os.Args[1]
	}

	files := listFiles(dir)

	index_path := "example.bleve"

	// delete_index(index_path)
	index := Make_index(index_path, files)

	do_search(index)

}

func do_search(index bleve.Index) {

	// search for some text
	// TODO Make this an interactive query
	query_text := getInput()
	query := bleve.NewMatchQuery(query_text)
	search := bleve.NewSearchRequest(query)
	searchResults, err := index.Search(search)
	if err != nil {

		fmt.Println("No Search Results :( ")
		fmt.Println(err)
		return
	}

	// Print out the Results
	// TODO Only print out the File Path
	// TODO, give this file path to fuzzy-finder-go --preview
	fmt.Println(searchResults) // This prints everything
	// fmt.Println(searchResults.Hits[0].ID) // This prints the ID of the first

}

func getInput() string {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter a Search Term:\n")
	term, _ := reader.ReadString('\n')
	return term
}

func Make_index(index_path string, files []string) bleve.Index {

	// TODO This should have more error checking, what if there is just a write permission?
	// what if it's the wrong file? then it would be overwritten...
	index, err := bleve.Open(index_path)
	if err != nil {
		fmt.Println(err)
		fmt.Println("Creating a New index")
		mapping := bleve.NewIndexMapping()

		index, err = bleve.New(index_path, mapping)

		if err != nil {
			fmt.Print(err)
			fmt.Print("Unable to Create new index")
			os.Exit(1)
		}
	} else {
		fmt.Println("Appending to Old Index")
	}

	var notecontent string
	var a_document text_structure

	bar := progressbar.Default(int64(len(files)))
	documents := []text_structure{}
	count := 1
	startTime := time.Now()
	batchcount := 1
	batch := index.NewBatch()

	// batch := index.NewBatch()
	for _, file := range files {
		// fmt.Println(file)
		count = count + 1

		notecontent = getFile(file)

		a_document = text_structure{
			Path:    file,
			Content: notecontent,
		}

		documents = append(documents, a_document)
		// fmt.Println(file)

		// index.Index(a_document.Path, a_document)
		// Add them to a batch
		batch.Index(a_document.Path, a_document)
		batchcount++

		// Index the batch now
		if batchcount >= *batchSize {
			err = index.Batch(batch)
			if err != nil {
				panic(err)
			}
			// Reset the batch
			batch = index.NewBatch()
			batchcount = 0

		}

		bar.Add(1)

	}

	// Index the last inclomplete batch
	if batchcount > 0 {
		err = index.Batch(batch)
		if err != nil {
			panic(err)
		}
		// no need to reset the batch, we are don

	}
	indexDuration := time.Since(startTime)
	indexDurationSeconds := float64(indexDuration) / float64(time.Second)
	timePerDoc := float64(indexDuration) / float64(count)
	log.Printf("Indexed %d documents, in %.2fs (average %.2fms/doc)", count, indexDurationSeconds, timePerDoc/float64(time.Millisecond))

	return index
}

func getFile(path string) string {
	buf, err := os.ReadFile(path)
	notecontent := string(buf)

	if err != nil {
		fmt.Print("Error Reading File")
		os.Exit(1)
	}
	return notecontent
}

func delete_index(path string) {
	os.RemoveAll(path)
}

func listFiles(dir string) []string {
	files := []string{}

	// TODO Why is this different?
	// https://stackoverflow.com/a/42423998
	// https://flaviocopes.com/go-list-files/
	append_files := func(path string, info os.FileInfo, err error) error {

		if info.IsDir() {
			return nil
		}

		// TODO there should be many formats allowed
		if !(filepath.Ext(path) == ".md") {
			return nil
		}

		files = append(files, path)
		return nil
	}

	// TODO Why not Symlinks?
	root := dir
	err := filepath.Walk(root, append_files)
	if err != nil {
		panic(err)
	}

	return files
}
