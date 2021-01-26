// test this with node print_unused_attachments.js | xargs rg
// It doesn't seem to work.

// //////////////////////////////////////////////////////////
// ////////// Load Libraries ////////////////////////////////
// //////////////////////////////////////////////////////////

const path = require('path');
const fs = require('fs');
// const yamlFront = require('yaml-front-matter');
let debugFlag = false;
let glob = require('glob');

function main() {
    change_directory();
    attachments = get_file_names()[0];
    notes       = get_file_names()[1];
    unused_attachments = find_unused_attachments(attachments, notes);
    print(unused_attachments)


}

function change_directory() {

    ////////////////////////////////////////////////////////////
    /////////// Change Directory ///////////////////////////////
    ////////////////////////////////////////////////////////////

    if (process.argv[2] == undefined) {
        const path = "./";
        if (debugFlag) {
            console.log(`No Path Detected, using this directory ${process.argv[1]}`)
            console.log("Remember to use $HOME not ~")
        }
    } else if (process.argv[2] == "-h" | process.argv[2] == "--help") {
        console.log("\nProvide the Directory of MD Notes as the First Argument")
        console.log("Otherwise the current directory, ./, will be used.\n")
        console.log("No notes will not lead to any warning")
        console.log("This is necessary so as to not be dangerous when | bash\n")
    } else {
        const path = process.argv[2];
        process.chdir(path);
        if (debugFlag) {
            console.log(`Using Specified Directory ${process.argv[2]}`)
        }
    }

}

function get_file_names() {
    // //////////////////////////////////////////////////////////
    // ////////////// Get File Names/////////////////////////////
    // //////////////////////////////////////////////////////////

    let att_extensions = [
        "./**/*.png",
        "./**/*.jpeg",
        "./**/*.jpg",
        "./**/*.svg"
    ]

    let note_extensions = [
        "./**/*.md",
        "./**/*.org",
        "./**/*.txt",
        "./**/*.html",
        "./**/*.tex"
    ]

    var attFilePathList = [];
    var noteFilePathList = [];
    for (i=0; i < note_extensions.length; i++) {
        noteFilePathList.push(glob.sync(note_extensions[i]));
    }
    for (i=0; i < att_extensions.length; i++) {
        attFilePathList.push(glob.sync(att_extensions[i]));
    }
    noteFilePathList = noteFilePathList.flat();
    attFilePathList = attFilePathList.flat();
    return [attFilePathList, noteFilePathList];
}

function find_unused_attachments(attachments, notes) {
    for (i=0; i < attachments.length;i++) {
        att = attachments[i];
        for (j = 0; j < notes.length; j++) {
           note = fs.readFileSync(notes[j], "utf-8");
            att_referencedQ = note.includes(basename(att))
            // TODO this probably doesn't work because I need to loop over each line
            if (!att_referencedQ) {
                print(basename(att))
                break
            }
        }
    }
    return 0;
}

function basename(string) {
    return string.split('\\').pop().split('/').pop(); // https://stackoverflow.com/a/25221100
}

function print(val) {
    console.log(val);
}

main()
