package main

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
	"fmt"
	"os"
	"path/filepath"

	"github.com/blevesearch/bleve/v2"
	"github.com/schollz/progressbar/v3"
)

type text_structure struct {
	Path    string
	Content string
}

func main() {

	files := listFiles()

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

	notecontent := getFile("/home/ryan/Sync/Notes/Org/1.org")
	data3 := text_structure{
		Path:    "1.org",
		Content: notecontent,
	}
	_ = data3

	bar := progressbar.Default(int64(len(files)))
	documents := []text_structure{}
	i := 1

	for _, file := range files {
		// fmt.Println(file)
		i = i + 1

		notecontent = getFile(file)

		data3 = text_structure{
			Path:    file,
			Content: notecontent,
		}

		// documents = append(documents, data3)
		// fmt.Println(file)

		index.Index(data3.Path, data3)

		bar.Add(1)

	}

	data1 := text_structure{
		Path:    "/home/ryan/Notes/MD/index.md",
		Content: "lots of text in quick brown fox",
	}

	data2 := text_structure{
		Path:    "1.org",
		Content: notecontent,
	}
	// TODO loop over files

	documents = append(documents, data1)
	documents = append(documents, data2)

	// for key, doc := range documents {
	// 	// first is string returned, second is struct searched
	// 	index.Index(doc.Path, doc)
	// }

	// for i := 0; i < len(documents); i++ {
	// 	fmt.Print(documents[i])
	// }

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

func listFiles() []string {
	files := []string{}

	// TODO Why is this different?
	// https://stackoverflow.com/a/42423998
	// https://flaviocopes.com/go-list-files/
	echo := func(path string, info os.FileInfo, err error) error {

		if info.IsDir() {
			return nil
		}

		// TODO there should be many formats allowed
		if !(filepath.Ext(path) == ".md") {
			return nil
		}

		files = append(files, path)

		// fmt.Print(path)
		return nil

	}

	// TODO Why not Symlinks?
	root := "/home/ryan/Sync/Notes/MD/"
	err := filepath.Walk(root, echo)
	if err != nil {
		panic(err)
	}

	return files
}
