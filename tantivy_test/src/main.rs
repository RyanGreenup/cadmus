// copied from
//  https://tantivy-search.github.io/examples/basic_search.html

#[macro_use]
extern crate tantivy;
use glob::glob_with;
use glob::MatchOptions;
use std::fs;  // Instead of using glob
use std::env;
use tantivy::collector::TopDocs;
use tantivy::query::QueryParser;
use tantivy::schema::*;
use tantivy::Index;
use tantivy::ReloadPolicy;
use tempfile::TempDir;

fn main() -> tantivy::Result<()> {
    // List Directories that I will want to later scan
    // list_dirs();

    let search_directory: &str;
    let args: Vec<String> = env::args().collect();
    if args.len() >= 2 {
        search_directory = &args[1];
    } else {
        // todo, this should be 
        // let mut cwd = std::env::current_dir();
        search_directory = "/home/ryan/Notes/";
    }

    let mut glob_string: String = search_directory.to_owned();
    glob_string.push_str("/**/*.md");
    println!("{}", glob_string);


    // Use a temp directory
    let index_path = TempDir::new()?;

    // Define a schema
    let mut schema_builder = Schema::builder();
    // The title needs to be retrieved and have searchable text
    schema_builder.add_text_field("title", TEXT | STORED);
    // we only need to search the text from the body, not retrieve it
    // Omitting the STORED flag acheives this and makes the index lighter
    schema_builder.add_text_field("body", TEXT);

    // Build the schema
    let schema = schema_builder.build();

    // Create an index
    let index = Index::create_in_dir(&index_path, schema.clone())?;

    // Let's make an index
    // TODO does changing this help?
    let mut index_writer = index.writer(50_000_000)?;

    // Add Documents
    let title = schema.get_field("title").unwrap();
    let body = schema.get_field("body").unwrap();

    let mut old_man_doc = Document::default();
    old_man_doc.add_text(title, "The old man");
    old_man_doc.add_text(body, "Lots and lots and lots of text in here 3141");

    index_writer.add_document(old_man_doc);

    let options = MatchOptions {
        case_sensitive: false,
        require_literal_separator: false,
        require_literal_leading_dot: false,
    };

    let mut i = 1;
    // TODO Path should be argument or config
    // TODO should time docs/second
    // TODO should obviously be able to cache the index
    // TODO should print a progress bar
    // TODO what does the to_owned method do?
    for entry in glob_with(&glob_string, options).unwrap() {
        // let path2 = std::path::PathBuf::new();
        if let Ok(path) = entry {

            add_file_to_index(path, &schema, &index_writer);

        }

        i = i + 1;
    }

    println!("Succesfully indexed {} files", i);



    // Call Commit to force the index to search them
    index_writer.commit()?;

    // Create a reader
    let reader = index
        .reader_builder()
        .reload_policy(ReloadPolicy::OnCommit)
        .try_into()?;

    // Create a searcher
    let searcher = reader.searcher();

    // Create a Query
    println!("Please enter a search term:");
    let mut user_query = String::new();
    std::io::stdin().read_line(&mut user_query);

    let query_parser = QueryParser::for_index(&index, vec![title, body]);
    // TODO How can I change this text to something user entered
    let query = query_parser.parse_query(&user_query)?;

    // Get back the top documents
    let top_docs = searcher.search(&query, &TopDocs::with_limit(10))?;

    println!("I've finished indexing and querying now");
    // Print out the top documents
    for (_score, doc_address) in top_docs {
        let retrieved_doc = searcher.doc(doc_address)?;
        println!("{}", schema.to_json(&retrieved_doc));
    }

    Ok(())
}

fn list_dirs() {
    let options = MatchOptions {
        case_sensitive: false,
        require_literal_separator: false,
        require_literal_leading_dot: false,
    };
    for entry in glob_with("/home/ryan/Notes/MD/**/*.md", options).unwrap() {
        if let Ok(path) = entry {
            println!("{:?}", path.display());
            let contents = fs::read_to_string(path).expect("Couldn't Read File correctly");
            println!("With text:\n{}", contents);
        }
    }
}


    fn add_file_to_index(path: std::path::PathBuf, schema: &tantivy::schema::Schema, index_writer: &tantivy::IndexWriter) {

        let title = schema.get_field("title").unwrap();
        let body = schema.get_field("body").unwrap();

        let path2 = path.to_owned();
        let path3 = path.to_owned();

        // DEBUG print file name and contents
        // println!("{:?}", path.display());
        let contents = fs::read_to_string(path2).expect("Couldn't Read File correctly");
        // println!("With text:\n{}", contents);


        let path_str = path3.into_os_string().into_string().unwrap(); 


        let mut new_doc = Document::default();
        new_doc.add_text(title, path_str);
        new_doc.add_text(body, contents);

        index_writer.add_document(new_doc);
    }
