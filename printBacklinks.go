package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

// TODO this should not search a bleve index
// TODO this should really only return md/txt/org files?
// TODO this should handle arguments intelligently
func main() {
	// TODO this should be the second argument
	// TODO how can I make this work for symlinks?
	dir := "/home/ryan/Sync/Notes"
	note_path := "journal.teacher.preperation"

	all_files := note_paths(dir)
	matching_files := note_matches(note_path, all_files)

	for key, value := range matching_files {
		_ = key
		fmt.Println(value)
	}

	// fmt.Println(matching_files)

	// var note_path string
	// if len(os.Args) > 1 {
	// 	note_path := os.Args[1]
	// 	check_file(note_path)
	// } else {
	// 	note_path = os.Args[2]
	// }

}

// TODO
func check_file(note_path string) {
	fmt.Println("Is it the path to a file, on the disk, that I can find?, If not stop and ask for user input")
	fmt.Println("I need to check if the file is actually a file and otherwise print a warning")
	os.Stdout.WriteString("Warning: This has not been implemented")
}

// Walk through a directory and append all files and directories to an array
func note_paths(dir string) []string {
	var files_list []string

	err := filepath.WalkDir(dir,
		func(path string, d os.DirEntry, err error) error {
			if err != nil {
				return err
			}
			// if !strings.Contains(path, ".git") {
			// No dotFiles
			Is_matchedQ, _ := regexp.MatchString(".git.*|^[.].*|zap*|~$", path)
			if !Is_matchedQ {
				files_list = append(files_list, path)
			}
			return nil
		})
	if err != nil {
		log.Println(err)
	}
	// return []string{"g", "h", "i"}
	return files_list
}

func note_matches(target_string string, all_strings []string) []string {
	var matching_files []string
	for _, file := range all_strings {
		content, err := os.ReadFile(file)
		if err != nil {
			continue
		}
		content_string := string(content)
		matchedQ := strings.Contains(content_string, target_string)

		if matchedQ {
			matching_files = append(matching_files, file)
		}
	}

	return matching_files
}
