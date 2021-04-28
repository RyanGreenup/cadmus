// Return 50 words of an index from notes, using lowest IDf values

// TODO Read in all text documents from directory
// TODO Find IDF values
// TODO Find top 50 words corresponding to lowest IDF values
// TODO use fzf to select one of those words
// TODO return the top 20 documents that contain that word most frequently

package main

import (
	"fmt"
	"strings"
)

func main() {
	// Get some documents
	var docs [][]string = get_documents()

	// get the unique words out
	var all_words []string = unique_words(docs)

	// Make a DTM
	DTM := make_dtm(docs, all_words)

	// Print the DTM
	fmt.Println(all_words)
	for i := 0; i < len(DTM); i++ {
		for j := 0; j < len(DTM[1]); j++ {
			fmt.Print(DTM[i][j], " ")
		}
		fmt.Print("\n")
	}
}

func get_documents() [][]string {
	// Create some strings
	doc1 := "quick fox, \n *brown*, fox, jumpy fox"
	doc2 := "jumping jacks jacks jacks are fun fun meh"
	doc3 := "the fox fox fox was foo bar blah quick"

	// store the strings into an array
	var all_docs_str []string = []string{doc1, doc2, doc3}

	// Create an empty matrix
	all_docs := [][]string{}
	// Fill the Matrix with the terms
	for i := 0; i < 3; i++ {
		all_docs = append(all_docs, extract_words(all_docs_str[i]))
	}

	return all_docs
}

// Clean a string and return back a vector of words
func extract_words(doc string) []string {

	doc = strings.ToLower(doc)
	// remove commas ore strings.Fields respects them
	doc = strings.ReplaceAll(doc, ",", "")
	doc = strings.ReplaceAll(doc, "/", "")
	doc = strings.ReplaceAll(doc, "*", "")
	doc = strings.TrimSpace(doc)
	doc_vec := strings.Fields(doc)

	return doc_vec

}
func unique_words(docs [][]string) []string {

	var unique_words []string

	for i := 0; i < len(docs); i++ {
		for j := 0; j < len(docs[i]); j++ {
			// test if the word is in the vector before appending to esnure uniqueness
			if !in_arr(unique_words, docs[i][j]) {
				unique_words = append(unique_words, docs[i][j])
			}
		}
	}
	// fmt.Println(words)

	return unique_words

}

func in_arr(words []string, word string) bool {
	for i := 0; i < len(words); i++ {
		if words[i] == word {
			return true
		}
	}
	return false
}

func make_dtm(docs [][]string, all_words []string) [][]float64 {
	N := len(docs)
	n := len(all_words)

	DTM := make([][]float64, N, N)
	rows := make([]float64, n*N)
	for i := 0; i < N; i++ {
		DTM[i] = rows[i*n : (i+1)*n]
	}

	for i := 0; i < N; i++ {
		doc := docs[i]
		for k := 0; k < n; k++ {
			word := all_words[k]
			DTM[i][k] = how_many_times(word, doc)
		}
	}

	return DTM
}

func how_many_times(word string, doc []string) float64 {
	var count float64 = 0
	for i := 0; i < len(doc); i++ {
		if word == doc[i] {
			count = count + 1
		}
	}
	return count

}
