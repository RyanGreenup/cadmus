# hugo-theme-basic

Basic personal site theme styled with minimal tachyons, syntax highlighting, and blog series configuration.

## Demo

[https://hugo-theme-basic.netlify.com/](https://hugo-theme-basic.netlify.com/)

## Screenshot

![](https://github.com/siegerts/hugo-theme-basic/blob/master/images/tn.png)

## Features

- ✨ Basic — HTML with a dash of style + emoji
- 🌯 Extensible — Easily leverage [tachyons](https://tachyons.io/components/) to add more spice
- 🗞️ `series` taxonomy - Automatically group posts and display within an isolated taxonomy type
- 🥑 Syntax Highlighting - It's there when you need it

## Installation

Run this command from the root of your Hugo directory (Git needs to be installed):

```
$ git clone https://github.com/siegerts/hugo-theme-basic.git
```

Or, if your Hugo site is already in git, you can include this repository as a `git submodule`. This makes it easier to update this theme (_and for some deployment options i.e. Netlify_).

```
$ git submodule add https://github.com/siegerts/hugo-theme-basic.git themes/hugo-theme-basic
```

Alternatively, if you are not familiar with git, you can download the theme as a .zip file, unzip the theme contents, and then move the unzipped source into your themes directory.

For more information, read the official [documentation](https://gohugo.io/themes/installing-and-using-themes) of Hugo.

## Run example site

From the root of `themes/hugo-theme-basic/exampleSite`:

```
hugo server --themesDir ../..
```

## Configuration

Check out the sample `config.toml`file located in the [`exampleSite`](https://github.com/siegerts/hugo-theme-basic/tree/master/exampleSite) directory. Copy the `config.toml` to the root directory of your Hugo site, then edit as desired.

## Content Types

| Type        | Description                                                                                 | Command                              |
| ----------- | ------------------------------------------------------------------------------------------- | ------------------------------------ |
| **Post**    | Used for blog posts. Posts are listed on the `/post` page.                                  | `hugo new post/<post-name>.md`       |
| **Page**    | Used for site pages.                                                                        | `hugo new <page-name>.md`            |
| **Project** | Used for project pages. Extend project list by customizing `/layouts/section/project.html`. | `hugo new project/<project-name>.md` |

## Blog post series

An extra _taxonomy_, `series`, is added to allow for the grouping of blog posts. A _Read More_ section shows at the bottom of each post within the series when two or more posts are grouped.

```toml
[taxonomies]
  category = "categories"
  series = "series"
  tag = "tags"
```

### _Series read more_

![](https://github.com/siegerts/hugo-theme-basic/blob/master/images/series.png)

## `.Params.Menu`

Menu links are specified, in order, in the theme configuration.

For example:

```toml
[[params.menu]]
  name = "blog"
  url = "blog/"

[[params.menu]]
  name = "post series"
  url = "series/"

[[params.menu]]
  name = "about"
  url = "about/"
```

## Syntax highlighting

Syntax highlighting is provided by [highlight.js](https://highlightjs.org/). The color theme can be changed by modifying the highlight.js stylesheet in `layouts/partials/head_includes.html`.

## Acknowledgments

- [tachyons](http://tachyons.io/)
- [highlightjs](https://highlightjs.org/)

## License

The code is available under the [MIT license](https://github.com/siegerts/hugo-theme-basic/blob/master/LICENSE).
